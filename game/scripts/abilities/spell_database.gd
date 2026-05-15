## spell_database.gd
## Base de datos central de conjuros y trucos (D&D 2024).
## Autoload. Uso: SpellDatabase.get("marca_cazador")
##
## FUENTE: Documentación DND/Hechizos/CONJUROS.txt
## Los conjuros se registran con sus stats exactos del libro.

extends Node

# ============================================================
# REGISTRO INDEXADO POR spell_id
# ============================================================
var _spells: Dictionary = {}

# ============================================================
# API PÚBLICA
# ============================================================

func get(spell_id: String) -> SpellData:
	return _spells.get(spell_id)

func get_all_cantrips() -> Array[SpellData]:
	return _spells.values().filter(func(s: SpellData) -> bool: return s.is_cantrip())

## Devuelve todos los conjuros disponibles para una clase.
## Las clases están almacenadas en el campo description como "... — clase1, clase2"
func get_spells_for_class(class_id: String) -> Array[SpellData]:
	return _spells.values().filter(
		func(s: SpellData) -> bool:
			if s.description.is_empty():
				return false
			var desc_lower := s.description.to_lower()
			# Buscar en la parte de clases (tras "—")
			var dash_idx := desc_lower.rfind("—")
			if dash_idx >= 0:
				return class_id.to_lower() in desc_lower.substr(dash_idx)
			return class_id.to_lower() in desc_lower
	)

func get_spells_by_level(level: int) -> Array[SpellData]:
	return _spells.values().filter(func(s: SpellData) -> bool: return s.spell_level == level)

# ============================================================
# LIFECYCLE
# ============================================================

func _ready() -> void:
	# Primero registros automáticos (todos los 371 conjuros del libro)
	_register_nivel_0_auto()
	_register_nivel_1_auto()
	_register_nivel_2_auto()
	_register_nivel_3_auto()
	_register_nivel_4_auto()
	_register_nivel_5_auto()
	_register_nivel_6_auto()
	_register_nivel_7_auto()
	_register_nivel_8_auto()
	_register_nivel_9_auto()
	# Luego registros manuales — sobreescriben los automáticos con datos mecánicos precisos
	_register_trucos()
	_register_nivel_1()
	_register_nivel_2()
	_register_nivel_3()
	_register_nivel_4_plus()

# ============================================================
# TRUCOS (nivel 0 — uso ilimitado)
# ============================================================

func _register_trucos() -> void:

	# BURLA DAÑINA — Encantamiento · Bardo
	# Salvación SAB o 1d4+desventaja en siguiente ataque del objetivo
	_s("burla_danosa", "Burla dañina", 0, SpellData.School.ENCANTAMIENTO,
		SpellData.CastingTime.ACCION, ["v"], 60, "Instantáneo", false, {
			ability_type = AbilityData.AbilityType.SAVING_THROW,
			target_type = AbilityData.TargetType.SINGLE_ENEMY,
			attack_ability = "cha",
			save_ability = "wis", save_dc = 0,
			damage_dice_count = 1, damage_dice_sides = 4, damage_type = "psíquico",
			save_success_multiplier = 0.0,
			damage_scale_at_levels = {5:1, 11:2, 17:3},
			description = "El objetivo hace salvación de Sabiduría o sufre 1d4 de daño psíquico y tiene desventaja en su siguiente tirada de ataque.",
		})

	# LUZ — Evocación · Bardo/Clérigo/Hechicero/Mago
	_s("luz", "Luz", 0, SpellData.School.EVOCACION,
		SpellData.CastingTime.ACCION, ["v","m"], 0, "1 hora", false, {
			ability_type = AbilityData.AbilityType.BUFF,
			target_type = AbilityData.TargetType.SELF,
			description = "Tocas un objeto. Emite luz brillante 6m, tenue 6m más. Lanzarlo de nuevo o destocarlo termina el efecto.",
		})

	# LLAMA SAGRADA — Evocación · Clérigo
	# Salvación DES o 1d8 radiante (no se puede beneficiar de cobertura)
	_s("llama_sagrada", "Llama sagrada", 0, SpellData.School.EVOCACION,
		SpellData.CastingTime.ACCION, ["v","s"], 60, "Instantáneo", false, {
			ability_type = AbilityData.AbilityType.SAVING_THROW,
			target_type = AbilityData.TargetType.SINGLE_ENEMY,
			attack_ability = "wis",
			save_ability = "dex", save_dc = 0,
			damage_dice_count = 1, damage_dice_sides = 8, damage_type = "radiante",
			save_success_multiplier = 0.0,
			damage_scale_at_levels = {5:1, 11:2, 17:3},
			description = "Un fulgor desciende sobre el objetivo. Salvación DES o 1d8 daño radiante. No se beneficia de cobertura.",
		})

	# PRESTIDIGITACIÓN — Transmutación · Bardo/Hechicero/Mago
	_s("prestidigitacion", "Prestidigitación", 0, SpellData.School.TRANSMUTACION,
		SpellData.CastingTime.ACCION, ["v","s"], 30, "1 hora", false, {
			ability_type = AbilityData.AbilityType.BUFF,
			target_type = AbilityData.TargetType.SELF,
			description = "Efectos mágicos menores: limpiar, ensuciar, enfriar, calentar, iluminar, crear sabor, crear sonido...",
		})

	# TAUMATURGIA — Transmutación · Clérigo
	_s("taumaturgia", "Taumaturgia", 0, SpellData.School.TRANSMUTACION,
		SpellData.CastingTime.ACCION, ["v"], 30, "1 minuto", false, {
			ability_type = AbilityData.AbilityType.BUFF,
			target_type = AbilityData.TargetType.SELF,
			description = "Manifiestas una maravilla menor: ampliar tu voz, hacer temblar el suelo, abrir puertas...",
		})

	# ILUSIÓN MENOR — Ilusión · Bardo/Brujo/Hechicero/Mago
	_s("ilusion_menor", "Ilusión menor", 0, SpellData.School.ILUSION,
		SpellData.CastingTime.ACCION, ["s","m"], 30, "1 minuto", false, {
			ability_type = AbilityData.AbilityType.BUFF,
			target_type = AbilityData.TargetType.SELF,
			description = "Creas un sonido o imagen ilusoria (cubo 1.5m). Investigación contra CD de conjuro para descubrirla.",
		})

	# GUÍA — Adivinación · Clérigo/Druida
	_s("guia", "Guía", 0, SpellData.School.ADIVINACION,
		SpellData.CastingTime.ACCION, ["v","s"], 0, "Concentración, 1 minuto", true, {
			ability_type = AbilityData.AbilityType.BUFF,
			target_type = AbilityData.TargetType.SINGLE_ALLY,
			description = "Tocas una criatura voluntaria. Una vez antes de que termine el conjuro puede añadir 1d4 a una prueba de característica.",
		})

# ============================================================
# CONJUROS NIVEL 1
# ============================================================

func _register_nivel_1() -> void:

	# CASTIGO DIVINO — Evocación · Paladín
	# Acción adicional tras golpear. +2d8 radiante. +1d8 extra vs infernales/no muertos.
	_s("castigo_divino", "Castigo divino", 1, SpellData.School.EVOCACION,
		SpellData.CastingTime.ACCION_ADICIONAL, ["v"], 0, "Instantáneo", false, {
			ability_type = AbilityData.AbilityType.BUFF,  # se aplica como daño extra al golpe
			target_type = AbilityData.TargetType.SINGLE_ENEMY,
			attack_ability = "cha",
			damage_dice_count = 2, damage_dice_sides = 8, damage_type = "radiante",
			upcast_dice_per_slot = 1,
			reaction_trigger = "Tras acertar un ataque cuerpo a cuerpo",
			description = "Acción adicional inmediatamente tras golpear: +2d8 radiante. +1d8 extra vs infernales/muertos vivientes. Escala +1d8 por nivel.",
		})

	# CURAR HERIDAS — Abjuración · Bardo/Clérigo/Druida/Explorador/Paladín
	_s("curar_heridas", "Curar heridas", 1, SpellData.School.ABJURACION,
		SpellData.CastingTime.ACCION, ["v","s"], 0, "Instantáneo", false, {
			ability_type = AbilityData.AbilityType.HEAL,
			target_type = AbilityData.TargetType.SINGLE_ALLY,
			attack_ability = "wis",
			damage_dice_count = 2, damage_dice_sides = 8, damage_ability = "wis",
			upcast_dice_per_slot = 2,
			description = "Toque: la criatura recupera 2d8+mod curación. Escala +2d8 por nivel.",
		})

	# PALABRA DE CURACIÓN — Abjuración · Bardo/Clérigo/Druida
	# Acción adicional, 18m, solo 1d4+mod pero en bonus action
	_s("palabra_curacion", "Palabra de curación", 1, SpellData.School.ABJURACION,
		SpellData.CastingTime.ACCION_ADICIONAL, ["v"], 60, "Instantáneo", false, {
			ability_type = AbilityData.AbilityType.HEAL,
			target_type = AbilityData.TargetType.SINGLE_ALLY,
			attack_ability = "wis",
			damage_dice_count = 1, damage_dice_sides = 4, damage_ability = "wis",
			upcast_dice_per_slot = 1,
			range_ft = 60,
			description = "Acción adicional: un objetivo a 18m recupera 1d4+mod. Escala +1d4 por nivel.",
		})

	# HEROÍSMO — Encantamiento · Bardo/Paladín
	# Concentración. Objetivo inmune asustado + PG temporales = mod por turno.
	_s("heroismo", "Heroísmo", 1, SpellData.School.ENCANTAMIENTO,
		SpellData.CastingTime.ACCION, ["v","s"], 0, "Concentración, 1 minuto", true, {
			ability_type = AbilityData.AbilityType.BUFF,
			target_type = AbilityData.TargetType.SINGLE_ALLY,
			attack_ability = "cha",
			description = "Toque: concentración 1min. El objetivo es inmune a Asustado y gana PG temporales = tu mod de aptitud mágica al inicio de cada turno.",
		})

	# ESCUDO DE LA FE — Abjuración · Clérigo/Paladín
	# Concentración. +2 CA al objetivo.
	_s("escudo_fe", "Escudo de la fe", 1, SpellData.School.ABJURACION,
		SpellData.CastingTime.ACCION_ADICIONAL, ["v","s","m"], 60, "Concentración, 10 minutos", true, {
			ability_type = AbilityData.AbilityType.BUFF,
			target_type = AbilityData.TargetType.SINGLE_ALLY,
			attack_ability = "wis",
			description = "Un campo brillante rodea a una criatura a 18m. Gana +2 CA mientras dure la concentración.",
		})

	# ESCUDO — Abjuración · Hechicero/Mago (reacción)
	# +5 CA hasta inicio de tu siguiente turno. Bloquea Proyectil mágico.
	_s("escudo", "Escudo", 1, SpellData.School.ABJURACION,
		SpellData.CastingTime.REACCION, ["v","s"], 0, "1 ronda", false, {
			ability_type = AbilityData.AbilityType.BUFF,
			target_type = AbilityData.TargetType.SELF,
			attack_ability = "int",
			reaction_trigger = "Al ser atacado o ser objetivo de proyectil mágico",
			description = "Reacción: +5 CA hasta inicio de tu siguiente turno. Bloquea Proyectil mágico.",
		})

	# PROYECTIL MÁGICO — Evocación · Hechicero/Mago
	# 3 dardos automáticos de 1d4+1 fuerza. Sin tirada de ataque.
	_s("proyectil_magico", "Proyectil mágico", 1, SpellData.School.EVOCACION,
		SpellData.CastingTime.ACCION, ["v","s"], 120, "Instantáneo", false, {
			ability_type = AbilityData.AbilityType.SAVING_THROW,  # automático (save_dc=0 = hit siempre)
			target_type = AbilityData.TargetType.SINGLE_ENEMY,
			attack_ability = "int",
			damage_dice_count = 3, damage_dice_sides = 4, damage_ability = "",
			save_ability = "none", save_dc = 999,  # truco: no falla nunca
			save_success_multiplier = 1.0,          # daño completo siempre
			upcast_dice_per_slot = 1,
			description = "3 dardos de fuerza (1d4+1 c/u) que golpean automáticamente. +1 dardo por nivel.",
		})

	# HECHIZAR PERSONA — Encantamiento · Bardo/Brujo/Druida/Hechicero/Mago
	_s("hechizar_persona", "Hechizar persona", 1, SpellData.School.ENCANTAMIENTO,
		SpellData.CastingTime.ACCION, ["v","s"], 30, "1 hora", false, {
			ability_type = AbilityData.AbilityType.SAVING_THROW,
			target_type = AbilityData.TargetType.SINGLE_ENEMY,
			attack_ability = "cha",
			save_ability = "wis", save_dc = 0, save_success_multiplier = 0.0,
			condition_on_fail = "hechizado",
			description = "Salvación de Sabiduría o el objetivo queda Hechizado 1h. Ventaja si está combatiendo contigo.",
		})

	# DETECTAR EL MAL Y EL BIEN — Adivinación · Clérigo/Paladín
	_s("detectar_mal_bien", "Detectar el mal y el bien", 1, SpellData.School.ADIVINACION,
		SpellData.CastingTime.ACCION, ["v","s"], 0, "Concentración, 10 minutos", true, {
			ability_type = AbilityData.AbilityType.BUFF,
			target_type = AbilityData.TargetType.SELF,
			description = "Conoces la ubicación de infernales, celestiales y muertos vivientes a 18m. Detectas lugares sagrados o profanos.",
		})

	# MARCA DEL CAZADOR — Adivinación · Explorador
	# Acción adicional, concentración 1h. +1d6 daño fuerza al objetivo marcado.
	_s("marca_cazador", "Marca del cazador", 1, SpellData.School.ADIVINACION,
		SpellData.CastingTime.ACCION_ADICIONAL, ["v"], 90, "Concentración, hasta 1 hora", true, {
			ability_type = AbilityData.AbilityType.BUFF,
			target_type = AbilityData.TargetType.SINGLE_ENEMY,
			attack_ability = "wis",
			damage_dice_count = 1, damage_dice_sides = 6, damage_type = "fuerza",
			range_ft = 90,
			description = "Marcas a un objetivo como presa. +1d6 daño fuerza al golpearle. Ventaja en Percepción/Supervivencia para rastrearlo.",
		})

	# MANOS ARDIENTES — Evocación · Hechicero/Mago
	# Cono 4.5m, salvación DES, 3d6 fuego
	_s("manos_ardientes", "Manos ardientes", 1, SpellData.School.EVOCACION,
		SpellData.CastingTime.ACCION, ["v","s"], 15, "Instantáneo", false, {
			ability_type = AbilityData.AbilityType.SAVING_THROW,
			target_type = AbilityData.TargetType.ALL_ENEMIES,
			attack_ability = "cha",
			save_ability = "dex", save_dc = 0, save_success_multiplier = 0.5,
			damage_dice_count = 3, damage_dice_sides = 6, damage_type = "fuego",
			area_shape = SpellData.AreaShape.CONO,
			area_size_ft = 15,
			upcast_dice_per_slot = 1,
			description = "Cono de 4.5m: salvación DES o 3d6 fuego. Escala +1d6 por nivel.",
		})

	# SUEÑO — Encantamiento · Bardo/Hechicero/Mago
	# 5d8 PG de criaturas afectadas (las de menos PG primero)
	_s("sueno", "Sueño", 1, SpellData.School.ENCANTAMIENTO,
		SpellData.CastingTime.ACCION, ["v","s","m"], 90, "1 minuto", false, {
			ability_type = AbilityData.AbilityType.SAVING_THROW,
			target_type = AbilityData.TargetType.ALL_ENEMIES,
			attack_ability = "cha",
			save_ability = "wis", save_dc = 999, save_success_multiplier = 0.0,  # inmunes
			damage_dice_count = 5, damage_dice_sides = 8, damage_type = "sueño",
			area_shape = SpellData.AreaShape.ESFERA,
			area_size_ft = 20,
			upcast_dice_per_slot = 2,
			description = "5d8 PG de criaturas en 6m radio caen dormidas (las de menos PG primero). Inmunes si son inmunes al Hechizo.",
		})

	# RESTAURACIÓN MENOR — Abjuración · Bardo/Clérigo/Druida/Paladín
	_s("restauracion_menor", "Restauración menor", 1, SpellData.School.ABJURACION,
		SpellData.CastingTime.ACCION, ["v","s"], 0, "Instantáneo", false, {
			ability_type = AbilityData.AbilityType.HEAL,
			target_type = AbilityData.TargetType.SINGLE_ALLY,
			attack_ability = "wis",
			description = "Toque: elimina una enfermedad o uno de estos estados: cegado, ensordecido, envenenado, paralizado.",
		})

# ============================================================
# CONJUROS NIVEL 2
# ============================================================

func _register_nivel_2() -> void:

	# INVISIBILIDAD — Ilusión · Bardo/Hechicero/Mago
	_s("invisibilidad", "Invisibilidad", 2, SpellData.School.ILUSION,
		SpellData.CastingTime.ACCION, ["v","s","m"], 0, "Concentración, 1 hora", true, {
			ability_type = AbilityData.AbilityType.BUFF,
			target_type = AbilityData.TargetType.SINGLE_ALLY,
			attack_ability = "cha",
			description = "Toque: el objetivo es invisible hasta atacar o lanzar conjuro. Escala nv3: hasta 2 criaturas.",
		})

	# PASO BRUMOSO — Conjuración · Hechicero/Mago
	# Acción adicional: teletransporte 9m a lugar visible
	_s("paso_brumoso", "Paso brumoso", 2, SpellData.School.CONJURACION,
		SpellData.CastingTime.ACCION_ADICIONAL, ["v"], 0, "Instantáneo", false, {
			ability_type = AbilityData.AbilityType.BUFF,
			target_type = AbilityData.TargetType.SELF,
			attack_ability = "cha",
			range_ft = 30,
			description = "Acción adicional: te teleportas a un espacio que puedas ver a 9m.",
		})

	# SILENCIO — Ilusión · Bardo/Clérigo
	# Esfera 6m, concentración 10min. No se puede lanzar conjuros ni hacer ruido.
	_s("silencio", "Silencio", 2, SpellData.School.ILUSION,
		SpellData.CastingTime.ACCION, ["v","s"], 120, "Concentración, 10 minutos", true, {
			ability_type = AbilityData.AbilityType.BUFF,
			target_type = AbilityData.TargetType.SINGLE_ENEMY,
			attack_ability = "wis",
			area_shape = SpellData.AreaShape.ESFERA,
			area_size_ft = 20,
			description = "Esfera de silencio 6m radio centrada en un punto 36m. Ningún sonido en la zona. No se puede lanzar conjuros verbales.",
		})

	# AUXILIO — Abjuración · Clérigo/Paladín
	# 3 criaturas ganan +5 PG máximos y actuales durante 8h
	_s("auxilio", "Auxilio", 2, SpellData.School.ABJURACION,
		SpellData.CastingTime.ACCION, ["v","s","m"], 30, "8 horas", false, {
			ability_type = AbilityData.AbilityType.BUFF,
			target_type = AbilityData.TargetType.ALL_ALLIES,
			attack_ability = "wis",
			description = "Hasta 3 criaturas: PG máximos y actuales +5 durante 8h. Escala +5 por nivel.",
		})

	# SUGESTIÓN — Encantamiento · Bardo/Hechicero/Mago
	_s("sugesion", "Sugestión", 2, SpellData.School.ENCANTAMIENTO,
		SpellData.CastingTime.ACCION, ["v","m"], 30, "Concentración, 8 horas", true, {
			ability_type = AbilityData.AbilityType.SAVING_THROW,
			target_type = AbilityData.TargetType.SINGLE_ENEMY,
			attack_ability = "cha",
			save_ability = "wis", save_dc = 0, save_success_multiplier = 0.0,
			description = "Propones mágicamente una acción (máx 2 frases). Salvación SAB o el objetivo la ejecuta durante 8h.",
		})

