## condition_definitions.gd
## Catálogo de todos los estados del juego con sus efectos mecánicos.
## Basado en D&D 5e 2014 SRD + estados propios de Vestigios.

class_name ConditionDefs
extends RefCounted

# ============================================================
# TODAS LAS CONDICIONES (IDs en snake_case español)
# ============================================================

## Mapa completo: condition_id → definición de efectos
const ALL: Dictionary = {

	# ── D&D 5e SRD ────────────────────────────────────────────

	"agarrado": {
		"display_name": "Agarrado",
		"icon": "🤝",
		"description": "Velocidad = 0. Se libera si el agarrador queda incapacitado o el efecto se contrarresta.",
		"speed_zero": true,
	},

	"apresado": {
		"display_name": "Apresado",
		"icon": "⛓",
		"description": "Velocidad = 0. Desventaja en ataques y tiradas de salvación de DES.",
		"speed_zero": true,
		"attack_disadvantage": true,
		"dex_save_disadvantage": true,
		"attackers_advantage": true,
	},

	"asustado": {
		"display_name": "Asustado",
		"icon": "😨",
		"description": "Desventaja en tiradas mientras vea la fuente del miedo. No puede moverse voluntariamente hacia ella.",
		"attack_disadvantage": true,
		"ability_check_disadvantage": true,
	},

	"aturdido": {
		"display_name": "Aturdido",
		"icon": "💫",
		"description": "Incapacitado. Falla salvaciones de FUE y DES. Los atacantes tienen ventaja.",
		"incapacitated": true,
		"str_save_fail": true,
		"dex_save_fail": true,
		"attackers_advantage": true,
	},

	"cansancio_1": {
		"display_name": "Cansancio 1",
		"icon": "😓",
		"description": "Desventaja en tiradas de característica.",
		"ability_check_disadvantage": true,
	},
	"cansancio_2": {
		"display_name": "Cansancio 2",
		"icon": "😓",
		"description": "Desventaja en tiradas de característica. Velocidad a la mitad.",
		"ability_check_disadvantage": true,
		"speed_half": true,
	},
	"cansancio_3": {
		"display_name": "Cansancio 3",
		"icon": "😓",
		"description": "Desventaja en ataques y tiradas de salvación. Velocidad a la mitad.",
		"ability_check_disadvantage": true,
		"attack_disadvantage": true,
		"save_disadvantage": true,
		"speed_half": true,
	},
	"cansancio_4": {
		"display_name": "Cansancio 4",
		"icon": "😓",
		"description": "Todos los efectos anteriores. PG máximos a la mitad.",
		"ability_check_disadvantage": true,
		"attack_disadvantage": true,
		"save_disadvantage": true,
		"speed_half": true,
		"max_hp_half": true,
	},
	"cansancio_5": {
		"display_name": "Cansancio 5",
		"icon": "😓",
		"description": "Velocidad = 0. Todos los efectos anteriores.",
		"ability_check_disadvantage": true,
		"attack_disadvantage": true,
		"save_disadvantage": true,
		"speed_zero": true,
		"max_hp_half": true,
	},

	"cegado": {
		"display_name": "Cegado",
		"icon": "🙈",
		"description": "No puede ver. Falla tiradas que requieran visión. Desventaja en ataques, ventaja para atacantes.",
		"attack_disadvantage": true,
		"attackers_advantage": true,
	},

	"derribado": {
		"display_name": "Derribado",
		"icon": "⬇",
		"description": "Solo puede arrastrarse (1ft cuesta 2ft). Desventaja en ataques. Cuerpo a cuerpo: ventaja para atacantes. Distancia: desventaja para atacantes.",
		"attack_disadvantage": true,
		"attackers_melee_advantage": true,
	},

	"ensordecido": {
		"display_name": "Ensordecido",
		"icon": "🔇",
		"description": "No puede oír. Falla tiradas que requieran oído.",
		"deafened": true,
	},

	"envenenado": {
		"display_name": "Envenenado",
		"icon": "🤢",
		"description": "Desventaja en tiradas de ataque y de característica.",
		"attack_disadvantage": true,
		"ability_check_disadvantage": true,
	},

	"hechizado": {
		"display_name": "Hechizado",
		"icon": "💜",
		"description": "No puede atacar al hechizador. El hechizador tiene ventaja en tiradas sociales contra ti.",
		"charmed": true,
	},

	"incapacitado": {
		"display_name": "Incapacitado",
		"icon": "🚫",
		"description": "No puede realizar acciones ni reacciones.",
		"incapacitated": true,
	},

	"inconsciente": {
		"display_name": "Inconsciente",
		"icon": "💤",
		"description": "Incapacitado, cae al suelo. Falla FUE y DES. Los atacantes tienen ventaja. Crítico automático en cuerpo a cuerpo.",
		"incapacitated": true,
		"prone_forced": true,
		"str_save_fail": true,
		"dex_save_fail": true,
		"attackers_advantage": true,
		"auto_crit_melee": true,
	},

	"invisible": {
		"display_name": "Invisible",
		"icon": "👻",
		"description": "No puede ser visto sin magia. Ventaja en ataques. Los atacantes tienen desventaja.",
		"attack_advantage": true,
		"attackers_disadvantage": true,
	},

	"paralizado": {
		"display_name": "Paralizado",
		"icon": "🧊",
		"description": "Incapacitado, no puede moverse ni hablar. Falla FUE y DES. Los atacantes tienen ventaja. Crítico en cuerpo a cuerpo.",
		"incapacitated": true,
		"speed_zero": true,
		"str_save_fail": true,
		"dex_save_fail": true,
		"attackers_advantage": true,
		"auto_crit_melee": true,
	},

	"petrificado": {
		"display_name": "Petrificado",
		"icon": "🗿",
		"description": "Convertido en piedra. Incapacitado. Resistencia a todo el daño. Falla FUE y DES. Los atacantes tienen ventaja.",
		"incapacitated": true,
		"speed_zero": true,
		"str_save_fail": true,
		"dex_save_fail": true,
		"attackers_advantage": true,
		"damage_resistance_all": true,
	},

	# ── PROPIOS DE VESTIGIOS ───────────────────────────────────

	"borracho": {
		"display_name": "Borracho",
		"icon": "🍺",
		"description": "Desventaja en ataques y tiradas de característica. Ventaja en tiradas contra miedo (valor líquido).",
		"attack_disadvantage": true,
		"ability_check_disadvantage": true,
		"fear_advantage": true,
		"persistent": true,  # sobrevive entre escenas hasta que duerma
	},

	"resaca": {
		"display_name": "Resaca",
		"icon": "🤕",
		"description": "Desventaja en todos los ataques y tiradas de característica hasta el primer combate.",
		"attack_disadvantage": true,
		"ability_check_disadvantage": true,
		"persistent": true,
		"remove_after_combat": true,
	},

	"exhausto_nado": {
		"display_name": "Exhausto (nado)",
		"icon": "🌊",
		"description": "Llegó exhausto del agua. Desventaja en el primer combate del día.",
		"attack_disadvantage": true,
		"ability_check_disadvantage": true,
		"remove_after_combat": true,
	},

	"bosque_oscuro": {
		"display_name": "Bosque oscuro",
		"icon": "🌑",
		"description": "Desventaja en Supervivencia y Naturaleza en este entorno.",
		"skill_disadvantage": ["supervivencia", "naturaleza"],
	},

	"en_silencio": {
		"display_name": "En Silencio",
		"icon": "🔇✨",
		"description": "Dentro del área del conjuro Silencio. No puede pronunciar componentes verbales.",
		"blocks_verbal_components": true,
	},

	"oculto": {
		"display_name": "Oculto",
		"icon": "👤",
		"description": "El personaje se ha ocultado con éxito. Los ataques contra él tienen desventaja.",
		"attackers_disadvantage": true,
	},

	"punto_debil_revelado": {
		"display_name": "Punto débil revelado",
		"icon": "🎯",
		"description": "Se ha identificado una apertura en su defensa. Los ataques tienen ventaja durante 3 turnos.",
		"attackers_advantage": true,
	},

	"posicion_revelada": {
		"display_name": "Posición revelada",
		"icon": "📍",
		"description": "Su posición ha sido detectada a pesar de la invisibilidad. Atacarle no tiene desventaja por 2 turnos.",
	},

	# ── MAESTRÍA ─────────────────────────────────────────────

	"debilitado_maestria": {
		"display_name": "Debilitado",
		"icon": "⬇⚔",
		"description": "Desventaja en la próxima tirada de ataque (propiedad Debilitar).",
		"attack_disadvantage": true,
	},

	"ralentizado_maestria": {
		"display_name": "Ralentizado",
		"icon": "🐌",
		"description": "Velocidad reducida 3m (propiedad Ralentizar). No acumula.",
		"speed_reduction": 10,
	},

	"destrabado": {
		"display_name": "Destrabado",
		"icon": "↗",
		"description": "No provoca ataques de oportunidad este turno (acción Destrabarse).",
	},
}

# ============================================================
# CONSULTAS RÁPIDAS
# ============================================================

static func get_def(condition_id: String) -> Dictionary:
	return ALL.get(condition_id, {})

static func display_name(condition_id: String) -> String:
	return ALL.get(condition_id, {}).get("display_name", condition_id)

static func icon(condition_id: String) -> String:
	return ALL.get(condition_id, {}).get("icon", "●")

static func is_persistent(condition_id: String) -> bool:
	return ALL.get(condition_id, {}).get("persistent", false)

static func removes_after_combat(condition_id: String) -> bool:
	return ALL.get(condition_id, {}).get("remove_after_combat", false)
