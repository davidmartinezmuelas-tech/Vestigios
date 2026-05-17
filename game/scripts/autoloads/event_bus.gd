## event_bus.gd
## Bus de eventos global. Desacopla todos los sistemas del juego.
## Ningún sistema debe llamar a otro directamente — solo emitir señales aquí.

extends Node

# ============================================================
# COMBATE
# ============================================================
signal combat_started(party: Array, enemies: Array)
signal combat_ended(victory: bool, rewards: Dictionary)
signal round_started(round_number: int)
signal turn_started(character: BaseCharacter)
signal turn_ended(character: BaseCharacter)
signal ability_used(user: BaseCharacter, ability: AbilityData, targets: Array)
signal attack_missed(attacker: BaseCharacter, target: BaseCharacter)
signal damage_dealt(target: BaseCharacter, amount: int, is_crit: bool)
signal healing_applied(target: BaseCharacter, amount: int)
signal effect_applied(target: BaseCharacter, effect: EffectData)
signal effect_expired(target: BaseCharacter, effect: EffectData)
signal character_died(character: BaseCharacter)
signal stress_changed(character: BaseCharacter, new_stress: int)
signal affliction_triggered(character: BaseCharacter, affliction_type: String)
signal virtue_triggered(character: BaseCharacter, virtue_type: String)

# ============================================================
# DIÁLOGO
# ============================================================
signal dialogue_started(dialogue_id: String)
signal dialogue_ended(dialogue_id: String)
signal dialogue_choice_made(choice_index: int)
signal skill_check_requested(skill: String, difficulty: int)
signal skill_check_resolved(passed: bool, roll: int, difficulty: int)

# ============================================================
# DUNGEON / EXPLORACIÓN
# ============================================================
signal dungeon_entered(dungeon_id: String)
signal dungeon_completed(dungeon_id: String)
signal room_entered(room_data: Dictionary)
signal room_cleared(room_data: Dictionary)
signal loot_found(items: Array)

# ============================================================
# ECONOMÍA / INVENTARIO
# ============================================================
signal gold_changed(amount: int, total: int)
signal item_added(item: Dictionary)  ## Deprecado — usar camp_chest_changed
signal item_used(item: Dictionary, target: BaseCharacter)
signal item_removed(item: Dictionary)

# ============================================================
# EQUIPAMIENTO
# ============================================================
## Un personaje equipó un objeto en un slot (slot como int del enum EquipmentSlot.Slot).
signal item_equipped(character_id: String, item_id: String, slot: int)
## Un personaje desequipó un objeto de un slot.
signal item_unequipped(character_id: String, item_id: String, slot: int)
## Un personaje pasó un objeto a otro.
signal item_passed(from_character_id: String, to_character_id: String, item_id: String)
## El cofre del campamento cambió. items = lista completa actual de item_ids.
signal camp_chest_changed(items: Array)
## Un personaje sintonizó un objeto (al completar descanso largo).
signal item_attuned(character_id: String, item_id: String)
## Un personaje perdió la sintonía con un objeto.
signal item_unattuned(character_id: String, item_id: String)
## Solicitud de cambio de sintonía pendiente para el próximo descanso largo.
signal attunement_change_requested(character_id: String, item_id: String, attune: bool)

# ============================================================
# EXPLORACIÓN — SPLIT PARTY
# ============================================================
## Tab pulsado: alterna modo grupo (false) / modo split (true).
signal party_split_changed(is_split: bool)
## Un personaje fue seleccionado individualmente en modo split.
signal explorer_selected(character_id: String)
## Orden de movimiento: character_id debe moverse a world_pos.
signal move_to_requested(character_id: String, world_pos: Vector2)
## Todos los personajes han reagrupado alrededor del líder.
signal party_regrouped

# ============================================================
# NARRACIÓN
# ============================================================
signal narrator_bark(text: String, duration: float)
signal journal_entry_added(entry: String)

# ============================================================
# META / UI / SISTEMA
# ============================================================
signal scene_transition_started(scene_name: String)
signal scene_transition_ended(scene_name: String)
signal game_paused(is_paused: bool)
signal game_saved(slot: int)
signal game_loaded(slot: int)
signal settings_changed(key: String, value: Variant)