# ============================================================
# CONJUROS NIVEL 3+
# ============================================================

func _register_nivel_3() -> void:

	# BOLA DE FUEGO — Evocación · Hechicero/Mago
	# 45m, esfera 6m radio, salvación DES, 8d6 fuego
	_s("bola_fuego", "Bola de fuego", 3, SpellData.School.EVOCACION,
		SpellData.CastingTime.ACCION, ["v","s","m"], 150, "Instantáneo", false, {
			ability_type = AbilityData.AbilityType.SAVING_THROW,
			target_type = AbilityData.TargetType.ALL_ENEMIES,
			attack_ability = "cha",
			save_ability = "dex", save_dc = 0, save_success_multiplier = 0.5,
			damage_dice_count = 8, damage_dice_sides = 6, damage_type = "fuego",
			area_shape = SpellData.AreaShape.ESFERA,
			area_size_ft = 20,
			upcast_dice_per_slot = 1,
			description = "Esfera 6m radio a 45m: salvación DES o 8d6 fuego. Escala +1d6 por nivel.",
		})

	# DISIPAR MAGIA — Abjuración · Bardo/Clérigo/Druida/Paladín/Hechicero/Mago
	_s("disipar_magia", "Disipar magia", 3, SpellData.School.ABJURACION,
		SpellData.CastingTime.ACCION, ["v","s"], 120, "Instantáneo", false, {
			ability_type = AbilityData.AbilityType.DEBUFF,
			target_type = AbilityData.TargetType.SINGLE_ENEMY,
			attack_ability = "cha",
			description = "Termina automáticamente conjuros de nivel 3 o inferior en el objetivo. Si es de nivel superior: prueba de aptitud mágica CD 10+nivel del conjuro.",
		})

	# CONTRAHECHIZO — Abjuración · Hechicero/Mago (reacción)
	_s("contrahechizo", "Contrahechizo", 3, SpellData.School.ABJURACION,
		SpellData.CastingTime.REACCION, ["s"], 60, "Instantáneo", false, {
			ability_type = AbilityData.AbilityType.DEBUFF,
			target_type = AbilityData.TargetType.SINGLE_ENEMY,
			attack_ability = "cha",
			reaction_trigger = "Cuando una criatura a 18m lanza un conjuro",
			description = "Reacción: interrumpe un conjuro de nivel 3 o inferior automáticamente. Para niveles superiores: prueba de aptitud CD 10+nivel.",
		})

	# LUZ DEL DÍA — Evocación · Bardo/Clérigo/Druida/Paladín
	_s("luz_dia", "Luz del día", 3, SpellData.School.EVOCACION,
		SpellData.CastingTime.ACCION, ["v","s"], 60, "1 hora", false, {
			ability_type = AbilityData.AbilityType.BUFF,
			target_type = AbilityData.TargetType.SELF,
			attack_ability = "wis",
			description = "Un punto emite luz brillante 18m, tenue 18m más. Disipa la oscuridad mágica de nivel 3 o inferior.",
		})

func _register_nivel_4_plus() -> void:
	# Espacio para conjuros de niveles superiores. Se añadirán por misión/necesidad narrativa.
	pass

# ============================================================
# HELPER DE REGISTRO
# ============================================================

func _s(
	id: String, name: String, level: int, school: SpellData.School,
	cast_time: SpellData.CastingTime, components: Array,
	range_ft: int, duration: String, concentration: bool,
	props: Dictionary
) -> void:

	var s := SpellData.new()
	s.ability_id     = id
	s.display_name   = name
	s.spell_level    = level
	s.school         = school
	s.casting_time_type = cast_time
	s.components     = Array(components, TYPE_STRING, "", null)
	s.range_ft       = range_ft
	s.duration       = duration
	s.requires_concentration = concentration
	s.range_tiles    = max(1, range_ft / 5)
	s.uses_proficiency = true
	s.item_type      = -1  # no es un item

	# Valores por defecto para campos de AbilityData
	s.damage_dice_count = 0
	s.damage_dice_sides = 6
	s.damage_ability    = ""
	s.save_dc           = 0
	s.save_success_multiplier = 0.5

	for key in props:
		s.set(key, props[key])

	_spells[id] = s

# ============================================================
# REGISTROS AUTOMÁTICOS — generados desde CONJUROS.txt (D&D 2024)
# 9150 líneas originales
# ============================================================


func _register_nivel_0_auto() -> void:
	_s("agarre_electrizante", "AGARRE ELECTRIZANTE", 0, School.EVOCACION, CastingTime.ACCION, ["V","S"], 0, "Instantáneo", false, {
		ability_type = AbilityData.AbilityType.SPELL_ATTACK, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		damage_dice_count = 1, damage_dice_sides = 8, damage_type = "relampago",
		description = "AGARRE ELECTRIZANTE (evocacion 0) — hechicero, mago",
	})
	_s("amistad", "AMISTAD", 0, School.ENCANTAMIENTO, CastingTime.ACCION, ["V","S"], 10, "Concentración, hasta 1 minuto", true, {
		ability_type = AbilityData.AbilityType.SAVING_THROW, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "wis",
		description = "AMISTAD (encantamiento 0) — bardo, brujo, hechicero, mago",
	})
	_s("burla_danina", "BURLA DAÑINA", 0, School.ENCANTAMIENTO, CastingTime.ACCION, ["V","S"], 59, "Instantáneo", false, {
		ability_type = AbilityData.AbilityType.SAVING_THROW, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "wis",
		description = "BURLA DAÑINA (encantamiento 0) — bardo",
	})
	_s("crear_llama", "CREAR LLAMA", 0, School.CONJURACION, CastingTime.ACCION_ADICIONAL, ["V","S"], 0, "10 minutos", false, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "CREAR LLAMA (conjuracion 0) — druida",
	})
	_s("descarga_de_fuego", "DESCARGA DE FUEGO", 0, School.EVOCACION, CastingTime.ACCION, ["V","S"], 118, "Instantáneo", false, {
		ability_type = AbilityData.AbilityType.SPELL_ATTACK, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		damage_dice_count = 1, damage_dice_sides = 10, damage_type = "none",
		description = "DESCARGA DE FUEGO (evocacion 0) — hechicero, mago",
	})
	_s("descarga_sobrenatural", "DESCARGA SOBRENATURAL", 0, School.EVOCACION, CastingTime.ACCION, ["V","S"], 0, "Instantáneo", false, {
		ability_type = AbilityData.AbilityType.SPELL_ATTACK, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		damage_dice_count = 1, damage_dice_sides = 10, damage_type = "none",
		description = "DESCARGA SOBRENATURAL (evocacion 0) — brujo",
	})
	_s("elementalismo", "ELEMENTALISMO", 0, School.TRANSMUTACION, CastingTime.ACCION, ["V","S"], 30, "Instantáneo", false, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "ELEMENTALISMO (transmutacion 0) — druida, hechicero, mago",
	})
	_s("estallido_magico", "ESTALLIDO MÁGICO", 0, School.EVOCACION, CastingTime.ACCION, ["V","S"], 118, "Instantáneo", false, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "ESTALLIDO MÁGICO (evocacion 0) — hechicero",
	})
	_s("fragmento_mental", "FRAGMENTO MENTAL", 0, School.ENCANTAMIENTO, CastingTime.ACCION, ["V","S"], 59, "1 asalto", false, {
		ability_type = AbilityData.AbilityType.SAVING_THROW, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "int",
		damage_dice_count = 1, damage_dice_sides = 6, damage_type = "none",
		description = "FRAGMENTO MENTAL (encantamiento 0) — brujo, hechicero, mago",
	})
	_s("guardia_de_cuchillas", "GUARDIA DE CUCHILLAS", 0, School.ABJURACION, CastingTime.ACCION, ["V","S"], 0, "Concentración, hasta 1 minuto", true, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "GUARDIA DE CUCHILLAS (abjuracion 0) — bardo, brujo, hechicero, mago",
	})
	_s("guia", "GUÍA", 0, School.ADIVINACION, CastingTime.ACCION, ["V","S"], 0, "Concentración, hasta 1 minuto", true, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "GUÍA (adivinacion 0) — clérigo, druida",
	})
	_s("ilusion_menor", "ILUSIÓN MENOR", 0, School.ILUSION, CastingTime.ACCION, ["V","S"], 30, "1 minuto", false, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "ILUSIÓN MENOR (ilusion 0) — bardo, brujo, hechicero, mago",
	})
	_s("impacto_certero", "IMPACTO CERTERO", 0, School.ADIVINACION, CastingTime.ACCION, ["V","S"], 0, "Instantáneo", false, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "IMPACTO CERTERO (adivinacion 0) — bardo, brujo, hechicero, mago",
	})
	_s("latigo_de_espinas", "LÁTIGO DE ESPINAS", 0, School.TRANSMUTACION, CastingTime.ACCION, ["V","S"], 30, "Instantáneo", false, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "LÁTIGO DE ESPINAS (transmutacion 0) — druida",
	})
	_s("llama_sagrada", "LLAMA SAGRADA", 0, School.EVOCACION, CastingTime.ACCION, ["V","S"], 59, "Instantáneo", false, {
		ability_type = AbilityData.AbilityType.SAVING_THROW, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "dex",
		damage_dice_count = 1, damage_dice_sides = 8, damage_type = "none",
		description = "LLAMA SAGRADA (evocacion 0) — clérigo",
	})
	_s("luces_danzantes", "LUCES DANZANTES", 0, School.ILUSION, CastingTime.ACCION, ["V","S"], 0, "Concentración, hasta 1 minuto", true, {
		ability_type = AbilityData.AbilityType.SAVING_THROW, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "wis",
		description = "LUCES DANZANTES (ilusion 0) — bardo, hechicero, mago",
	})
	_s("mano_de_mago", "MANO DE MAGO", 0, School.CONJURACION, CastingTime.ACCION, ["V","S"], 30, "1 minuto", false, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "MANO DE MAGO (conjuracion 0) — bardo, brujo, hechicero, mago",
	})
	_s("mensaje", "MENSAJE", 0, School.TRANSMUTACION, CastingTime.ACCION, ["V","S"], 118, "1 asalto", false, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "MENSAJE (transmutacion 0) — bardo, druida, hechicero, mago",
	})
	_s("palabra_de_resplandor", "PALABRA DE RESPLANDOR", 0, School.EVOCACION, CastingTime.ACCION, ["V","S"], 0, "Instantáneo", false, {
		ability_type = AbilityData.AbilityType.SAVING_THROW, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "con",
		damage_dice_count = 1, damage_dice_sides = 6, damage_type = "none",
		description = "PALABRA DE RESPLANDOR (evocacion 0) — clérigo",
	})
	_s("piedad_con_los_moribundos", "PIEDAD CON LOS MORIBUNDOS", 0, School.NECROMANCIA, CastingTime.ACCION, ["V","S"], 15, "Instantáneo", false, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "PIEDAD CON LOS MORIBUNDOS (necromancia 0) — clérigo, druida",
	})
	_s("prestidigitacion", "PRESTIDIGITACIÓN", 0, School.TRANSMUTACION, CastingTime.ACCION, ["V","S"], 10, "Hasta 1 hora", false, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "PRESTIDIGITACIÓN (transmutacion 0) — bardo, brujo, hechicero, mago",
	})
	_s("rayo_de_escarcha", "RAYO DE ESCARCHA", 0, School.EVOCACION, CastingTime.ACCION, ["V","S"], 59, "Instantáneo", false, {
		ability_type = AbilityData.AbilityType.SPELL_ATTACK, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		damage_dice_count = 1, damage_dice_sides = 8, damage_type = "frio",
		description = "RAYO DE ESCARCHA (evocacion 0) — hechicero, mago",
	})
	_s("reparar", "REPARAR", 0, School.TRANSMUTACION, CastingTime.MINUTO_1, ["V","S"], 0, "Instantáneo", false, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "REPARAR (transmutacion 0) — ",
	})
	_s("resistencia", "RESISTENCIA", 0, School.ABJURACION, CastingTime.ACCION, ["V","S"], 0, "Concentración, hasta 1 minuto", true, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "RESISTENCIA (abjuracion 0) — clérigo, druida",
	})
	_s("saber_druidico", "SABER DRUÍDICO", 0, School.TRANSMUTACION, CastingTime.ACCION, ["V","S"], 30, "Instantáneo", false, {
		ability_type = AbilityData.AbilityType.SAVING_THROW, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "wis",
		description = "SABER DRUÍDICO (transmutacion 0) — druida",
	})
	_s("salpicadura_acida", "SALPICADURA ÁCIDA", 0, School.EVOCACION, CastingTime.ACCION, ["V","S"], 59, "Instantáneo", false, {
		ability_type = AbilityData.AbilityType.SAVING_THROW, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "dex",
		damage_dice_count = 1, damage_dice_sides = 6, damage_type = "acido",
		description = "SALPICADURA ÁCIDA (evocacion 0) — hechicero, mago",
	})
	_s("shillelagh", "SHILLELAGH", 0, School.TRANSMUTACION, CastingTime.ACCION_ADICIONAL, ["V","S"], 0, "1 minuto", false, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "SHILLELAGH (transmutacion 0) — druida",
	})
	_s("tanido_por_los_muertos", "TAÑIDO POR LOS MUERTOS", 0, School.NECROMANCIA, CastingTime.ACCION, ["V","S"], 59, "Instantáneo", false, {
		ability_type = AbilityData.AbilityType.SAVING_THROW, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "wis",
		damage_dice_count = 1, damage_dice_sides = 8, damage_type = "none",
		description = "TAÑIDO POR LOS MUERTOS (necromancia 0) — brujo, clérigo, mago",
	})
	_s("taumaturgia", "TAUMATURGIA", 0, School.TRANSMUTACION, CastingTime.ACCION, ["V","S"], 30, "Hasta 1 minuto", false, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "TAUMATURGIA (transmutacion 0) — clérigo",
	})
	_s("toque_helado", "TOQUE HELADO", 0, School.NECROMANCIA, CastingTime.ACCION, ["V","S"], 0, "Instantáneo", false, {
		ability_type = AbilityData.AbilityType.SPELL_ATTACK, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		damage_dice_count = 1, damage_dice_sides = 10, damage_type = "none",
		description = "TOQUE HELADO (necromancia 0) — brujo, hechicero, mago",
	})
	_s("tronar", "TRONAR", 0, School.EVOCACION, CastingTime.ACCION, ["V","S"], 0, "1 hora", false, {
		ability_type = AbilityData.AbilityType.SAVING_THROW, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "con",
		damage_dice_count = 1, damage_dice_sides = 6, damage_type = "none",
		description = "TRONAR (evocacion 0) — bardo, brujo, druida, hechicero, mago",
	})
	_s("voluta_estelar", "VOLUTA ESTELAR", 0, School.EVOCACION, CastingTime.ACCION, ["V","S"], 59, "Instantáneo", false, {
		ability_type = AbilityData.AbilityType.SPELL_ATTACK, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		damage_dice_count = 1, damage_dice_sides = 8, damage_type = "none",
		description = "VOLUTA ESTELAR (evocacion 0) — bardo, druida",
	})

