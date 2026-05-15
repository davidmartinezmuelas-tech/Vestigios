## character_builder.gd
## Convierte un CustomCharacterConfig en un CharacterData completo y funcional.

class_name CharacterBuilder
extends RefCounted

static func build(config: CustomCharacterConfig) -> CharacterData:
	var data := CharacterData.new()

	# Identidad
	data.character_id = "player_custom"
	data.display_name = config.character_name if not config.character_name.is_empty() else "Aventurero"
	data.is_hero = true

	# Puntuaciones base (antes de bonos raciales)
	data.strength     = config.ability_scores[0]
	data.dexterity    = config.ability_scores[1]
	data.constitution = config.ability_scores[2]
	data.intelligence = config.ability_scores[3]
	data.wisdom       = config.ability_scores[4]
	data.charisma     = config.ability_scores[5]

	# Clase
	if config.chosen_class:
		data.hit_dice_sides           = config.chosen_class.hit_dice_sides
		data.saving_throw_proficiencies = config.chosen_class.saving_throw_proficiencies.duplicate()

	# Raza — aplica bonos de característica, velocidad y rasgos
	data.speed_ft = 30
	if config.race:
		config.race.apply_to(data)

	# Trasfondo — competencias de habilidad
	if config.background:
		data.starting_gold = config.background.starting_gold
		for skill in config.background.skill_proficiencies:
			if skill not in data.skill_proficiencies:
				data.skill_proficiencies.append(skill)

	# Habilidades elegidas de la clase
	for skill in config.chosen_skill_proficiencies:
		if skill not in data.skill_proficiencies:
			data.skill_proficiencies.append(skill)

	# Progresión
	data.level             = 1
	data.proficiency_bonus = 2

	# CA por defecto (sin armadura: 10 + DEX)
	var dex_mod := CharacterData.ability_modifier(data.dexterity)
	data.armor_class = 10 + dex_mod

	# Retratos desde el set elegido
	if config.portrait_set:
		data.portrait_neutral = config.portrait_set.portrait_neutral
		data.portrait_happy   = config.portrait_set.portrait_happy
		data.portrait_angry   = config.portrait_set.portrait_angry
		data.portrait_scared  = config.portrait_set.portrait_scared
		data.portrait_focused = config.portrait_set.portrait_focused

	# Estrés
	data.max_stress = 100

	return data
