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
signal item_added(item: Dictionary)
signal item_used(item: Dictionary, target: BaseCharacter)
signal item_removed(item: Dictionary)

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