func _register_nivel_1_auto() -> void:
	_s("alarma", "ALARMA", 1, School.ABJURACION, CastingTime.MINUTO_1, ["V","S"], 30, "8 horas", false, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "ALARMA (abjuracion 1) — explorador, mago",
	})
	_s("armadura_de_agathys", "ARMADURA DE AGATHYS", 1, School.ABJURACION, CastingTime.ACCION_ADICIONAL, ["V","S"], 0, "1 hora", false, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "ARMADURA DE AGATHYS (abjuracion 1) — brujo",
	})
	_s("armadura_de_mago", "ARMADURA DE MAGO", 1, School.ABJURACION, CastingTime.ACCION, ["V","S"], 0, "8 horas", false, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "ARMADURA DE MAGO (abjuracion 1) — hechicero, mago",
	})
	_s("bendicion", "BENDICIÓN", 1, School.ENCANTAMIENTO, CastingTime.ACCION, ["V","S"], 30, "Concentración, hasta 1 minuto", true, {
		ability_type = AbilityData.AbilityType.HEAL, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "BENDICIÓN (encantamiento 1) — clérigo, paladín",
	})
	_s("brazos_de_hadar", "BRAZOS DE HADAR", 1, School.CONJURACION, CastingTime.ACCION, ["V","S"], 0, "Instantáneo", false, {
		ability_type = AbilityData.AbilityType.SAVING_THROW, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "str",
		damage_dice_count = 2, damage_dice_sides = 6, damage_type = "none",
		upcast_dice_per_slot = 1,
		description = "BRAZOS DE HADAR (conjuracion 1) — brujo",
	})
	_s("buenas_bayas", "BUENAS BAYAS", 1, School.CONJURACION, CastingTime.ACCION, ["V","S"], 0, "24 horas", false, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "BUENAS BAYAS (conjuracion 1) — druida, explorador",
	})
	_s("caida_de_pluma", "CAÍDA DE PLUMA", 1, School.TRANSMUTACION, CastingTime.REACCION, ["V","S"], 59, "1 minuto", false, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "CAÍDA DE PLUMA (transmutacion 1) — bardo, hechicero, mago",
	})
	_s("castigo_abrasador", "CASTIGO ABRASADOR", 1, School.EVOCACION, CastingTime.ACCION_ADICIONAL, ["V","S"], 0, "1 minuto", false, {
		ability_type = AbilityData.AbilityType.SAVING_THROW, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "str",
		damage_dice_count = 1, damage_dice_sides = 6, damage_type = "fuego",
		upcast_dice_per_slot = 1,
		description = "CASTIGO ABRASADOR (evocacion 1) — paladín",
	})
	_s("castigo_atronador", "CASTIGO ATRONADOR", 1, School.EVOCACION, CastingTime.ACCION_ADICIONAL, ["V","S"], 0, "Instantáneo", false, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		upcast_dice_per_slot = 1,
		description = "CASTIGO ATRONADOR (evocacion 1) — paladín",
	})
	_s("castigo_divino", "CASTIGO DIVINO", 1, School.EVOCACION, CastingTime.ACCION, ["V","S"], 0, "Instantáneo", false, {
		ability_type = AbilityData.AbilityType.SPELL_ATTACK, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		damage_dice_count = 2, damage_dice_sides = 8, damage_type = "none",
		upcast_dice_per_slot = 1,
		description = "CASTIGO DIVINO (evocacion 1) — paladín",
	})
	_s("castigo_furioso", "CASTIGO FURIOSO", 1, School.NECROMANCIA, CastingTime.ACCION_ADICIONAL, ["V","S"], 0, "1 minuto", false, {
		ability_type = AbilityData.AbilityType.SPELL_ATTACK, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		damage_dice_count = 1, damage_dice_sides = 6, damage_type = "none",
		upcast_dice_per_slot = 1,
		description = "CASTIGO FURIOSO (necromancia 1) — paladín",
	})
	_s("crear_o_destruir_agua", "CREAR O DESTRUIR AGUA", 1, School.TRANSMUTACION, CastingTime.ACCION, ["V","S"], 30, "Instantáneo", false, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "CREAR O DESTRUIR AGUA (transmutacion 1) — clérigo, druida",
	})
	_s("cuchillo_de_hielo", "CUCHILLO DE HIELO", 1, School.CONJURACION, CastingTime.ACCION, ["V","S"], 59, "Instantáneo", false, {
		ability_type = AbilityData.AbilityType.SAVING_THROW, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "dex",
		damage_dice_count = 2, damage_dice_sides = 6, damage_type = "frio",
		upcast_dice_per_slot = 1,
		description = "CUCHILLO DE HIELO (conjuracion 1) — druida, hechicero, mago",
	})
	_s("curar_heridas", "CURAR HERIDAS", 1, School.ABJURACION, CastingTime.ACCION, ["V","S"], 30, "Instantaneo", false, {
		ability_type = AbilityData.AbilityType.HEAL, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "CURAR HERIDAS (abjuracion 1) — ",
	})
	_s("detectar_el_bien_y_el_mal", "DETECTAR EL BIEN Y EL MAL", 1, School.ADIVINACION, CastingTime.ACCION, ["V","S"], 0, "Concentración, hasta 10 minutos", true, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "DETECTAR EL BIEN Y EL MAL (adivinacion 1) — clérigo, paladín",
	})
	_s("detectar_magia", "DETECTAR MAGIA", 1, School.ADIVINACION, CastingTime.ACCION, ["V","S"], 0, "Concentración, hasta 10 minutos", true, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "DETECTAR MAGIA (adivinacion 1) — ",
	})
	_s("detectar_venenos_y_enfermedades", "DETECTAR VENENOS Y ENFERMEDADES", 1, School.ADIVINACION, CastingTime.ACCION, ["V","S"], 30, "1 hora", true, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "DETECTAR VENENOS Y ENFERMEDADES (adivinacion 1) — clérigo, druida, explorador, paladín",
	})
	_s("disfrazarse", "DISFRAZARSE", 1, School.ILUSION, CastingTime.ACCION, ["V","S"], 0, "1 hora", false, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "DISFRAZARSE (ilusion 1) — bardo, hechicero, mago",
	})
	_s("dormir", "DORMIR", 1, School.ENCANTAMIENTO, CastingTime.ACCION, ["V","S"], 59, "Concentración, hasta 1 minuto", true, {
		ability_type = AbilityData.AbilityType.SAVING_THROW, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "wis",
		description = "DORMIR (encantamiento 1) — bardo, hechicero, mago",
	})
	_s("duelo_forzado", "DUELO FORZADO", 1, School.ENCANTAMIENTO, CastingTime.ACCION_ADICIONAL, ["V","S"], 30, "Concentración, hasta 1 minuto", true, {
		ability_type = AbilityData.AbilityType.SAVING_THROW, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "wis",
		description = "DUELO FORZADO (encantamiento 1) — paladín",
	})
	_s("encantar_animal", "ENCANTAR ANIMAL", 1, School.ENCANTAMIENTO, CastingTime.ACCION, ["V","S"], 30, "24 horas", false, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "ENCANTAR ANIMAL (encantamiento 1) — bardo, druida, explorador",
	})
	_s("encontrar_familiar", "ENCONTRAR FAMILIAR", 1, School.CONJURACION, CastingTime.HORA_1, ["V","S"], 10, "Instantáneo", false, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "ENCONTRAR FAMILIAR (conjuracion 1) — mago",
	})
	_s("enmaranar", "ENMARAÑAR", 1, School.CONJURACION, CastingTime.ACCION, ["V","S"], 89, "Concentración, hasta 1 minuto", true, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "ENMARAÑAR (conjuracion 1) — druida, explorador",
	})
	_s("entender_idiomas", "ENTENDER IDIOMAS", 1, School.ADIVINACION, CastingTime.REACCION, ["V","S"], 0, "1 asalto", false, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "ENTENDER IDIOMAS (adivinacion 1) — bardo, brujo, hechicero, mago",
	})
	_s("escudo_de_fe", "ESCUDO DE FE", 1, School.ABJURACION, CastingTime.ACCION_ADICIONAL, ["V","S"], 59, "Concentración, hasta 10 minutos", true, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "ESCUDO DE FE (abjuracion 1) — clérigo, paladín",
	})
	_s("falsa_vida", "FALSA VIDA", 1, School.NECROMANCIA, CastingTime.ACCION, ["V","S"], 0, "Instantáneo", false, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "FALSA VIDA (necromancia 1) — hechicero, mago",
	})
	_s("favor_divino", "FAVOR DIVINO", 1, School.TRANSMUTACION, CastingTime.ACCION_ADICIONAL, ["V","S"], 0, "1 minuto", false, {
		ability_type = AbilityData.AbilityType.SPELL_ATTACK, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		damage_dice_count = 1, damage_dice_sides = 4, damage_type = "none",
		description = "FAVOR DIVINO (transmutacion 1) — paladín",
	})
	_s("fuego_feerico", "FUEGO FEÉRICO", 1, School.EVOCACION, CastingTime.ACCION, ["V","S"], 59, "Concentración, hasta 1 minuto", true, {
		ability_type = AbilityData.AbilityType.SAVING_THROW, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "dex",
		description = "FUEGO FEÉRICO (evocacion 1) — bardo, druida",
	})
	_s("golpe_apresador", "GOLPE APRESADOR", 1, School.CONJURACION, CastingTime.ACCION_ADICIONAL, ["V","S"], 0, "Concentración, hasta 1 minuto", true, {
		ability_type = AbilityData.AbilityType.SAVING_THROW, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "str",
		upcast_dice_per_slot = 1,
		description = "GOLPE APRESADOR (conjuracion 1) — explorador",
	})
	_s("grasa", "GRASA", 1, School.CONJURACION, CastingTime.ACCION, ["V","S"], 59, "1 minuto", false, {
		ability_type = AbilityData.AbilityType.SAVING_THROW, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "dex",
		description = "GRASA (conjuracion 1) — hechicero, mago",
	})
	_s("hablar_con_los_animales", "HABLAR CON LOS ANIMALES", 1, School.ADIVINACION, CastingTime.ACCION, ["V","S"], 0, "10 minutos", false, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "HABLAR CON LOS ANIMALES (adivinacion 1) — bardo, brujo, druida, explorador",
	})
	_s("hechizar_persona", "HECHIZAR PERSONA", 1, School.ENCANTAMIENTO, CastingTime.ACCION, ["V","S"], 0, "Concentración, hasta 1 minuto", true, {
		ability_type = AbilityData.AbilityType.SAVING_THROW, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "wis",
		description = "HECHIZAR PERSONA (encantamiento 1) — bardo, brujo, druida, hechicero, mago",
	})
	_s("identificar", "IDENTIFICAR", 1, School.ADIVINACION, CastingTime.MINUTO_1, ["V","S"], 0, "Instantáneo", false, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "IDENTIFICAR (adivinacion 1) — bardo, mago",
	})
	_s("imagen_silenciosa", "IMAGEN SILENCIOSA", 1, School.ILUSION, CastingTime.ACCION, ["V","S"], 59, "Concentración, hasta 10 minutos", true, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "IMAGEN SILENCIOSA (ilusion 1) — bardo, hechicero, mago",
	})
	_s("infligir_heridas", "INFLIGIR HERIDAS", 1, School.NECROMANCIA, CastingTime.ACCION, ["V","S"], 0, "Instantáneo", false, {
		ability_type = AbilityData.AbilityType.SPELL_ATTACK, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		damage_dice_count = 2, damage_dice_sides = 10, damage_type = "none",
		upcast_dice_per_slot = 1,
		description = "INFLIGIR HERIDAS (necromancia 1) — clérigo",
	})
	_s("maleficio", "MALEFICIO", 1, School.ENCANTAMIENTO, CastingTime.ACCION_ADICIONAL, ["V","S"], 118, "Concentración, hasta 1 minuto", true, {
		ability_type = AbilityData.AbilityType.SAVING_THROW, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "str",
		damage_dice_count = 1, damage_dice_sides = 6, damage_type = "none",
		description = "MALEFICIO (encantamiento 1) — brujo",
	})
	_s("manos_ardientes", "MANOS ARDIENTES", 1, School.EVOCACION, CastingTime.ACCION, ["V","S"], 0, "Instantáneo", false, {
		ability_type = AbilityData.AbilityType.SAVING_THROW, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "dex",
		damage_dice_count = 3, damage_dice_sides = 6, damage_type = "fuego",
		upcast_dice_per_slot = 1,
		description = "MANOS ARDIENTES (evocacion 1) — hechicero, mago",
	})
	_s("marca_del_cazador", "MARCA DEL CAZADOR", 1, School.ADIVINACION, CastingTime.ACCION_ADICIONAL, ["V","S"], 89, "Concentración, hasta 1 hora", true, {
		ability_type = AbilityData.AbilityType.SPELL_ATTACK, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		damage_dice_count = 1, damage_dice_sides = 6, damage_type = "fuerza",
		description = "MARCA DEL CAZADOR (adivinacion 1) — explorador",
	})
	_s("nube_de_oscurecimiento", "NUBE DE OSCURECIMIENTO", 1, School.CONJURACION, CastingTime.ACCION, ["V","S"], 118, "Concentración, hasta 1 hora", true, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "NUBE DE OSCURECIMIENTO (conjuracion 1) — druida, explorador, hechicero, mago",
	})
	_s("ola_atronadora", "OLA ATRONADORA", 1, School.EVOCACION, CastingTime.ACCION, ["V","S"], 0, "Instantáneo", false, {
		ability_type = AbilityData.AbilityType.SAVING_THROW, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "con",
		damage_dice_count = 2, damage_dice_sides = 8, damage_type = "trueno",
		upcast_dice_per_slot = 1,
		description = "OLA ATRONADORA (evocacion 1) — bardo, druida, hechicero, mago",
	})
	_s("orbe_cromatico", "ORBE CROMÁTICO", 1, School.EVOCACION, CastingTime.ACCION, ["V","S"], 89, "Instantáneo", false, {
		ability_type = AbilityData.AbilityType.SPELL_ATTACK, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		damage_dice_count = 3, damage_dice_sides = 8, damage_type = "none",
		upcast_dice_per_slot = 1,
		description = "ORBE CROMÁTICO (evocacion 1) — hechicero, mago",
	})
	_s("orden_imperiosa", "ORDEN IMPERIOSA", 1, School.ENCANTAMIENTO, CastingTime.ACCION, ["V","S"], 59, "Instantáneo", false, {
		ability_type = AbilityData.AbilityType.SAVING_THROW, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "wis",
		description = "ORDEN IMPERIOSA (encantamiento 1) — bardo, clérigo, paladín",
	})
	_s("palabra_de_curacion", "PALABRA DE CURACIÓN", 1, School.ABJURACION, CastingTime.ACCION_ADICIONAL, ["V","S"], 59, "Instantáneo", false, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "PALABRA DE CURACIÓN (abjuracion 1) — bardo, clérigo, druida",
	})
	_s("perdicion", "PERDICIÓN", 1, School.ENCANTAMIENTO, CastingTime.ACCION, ["V","S"], 30, "Concentración, hasta 1 minuto", true, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "PERDICIÓN (encantamiento 1) — bardo, clérigo, brujo",
	})
	_s("proteccion_contra_el_bien_y_el_mal", "PROTECCIÓN CONTRA EL BIEN Y EL MAL", 1, School.ABJURACION, CastingTime.ACCION, ["V","S"], 0, "Concentración, hasta 10 minutos", true, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "PROTECCIÓN CONTRA EL BIEN Y EL MAL (abjuracion 1) — brujo, clérigo, druida, mago, paladín",
	})
	_s("proyectil_magico", "PROYECTIL MÁGICO", 1, School.EVOCACION, CastingTime.ACCION, ["V","S"], 118, "Instantáneo", false, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "PROYECTIL MÁGICO (evocacion 1) — hechicero, mago",
	})
	_s("purificar_comida_y_bebida", "PURIFICAR COMIDA Y BEBIDA", 1, School.TRANSMUTACION, CastingTime.ACCION, ["V","S"], 10, "Instantáneo", false, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "PURIFICAR COMIDA Y BEBIDA (transmutacion 1) — clérigo, druida, paladín",
	})
	_s("rayo_de_hechiceria", "RAYO DE HECHICERÍA", 1, School.EVOCACION, CastingTime.ACCION, ["V","S"], 59, "Concentración, hasta 1 minuto", true, {
		ability_type = AbilityData.AbilityType.SPELL_ATTACK, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		damage_dice_count = 2, damage_dice_sides = 12, damage_type = "relampago",
		upcast_dice_per_slot = 1,
		description = "RAYO DE HECHICERÍA (evocacion 1) — brujo, hechicero, mago",
	})
	_s("rayo_nauseabundo", "RAYO NAUSEABUNDO", 1, School.NECROMANCIA, CastingTime.ACCION, ["V","S"], 59, "Instantáneo", false, {
		ability_type = AbilityData.AbilityType.SPELL_ATTACK, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		damage_dice_count = 2, damage_dice_sides = 8, damage_type = "none",
		upcast_dice_per_slot = 1,
		description = "RAYO NAUSEABUNDO (necromancia 1) — hechicero, mago",
	})
	_s("reprension_infernal", "REPRENSIÓN INFERNAL", 1, School.EVOCACION, CastingTime.REACCION, ["V","S"], 59, "Instantáneo", false, {
		ability_type = AbilityData.AbilityType.SAVING_THROW, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "dex",
		damage_dice_count = 2, damage_dice_sides = 10, damage_type = "none",
		upcast_dice_per_slot = 1,
		description = "REPRENSIÓN INFERNAL (evocacion 1) — brujo",
	})
	_s("retirada_expeditiva", "RETIRADA EXPEDITIVA", 1, School.TRANSMUTACION, CastingTime.ACCION_ADICIONAL, ["V","S"], 0, "Concentración, hasta 10 minutos", true, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "RETIRADA EXPEDITIVA (transmutacion 1) — brujo, hechicero, mago",
	})
	_s("risa_horrible_de_tasha", "RISA HORRIBLE DE TASHA", 1, School.ENCANTAMIENTO, CastingTime.ACCION, ["V","S"], 30, "Concentración, hasta 1 minuto", true, {
		ability_type = AbilityData.AbilityType.SAVING_THROW, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "wis",
		description = "RISA HORRIBLE DE TASHA (encantamiento 1) — bardo, brujo, mago",
	})
	_s("rociada_de_color", "ROCIADA DE COLOR", 1, School.EVOCACION, CastingTime.ACCION, ["V","S"], 0, "Instantáneo", false, {
		ability_type = AbilityData.AbilityType.SAVING_THROW, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "con",
		description = "ROCIADA DE COLOR (evocacion 1) — bardo, hechicero, mago",
	})
	_s("saeta_guia", "SAETA GUÍA", 1, School.EVOCACION, CastingTime.ACCION, ["V","S"], 118, "1 asalto", false, {
		ability_type = AbilityData.AbilityType.SPELL_ATTACK, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		damage_dice_count = 4, damage_dice_sides = 6, damage_type = "none",
		upcast_dice_per_slot = 1,
		description = "SAETA GUÍA (evocacion 1) — clérigo",
	})
	_s("salto", "SALTO", 1, School.TRANSMUTACION, CastingTime.ACCION_ADICIONAL, ["V","S"], 0, "1 minuto", false, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "SALTO (transmutacion 1) — druida, explorador, hechicero, mago",
	})
	_s("santuario", "SANTUARIO", 1, School.ABJURACION, CastingTime.ACCION_ADICIONAL, ["V","S"], 30, "1 minuto", false, {
		ability_type = AbilityData.AbilityType.SAVING_THROW, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "wis",
		description = "SANTUARIO (abjuracion 1) — clérigo",
	})
	_s("sirviente_invisible", "SIRVIENTE INVISIBLE", 1, School.CONJURACION, CastingTime.ACCION, ["V","S"], 59, "1 hora", false, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "SIRVIENTE INVISIBLE (conjuracion 1) — bardo, brujo, mago",
	})
	_s("susurros_discordantes", "SUSURROS DISCORDANTES", 1, School.ENCANTAMIENTO, CastingTime.ACCION, ["V","S"], 59, "Instantáneo", false, {
		ability_type = AbilityData.AbilityType.SAVING_THROW, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "wis",
		damage_dice_count = 3, damage_dice_sides = 6, damage_type = "none",
		upcast_dice_per_slot = 1,
		description = "SUSURROS DISCORDANTES (encantamiento 1) — bardo",
	})
	_s("texto_ilusorio", "TEXTO ILUSORIO", 1, School.ILUSION, CastingTime.MINUTO_1, ["V","S"], 0, "10 días", false, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "TEXTO ILUSORIO (ilusion 1) — bardo, brujo, mago",
	})
	_s("zancada_prodigiosa", "ZANCADA PRODIGIOSA", 1, School.TRANSMUTACION, CastingTime.ACCION, ["V","S"], 0, "1 hora", false, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "ZANCADA PRODIGIOSA (transmutacion 1) — bardo, druida, explorador, mago",
	})

