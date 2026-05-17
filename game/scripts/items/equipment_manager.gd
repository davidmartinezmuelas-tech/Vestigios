## equipment_manager.gd
## Lógica de equipamiento/desequipamiento y paso de objetos entre personajes.
## Clase estática — no es autoload ni Node. Validaciones D&D 2024.
## Nunca toca UI directamente: notifica vía EventBus.

class_name EquipmentManager

enum EquipResult {
	OK,
	SLOT_INCOMPATIBLE,      ## El objeto no puede ir en ese slot
	TWO_HANDED_CONFLICT,    ## Arma a dos manos requiere mano secundaria vacía (o viceversa)
	SHIELD_WEAPON_CONFLICT, ## Escudo incompatible con arma a dos manos
	ITEM_NOT_FOUND,         ## item_id no existe en ninguna base de datos
}

# ============================================================
# API PÚBLICA
# ============================================================

## Equipa item_id en slot para el personaje representado por data + stats.
## El objeto debe estar en el inventario personal o el caller debe haberlo validado.
## Devuelve EquipResult.OK si todo fue bien.
static func equip(
	data: CharacterData,
	stats: CharacterStats,
	item_id: String,
	slot: EquipmentSlot.Slot
) -> EquipResult:
	# 1. Verificar que el item existe
	var item := _resolve_item(item_id)
	if item == null:
		return EquipResult.ITEM_NOT_FOUND

	# 2. Validar compatibilidad slot ↔ tipo
	var compat := _validate_slot_compatibility(item, slot)
	if compat != EquipResult.OK:
		return compat

	# 3. Validar reglas de manos (dos manos, escudo)
	var hands := _validate_hand_rules(data, item, slot)
	if hands != EquipResult.OK:
		return hands

	# 4. Desequipar lo que había (si algo)
	var previously := data.get_slot(slot)
	if not previously.is_empty():
		_do_unequip(data, stats, slot, previously)
		data.inventory_add(previously)

	# 5. Quitar del inventario personal (si estaba ahí)
	data.inventory_remove(item_id)

	# 6. Equipar
	data.set_slot(slot, item_id)
	stats.apply_equipment_bonus(item_id, data)

	EventBus.item_equipped.emit(data.character_id, item_id, slot)
	return EquipResult.OK

## Desequipa el objeto en slot y lo devuelve al inventario personal.
static func unequip(
	data: CharacterData,
	stats: CharacterStats,
	slot: EquipmentSlot.Slot
) -> bool:
	var item_id := data.get_slot(slot)
	if item_id.is_empty():
		return false
	_do_unequip(data, stats, slot, item_id)
	data.inventory_add(item_id)
	EventBus.item_unequipped.emit(data.character_id, item_id, slot)
	return true

## Transfiere item_id del inventario personal de from_data al de to_data.
## En combate el caller debe verificar que el personaje tiene Acción disponible.
static func pass_item(
	from_data: CharacterData,
	to_data: CharacterData,
	item_id: String
) -> bool:
	if not from_data.inventory_remove(item_id):
		return false
	if not to_data.inventory_add(item_id):
		from_data.inventory_add(item_id)  # rollback
		return false
	EventBus.item_passed.emit(from_data.character_id, to_data.character_id, item_id)
	return true

# ============================================================
# PRIVADOS
# ============================================================

static func _do_unequip(
	data: CharacterData,
	stats: CharacterStats,
	slot: EquipmentSlot.Slot,
	item_id: String
) -> void:
	stats.remove_equipment_bonus(item_id)
	data.set_slot(slot, "")

static func _resolve_item(item_id: String) -> ItemData:
	var item := ItemDatabase.get_item(item_id)
	if item != null:
		return item
	return MagicItemDatabase.get(item_id)

static func _validate_slot_compatibility(item: ItemData, slot: EquipmentSlot.Slot) -> EquipResult:
	match slot:
		EquipmentSlot.Slot.MANO_PRINCIPAL, EquipmentSlot.Slot.COMPLEMENTO:
			if item.item_type not in [ItemData.ItemType.WEAPON, ItemData.ItemType.MAGIC]:
				return EquipResult.SLOT_INCOMPATIBLE
		EquipmentSlot.Slot.MANO_SECUNDARIA:
			if item.item_type not in [
				ItemData.ItemType.WEAPON, ItemData.ItemType.SHIELD, ItemData.ItemType.MAGIC
			]:
				return EquipResult.SLOT_INCOMPATIBLE
		EquipmentSlot.Slot.ARMADURA:
			if item.item_type not in [ItemData.ItemType.ARMOR, ItemData.ItemType.MAGIC]:
				return EquipResult.SLOT_INCOMPATIBLE
		_:
			# Slots de accesorio: solo objetos mágicos o tipo MAGIC/MISC
			if not EquipmentSlot.is_accessory_slot(slot):
				return EquipResult.SLOT_INCOMPATIBLE
			if item.item_type not in [ItemData.ItemType.MAGIC, ItemData.ItemType.MISC]:
				return EquipResult.SLOT_INCOMPATIBLE
	return EquipResult.OK

static func _validate_hand_rules(
	data: CharacterData,
	item: ItemData,
	slot: EquipmentSlot.Slot
) -> EquipResult:
	if item.item_type != ItemData.ItemType.WEAPON:
		return EquipResult.OK
	var weapon := item as WeaponData
	if weapon == null:
		return EquipResult.OK

	# Equipar arma a dos manos en mano principal → secundaria debe estar vacía
	if slot == EquipmentSlot.Slot.MANO_PRINCIPAL and weapon.is_two_handed:
		if not data.slot_mano_secundaria.is_empty():
			return EquipResult.TWO_HANDED_CONFLICT

	# Equipar algo en secundaria → mano principal no puede tener arma a dos manos
	if slot == EquipmentSlot.Slot.MANO_SECUNDARIA:
		var main_id := data.slot_mano_principal
		if not main_id.is_empty():
			var main_weapon := ItemDatabase.get_weapon(main_id)
			if main_weapon != null and main_weapon.is_two_handed:
				return EquipResult.TWO_HANDED_CONFLICT

	return EquipResult.OK
