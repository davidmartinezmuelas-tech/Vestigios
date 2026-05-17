## equipment_slot.gd
## Enum global de slots de equipamiento + helpers estáticos.
## No es un autoload ni un Node. Usar como clase global (class_name registrado).

class_name EquipmentSlot

enum Slot {
	MANO_PRINCIPAL,   ## Arma principal o arma a dos manos
	MANO_SECUNDARIA,  ## Arma ligera, escudo o vacío
	ARMADURA,         ## Armadura corporal
	CABEZA,           ## Casco, diadema u objeto de cabeza
	MANOS,            ## Guantes, manoplas o brazales
	CAPA,             ## Capa mágica
	CUELLO,           ## Amuleto o collar
	ANILLO_1,         ## Primer anillo
	ANILLO_2,         ## Segundo anillo
	BOTAS,            ## Botas
	CINTURON,         ## Cinturón
	COMPLEMENTO,      ## Arma secundaria a distancia (ej: arco cuando la principal es espada)
}

## Devuelve true si el slot puede contener un arma.
static func is_weapon_slot(slot: Slot) -> bool:
	return slot == Slot.MANO_PRINCIPAL \
		or slot == Slot.MANO_SECUNDARIA \
		or slot == Slot.COMPLEMENTO

## Devuelve true si el slot es de accesorio mágico (no arma ni armadura).
static func is_accessory_slot(slot: Slot) -> bool:
	return slot in [
		Slot.CABEZA, Slot.MANOS, Slot.CAPA,
		Slot.CUELLO, Slot.ANILLO_1, Slot.ANILLO_2,
		Slot.BOTAS, Slot.CINTURON,
	]

## Convierte un Slot a su clave string snake_case (para serialización y .tres).
static func to_key(slot: Slot) -> String:
	return Slot.keys()[slot].to_lower()

## Convierte una clave string al Slot correspondiente.
## Devuelve MANO_PRINCIPAL si la clave no es reconocida.
static func from_key(key: String) -> Slot:
	var upper := key.to_upper()
	if Slot.has(upper):
		return Slot[upper]
	return Slot.MANO_PRINCIPAL

## Devuelve todos los slots como Array para iteración.
static func all_slots() -> Array[Slot]:
	var result: Array[Slot] = []
	for s in Slot.values():
		result.append(s as Slot)
	return result

## Nombre legible del slot para mostrar en UI.
static func display_name(slot: Slot) -> String:
	match slot:
		Slot.MANO_PRINCIPAL:  return "Mano Principal"
		Slot.MANO_SECUNDARIA: return "Mano Secundaria"
		Slot.ARMADURA:        return "Armadura"
		Slot.CABEZA:          return "Cabeza"
		Slot.MANOS:           return "Manos"
		Slot.CAPA:            return "Capa"
		Slot.CUELLO:          return "Cuello"
		Slot.ANILLO_1:        return "Anillo (izq.)"
		Slot.ANILLO_2:        return "Anillo (der.)"
		Slot.BOTAS:           return "Botas"
		Slot.CINTURON:        return "Cinturón"
		Slot.COMPLEMENTO:     return "Complemento"
	return ""