func _register_nivel_2_auto() -> void:
	_s("abrir", "ABRIR", 2, School.TRANSMUTACION, CastingTime.ACCION, ["V","S"], 59, "Instantáneo", false, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "ABRIR (transmutacion 2) — bardo, hechicero, mago",
	})
	_s("agrandarreducir", "AGRANDAR/REDUCIR", 2, School.TRANSMUTACION, CastingTime.ACCION, ["V","S"], 30, "Concentración, hasta 1 minuto", true, {
		ability_type = AbilityData.AbilityType.SAVING_THROW, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "str",
		damage_dice_count = 1, damage_dice_sides = 4, damage_type = "none",
		description = "AGRANDAR/REDUCIR (transmutacion 2) — bardo, druida, hechicero, mago",
	})
	_s("aliento_de_dragon", "ALIENTO DE DRAGÓN", 2, School.TRANSMUTACION, CastingTime.ACCION_ADICIONAL, ["V","S"], 0, "Concentración, hasta 1 minuto", true, {
		ability_type = AbilityData.AbilityType.SAVING_THROW, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "dex",
		damage_dice_count = 3, damage_dice_sides = 6, damage_type = "none",
		upcast_dice_per_slot = 1,
		description = "ALIENTO DE DRAGÓN (transmutacion 2) — hechicero, mago",
	})
	_s("alterar_el_propio_aspecto", "ALTERAR EL PROPIO ASPECTO", 2, School.TRANSMUTACION, CastingTime.ACCION, ["V","S"], 0, "Concentración, hasta 1 hora", true, {
		ability_type = AbilityData.AbilityType.SPELL_ATTACK, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		damage_dice_count = 1, damage_dice_sides = 6, damage_type = "none",
		description = "ALTERAR EL PROPIO ASPECTO (transmutacion 2) — hechicero, mago",
	})
	_s("arma_espiritual", "ARMA ESPIRITUAL", 2, School.EVOCACION, CastingTime.ACCION_ADICIONAL, ["V","S"], 59, "Concentración, hasta 1 minuto", true, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		upcast_dice_per_slot = 1,
		description = "ARMA ESPIRITUAL (evocacion 2) — clérigo",
	})
	_s("arma_magica", "ARMA MÁGICA", 2, School.TRANSMUTACION, CastingTime.ACCION_ADICIONAL, ["V","S"], 0, "1 hora", false, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "ARMA MÁGICA (transmutacion 2) — explorador, hechicero, mago, paladín",
	})
	_s("augurio", "AUGURIO", 2, School.ADIVINACION, CastingTime.MINUTO_1, ["V","S"], 0, "Instantáneo", false, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "AUGURIO (adivinacion 2) — clérigo, druida, mago",
	})
	_s("aura_magica_de_nystul", "AURA MÁGICA DE NYSTUL", 2, School.ILUSION, CastingTime.ACCION, ["V","S"], 0, "24 horas", false, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "AURA MÁGICA DE NYSTUL (ilusion 2) — mago",
	})
	_s("auxilio", "AUXILIO", 2, School.ABJURACION, CastingTime.ACCION, ["V","S"], 30, "8 horas", false, {
		ability_type = AbilityData.AbilityType.HEAL, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "AUXILIO (abjuracion 2) — bardo, clérigo, druida, explorador, paladín",
	})
	_s("boca_magica", "BOCA MÁGICA", 2, School.ILUSION, CastingTime.MINUTO_1, ["V","S"], 30, "Hasta que sea disipado", false, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "BOCA MÁGICA (ilusion 2) — bardo, mago",
	})
	_s("calentar_metal", "CALENTAR METAL", 2, School.TRANSMUTACION, CastingTime.ACCION, ["V","S"], 59, "Concentración, hasta 1 minuto", true, {
		ability_type = AbilityData.AbilityType.SPELL_ATTACK, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		damage_dice_count = 2, damage_dice_sides = 8, damage_type = "fuego",
		upcast_dice_per_slot = 1,
		description = "CALENTAR METAL (transmutacion 2) — bardo, druida",
	})
	_s("calmar_emociones", "CALMAR EMOCIONES", 2, School.ENCANTAMIENTO, CastingTime.ACCION, ["V","S"], 59, "Concentración, hasta 1 minuto", true, {
		ability_type = AbilityData.AbilityType.SAVING_THROW, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "cha",
		description = "CALMAR EMOCIONES (encantamiento 2) — bardo, clérigo",
	})
	_s("cerradura_arcana", "CERRADURA ARCANA", 2, School.ABJURACION, CastingTime.ACCION, ["V","S"], 0, "Hasta que sea disipado", false, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "CERRADURA ARCANA (abjuracion 2) — mago",
	})
	_s("clavo_mental", "CLAVO MENTAL", 2, School.ADIVINACION, CastingTime.ACCION, ["V","S"], 118, "Concentración, hasta 1 hora", true, {
		ability_type = AbilityData.AbilityType.SAVING_THROW, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "wis",
		upcast_dice_per_slot = 1,
		description = "CLAVO MENTAL (adivinacion 2) — brujo, hechicero, mago",
	})
	_s("contorno_borroso", "CONTORNO BORROSO", 2, School.ILUSION, CastingTime.ACCION, ["V","S"], 0, "Concentración, hasta 1 minuto", true, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "CONTORNO BORROSO (ilusion 2) — hechicero, mago",
	})
	_s("cordon_de_flechas", "CORDÓN DE FLECHAS", 2, School.TRANSMUTACION, CastingTime.ACCION, ["V","S"], 0, "8 horas", false, {
		ability_type = AbilityData.AbilityType.SAVING_THROW, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "dex",
		description = "CORDÓN DE FLECHAS (transmutacion 2) — explorador",
	})
	_s("corona_de_la_locura", "CORONA DE LA LOCURA", 2, School.ENCANTAMIENTO, CastingTime.ACCION, ["V","S"], 118, "Concentración, hasta 1 minuto", true, {
		ability_type = AbilityData.AbilityType.SAVING_THROW, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "wis",
		description = "CORONA DE LA LOCURA (encantamiento 2) — bardo, brujo, hechicero, mago",
	})
	_s("crecimiento_espinoso", "CRECIMIENTO ESPINOSO", 2, School.TRANSMUTACION, CastingTime.ACCION, ["V","S"], 148, "Concentración, hasta 10 minutos", true, {
		ability_type = AbilityData.AbilityType.SPELL_ATTACK, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		damage_dice_count = 2, damage_dice_sides = 4, damage_type = "none",
		description = "CRECIMIENTO ESPINOSO (transmutacion 2) — druida, explorador",
	})
	_s("detectar_pensamientos", "DETECTAR PENSAMIENTOS", 2, School.ADIVINACION, CastingTime.ACCION, ["V","S"], 0, "Concentración, hasta 1 minuto", true, {
		ability_type = AbilityData.AbilityType.SAVING_THROW, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "wis",
		description = "DETECTAR PENSAMIENTOS (adivinacion 2) — bardo, hechicero, mago",
	})
	_s("detectar_trampas", "DETECTAR TRAMPAS", 2, School.ADIVINACION, CastingTime.ACCION, ["V","S"], 118, "Instantáneo", false, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "DETECTAR TRAMPAS (adivinacion 2) — clérigo, druida, explorador",
	})
	_s("dulce_descanso", "DULCE DESCANSO", 2, School.NECROMANCIA, CastingTime.ACCION, ["V","S"], 0, "10 días", false, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "DULCE DESCANSO (necromancia 2) — clérigo, mago, paladín",
	})
	_s("embelesar", "EMBELESAR", 2, School.ENCANTAMIENTO, CastingTime.ACCION, ["V","S"], 59, "Concentración, hasta 1 minuto", true, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "EMBELESAR (encantamiento 2) — bardo, brujo",
	})
	_s("esfera_de_llamas", "ESFERA DE LLAMAS", 2, School.CONJURACION, CastingTime.ACCION, ["V","S"], 59, "Concentración, hasta 1 minuto", true, {
		ability_type = AbilityData.AbilityType.SAVING_THROW, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "dex",
		damage_dice_count = 2, damage_dice_sides = 6, damage_type = "fuego",
		upcast_dice_per_slot = 1,
		description = "ESFERA DE LLAMAS (conjuracion 2) — druida, hechicero, mago",
	})
	_s("flecha_acida_de_melf", "FLECHA ÁCIDA DE MELF", 2, School.EVOCACION, CastingTime.ACCION, ["V","S"], 89, "Instantáneo", false, {
		ability_type = AbilityData.AbilityType.SPELL_ATTACK, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		damage_dice_count = 4, damage_dice_sides = 4, damage_type = "acido",
		upcast_dice_per_slot = 1,
		description = "FLECHA ÁCIDA DE MELF (evocacion 2) — mago",
	})
	_s("fuerza_fantasmal", "FUERZA FANTASMAL", 2, School.ILUSION, CastingTime.ACCION, ["V","S"], 59, "Concentración, hasta 1 minuto", true, {
		ability_type = AbilityData.AbilityType.SAVING_THROW, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "int",
		damage_dice_count = 2, damage_dice_sides = 8, damage_type = "none",
		description = "FUERZA FANTASMAL (ilusion 2) — bardo, hechicero, mago",
	})
	_s("hacer_anicos", "HACER AÑICOS", 2, School.EVOCACION, CastingTime.ACCION, ["V","S"], 59, "Instantáneo", false, {
		ability_type = AbilityData.AbilityType.SAVING_THROW, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "con",
		damage_dice_count = 3, damage_dice_sides = 8, damage_type = "trueno",
		upcast_dice_per_slot = 1,
		description = "HACER AÑICOS (evocacion 2) — bardo, hechicero, mago",
	})
	_s("hallar_corcel", "HALLAR CORCEL", 2, School.CONJURACION, CastingTime.ACCION, ["V","S"], 30, "Instantáneo", false, {
		ability_type = AbilityData.AbilityType.SAVING_THROW, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "wis",
		description = "HALLAR CORCEL (conjuracion 2) — paladín",
	})
	_s("hoja_de_fuego", "HOJA DE FUEGO", 2, School.EVOCACION, CastingTime.ACCION_ADICIONAL, ["V","S"], 0, "Concentración, hasta 10 minutos", true, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		upcast_dice_per_slot = 1,
		description = "HOJA DE FUEGO (evocacion 2) — druida, hechicero",
	})
	_s("imagen_multiple", "IMAGEN MÚLTIPLE", 2, School.ILUSION, CastingTime.ACCION, ["V","S"], 0, "1 minuto", false, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "IMAGEN MÚLTIPLE (ilusion 2) — bardo, brujo, hechicero, mago",
	})
	_s("inmovilizar_persona", "INMOVILIZAR PERSONA", 2, School.ENCANTAMIENTO, CastingTime.ACCION, ["V","S"], 59, "Concentración, hasta 1 minuto", true, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "INMOVILIZAR PERSONA (encantamiento 2) — ",
	})
	_s("invisibilidad", "INVISIBILIDAD", 2, School.ILUSION, CastingTime.ACCION, ["V","S"], 0, "Concentración, hasta 1 hora", true, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "INVISIBILIDAD (ilusion 2) — bardo, brujo, hechicero, mago",
	})
	_s("invocar_bestia", "INVOCAR BESTIA", 2, School.CONJURACION, CastingTime.ACCION, ["V","S"], 89, "Concentración, hasta 1 hora", true, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "INVOCAR BESTIA (conjuracion 2) — druida, explorador",
	})
	_s("levitar", "LEVITAR", 2, School.TRANSMUTACION, CastingTime.ACCION, ["V","S"], 59, "Concentración, hasta 10 minutos", true, {
		ability_type = AbilityData.AbilityType.SAVING_THROW, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "con",
		description = "LEVITAR (transmutacion 2) — hechicero, mago",
	})
	_s("llama_permanente", "LLAMA PERMANENTE", 2, School.EVOCACION, CastingTime.ACCION, ["V","S"], 0, "Hasta que sea disipado", false, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "LLAMA PERMANENTE (evocacion 2) — clérigo, druida, mago",
	})
	_s("localizar_animales_o_plantas", "LOCALIZAR ANIMALES O PLANTAS", 2, School.ADIVINACION, CastingTime.ACCION, ["V","S"], 0, "Instantáneo", false, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "LOCALIZAR ANIMALES O PLANTAS (adivinacion 2) — bardo, druida, explorador",
	})
	_s("localizar_objeto", "LOCALIZAR OBJETO", 2, School.ADIVINACION, CastingTime.ACCION, ["V","S"], 0, "Concentración, hasta 10 minutos", true, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "LOCALIZAR OBJETO (adivinacion 2) — ",
	})
	_s("mensajero_animal", "MENSAJERO ANIMAL", 2, School.ENCANTAMIENTO, CastingTime.ACCION, ["V","S"], 30, "24 horas", false, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "MENSAJERO ANIMAL (encantamiento 2) — bardo, druida, explorador",
	})
	_s("nube_de_dagas", "NUBE DE DAGAS", 2, School.CONJURACION, CastingTime.ACCION, ["V","S"], 59, "Concentración, hasta 1 minuto", true, {
		ability_type = AbilityData.AbilityType.SPELL_ATTACK, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		damage_dice_count = 4, damage_dice_sides = 4, damage_type = "none",
		description = "NUBE DE DAGAS (conjuracion 2) — bardo, brujo, hechicero, mago",
	})
	_s("oscuridad", "OSCURIDAD", 2, School.EVOCACION, CastingTime.ACCION, ["V","S"], 59, "Concentración, hasta 10 minutos", true, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "OSCURIDAD (evocacion 2) — brujo, hechicero, mago",
	})
	_s("pasar_sin_rastro", "PASAR SIN RASTRO", 2, School.ABJURACION, CastingTime.ACCION, ["V","S"], 0, "Concentración, hasta 1 hora", true, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "PASAR SIN RASTRO (abjuracion 2) — druida, explorador",
	})
	_s("paso_brumoso", "PASO BRUMOSO", 2, School.CONJURACION, CastingTime.ACCION_ADICIONAL, ["V","S"], 0, "Instantáneo", false, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "PASO BRUMOSO (conjuracion 2) — brujo, hechicero, mago",
	})
	_s("piel_robliza", "PIEL ROBLIZA", 2, School.TRANSMUTACION, CastingTime.ACCION_ADICIONAL, ["V","S"], 0, "1 hora", false, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "PIEL ROBLIZA (transmutacion 2) — druida, explorador",
	})
	_s("plegaria_de_curacion", "PLEGARIA DE CURACIÓN", 2, School.ABJURACION, CastingTime.MINUTO_10, ["V","S"], 30, "Instantáneo", false, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		upcast_dice_per_slot = 1,
		description = "PLEGARIA DE CURACIÓN (abjuracion 2) — clérigo, paladín",
	})
	_s("potenciar_caracteristica", "POTENCIAR CARACTERÍSTICA", 2, School.TRANSMUTACION, CastingTime.ACCION, ["V","S"], 0, "Concentración, hasta 1 hora", true, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "POTENCIAR CARACTERÍSTICA (transmutacion 2) — ",
	})
	_s("proteccion_contra_veneno", "PROTECCIÓN CONTRA VENENO", 2, School.ABJURACION, CastingTime.ACCION, ["V","S"], 0, "1 hora", false, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "PROTECCIÓN CONTRA VENENO (abjuracion 2) — clérigo, druida, explorador, paladín",
	})
	_s("rafaga_de_viento", "RÁFAGA DE VIENTO", 2, School.EVOCACION, CastingTime.ACCION, ["V","S"], 0, "Concentración, hasta 1 minuto", true, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "RÁFAGA DE VIENTO (evocacion 2) — druida, explorador, hechicero, mago",
	})
	_s("rayo_abrasador", "RAYO ABRASADOR", 2, School.EVOCACION, CastingTime.ACCION, ["V","S"], 118, "Instantáneo", false, {
		ability_type = AbilityData.AbilityType.SPELL_ATTACK, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		damage_dice_count = 2, damage_dice_sides = 6, damage_type = "fuego",
		description = "RAYO ABRASADOR (evocacion 2) — hechicero, mago",
	})
	_s("rayo_de_luna", "RAYO DE LUNA", 2, School.EVOCACION, CastingTime.ACCION, ["V","S"], 118, "Concentración, hasta 1 minuto", true, {
		ability_type = AbilityData.AbilityType.SPELL_ATTACK, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		damage_dice_count = 2, damage_dice_sides = 10, damage_type = "none",
		upcast_dice_per_slot = 1,
		description = "RAYO DE LUNA (evocacion 2) — druida",
	})
	_s("rayo_debilitador", "RAYO DEBILITADOR", 2, School.NECROMANCIA, CastingTime.ACCION, ["V","S"], 59, "Concentración, hasta 1 minuto", true, {
		ability_type = AbilityData.AbilityType.SAVING_THROW, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "con",
		description = "RAYO DEBILITADOR (necromancia 2) — brujo, mago",
	})
	_s("restablecimiento_menor", "RESTABLECIMIENTO MENOR", 2, School.ABJURACION, CastingTime.ACCION_ADICIONAL, ["V","S"], 0, "Instantáneo", false, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "RESTABLECIMIENTO MENOR (abjuracion 2) — ",
	})
	_s("sentidos_de_la_bestia", "SENTIDOS DE LA BESTIA", 2, School.ADIVINACION, CastingTime.ACCION, ["V","S"], 0, "Concentración, hasta 1 hora", true, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "SENTIDOS DE LA BESTIA (adivinacion 2) — druida, explorador",
	})
	_s("silencio", "SILENCIO", 2, School.ILUSION, CastingTime.ACCION, ["V","S"], 118, "Concentración, hasta 10 minutos", true, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "SILENCIO (ilusion 2) — bardo, clérigo, explorador",
	})
	_s("sorderaceguera", "SORDERA/CEGUERA", 2, School.TRANSMUTACION, CastingTime.ACCION, ["V","S"], 118, "1 minuto", false, {
		ability_type = AbilityData.AbilityType.SAVING_THROW, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "con",
		description = "SORDERA/CEGUERA (transmutacion 2) — bardo, clérigo, hechicero, mago",
	})
	_s("sugestion", "SUGESTIÓN", 2, School.ENCANTAMIENTO, CastingTime.ACCION, ["V","S"], 30, "Concentración, hasta 8 horas", true, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "SUGESTIÓN (encantamiento 2) — bardo, brujo, hechicero, mago",
	})
	_s("telarana", "TELARAÑA", 2, School.CONJURACION, CastingTime.ACCION, ["V","S"], 59, "Concentración, hasta 1 hora", true, {
		ability_type = AbilityData.AbilityType.SAVING_THROW, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "dex",
		damage_dice_count = 2, damage_dice_sides = 4, damage_type = "fuego",
		description = "TELARAÑA (conjuracion 2) — hechicero, mago",
	})
	_s("trepar_cual_aracnido", "TREPAR CUAL ARÁCNIDO", 2, School.TRANSMUTACION, CastingTime.ACCION, ["V","S"], 0, "Concentración, hasta 1 hora", true, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "TREPAR CUAL ARÁCNIDO (transmutacion 2) — brujo, hechicero, mago",
	})
	_s("ver_invisibilidad", "VER INVISIBILIDAD", 2, School.ADIVINACION, CastingTime.ACCION, ["V","S"], 0, "1 hora", false, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "VER INVISIBILIDAD (adivinacion 2) — bardo, hechicero, mago",
	})
	_s("vigor_arcano", "VIGOR ARCANO", 2, School.ABJURACION, CastingTime.ACCION_ADICIONAL, ["V","S"], 0, "Instantáneo", false, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "VIGOR ARCANO (abjuracion 2) — hechicero, mago",
	})
	_s("vinculo_protector", "VÍNCULO PROTECTOR", 2, School.ABJURACION, CastingTime.ACCION, ["V","S"], 0, "1 hora", false, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "VÍNCULO PROTECTOR (abjuracion 2) — clérigo, paladín",
	})
	_s("vision_en_la_oscuridad", "VISIÓN EN LA OSCURIDAD", 2, School.TRANSMUTACION, CastingTime.ACCION, ["V","S"], 0, "8 horas", false, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "VISIÓN EN LA OSCURIDAD (transmutacion 2) — druida, explorador, hechicero, mago",
	})
	_s("zona_de_la_verdad", "ZONA DE LA VERDAD", 2, School.ENCANTAMIENTO, CastingTime.ACCION, ["V","S"], 59, "10 minutos", false, {
		ability_type = AbilityData.AbilityType.SAVING_THROW, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "cha",
		description = "ZONA DE LA VERDAD (encantamiento 2) — bardo, clérigo, paladín",
	})

func _register_nivel_3_auto() -> void:
	_s("acelerar", "ACELERAR", 3, School.TRANSMUTACION, CastingTime.ACCION, ["V","S"], 30, "Concentración, hasta 1 minuto", true, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "ACELERAR (transmutacion 3) — hechicero, mago",
	})
	_s("animar_a_los_muertos", "ANIMAR A LOS MUERTOS", 3, School.NECROMANCIA, CastingTime.MINUTO_1, ["V","S"], 10, "Instantáneo", false, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "ANIMAR A LOS MUERTOS (necromancia 3) — clérigo, mago",
	})
	_s("arma_elemental", "ARMA ELEMENTAL", 3, School.TRANSMUTACION, CastingTime.ACCION, ["V","S"], 0, "Concentración, hasta 1 hora", true, {
		ability_type = AbilityData.AbilityType.SPELL_ATTACK, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		damage_dice_count = 1, damage_dice_sides = 4, damage_type = "none",
		description = "ARMA ELEMENTAL (transmutacion 3) — druida, explorador, paladín",
	})
	_s("aura_de_vitalidad", "AURA DE VITALIDAD", 3, School.ABJURACION, CastingTime.ACCION, ["V","S"], 0, "Concentración, hasta 1 minuto", true, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "AURA DE VITALIDAD (abjuracion 3) — clérigo, druida, paladín",
	})
	_s("bola_de_fuego", "BOLA DE FUEGO", 3, School.EVOCACION, CastingTime.ACCION, ["V","S"], 148, "Instantáneo", false, {
		ability_type = AbilityData.AbilityType.SAVING_THROW, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "dex",
		damage_dice_count = 8, damage_dice_sides = 6, damage_type = "fuego",
		upcast_dice_per_slot = 1,
		description = "BOLA DE FUEGO (evocacion 3) — hechicero, mago",
	})
	_s("caminar_sobre_el_agua", "CAMINAR SOBRE EL AGUA", 3, School.TRANSMUTACION, CastingTime.ACCION, ["V","S"], 30, "1 hora", false, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "CAMINAR SOBRE EL AGUA (transmutacion 3) — clérigo, druida, explorador, hechicero",
	})
	_s("castigo_cegador", "CASTIGO CEGADOR", 3, School.EVOCACION, CastingTime.ACCION_ADICIONAL, ["V","S"], 0, "1 minuto", false, {
		ability_type = AbilityData.AbilityType.SAVING_THROW, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "con",
		damage_dice_count = 3, damage_dice_sides = 8, damage_type = "none",
		upcast_dice_per_slot = 1,
		description = "CASTIGO CEGADOR (evocacion 3) — paladín",
	})
	_s("circulo_magico", "CÍRCULO MÁGICO", 3, School.ABJURACION, CastingTime.MINUTO_1, ["V","S"], 10, "1 hora", false, {
		ability_type = AbilityData.AbilityType.SAVING_THROW, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "cha",
		description = "CÍRCULO MÁGICO (abjuracion 3) — brujo, clérigo, mago, paladín",
	})
	_s("clarividencia", "CLARIVIDENCIA", 3, School.ADIVINACION, CastingTime.MINUTO_10, ["V","S"], 30, "Concentración, hasta 10 minutos", true, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "CLARIVIDENCIA (adivinacion 3) — bardo, clérigo, hechicero, mago",
	})
	_s("conjurar_animales", "CONJURAR ANIMALES", 3, School.CONJURACION, CastingTime.ACCION, ["V","S"], 59, "Concentración, hasta 10 minutos", true, {
		ability_type = AbilityData.AbilityType.SAVING_THROW, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "dex",
		damage_dice_count = 3, damage_dice_sides = 10, damage_type = "none",
		upcast_dice_per_slot = 1,
		description = "CONJURAR ANIMALES (conjuracion 3) — druida, explorador",
	})
	_s("conjurar_descarga_de_proyectiles", "CONJURAR DESCARGA DE PROYECTILES", 3, School.CONJURACION, CastingTime.ACCION, ["V","S"], 0, "Instantáneo", false, {
		ability_type = AbilityData.AbilityType.SAVING_THROW, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "dex",
		damage_dice_count = 5, damage_dice_sides = 8, damage_type = "none",
		upcast_dice_per_slot = 1,
		description = "CONJURAR DESCARGA DE PROYECTILES (conjuracion 3) — explorador",
	})
	_s("contrahechizo", "CONTRAHECHIZO", 3, School.ABJURACION, CastingTime.REACCION, ["V","S"], 59, "Instantáneo", false, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "CONTRAHECHIZO (abjuracion 3) — brujo, hechicero, mago",
	})
	_s("corcel_fantasma", "CORCEL FANTASMA", 3, School.ILUSION, CastingTime.MINUTO_1, ["V","S"], 30, "1 hora", false, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "CORCEL FANTASMA (ilusion 3) — mago",
	})
	_s("crear_comida_y_agua", "CREAR COMIDA Y AGUA", 3, School.CONJURACION, CastingTime.ACCION, ["V","S"], 30, "Instantáneo", false, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "CREAR COMIDA Y AGUA (conjuracion 3) — clérigo, paladín",
	})
	_s("crecimiento_vegetal", "CRECIMIENTO VEGETAL", 3, School.TRANSMUTACION, CastingTime.ACCION, ["V","S"], 148, "Instantáneo", false, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "CRECIMIENTO VEGETAL (transmutacion 3) — bardo, druida, explorador",
	})
	_s("desplazamiento", "DESPLAZAMIENTO", 3, School.TRANSMUTACION, CastingTime.ACCION, ["V","S"], 0, "1 minuto", false, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "DESPLAZAMIENTO (transmutacion 3) — hechicero, mago",
	})
	_s("disipar_magia", "DISIPAR MAGIA", 3, School.ABJURACION, CastingTime.ACCION, ["V","S"], 118, "Instantáneo", false, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "DISIPAR MAGIA (abjuracion 3) — ",
	})
	_s("don_de_lenguas", "DON DE LENGUAS", 3, School.ADIVINACION, CastingTime.ACCION, ["V","S"], 0, "1 hora", false, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "DON DE LENGUAS (adivinacion 3) — bardo, brujo, clérigo, hechicero, mago",
	})
	_s("espiritus_guardianes", "ESPÍRITUS GUARDIANES", 3, School.CONJURACION, CastingTime.ACCION, ["V","S"], 0, "Concentración, hasta 10 minutos", true, {
		ability_type = AbilityData.AbilityType.SAVING_THROW, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "wis",
		damage_dice_count = 3, damage_dice_sides = 8, damage_type = "none",
		upcast_dice_per_slot = 1,
		description = "ESPÍRITUS GUARDIANES (conjuracion 3) — clérigo",
	})
	_s("fingir_muerte", "FINGIR MUERTE", 3, School.NECROMANCIA, CastingTime.ACCION, ["V","S"], 0, "1 hora", false, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "FINGIR MUERTE (necromancia 3) — bardo, clérigo, druida, mago",
	})
	_s("flecha_de_relampago", "FLECHA DE RELÁMPAGO", 3, School.TRANSMUTACION, CastingTime.ACCION_ADICIONAL, ["V","S"], 0, "Instantáneo", false, {
		ability_type = AbilityData.AbilityType.SPELL_ATTACK, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		damage_dice_count = 4, damage_dice_sides = 8, damage_type = "relampago",
		upcast_dice_per_slot = 1,
		description = "FLECHA DE RELÁMPAGO (transmutacion 3) — explorador",
	})
	_s("forma_gaseosa", "FORMA GASEOSA", 3, School.TRANSMUTACION, CastingTime.ACCION, ["V","S"], 0, "Concentración, hasta 1 hora", true, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "FORMA GASEOSA (transmutacion 3) — brujo, hechicero, mago",
	})
	_s("fundirse_con_la_piedra", "FUNDIRSE CON LA PIEDRA", 3, School.TRANSMUTACION, CastingTime.ACCION, ["V","S"], 0, "8 horas", false, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "FUNDIRSE CON LA PIEDRA (transmutacion 3) — clérigo, druida, explorador",
	})
	_s("glifo_custodio", "GLIFO CUSTODIO", 3, School.ABJURACION, CastingTime.HORA_1, ["V","S"], 0, "Hasta que sea disipado o se active", false, {
		ability_type = AbilityData.AbilityType.SAVING_THROW, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "dex",
		damage_dice_count = 5, damage_dice_sides = 8, damage_type = "none",
		upcast_dice_per_slot = 1,
		description = "GLIFO CUSTODIO (abjuracion 3) — bardo, clérigo, mago",
	})
	_s("hablar_con_las_plantas", "HABLAR CON LAS PLANTAS", 3, School.TRANSMUTACION, CastingTime.ACCION, ["V","S"], 0, "10 minutos", false, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "HABLAR CON LAS PLANTAS (transmutacion 3) — bardo, druida, explorador",
	})
	_s("hablar_con_los_muertos", "HABLAR CON LOS MUERTOS", 3, School.NECROMANCIA, CastingTime.ACCION, ["V","S"], 10, "10 minutos", false, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "HABLAR CON LOS MUERTOS (necromancia 3) — bardo, clérigo, mago",
	})
	_s("hambre_de_hadar", "HAMBRE DE HADAR", 3, School.CONJURACION, CastingTime.ACCION, ["V","S"], 148, "Concentración, hasta 1 minuto", true, {
		ability_type = AbilityData.AbilityType.SAVING_THROW, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "dex",
		damage_dice_count = 2, damage_dice_sides = 6, damage_type = "frio",
		upcast_dice_per_slot = 1,
		description = "HAMBRE DE HADAR (conjuracion 3) — brujo",
	})
	_s("imagen_mayor", "IMAGEN MAYOR", 3, School.ILUSION, CastingTime.ACCION, ["V","S"], 118, "Concentración, hasta 10 minutos", true, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "IMAGEN MAYOR (ilusion 3) — bardo, brujo, hechicero, mago",
	})
	_s("imponer_maldicion", "IMPONER MALDICIÓN", 3, School.NECROMANCIA, CastingTime.ACCION, ["V","S"], 0, "Concentración, hasta 1 minuto", true, {
		ability_type = AbilityData.AbilityType.SAVING_THROW, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "wis",
		damage_dice_count = 1, damage_dice_sides = 8, damage_type = "none",
		description = "IMPONER MALDICIÓN (necromancia 3) — bardo, clérigo, mago",
	})
	_s("indetectable", "INDETECTABLE", 3, School.ABJURACION, CastingTime.ACCION, ["V","S"], 0, "8 horas", false, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "INDETECTABLE (abjuracion 3) — bardo, explorador, mago",
	})
	_s("invocar_feerico", "INVOCAR FEÉRICO", 3, School.CONJURACION, CastingTime.ACCION, ["V","S"], 89, "Concentración, hasta 1 hora", true, {
		ability_type = AbilityData.AbilityType.SAVING_THROW, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "wis",
		description = "INVOCAR FEÉRICO (conjuracion 3) — brujo, druida, explorador, mago",
	})
	_s("invocar_muerto_viviente", "INVOCAR MUERTO VIVIENTE", 3, School.NECROMANCIA, CastingTime.ACCION, ["V","S"], 89, "Concentración, hasta 1 hora", true, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "INVOCAR MUERTO VIVIENTE (necromancia 3) — brujo, mago",
	})
	_s("levantar_maldicion", "LEVANTAR MALDICIÓN", 3, School.ABJURACION, CastingTime.ACCION, ["V","S"], 0, "Instantáneo", false, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "LEVANTAR MALDICIÓN (abjuracion 3) — brujo, clérigo, mago, paladín",
	})
	_s("llamar_al_relampago", "LLAMAR AL RELÁMPAGO", 3, School.CONJURACION, CastingTime.ACCION, ["V","S"], 118, "Concentración, hasta 10 minutos", true, {
		ability_type = AbilityData.AbilityType.SAVING_THROW, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "dex",
		upcast_dice_per_slot = 1,
		description = "LLAMAR AL RELÁMPAGO (conjuracion 3) — druida",
	})
	_s("manto_del_cruzado", "MANTO DEL CRUZADO", 3, School.EVOCACION, CastingTime.ACCION, ["V","S"], 0, "Concentración, hasta 1 minuto", true, {
		ability_type = AbilityData.AbilityType.SPELL_ATTACK, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		damage_dice_count = 1, damage_dice_sides = 4, damage_type = "none",
		description = "MANTO DEL CRUZADO (evocacion 3) — paladín",
	})
	_s("muro_de_viento", "MURO DE VIENTO", 3, School.EVOCACION, CastingTime.ACCION, ["V","S"], 118, "Concentración, hasta 1 minuto", true, {
		ability_type = AbilityData.AbilityType.SAVING_THROW, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "str",
		damage_dice_count = 4, damage_dice_sides = 8, damage_type = "none",
		description = "MURO DE VIENTO (evocacion 3) — druida, explorador",
	})
	_s("nube_apestosa", "NUBE APESTOSA", 3, School.CONJURACION, CastingTime.ACCION, ["V","S"], 89, "Concentración, hasta 1 minuto", true, {
		ability_type = AbilityData.AbilityType.SAVING_THROW, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "con",
		description = "NUBE APESTOSA (conjuracion 3) — bardo, hechicero, mago",
	})
	_s("palabra_de_curacion_en_masa", "PALABRA DE CURACIÓN EN MASA", 3, School.ABJURACION, CastingTime.ACCION_ADICIONAL, ["V","S"], 59, "Instantáneo", false, {
		ability_type = AbilityData.AbilityType.SPELL_ATTACK, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		damage_dice_count = 12, damage_dice_sides = 12, damage_type = "none",
		upcast_dice_per_slot = 1,
		description = "PALABRA DE CURACIÓN EN MASA (abjuracion 3) — bardo, clérigo",
	})
	_s("patron_hipnotico", "PATRÓN HIPNÓTICO", 3, School.ILUSION, CastingTime.ACCION, ["V","S"], 118, "Concentración, hasta 1 minuto", true, {
		ability_type = AbilityData.AbilityType.SAVING_THROW, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "wis",
		description = "PATRÓN HIPNÓTICO (ilusion 3) — bardo, brujo, hechicero, mago",
	})
	_s("pequena_choza_de_leomund", "PEQUEÑA CHOZA DE LEOMUND", 3, School.EVOCACION, CastingTime.MINUTO_1, ["V","S"], 0, "8 horas", false, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "PEQUEÑA CHOZA DE LEOMUND (evocacion 3) — bardo, mago",
	})
	_s("proteccion_contra_energia", "PROTECCIÓN CONTRA ENERGÍA", 3, School.ABJURACION, CastingTime.ACCION, ["V","S"], 0, "Concentración, hasta 1 hora", true, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "PROTECCIÓN CONTRA ENERGÍA (abjuracion 3) — ",
	})
	_s("ralentizar", "RALENTIZAR", 3, School.TRANSMUTACION, CastingTime.ACCION, ["V","S"], 118, "Concentración, hasta 1 minuto", true, {
		ability_type = AbilityData.AbilityType.SAVING_THROW, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "dex",
		description = "RALENTIZAR (transmutacion 3) — bardo, hechicero, mago",
	})
	_s("recado", "RECADO", 3, School.ADIVINACION, CastingTime.ACCION, ["V","S"], 30, "Instantáneo", false, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "RECADO (adivinacion 3) — bardo, clérigo, mago",
	})
	_s("relampago", "RELÁMPAGO", 3, School.EVOCACION, CastingTime.ACCION, ["V","S"], 0, "Instantáneo", false, {
		ability_type = AbilityData.AbilityType.SAVING_THROW, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "dex",
		damage_dice_count = 8, damage_dice_sides = 6, damage_type = "none",
		upcast_dice_per_slot = 1,
		description = "RELÁMPAGO (evocacion 3) — hechicero, mago",
	})
	_s("respirar_bajo_el_agua", "RESPIRAR BAJO EL AGUA", 3, School.TRANSMUTACION, CastingTime.ACCION, ["V","S"], 30, "24 horas", false, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "RESPIRAR BAJO EL AGUA (transmutacion 3) — druida, explorador, hechicero, mago",
	})
	_s("revivir", "REVIVIR", 3, School.NECROMANCIA, CastingTime.ACCION, ["V","S"], 0, "Instantáneo", false, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "REVIVIR (necromancia 3) — clérigo, druida, explorador, paladín",
	})
	_s("senal_de_esperanza", "SEÑAL DE ESPERANZA", 3, School.ABJURACION, CastingTime.ACCION, ["V","S"], 30, "Concentración, hasta 1 minuto", true, {
		ability_type = AbilityData.AbilityType.SAVING_THROW, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "wis",
		description = "SEÑAL DE ESPERANZA (abjuracion 3) — clérigo",
	})
	_s("toque_vampirico", "TOQUE VAMPÍRICO", 3, School.NECROMANCIA, CastingTime.ACCION, ["V","S"], 0, "Concentración, hasta 1 minuto", true, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		upcast_dice_per_slot = 1,
		description = "TOQUE VAMPÍRICO (necromancia 3) — brujo, hechicero, mago",
	})
	_s("tormenta_de_aguanieve", "TORMENTA DE AGUANIEVE", 3, School.CONJURACION, CastingTime.ACCION_ADICIONAL, ["V","S"], 0, "Instantáneo", true, {
		ability_type = AbilityData.AbilityType.SAVING_THROW, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "dex",
		damage_dice_count = 1, damage_dice_sides = 10, damage_type = "none",
		upcast_dice_per_slot = 1,
		description = "TORMENTA DE AGUANIEVE (conjuracion 3) — druida, hechicero, mago",
	})
	_s("volar", "VOLAR", 3, School.TRANSMUTACION, CastingTime.ACCION, ["V","S"], 0, "Concentración, hasta 10 minutos", true, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "VOLAR (transmutacion 3) — brujo, hechicero, mago",
	})

func _register_nivel_4_auto() -> void:
	_s("adivinacion", "ADIVINACIÓN", 4, School.ADIVINACION, CastingTime.ACCION, ["V","S"], 0, "Instantáneo", false, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "ADIVINACIÓN (adivinacion 4) — clérigo, druida, mago",
	})
	_s("asesino_fantasmal", "ASESINO FANTASMAL", 4, School.ILUSION, CastingTime.ACCION, ["V","S"], 118, "Concentración, hasta 1 minuto", true, {
		ability_type = AbilityData.AbilityType.SAVING_THROW, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "wis",
		damage_dice_count = 4, damage_dice_sides = 10, damage_type = "none",
		upcast_dice_per_slot = 1,
		description = "ASESINO FANTASMAL (ilusion 4) — bardo, mago",
	})
	_s("aura_de_pureza", "AURA DE PUREZA", 4, School.ABJURACION, CastingTime.ACCION, ["V","S"], 0, "Concentración, hasta 10 minutos", true, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "AURA DE PUREZA (abjuracion 4) — clérigo, paladín",
	})
	_s("aura_de_vida", "AURA DE VIDA", 4, School.ABJURACION, CastingTime.ACCION, ["V","S"], 0, "Concentración, hasta 10 minutos", true, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "AURA DE VIDA (abjuracion 4) — clérigo, paladín",
	})
	_s("castigo_abrumador", "CASTIGO ABRUMADOR", 4, School.ENCANTAMIENTO, CastingTime.ACCION_ADICIONAL, ["V","S"], 0, "Concentración, hasta 1 minuto", true, {
		ability_type = AbilityData.AbilityType.SPELL_ATTACK, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		damage_dice_count = 4, damage_dice_sides = 6, damage_type = "none",
		upcast_dice_per_slot = 1,
		description = "CASTIGO ABRUMADOR (encantamiento 4) — paladín",
	})
	_s("cofre_oculto_de_leomund", "COFRE OCULTO DE LEOMUND", 4, School.CONJURACION, CastingTime.ACCION, ["V","S"], 0, "Hasta que sea disipado", false, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "COFRE OCULTO DE LEOMUND (conjuracion 4) — mago",
	})
	_s("compulsion", "COMPULSIÓN", 4, School.ENCANTAMIENTO, CastingTime.ACCION, ["V","S"], 30, "Concentración, hasta 1 minuto", true, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "COMPULSIÓN (encantamiento 4) — bardo",
	})
	_s("confusion", "CONFUSIÓN", 4, School.ENCANTAMIENTO, CastingTime.ACCION, ["V","S"], 89, "Concentración, hasta 1 minuto", true, {
		ability_type = AbilityData.AbilityType.SAVING_THROW, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "wis",
		description = "CONFUSIÓN (encantamiento 4) — bardo, druida, hechicero, mago",
	})
	_s("conjurar_elementales_menores", "CONJURAR ELEMENTALES MENORES", 4, School.CONJURACION, CastingTime.ACCION, ["V","S"], 0, "Concentración, hasta 10 minutos", true, {
		ability_type = AbilityData.AbilityType.SPELL_ATTACK, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		damage_dice_count = 2, damage_dice_sides = 8, damage_type = "none",
		description = "CONJURAR ELEMENTALES MENORES (conjuracion 4) — druida, mago",
	})
	_s("conjurar_seres_del_bosque", "CONJURAR SERES DEL BOSQUE", 4, School.CONJURACION, CastingTime.ACCION, ["V","S"], 0, "Concentración, hasta 10 minutos", true, {
		ability_type = AbilityData.AbilityType.SAVING_THROW, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "wis",
		damage_dice_count = 5, damage_dice_sides = 8, damage_type = "fuerza",
		upcast_dice_per_slot = 1,
		description = "CONJURAR SERES DEL BOSQUE (conjuracion 4) — druida, explorador",
	})
	_s("controlar_agua", "CONTROLAR AGUA", 4, School.TRANSMUTACION, CastingTime.ACCION, ["V","S"], 295, "Concentración, hasta 10 minutos", true, {
		ability_type = AbilityData.AbilityType.SPELL_ATTACK, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		damage_dice_count = 2, damage_dice_sides = 8, damage_type = "Fuerza",
		description = "CONTROLAR AGUA (transmutacion 4) — clérigo, druida, mago",
	})
	_s("destierro", "DESTIERRO", 4, School.ABJURACION, CastingTime.ACCION, ["V","S"], 30, "Concentración, hasta 1 minuto", true, {
		ability_type = AbilityData.AbilityType.SAVING_THROW, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "cha",
		description = "DESTIERRO (abjuracion 4) — brujo, clérigo, hechicero, mago, paladín",
	})
	_s("dominar_bestia", "DOMINAR BESTIA", 4, School.ENCANTAMIENTO, CastingTime.ACCION, ["V","S"], 59, "Concentración, hasta 1 minuto", true, {
		ability_type = AbilityData.AbilityType.SAVING_THROW, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "wis",
		description = "DOMINAR BESTIA (encantamiento 4) — druida, explorador, hechicero",
	})
	_s("enredadera", "ENREDADERA", 4, School.CONJURACION, CastingTime.ACCION_ADICIONAL, ["V","S"], 59, "Concentración, hasta 1 minuto", true, {
		ability_type = AbilityData.AbilityType.SPELL_ATTACK, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		damage_dice_count = 4, damage_dice_sides = 8, damage_type = "none",
		description = "ENREDADERA (conjuracion 4) — druida, explorador",
	})
	_s("escudo_de_fuego", "ESCUDO DE FUEGO", 4, School.EVOCACION, CastingTime.ACCION, ["V","S"], 0, "10 minutos", false, {
		ability_type = AbilityData.AbilityType.SPELL_ATTACK, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		damage_dice_count = 2, damage_dice_sides = 8, damage_type = "fuego",
		description = "ESCUDO DE FUEGO (evocacion 4) — druida, hechicero, mago",
	})
	_s("esfera_elastica_de_otiluke", "ESFERA ELÁSTICA DE OTILUKE", 4, School.ABJURACION, CastingTime.ACCION, ["V","S"], 30, "Concentración, hasta 1 minuto", true, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "ESFERA ELÁSTICA DE OTILUKE (abjuracion 4) — mago",
	})
	_s("esfera_vitriolica", "ESFERA VITRIÓLICA", 4, School.EVOCACION, CastingTime.ACCION, ["V","S"], 148, "Instantáneo", false, {
		ability_type = AbilityData.AbilityType.SAVING_THROW, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "dex",
		damage_dice_count = 10, damage_dice_sides = 4, damage_type = "acido",
		description = "ESFERA VITRIÓLICA (evocacion 4) — hechicero, mago",
	})
	_s("fabricar", "FABRICAR", 4, School.TRANSMUTACION, CastingTime.MINUTO_10, ["V","S"], 118, "Instantáneo", false, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "FABRICAR (transmutacion 4) — mago",
	})
	_s("fuente_de_luz_lunar", "FUENTE DE LUZ LUNAR", 4, School.EVOCACION, CastingTime.ACCION, ["V","S"], 0, "Concentración, hasta 10 minutos", true, {
		ability_type = AbilityData.AbilityType.SAVING_THROW, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "con",
		description = "FUENTE DE LUZ LUNAR (evocacion 4) — bardo, druida",
	})
	_s("guarda_contra_la_muerte", "GUARDA CONTRA LA MUERTE", 4, School.ABJURACION, CastingTime.ACCION, ["V","S"], 0, "8 horas", false, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "GUARDA CONTRA LA MUERTE (abjuracion 4) — clérigo, paladín",
	})
	_s("guardian_de_la_fe", "GUARDIÁN DE LA FE", 4, School.CONJURACION, CastingTime.ACCION, ["V","S"], 30, "8 horas", false, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "GUARDIÁN DE LA FE (conjuracion 4) — clérigo",
	})
	_s("hechizar_monstruo", "HECHIZAR MONSTRUO", 4, School.ENCANTAMIENTO, CastingTime.ACCION, ["V","S"], 30, "1 hora", false, {
		ability_type = AbilityData.AbilityType.SAVING_THROW, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "wis",
		description = "HECHIZAR MONSTRUO (encantamiento 4) — bardo, brujo, druida, hechicero, mago",
	})
	_s("insecto_gigante", "INSECTO GIGANTE", 4, School.CONJURACION, CastingTime.ACCION, ["V","S"], 59, "Concentración, hasta 10 minutos", true, {
		ability_type = AbilityData.AbilityType.SPELL_ATTACK, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		damage_dice_count = 1, damage_dice_sides = 4, damage_type = "Veneno",
		description = "INSECTO GIGANTE (conjuracion 4) — druida",
	})
	_s("invisibilidad_mejorada", "INVISIBILIDAD MEJORADA", 4, School.ILUSION, CastingTime.ACCION, ["V","S"], 0, "Concentración, hasta 1 minuto", true, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "INVISIBILIDAD MEJORADA (ilusion 4) — bardo, hechicero, mago",
	})
	_s("invocar_aberracion", "INVOCAR ABERRACIÓN", 4, School.CONJURACION, CastingTime.ACCION, ["V","S"], 89, "Concentración, hasta 1 hora", true, {
		ability_type = AbilityData.AbilityType.SAVING_THROW, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "wis",
		damage_dice_count = 2, damage_dice_sides = 6, damage_type = "none",
		description = "INVOCAR ABERRACIÓN (conjuracion 4) — brujo, mago",
	})
	_s("invocar_automata", "INVOCAR AUTÓMATA", 4, School.CONJURACION, CastingTime.ACCION, ["V","S"], 89, "Concentración, hasta 1 hora", true, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "INVOCAR AUTÓMATA (conjuracion 4) — mago",
	})
	_s("invocar_elemental", "INVOCAR ELEMENTAL", 4, School.CONJURACION, CastingTime.ACCION, ["V","S"], 89, "Concentración, hasta 1 hora", true, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "INVOCAR ELEMENTAL (conjuracion 4) — druida, explorador, mago",
	})
	_s("libertad_de_movimiento", "LIBERTAD DE MOVIMIENTO", 4, School.ABJURACION, CastingTime.ACCION, ["V","S"], 0, "1 hora", false, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "LIBERTAD DE MOVIMIENTO (abjuracion 4) — bardo, clérigo, druida, explorador",
	})
	_s("localizar_criatura", "LOCALIZAR CRIATURA", 4, School.ADIVINACION, CastingTime.ACCION, ["V","S"], 0, "Concentración, hasta 1 hora", true, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "LOCALIZAR CRIATURA (adivinacion 4) — ",
	})
	_s("marchitar", "MARCHITAR", 4, School.NECROMANCIA, CastingTime.ACCION, ["V","S"], 30, "Instantáneo", false, {
		ability_type = AbilityData.AbilityType.SAVING_THROW, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "con",
		damage_dice_count = 8, damage_dice_sides = 8, damage_type = "none",
		upcast_dice_per_slot = 1,
		description = "MARCHITAR (necromancia 4) — brujo, druida, hechicero, mago",
	})
	_s("mastin_fiel_de_mordenkainen", "MASTÍN FIEL DE MORDENKAINEN", 4, School.CONJURACION, CastingTime.ACCION, ["V","S"], 30, "3 horas", false, {
		ability_type = AbilityData.AbilityType.SPELL_ATTACK, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		damage_dice_count = 4, damage_dice_sides = 8, damage_type = "fuerza",
		description = "MASTÍN FIEL DE MORDENKAINEN (conjuracion 4) — mago",
	})
	_s("moldear_la_piedra", "MOLDEAR LA PIEDRA", 4, School.TRANSMUTACION, CastingTime.ACCION, ["V","S"], 0, "Instantáneo", false, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "MOLDEAR LA PIEDRA (transmutacion 4) — clérigo, druida, mago",
	})
	_s("muro_de_fuego", "MURO DE FUEGO", 4, School.EVOCACION, CastingTime.ACCION, ["V","S"], 118, "Concentración, hasta 1 minuto", true, {
		ability_type = AbilityData.AbilityType.SAVING_THROW, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "dex",
		damage_dice_count = 5, damage_dice_sides = 8, damage_type = "fuego",
		upcast_dice_per_slot = 1,
		description = "MURO DE FUEGO (evocacion 4) — druida, hechicero, mago",
	})
	_s("ojo_arcano", "OJO ARCANO", 4, School.ADIVINACION, CastingTime.ACCION, ["V","S"], 30, "Concentración, hasta 1 hora", true, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "OJO ARCANO (adivinacion 4) — mago",
	})
	_s("piel_petrea", "PIEL PÉTREA", 4, School.TRANSMUTACION, CastingTime.ACCION, ["V","S"], 0, "Concentración, hasta 1 hora", true, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "PIEL PÉTREA (transmutacion 4) — druida, explorador, hechicero, mago",
	})
	_s("polimorfar", "POLIMORFAR", 4, School.TRANSMUTACION, CastingTime.ACCION, ["V","S"], 59, "Concentración, hasta 1 hora", true, {
		ability_type = AbilityData.AbilityType.SAVING_THROW, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "wis",
		description = "POLIMORFAR (transmutacion 4) — bardo, druida, hechicero, mago",
	})
	_s("puerta_dimensional", "PUERTA DIMENSIONAL", 4, School.CONJURACION, CastingTime.ACCION, ["V","S"], 492, "Instantáneo", false, {
		ability_type = AbilityData.AbilityType.SPELL_ATTACK, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		damage_dice_count = 4, damage_dice_sides = 6, damage_type = "fuerza",
		description = "PUERTA DIMENSIONAL (conjuracion 4) — bardo, brujo, hechicero, mago",
	})
	_s("de_mordenkainen", "DE MORDENKAINEN", 4, School.ABJURACION, CastingTime.MINUTO_10, ["V","S"], 118, "24 horas", false, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "DE MORDENKAINEN (abjuracion 4) — mago",
	})
	_s("tentaculos_negros_de_evard", "TENTÁCULOS NEGROS DE EVARD", 4, School.CONJURACION, CastingTime.ACCION, ["V","S"], 492, "Concentración, hasta 1 minuto", true, {
		ability_type = AbilityData.AbilityType.SAVING_THROW, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "dex",
		damage_dice_count = 12, damage_dice_sides = 6, damage_type = "none",
		description = "TENTÁCULOS NEGROS DE EVARD (conjuracion 4) — mago",
	})
	_s("terreno_alucinatorio", "TERRENO ALUCINATORIO", 4, School.ILUSION, CastingTime.MINUTO_10, ["V","S"], 0, "Concentración, hasta 1 minuto", true, {
		ability_type = AbilityData.AbilityType.SAVING_THROW, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "wis",
		description = "TERRENO ALUCINATORIO (ilusion 4) — bardo, brujo, druida, mago",
	})
	_s("tormenta_de_hielo", "TORMENTA DE HIELO", 4, School.EVOCACION, CastingTime.ACCION, ["V","S"], 295, "Instantáneo", false, {
		ability_type = AbilityData.AbilityType.SAVING_THROW, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "dex",
		damage_dice_count = 2, damage_dice_sides = 10, damage_type = "none",
		upcast_dice_per_slot = 1,
		description = "TORMENTA DE HIELO (evocacion 4) — druida, hechicero, mago",
	})

func _register_nivel_5_auto() -> void:
	_s("alterar_los_recuerdos", "ALTERAR LOS RECUERDOS", 5, School.ENCANTAMIENTO, CastingTime.ACCION, ["V","S"], 30, "Concentración, hasta 1 minuto", true, {
		ability_type = AbilityData.AbilityType.SAVING_THROW, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "wis",
		description = "ALTERAR LOS RECUERDOS (encantamiento 5) — bardo, mago",
	})
	_s("alzar_a_los_muertos", "ALZAR A LOS MUERTOS", 5, School.NECROMANCIA, CastingTime.HORA_1, ["V","S"], 0, "Instantáneo", false, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "ALZAR A LOS MUERTOS (necromancia 5) — bardo, clérigo, paladín",
	})
	_s("animar_objetos", "ANIMAR OBJETOS", 5, School.TRANSMUTACION, CastingTime.ACCION, ["V","S"], 118, "Concentración, hasta 1 minuto", true, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "ANIMAR OBJETOS (transmutacion 5) — bardo, hechicero, mago",
	})
	_s("apariencia", "APARIENCIA", 5, School.ILUSION, CastingTime.ACCION, ["V","S"], 30, "8 horas", false, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "APARIENCIA (ilusion 5) — bardo, hechicero, mago",
	})
	_s("atadura_planar", "ATADURA PLANAR", 5, School.ABJURACION, CastingTime.HORA_1, ["V","S"], 59, "24 horas", false, {
		ability_type = AbilityData.AbilityType.SAVING_THROW, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "cha",
		description = "ATADURA PLANAR (abjuracion 5) — bardo, brujo, clérigo, druida, mago",
	})
	_s("caparazon_antivida", "CAPARAZÓN ANTIVIDA", 5, School.ABJURACION, CastingTime.ACCION, ["V","S"], 0, "Concentración, hasta 1 hora", true, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "CAPARAZÓN ANTIVIDA (abjuracion 5) — druida",
	})
	_s("carcaj_veloz", "CARCAJ VELOZ", 5, School.TRANSMUTACION, CastingTime.ACCION_ADICIONAL, ["V","S"], 0, "Concentración, hasta 1 minuto", true, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "CARCAJ VELOZ (transmutacion 5) — explorador",
	})
	_s("castigo_desterrador", "CASTIGO DESTERRADOR", 5, School.CONJURACION, CastingTime.ACCION_ADICIONAL, ["V","S"], 0, "Concentración, hasta 1 minuto", true, {
		ability_type = AbilityData.AbilityType.SAVING_THROW, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "cha",
		damage_dice_count = 5, damage_dice_sides = 10, damage_type = "none",
		description = "CASTIGO DESTERRADOR (conjuracion 5) — paladín",
	})
	_s("circulo_de_poder", "CÍRCULO DE PODER", 5, School.ABJURACION, CastingTime.ACCION, ["V","S"], 0, "Concentración, hasta 10 minutos", true, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "CÍRCULO DE PODER (abjuracion 5) — clérigo, mago, paladín",
	})
	_s("circulo_de_teletransportacion", "CÍRCULO DE TELETRANSPORTACIÓN", 5, School.CONJURACION, CastingTime.ACCION, ["V","S"], 10, "1 asalto", false, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "CÍRCULO DE TELETRANSPORTACIÓN (conjuracion 5) — bardo, brujo, hechicero, mago",
	})
	_s("comunion", "COMUNIÓN", 5, School.ADIVINACION, CastingTime.MINUTO_1, ["V","S"], 0, "1 minuto", false, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "COMUNIÓN (adivinacion 5) — clérigo",
	})
	_s("comunion_con_la_naturaleza", "COMUNIÓN CON LA NATURALEZA", 5, School.ADIVINACION, CastingTime.MINUTO_1, ["V","S"], 0, "Instantáneo", false, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "COMUNIÓN CON LA NATURALEZA (adivinacion 5) — druida, explorador",
	})
	_s("conjurar_elemental", "CONJURAR ELEMENTAL", 5, School.CONJURACION, CastingTime.ACCION, ["V","S"], 59, "Concentración, hasta 10 minutos", true, {
		ability_type = AbilityData.AbilityType.SPELL_ATTACK, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		damage_dice_count = 8, damage_dice_sides = 8, damage_type = "none",
		description = "CONJURAR ELEMENTAL (conjuracion 5) — druida, mago",
	})
	_s("conjurar_lluvia_de_flechas", "CONJURAR LLUVIA DE FLECHAS", 5, School.CONJURACION, CastingTime.ACCION, ["V","S"], 148, "Instantáneo", false, {
		ability_type = AbilityData.AbilityType.SAVING_THROW, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "dex",
		damage_dice_count = 8, damage_dice_sides = 8, damage_type = "fuerza",
		description = "CONJURAR LLUVIA DE FLECHAS (conjuracion 5) — explorador",
	})
	_s("cono_de_frio", "CONO DE FRÍO", 5, School.EVOCACION, CastingTime.ACCION, ["V","S"], 0, "Instantáneo", false, {
		ability_type = AbilityData.AbilityType.SAVING_THROW, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "con",
		damage_dice_count = 8, damage_dice_sides = 8, damage_type = "none",
		upcast_dice_per_slot = 1,
		description = "CONO DE FRÍO (evocacion 5) — druida, hechicero, mago",
	})
	_s("conocer_las_leyendas", "CONOCER LAS LEYENDAS", 5, School.ADIVINACION, CastingTime.MINUTO_10, ["V","S"], 0, "Instantáneo", false, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "CONOCER LAS LEYENDAS (adivinacion 5) — bardo, clérigo, mago",
	})
	_s("consagrar", "CONSAGRAR", 5, School.ABJURACION, CastingTime.ACCION, ["V","S"], 0, "Hasta que sea disipado", false, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "CONSAGRAR (abjuracion 5) — clérigo",
	})
	_s("contactar_con_otro_plano", "CONTACTAR CON OTRO PLANO", 5, School.ADIVINACION, CastingTime.MINUTO_1, ["V","S"], 0, "1 minuto", false, {
		ability_type = AbilityData.AbilityType.SAVING_THROW, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "int",
		damage_dice_count = 6, damage_dice_sides = 6, damage_type = "none",
		description = "CONTACTAR CON OTRO PLANO (adivinacion 5) — brujo, mago",
	})
	_s("contagio", "CONTAGIO", 5, School.NECROMANCIA, CastingTime.ACCION, ["V","S"], 0, "7 días", false, {
		ability_type = AbilityData.AbilityType.SAVING_THROW, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "con",
		damage_dice_count = 11, damage_dice_sides = 8, damage_type = "none",
		description = "CONTAGIO (necromancia 5) — clérigo, druida",
	})
	_s("creacion", "CREACIÓN", 5, School.ILUSION, CastingTime.MINUTO_1, ["V","S"], 30, "Especial", false, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "CREACIÓN (ilusion 5) — hechicero, mago",
	})
	_s("curar_heridas_en_masa", "CURAR HERIDAS EN MASA", 5, School.ABJURACION, CastingTime.ACCION, ["V","S"], 59, "Instantáneo", false, {
		ability_type = AbilityData.AbilityType.HEAL, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		upcast_dice_per_slot = 1,
		description = "CURAR HERIDAS EN MASA (abjuracion 5) — bardo, clérigo, druida",
	})
	_s("despertar", "DESPERTAR", 5, School.TRANSMUTACION, CastingTime.HORA_8, ["V","S"], 0, "Instantáneo", false, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "DESPERTAR (transmutacion 5) — bardo, druida",
	})
	_s("disipar_el_bien_y_el_mal", "DISIPAR EL BIEN Y EL MAL", 5, School.ABJURACION, CastingTime.ACCION, ["V","S"], 0, "Concentración, hasta 1 minuto", true, {
		ability_type = AbilityData.AbilityType.SAVING_THROW, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "cha",
		description = "DISIPAR EL BIEN Y EL MAL (abjuracion 5) — clérigo, paladín",
	})
	_s("dominar_persona", "DOMINAR PERSONA", 5, School.ENCANTAMIENTO, CastingTime.ACCION, ["V","S"], 59, "Concentración, hasta 1 minuto", true, {
		ability_type = AbilityData.AbilityType.SAVING_THROW, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "wis",
		description = "DOMINAR PERSONA (encantamiento 5) — bardo, hechicero, mago",
	})
	_s("enganar", "ENGAÑAR", 5, School.ILUSION, CastingTime.ACCION, ["V","S"], 0, "Concentración, hasta 1 hora", true, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "ENGAÑAR (ilusion 5) — bardo, brujo, mago",
	})
	_s("enlace_telepatico_de_rary", "ENLACE TELEPÁTICO DE RARY", 5, School.ADIVINACION, CastingTime.ACCION, ["V","S"], 30, "1 hora", false, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "ENLACE TELEPÁTICO DE RARY (adivinacion 5) — bardo, mago",
	})
	_s("ensueno", "ENSUEÑO", 5, School.ILUSION, CastingTime.MINUTO_1, ["V","S"], 30, "8 horas", false, {
		ability_type = AbilityData.AbilityType.SAVING_THROW, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "wis",
		damage_dice_count = 3, damage_dice_sides = 6, damage_type = "none",
		description = "ENSUEÑO (ilusion 5) — bardo, brujo, mago",
	})
	_s("escudrinar", "ESCUDRIÑAR", 5, School.ADIVINACION, CastingTime.MINUTO_10, ["V","S"], 0, "Concentración, hasta 10 minutos", true, {
		ability_type = AbilityData.AbilityType.SAVING_THROW, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "wis",
		description = "ESCUDRIÑAR (adivinacion 5) — bardo, brujo, clérigo, druida, mago",
	})
	_s("estatica_sinaptica", "ESTÁTICA SINÁPTICA", 5, School.ENCANTAMIENTO, CastingTime.ACCION, ["V","S"], 118, "Instantáneo", false, {
		ability_type = AbilityData.AbilityType.SAVING_THROW, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "int",
		damage_dice_count = 8, damage_dice_sides = 6, damage_type = "none",
		description = "ESTÁTICA SINÁPTICA (encantamiento 5) — bardo, brujo, hechicero, mago",
	})
	_s("geas", "GEAS", 5, School.ENCANTAMIENTO, CastingTime.MINUTO_1, ["V","S"], 59, "30 días", false, {
		ability_type = AbilityData.AbilityType.SAVING_THROW, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "wis",
		damage_dice_count = 5, damage_dice_sides = 10, damage_type = "none",
		description = "GEAS (encantamiento 5) — bardo, clérigo, druida, mago, paladín",
	})
	_s("golpe_de_viento_acerado", "GOLPE DE VIENTO ACERADO", 5, School.CONJURACION, CastingTime.ACCION, ["V","S"], 30, "Instantáneo", false, {
		ability_type = AbilityData.AbilityType.SPELL_ATTACK, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		damage_dice_count = 6, damage_dice_sides = 10, damage_type = "fuerza",
		description = "GOLPE DE VIENTO ACERADO (conjuracion 5) — explorador, mago",
	})
	_s("golpe_flamigero", "GOLPE FLAMÍGERO", 5, School.EVOCACION, CastingTime.ACCION, ["V","S"], 59, "Instantáneo", false, {
		ability_type = AbilityData.AbilityType.SAVING_THROW, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "dex",
		damage_dice_count = 5, damage_dice_sides = 6, damage_type = "none",
		description = "GOLPE FLAMÍGERO (evocacion 5) — clérigo",
	})
	_s("inmovilizar_monstruo", "INMOVILIZAR MONSTRUO", 5, School.ENCANTAMIENTO, CastingTime.ACCION, ["V","S"], 89, "Concentración, hasta 1 minuto", true, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "INMOVILIZAR MONSTRUO (encantamiento 5) — bardo, brujo, hechicero, mago",
	})
	_s("invocar_celestial", "INVOCAR CELESTIAL", 5, School.CONJURACION, CastingTime.ACCION, ["V","S"], 89, "Concentración, hasta 1 hora", true, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "INVOCAR CELESTIAL (conjuracion 5) — clérigo, paladín",
	})
	_s("invocar_dragon", "INVOCAR DRAGÓN", 5, School.CONJURACION, CastingTime.ACCION, ["V","S"], 59, "Concentración, hasta 1 hora", true, {
		ability_type = AbilityData.AbilityType.SAVING_THROW, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "dex",
		damage_dice_count = 2, damage_dice_sides = 6, damage_type = "none",
		description = "INVOCAR DRAGÓN (conjuracion 5) — mago",
	})
	_s("muro_de_fuerza", "MURO DE FUERZA", 5, School.EVOCACION, CastingTime.ACCION, ["V","S"], 118, "Concentración, hasta 10 minutos", true, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "MURO DE FUERZA (evocacion 5) — mago",
	})
	_s("muro_de_piedra", "MURO DE PIEDRA", 5, School.EVOCACION, CastingTime.ACCION, ["V","S"], 118, "Concentración, hasta 10 minutos", true, {
		ability_type = AbilityData.AbilityType.SAVING_THROW, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "dex",
		description = "MURO DE PIEDRA (evocacion 5) — druida, hechicero, mago",
	})
	_s("nube_aniquiladora", "NUBE ANIQUILADORA", 5, School.CONJURACION, CastingTime.ACCION, ["V","S"], 118, "Concentración, hasta 10 minutos", true, {
		ability_type = AbilityData.AbilityType.SAVING_THROW, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "con",
		damage_dice_count = 5, damage_dice_sides = 8, damage_type = "none",
		upcast_dice_per_slot = 1,
		description = "NUBE ANIQUILADORA (conjuracion 5) — hechicero, mago",
	})
	_s("ola_destructora", "OLA DESTRUCTORA", 5, School.EVOCACION, CastingTime.ACCION, ["V","S"], 0, "Instantáneo", false, {
		ability_type = AbilityData.AbilityType.SAVING_THROW, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "con",
		damage_dice_count = 5, damage_dice_sides = 6, damage_type = "trueno",
		description = "OLA DESTRUCTORA (evocacion 5) — paladín",
	})
	_s("pasamuros", "PASAMUROS", 5, School.TRANSMUTACION, CastingTime.ACCION, ["V","S"], 30, "1 hora", false, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "PASAMUROS (transmutacion 5) — mago",
	})
	_s("paso_arboreo", "PASO ARBÓREO", 5, School.CONJURACION, CastingTime.ACCION, ["V","S"], 0, "Concentración, hasta 1 minuto", true, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "PASO ARBÓREO (conjuracion 5) — druida, explorador",
	})
	_s("plaga_de_insectos", "PLAGA DE INSECTOS", 5, School.CONJURACION, CastingTime.ACCION, ["V","S"], 295, "Concentración, hasta 10 minutos", true, {
		ability_type = AbilityData.AbilityType.SAVING_THROW, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "con",
		damage_dice_count = 4, damage_dice_sides = 10, damage_type = "none",
		upcast_dice_per_slot = 1,
		description = "PLAGA DE INSECTOS (conjuracion 5) — clérigo, druida, hechicero",
	})
	_s("presencia_regia_de_yolande", "PRESENCIA REGIA DE YOLANDE", 5, School.ENCANTAMIENTO, CastingTime.ACCION, ["V","S"], 0, "Concentración, hasta 1 minuto", true, {
		ability_type = AbilityData.AbilityType.SAVING_THROW, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "wis",
		description = "PRESENCIA REGIA DE YOLANDE (encantamiento 5) — bardo, mago",
	})
	_s("reencarnar", "REENCARNAR", 5, School.NECROMANCIA, CastingTime.HORA_1, ["V","S"], 0, "Instantáneo", false, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "REENCARNAR (necromancia 5) — druida",
	})
	_s("restablecimiento_mayor", "RESTABLECIMIENTO MAYOR", 5, School.ABJURACION, CastingTime.ACCION, ["V","S"], 0, "Instantáneo", false, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "RESTABLECIMIENTO MAYOR (abjuracion 5) — ",
	})
	_s("tormenta_resplandeciente_de_jallarzi", "TORMENTA RESPLANDECIENTE DE JALLARZI", 5, School.EVOCACION, CastingTime.ACCION, ["V","S"], 118, "Concentración, hasta 1 minuto", true, {
		ability_type = AbilityData.AbilityType.SPELL_ATTACK, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		damage_dice_count = 2, damage_dice_sides = 10, damage_type = "none",
		upcast_dice_per_slot = 1,
		description = "TORMENTA RESPLANDECIENTE DE JALLARZI (evocacion 5) — brujo, mago",
	})

func _register_nivel_6_auto() -> void:
	_s("aliado_planar", "ALIADO PLANAR", 6, School.CONJURACION, CastingTime.MINUTO_10, ["V","S"], 59, "Instantáneo", false, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "ALIADO PLANAR (conjuracion 6) — clérigo",
	})
	_s("baile_irresistible_de_otto", "BAILE IRRESISTIBLE DE OTTO", 6, School.ENCANTAMIENTO, CastingTime.ACCION, ["V","S"], 30, "Concentración, hasta 1 minuto", true, {
		ability_type = AbilityData.AbilityType.SAVING_THROW, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "dex",
		description = "BAILE IRRESISTIBLE DE OTTO (encantamiento 6) — bardo, mago",
	})
	_s("barrera_de_cuchillas", "BARRERA DE CUCHILLAS", 6, School.EVOCACION, CastingTime.ACCION, ["V","S"], 89, "Concentración, hasta 10 minutos", true, {
		ability_type = AbilityData.AbilityType.SAVING_THROW, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "dex",
		description = "BARRERA DE CUCHILLAS (evocacion 6) — clérigo",
	})
	_s("caldero_burbujeante_de_tasha", "CALDERO BURBUJEANTE DE TASHA", 6, School.CONJURACION, CastingTime.ACCION, ["V","S"], 5, "10 minutos", false, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "CALDERO BURBUJEANTE DE TASHA (conjuracion 6) — brujo, mago",
	})
	_s("circulo_de_muerte", "CÍRCULO DE MUERTE", 6, School.NECROMANCIA, CastingTime.ACCION, ["V","S"], 148, "Instantáneo", false, {
		ability_type = AbilityData.AbilityType.SPELL_ATTACK, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		damage_dice_count = 8, damage_dice_sides = 8, damage_type = "none",
		description = "CÍRCULO DE MUERTE (necromancia 6) — brujo, hechicero, mago",
	})
	_s("conjurar_feerico", "CONJURAR FEÉRICO", 6, School.CONJURACION, CastingTime.ACCION, ["V","S"], 59, "Concentración, hasta 10 minutos", true, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "CONJURAR FEÉRICO (conjuracion 6) — druida",
	})
	_s("contingencia", "CONTINGENCIA", 6, School.ABJURACION, CastingTime.MINUTO_10, ["V","S"], 0, "10 días", false, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "CONTINGENCIA (abjuracion 6) — mago",
	})
	_s("crear_muerto_viviente", "CREAR MUERTO VIVIENTE", 6, School.NECROMANCIA, CastingTime.MINUTO_1, ["V","S"], 10, "Instantáneo", false, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "CREAR MUERTO VIVIENTE (necromancia 6) — brujo, clérigo, mago",
	})
	_s("curar", "CURAR", 6, School.ABJURACION, CastingTime.ACCION, ["V","S"], 59, "Instantáneo", false, {
		ability_type = AbilityData.AbilityType.HEAL, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "CURAR (abjuracion 6) — clérigo, druida",
	})
	_s("danar", "DAÑAR", 6, School.NECROMANCIA, CastingTime.ACCION, ["V","S"], 59, "Instantáneo", false, {
		ability_type = AbilityData.AbilityType.SAVING_THROW, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "con",
		description = "DAÑAR (necromancia 6) — clérigo",
	})
	_s("de_la_carne_a_la_piedra", "DE LA CARNE A LA PIEDRA", 6, School.TRANSMUTACION, CastingTime.ACCION, ["V","S"], 59, "Concentración, hasta 1 minuto", true, {
		ability_type = AbilityData.AbilityType.SAVING_THROW, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "con",
		description = "DE LA CARNE A LA PIEDRA (transmutacion 6) — druida, hechicero, mago",
	})
	_s("desintegrar", "DESINTEGRAR", 6, School.TRANSMUTACION, CastingTime.ACCION, ["V","S"], 59, "Instantáneo", false, {
		ability_type = AbilityData.AbilityType.SAVING_THROW, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "dex",
		description = "DESINTEGRAR (transmutacion 6) — hechicero, mago",
	})
	_s("encontrar_el_camino", "ENCONTRAR EL CAMINO", 6, School.ADIVINACION, CastingTime.MINUTO_1, ["V","S"], 0, "Concentración, hasta 1 día", true, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "ENCONTRAR EL CAMINO (adivinacion 6) — bardo, clérigo, druida",
	})
	_s("esfera_congelante_de_otiluke", "ESFERA CONGELANTE DE OTILUKE", 6, School.EVOCACION, CastingTime.ACCION, ["V","S"], 295, "Instantáneo", false, {
		ability_type = AbilityData.AbilityType.SAVING_THROW, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "con",
		damage_dice_count = 10, damage_dice_sides = 6, damage_type = "none",
		upcast_dice_per_slot = 1,
		description = "ESFERA CONGELANTE DE OTILUKE (evocacion 6) — hechicero, mago",
	})
	_s("festin_de_heroes", "FESTÍN DE HÉROES", 6, School.CONJURACION, CastingTime.MINUTO_10, ["V","S"], 0, "Instantáneo", false, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "FESTÍN DE HÉROES (conjuracion 6) — bardo, clérigo, druida",
	})
	_s("globo_de_invulnerabilidad", "GLOBO DE INVULNERABILIDAD", 6, School.ABJURACION, CastingTime.ACCION, ["V","S"], 0, "Concentración, hasta 1 minuto", true, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "GLOBO DE INVULNERABILIDAD (abjuracion 6) — hechicero, mago",
	})
	_s("guardas_y_guardias", "GUARDAS Y GUARDIAS", 6, School.ABJURACION, CastingTime.HORA_1, ["V","S"], 0, "24 horas", false, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "GUARDAS Y GUARDIAS (abjuracion 6) — bardo, mago",
	})
	_s("ilusion_programada", "ILUSIÓN PROGRAMADA", 6, School.ILUSION, CastingTime.ACCION, ["V","S"], 118, "Hasta que sea disipado", false, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "ILUSIÓN PROGRAMADA (ilusion 6) — bardo, mago",
	})
	_s("invocacion_instantanea_de_drawmij", "INVOCACIÓN INSTANTÁNEA DE DRAWMIJ", 6, School.CONJURACION, CastingTime.MINUTO_1, ["V","S"], 0, "Hasta que sea disipado", false, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "INVOCACIÓN INSTANTÁNEA DE DRAWMIJ (conjuracion 6) — mago",
	})
	_s("invocar_infernal", "INVOCAR INFERNAL", 6, School.CONJURACION, CastingTime.ACCION, ["V","S"], 89, "Concentración, hasta 1 hora", true, {
		ability_type = AbilityData.AbilityType.SAVING_THROW, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "dex",
		description = "INVOCAR INFERNAL (conjuracion 6) — brujo, mago",
	})
	_s("mover_la_tierra", "MOVER LA TIERRA", 6, School.TRANSMUTACION, CastingTime.ACCION, ["V","S"], 118, "Concentración, hasta 2 horas", true, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "MOVER LA TIERRA (transmutacion 6) — druida, hechicero, mago",
	})
	_s("muro_de_espinas", "MURO DE ESPINAS", 6, School.CONJURACION, CastingTime.ACCION, ["V","S"], 118, "Concentración, hasta 10 minutos", true, {
		ability_type = AbilityData.AbilityType.SAVING_THROW, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "dex",
		description = "MURO DE ESPINAS (conjuracion 6) — druida",
	})
	_s("muro_de_hielo", "MURO DE HIELO", 6, School.EVOCACION, CastingTime.ACCION, ["V","S"], 118, "Concentración, hasta 10 minutos", true, {
		ability_type = AbilityData.AbilityType.SAVING_THROW, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "con",
		damage_dice_count = 5, damage_dice_sides = 6, damage_type = "frio",
		upcast_dice_per_slot = 1,
		description = "MURO DE HIELO (evocacion 6) — mago",
	})
	_s("palabra_de_regreso", "PALABRA DE REGRESO", 6, School.CONJURACION, CastingTime.ACCION, ["V","S"], 5, "Instantáneo", false, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "PALABRA DE REGRESO (conjuracion 6) — clérigo",
	})
	_s("prohibicion", "PROHIBICIÓN", 6, School.ABJURACION, CastingTime.MINUTO_10, ["V","S"], 0, "1 día", false, {
		ability_type = AbilityData.AbilityType.SPELL_ATTACK, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		damage_dice_count = 5, damage_dice_sides = 10, damage_type = "none",
		description = "PROHIBICIÓN (abjuracion 6) — clérigo",
	})
	_s("puerta_arcana", "PUERTA ARCANA", 6, School.CONJURACION, CastingTime.ACCION, ["V","S"], 492, "Concentración, hasta 10 minutos", true, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "PUERTA ARCANA (conjuracion 6) — brujo, hechicero, mago",
	})
	_s("rayo_solar", "RAYO SOLAR", 6, School.EVOCACION, CastingTime.ACCION, ["V","S"], 0, "Concentración, hasta 1 minuto", true, {
		ability_type = AbilityData.AbilityType.SAVING_THROW, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "con",
		damage_dice_count = 6, damage_dice_sides = 8, damage_type = "none",
		description = "RAYO SOLAR (evocacion 6) — clérigo, druida, hechicero, mago",
	})
	_s("relampago_en_cadena", "RELÁMPAGO EN CADENA", 6, School.EVOCACION, CastingTime.ACCION, ["V","S"], 148, "Instantáneo", false, {
		ability_type = AbilityData.AbilityType.SAVING_THROW, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "dex",
		damage_dice_count = 10, damage_dice_sides = 8, damage_type = "relampago",
		description = "RELÁMPAGO EN CADENA (evocacion 6) — hechicero, mago",
	})
	_s("sugestion_en_masa", "SUGESTIÓN EN MASA", 6, School.ENCANTAMIENTO, CastingTime.ACCION, ["V","S"], 59, "24 horas", false, {
		ability_type = AbilityData.AbilityType.SAVING_THROW, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "wis",
		description = "SUGESTIÓN EN MASA (encantamiento 6) — bardo, hechicero, mago",
	})
	_s("urna_magica", "URNA MÁGICA", 6, School.NECROMANCIA, CastingTime.MINUTO_1, ["V","S"], 0, "Hasta que sea disipado", false, {
		ability_type = AbilityData.AbilityType.SAVING_THROW, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "cha",
		description = "URNA MÁGICA (necromancia 6) — mago",
	})
	_s("viajar_con_el_viento", "VIAJAR CON EL VIENTO", 6, School.TRANSMUTACION, CastingTime.MINUTO_1, ["V","S"], 30, "8 horas", false, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "VIAJAR CON EL VIENTO (transmutacion 6) — druida",
	})
	_s("viajar_mediante_plantas", "VIAJAR MEDIANTE PLANTAS", 6, School.CONJURACION, CastingTime.ACCION, ["V","S"], 10, "1 minuto", false, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "VIAJAR MEDIANTE PLANTAS (conjuracion 6) — druida",
	})
	_s("vision_veraz", "VISIÓN VERAZ", 6, School.ADIVINACION, CastingTime.ACCION, ["V","S"], 0, "1 hora", false, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "VISIÓN VERAZ (adivinacion 6) — bardo, brujo, clérigo, hechicero, mago",
	})

func _register_nivel_7_auto() -> void:
	_s("bola_de_fuego_de_explosion_retardada", "BOLA DE FUEGO DE EXPLOSIÓN RETARDADA", 7, School.EVOCACION, CastingTime.ACCION, ["V","S"], 148, "Concentración, hasta 1 minuto", true, {
		ability_type = AbilityData.AbilityType.SAVING_THROW, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "dex",
		upcast_dice_per_slot = 1,
		description = "BOLA DE FUEGO DE EXPLOSIÓN RETARDADA (evocacion 7) — hechicero, mago",
	})
	_s("conjurar_celestial", "CONJURAR CELESTIAL", 7, School.CONJURACION, CastingTime.ACCION, ["V","S"], 89, "Concentración, hasta 10 minutos", true, {
		ability_type = AbilityData.AbilityType.SPELL_ATTACK, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		damage_dice_count = 6, damage_dice_sides = 12, damage_type = "none",
		description = "CONJURAR CELESTIAL (conjuracion 7) — clérigo",
	})
	_s("dedo_de_la_muerte", "DEDO DE LA MUERTE", 7, School.NECROMANCIA, CastingTime.ACCION, ["V","S"], 59, "Instantáneo", false, {
		ability_type = AbilityData.AbilityType.SAVING_THROW, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "con",
		description = "DEDO DE LA MUERTE (necromancia 7) — brujo, hechicero, mago",
	})
	_s("desplazamiento_entre_planos", "DESPLAZAMIENTO ENTRE PLANOS", 7, School.CONJURACION, CastingTime.ACCION, ["V","S"], 0, "Instantáneo", false, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "DESPLAZAMIENTO ENTRE PLANOS (conjuracion 7) — brujo, clérigo, druida, hechicero, mago",
	})
	_s("espada_de_mordenkainen", "ESPADA DE MORDENKAINEN", 7, School.EVOCACION, CastingTime.ACCION, ["V","S"], 89, "Concentración, hasta 1 minuto", true, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "ESPADA DE MORDENKAINEN (evocacion 7) — bardo, mago",
	})
	_s("espejismo_arcano", "ESPEJISMO ARCANO", 7, School.ILUSION, CastingTime.MINUTO_10, ["V","S"], 30, "10 días", false, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "ESPEJISMO ARCANO (ilusion 7) — bardo, druida, mago",
	})
	_s("excursion_eterea", "EXCURSIÓN ETÉREA", 7, School.CONJURACION, CastingTime.ACCION, ["V","S"], 0, "Hasta 8 horas", false, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "EXCURSIÓN ETÉREA (conjuracion 7) — bardo, brujo, clérigo, hechicero, mago",
	})
	_s("invertir_la_gravedad", "INVERTIR LA GRAVEDAD", 7, School.TRANSMUTACION, CastingTime.ACCION, ["V","S"], 98, "Concentración, hasta 1 minuto", true, {
		ability_type = AbilityData.AbilityType.SAVING_THROW, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "dex",
		description = "INVERTIR LA GRAVEDAD (transmutacion 7) — druida, hechicero, mago",
	})
	_s("jaula_de_fuerza", "JAULA DE FUERZA", 7, School.EVOCACION, CastingTime.ACCION, ["V","S"], 98, "Concentración, hasta 1 hora", true, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "JAULA DE FUERZA (evocacion 7) — bardo, brujo, mago",
	})
	_s("mansion_magnifica_de_mordenkainen", "MANSIÓN MAGNÍFICA DE MORDENKAINEN", 7, School.CONJURACION, CastingTime.MINUTO_1, ["V","S"], 295, "24 horas", false, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "MANSIÓN MAGNÍFICA DE MORDENKAINEN (conjuracion 7) — bardo, mago",
	})
	_s("palabra_divina", "PALABRA DIVINA", 7, School.EVOCACION, CastingTime.ACCION_ADICIONAL, ["V","S"], 30, "Instantáneo", false, {
		ability_type = AbilityData.AbilityType.SAVING_THROW, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "cha",
		description = "PALABRA DIVINA (evocacion 7) — clérigo",
	})
	_s("proyectar_imagen", "PROYECTAR IMAGEN", 7, School.ILUSION, CastingTime.ACCION, ["V","S"], 30, "Concentración, hasta 1 día", true, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "PROYECTAR IMAGEN (ilusion 7) — bardo, mago",
	})
	_s("recluir", "RECLUIR", 7, School.TRANSMUTACION, CastingTime.ACCION, ["V","S"], 0, "Hasta que sea disipado", false, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "RECLUIR (transmutacion 7) — mago",
	})
	_s("regenerar", "REGENERAR", 7, School.TRANSMUTACION, CastingTime.MINUTO_1, ["V","S"], 0, "1 hora", false, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "REGENERAR (transmutacion 7) — bardo, clérigo, druida",
	})
	_s("resurreccion", "RESURRECCIÓN", 7, School.NECROMANCIA, CastingTime.HORA_1, ["V","S"], 0, "Instantáneo", false, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "RESURRECCIÓN (necromancia 7) — bardo, clérigo",
	})
	_s("rociada_prismatica", "ROCIADA PRISMÁTICA", 7, School.EVOCACION, CastingTime.ACCION, ["V","S"], 30, "Instantáneo", false, {
		ability_type = AbilityData.AbilityType.SAVING_THROW, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "dex",
		damage_dice_count = 12, damage_dice_sides = 6, damage_type = "acido",
		description = "ROCIADA PRISMÁTICA (evocacion 7) — bardo, hechicero, mago",
	})
	_s("simbolo", "SÍMBOLO", 7, School.ABJURACION, CastingTime.MINUTO_1, ["V","S"], 0, "Hasta que sea disipado o se active", false, {
		ability_type = AbilityData.AbilityType.SAVING_THROW, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "wis",
		damage_dice_count = 10, damage_dice_sides = 10, damage_type = "none",
		description = "SÍMBOLO (abjuracion 7) — bardo, clérigo, druida, mago",
	})
	_s("simulacro", "SIMULACRO", 7, School.ILUSION, CastingTime.ACCION, ["V","S"], 0, "Hasta que sea disipado", false, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "SIMULACRO (ilusion 7) — mago",
	})
	_s("teletransporte", "TELETRANSPORTE", 7, School.CONJURACION, CastingTime.ACCION, ["V","S"], 10, "Instantáneo", false, {
		ability_type = AbilityData.AbilityType.SPELL_ATTACK, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		damage_dice_count = 3, damage_dice_sides = 10, damage_type = "none",
		description = "TELETRANSPORTE (conjuracion 7) — bardo, hechicero, mago",
	})
	_s("tormenta_de_fuego", "TORMENTA DE FUEGO", 7, School.EVOCACION, CastingTime.ACCION, ["V","S"], 148, "Instantáneo", false, {
		ability_type = AbilityData.AbilityType.SAVING_THROW, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "dex",
		damage_dice_count = 7, damage_dice_sides = 10, damage_type = "fuego",
		description = "TORMENTA DE FUEGO (evocacion 7) — clérigo, druida, hechicero",
	})

func _register_nivel_8_auto() -> void:
	_s("antipatiasimpatia", "ANTIPATÍA/SIMPATÍA", 8, School.ENCANTAMIENTO, CastingTime.HORA_1, ["V","S"], 30, "Instantaneo", false, {
		ability_type = AbilityData.AbilityType.SAVING_THROW, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "wis",
		description = "ANTIPATÍA/SIMPATÍA (encantamiento 8) — bardo, druida, mago",
	})
	_s("aspectos_animales", "ASPECTOS ANIMALES", 8, School.TRANSMUTACION, CastingTime.ACCION, ["V","S"], 30, "24 horas", false, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "ASPECTOS ANIMALES (transmutacion 8) — druida",
	})
	_s("aura_sagrada", "AURA SAGRADA", 8, School.ABJURACION, CastingTime.ACCION, ["V","S"], 0, "Concentración, hasta 1 minuto", true, {
		ability_type = AbilityData.AbilityType.SAVING_THROW, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "con",
		description = "AURA SAGRADA (abjuracion 8) — clérigo",
	})
	_s("campo_antimagia", "CAMPO ANTIMAGIA", 8, School.ABJURACION, CastingTime.ACCION, ["V","S"], 0, "Concentración, hasta 1 hora", true, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "CAMPO ANTIMAGIA (abjuracion 8) — clérigo, mago",
	})
	_s("clon", "CLON", 8, School.NECROMANCIA, CastingTime.HORA_1, ["V","S"], 0, "Instantáneo", false, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "CLON (necromancia 8) — mago",
	})
	_s("controlar_el_clima", "CONTROLAR EL CLIMA", 8, School.TRANSMUTACION, CastingTime.MINUTO_10, ["V","S"], 0, "Concentración, hasta 8 horas", true, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "CONTROLAR EL CLIMA (transmutacion 8) — clérigo, druida, mago",
	})
	_s("dominar_monstruo", "DOMINAR MONSTRUO", 8, School.ENCANTAMIENTO, CastingTime.ACCION, ["V","S"], 59, "Concentración, hasta 1 hora", true, {
		ability_type = AbilityData.AbilityType.SAVING_THROW, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "wis",
		description = "DOMINAR MONSTRUO (encantamiento 8) — bardo, brujo, hechicero, mago",
	})
	_s("explosion_solar", "EXPLOSIÓN SOLAR", 8, School.EVOCACION, CastingTime.ACCION, ["V","S"], 148, "Instantáneo", false, {
		ability_type = AbilityData.AbilityType.SAVING_THROW, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "con",
		description = "EXPLOSIÓN SOLAR (evocacion 8) — clérigo, druida, hechicero, mago",
	})
	_s("laberinto", "LABERINTO", 8, School.CONJURACION, CastingTime.ACCION, ["V","S"], 59, "Concentración, hasta 10 minutos", true, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "LABERINTO (conjuracion 8) — mago",
	})
	_s("labia", "LABIA", 8, School.ENCANTAMIENTO, CastingTime.ACCION, ["V","S"], 0, "1 hora", false, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "LABIA (encantamiento 8) — bardo, brujo",
	})
	_s("mente_en_blanco", "MENTE EN BLANCO", 8, School.ABJURACION, CastingTime.ACCION, ["V","S"], 0, "24 horas", false, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "MENTE EN BLANCO (abjuracion 8) — bardo, mago",
	})
	_s("nube_incendiaria", "NUBE INCENDIARIA", 8, School.CONJURACION, CastingTime.ACCION, ["V","S"], 148, "Concentración, hasta 1 minuto", true, {
		ability_type = AbilityData.AbilityType.SAVING_THROW, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "dex",
		damage_dice_count = 10, damage_dice_sides = 8, damage_type = "fuego",
		description = "NUBE INCENDIARIA (conjuracion 8) — druida, hechicero, mago",
	})
	_s("ofuscacion", "OFUSCACIÓN", 8, School.ENCANTAMIENTO, CastingTime.ACCION, ["V","S"], 148, "Instantáneo", false, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "OFUSCACIÓN (encantamiento 8) — bardo, brujo, druida, mago",
	})
	_s("semiplano", "SEMIPLANO", 8, School.CONJURACION, CastingTime.ACCION, ["V","S"], 59, "1 hora", false, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "SEMIPLANO (conjuracion 8) — brujo, hechicero, mago",
	})
	_s("telepatia", "TELEPATÍA", 8, School.ADIVINACION, CastingTime.ACCION, ["V","S"], 59, "Concentración, hasta 10 minutos", true, {
		ability_type = AbilityData.AbilityType.SAVING_THROW, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "str",
		description = "TELEPATÍA (adivinacion 8) — mago",
	})
	_s("tsunami", "TSUNAMI", 8, School.CONJURACION, CastingTime.MINUTO_1, ["V","S"], 30, "Concentración, hasta 6 asaltos", true, {
		ability_type = AbilityData.AbilityType.SAVING_THROW, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "str",
		damage_dice_count = 6, damage_dice_sides = 10, damage_type = "none",
		description = "TSUNAMI (conjuracion 8) — druida",
	})

func _register_nivel_9_auto() -> void:
	_s("cambiar_de_forma", "CAMBIAR DE FORMA", 9, School.TRANSMUTACION, CastingTime.ACCION, ["V","S"], 0, "Concentración, hasta 1 hora", true, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "CAMBIAR DE FORMA (transmutacion 9) — druida, mago",
	})
	_s("cautiverio", "CAUTIVERIO", 9, School.ABJURACION, CastingTime.MINUTO_1, ["V","S"], 30, "Hasta que sea disipado", false, {
		ability_type = AbilityData.AbilityType.SAVING_THROW, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "wis",
		description = "CAUTIVERIO (abjuracion 9) — brujo, mago",
	})
	_s("curar_en_masa", "CURAR EN MASA", 9, School.ABJURACION, CastingTime.ACCION, ["V","S"], 59, "Instantáneo", false, {
		ability_type = AbilityData.AbilityType.HEAL, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "CURAR EN MASA (abjuracion 9) — clérigo",
	})
	_s("muro_prismatico", "MURO PRISMÁTICO", 9, School.ABJURACION, CastingTime.ACCION, ["V","S"], 59, "10 minutos", false, {
		ability_type = AbilityData.AbilityType.SAVING_THROW, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "dex",
		damage_dice_count = 12, damage_dice_sides = 6, damage_type = "acido",
		description = "MURO PRISMÁTICO (abjuracion 9) — bardo, mago",
	})
	_s("parar_el_tiempo", "PARAR EL TIEMPO", 9, School.TRANSMUTACION, CastingTime.ACCION, ["V","S"], 0, "Instantáneo", false, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "PARAR EL TIEMPO (transmutacion 9) — hechicero, mago",
	})
	_s("polimorfar_verdadero", "POLIMORFAR VERDADERO", 9, School.TRANSMUTACION, CastingTime.ACCION, ["V","S"], 30, "Concentración, hasta 1 hora", true, {
		ability_type = AbilityData.AbilityType.SAVING_THROW, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "wis",
		description = "POLIMORFAR VERDADERO (transmutacion 9) — bardo, brujo, mago",
	})
	_s("portal", "PORTAL", 9, School.CONJURACION, CastingTime.ACCION, ["V","S"], 59, "Concentración, hasta 1 minuto", true, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "PORTAL (conjuracion 9) — brujo, clérigo, hechicero, mago",
	})
	_s("presciencia", "PRESCIENCIA", 9, School.ADIVINACION, CastingTime.MINUTO_1, ["V","S"], 0, "8 horas", false, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "PRESCIENCIA (adivinacion 9) — bardo, brujo, druida, mago",
	})
	_s("proyeccion_astral", "PROYECCIÓN ASTRAL", 9, School.NECROMANCIA, CastingTime.HORA_1, ["V","S"], 10, "Hasta que sea disipado", false, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "PROYECCIÓN ASTRAL (necromancia 9) — brujo, clérigo, mago",
	})
	_s("resurreccion_verdadera", "RESURRECCIÓN VERDADERA", 9, School.NECROMANCIA, CastingTime.HORA_1, ["V","S"], 0, "Instantáneo", false, {
		ability_type = AbilityData.AbilityType.BUFF, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "none",
		description = "RESURRECCIÓN VERDADERA (necromancia 9) — clérigo, druida",
	})
	_s("terror_abyecto", "TERROR ABYECTO", 9, School.ILUSION, CastingTime.ACCION, ["V","S"], 118, "Concentración, hasta 1 minuto", true, {
		ability_type = AbilityData.AbilityType.SAVING_THROW, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "wis",
		damage_dice_count = 10, damage_dice_sides = 10, damage_type = "none",
		description = "TERROR ABYECTO (ilusion 9) — brujo, mago",
	})
	_s("tormenta_de_la_venganza", "TORMENTA DE LA VENGANZA", 9, School.CONJURACION, CastingTime.ACCION, ["V","S"], 30, "Instantáneo", true, {
		ability_type = AbilityData.AbilityType.SAVING_THROW, target_type = AbilityData.TargetType.SINGLE_ENEMY,
		attack_ability = "cha", save_ability = "dex",
		damage_dice_count = 4, damage_dice_sides = 6, damage_type = "none",
		description = "TORMENTA DE LA VENGANZA (conjuracion 9) — druida",
	})

