## feat_database.gd
## Base de datos de dotes D&D 2024. Autoload.
## Uso: FeatDatabase.get("alerta")

extends Node

var _feats: Dictionary = {}

func _ready() -> void:
	_register_origin_feats()
	_register_general_feats()
	_register_combat_style_feats()
	_register_epic_gifts()

func get(feat_id: String) -> FeatData: return _feats.get(feat_id)
func get_all() -> Array[FeatData]: return _feats.values()
func get_by_category(cat: FeatData.FeatCategory) -> Array[FeatData]:
	return _feats.values().filter(func(f: FeatData) -> bool: return f.category == cat)

# ============================================================
# DOTES DE ORIGEN (nivel 1, vienen con el trasfondo)
# ============================================================
func _register_origin_feats() -> void:
	_f("afortunado","Afortunado",FeatData.FeatCategory.ORIGEN,0,"",0,
		"1d4+BC puntos de suerte. Gastar para ventaja en d20 o desventaja al enemigo.",
		{},{})
	_f("alerta","Alerta",FeatData.FeatCategory.ORIGEN,0,"",0,
		"+BC a Iniciativa. Puedes intercambiar tu iniciativa con la de un aliado tras tirar.",
		{"dex":1},{})
	_f("atacante_salvaje","Atacante Salvaje",FeatData.FeatCategory.ORIGEN,0,"",0,
		"Una vez por turno, relanza ambos dados de daÃ±o al golpear. Usa el mejor resultado.",
		{"str":1},{})
	_f("duro","Duro",FeatData.FeatCategory.ORIGEN,0,"",0,
		"+2Ã—nivel de PG mÃ¡ximos al obtener esta dote. +2 PG por cada nivel posterior.",
		{"con":1},{})
	_f("fabricante","Fabricante",FeatData.FeatCategory.ORIGEN,0,"",0,
		"Competencia con 3 herramientas de artesano. 20% dto. objetos no mÃ¡gicos. Objetos temporales.",
		{"str":1},{"tool":"herramientas_artesano_x3"})
	_f("habilidoso","Habilidoso",FeatData.FeatCategory.ORIGEN,0,"",0,
		"Competencia en 3 habilidades o herramientas a elecciÃ³n. Repetible.",
		{},{"skill":"3_habilidades_a_eleccion"})
	_f("iniciado_magia","Iniciado en la Magia",FeatData.FeatCategory.ORIGEN,0,"",0,
		"2 trucos + 1 conjuro de nv1 de ClÃ©rigo/Druida/Mago. Lanzable 1/descanso largo sin espacio.",
		{"int":1},{})
	_f("matuton_taberna","MatÃ³n de Taberna",FeatData.FeatCategory.ORIGEN,0,"",0,
		"Golpes sin armas 1d4+FUE; relanza los 1 en daÃ±o; competencia armas improvisadas; empujar 1,5m 1/turno.",
		{"str":1},{})
	_f("musico","MÃºsico",FeatData.FeatCategory.ORIGEN,0,"",0,
		"Competencia 3 instrumentos. Otorgar inspiraciÃ³n heroica a hasta BC aliados tras descanso.",
		{"dex":1},{"tool":"instrumento_musical_x3"})
	_f("sanador","Sanador",FeatData.FeatCategory.ORIGEN,0,"",0,
		"Gastar uso de kit de curaciÃ³n: cura 1 dado de golpe+BC. Relanza los 1 en curaciÃ³n.",
		{"wis":1},{})

# ============================================================
# DOTES GENERALES (nivel 4+)
# ============================================================
func _register_general_feats() -> void:
	_f("acechador","Acechador",FeatData.FeatCategory.GENERAL,4,"dex",13,
		"+1 DES. VisiÃ³n ciega 1m. Ventaja en Sigilo mientras oculto. Los fallos no revelan ubicaciÃ³n.",
		{"dex":1},{})
	_f("actor","Actor",FeatData.FeatCategory.GENERAL,4,"cha",13,
		"+1 CAR. Ventaja EngaÃ±o/ActuaciÃ³n disfrazado. Imitar sonidos DC 8+CAR+BC.",
		{"cha":1},{})
	_f("apresador","Apresador",FeatData.FeatCategory.GENERAL,4,"str",13,
		"+1 FUE/DES. Golpear+agarrar en la misma acciÃ³n. Ventaja atacando agarrado. Mover agarrado gratis.",
		{"str":1},{})
	_f("atleta","Atleta",FeatData.FeatCategory.GENERAL,4,"str",13,
		"+1 FUE/DES. Escalar = caminar. Levantarse cuesta 1,5m. Salto largo tras 1,5m.",
		{"str":1},{})
	_f("azote_de_magos","Azote de Magos",FeatData.FeatCategory.GENERAL,4,"",0,
		"+1 FUE/DES. Desventaja en concentraciÃ³n al recibirles daÃ±o. Relanzar save INT/SAB/CAR 1/descanso.",
		{"str":1},{})
	_f("centinela","Centinela",FeatData.FeatCategory.GENERAL,4,"str",13,
		"+1 FUE/DES. Ataque de oportunidad al destrabarse o atacar a aliado. El golpe detiene su movimiento.",
		{"str":1},{})
	_f("defensor_duelo","Duelista Defensivo",FeatData.FeatCategory.GENERAL,4,"dex",13,
		"+1 DES. ReacciÃ³n +BC a CA vs melÃ© con arma sutil.",
		{"dex":1},{})
	_f("experto_ballestas","Experto en Ballestas",FeatData.FeatCategory.GENERAL,4,"dex",13,
		"+1 DES. Ignorar recarga en ballestas. Sin desventaja en melÃ©. +DES daÃ±o ballesta de mano (bonus).",
		{"dex":1},{})
	_f("experto_habilidades","Experto en Habilidades",FeatData.FeatCategory.GENERAL,4,"",0,
		"+1 cualquier caracterÃ­stica. Competencia 1 habilidad. Pericia 1 habilidad.",
		{},{"skill":"1_a_eleccion"})
	_f("iniciador_magia_general","Iniciado en la Magia (General)",FeatData.FeatCategory.GENERAL,4,"",0,
		"Como dote de origen pero de cualquier lista de clase. Repetible.",
		{"int":1},{})
	_f("lanzador_combate","Lanzador en Combate",FeatData.FeatCategory.GENERAL,4,"",0,
		"+1 INT/SAB/CAR. Ventaja en saves de concentraciÃ³n. ReacciÃ³n: lanzar conjuro como AoO.",
		{"int":1},{})
	_f("lanzador_preciso","Lanzador Preciso",FeatData.FeatCategory.GENERAL,4,"",0,
		"+1 INT/SAB/CAR. Ignorar cobertura media/tres cuartos. Sin desventaja en melÃ©. +18m alcance.",
		{"int":1},{})
	_f("lider_inspirador","LÃ­der Inspirador",FeatData.FeatCategory.GENERAL,4,"wis",13,
		"+1 SAB/CAR. Tras descanso: hasta 6 aliados ganan PG temporales = nivel+mod.",
		{"cha":1},{})
	_f("maestro_armas","MaestrÃ­a con Armas",FeatData.FeatCategory.GENERAL,4,"",0,
		"+1 FUE/DES. Propiedad de maestrÃ­a en 1 arma sencilla o marcial. Cambiar tras descanso.",
		{"str":1},{})
	_f("maestro_armadura_media","Maestro en Armadura Media",FeatData.FeatCategory.GENERAL,4,"",0,
		"+1 FUE/DES. +3 CA (no +2) con armadura media si DES 16+.",
		{"str":1},{})
	_f("maestro_armadura_pesada","Maestro en Armadura Pesada",FeatData.FeatCategory.GENERAL,4,"",0,
		"+1 CON/FUE. Reducir daÃ±o perforante/cortante/contundente en BC.",
		{"con":1},{})
	_f("maestro_armas_asta","MaestrÃ­a con Armas de Asta",FeatData.FeatCategory.GENERAL,4,"str",13,
		"+1 DES/FUE. Ataque de bonus con el otro extremo (d4). ReacciÃ³n al entrar en alcance.",
		{"str":1},{})
	_f("maestro_armas_pesadas","MaestrÃ­a con Armas Pesadas",FeatData.FeatCategory.GENERAL,4,"str",13,
		"+1 FUE. DaÃ±o arma pesada +BC. CrÃ­tico o matar: bonus de ataque extra.",
		{"str":1},{})
	_f("maestro_escudo","Maestro de Escudo",FeatData.FeatCategory.GENERAL,4,"",0,
		"+1 FUE. Golpe de escudo: empujar 1,5m o derribar. ReacciÃ³n: sin daÃ±o en save DES.",
		{"str":1},{})
	_f("mejora_caracteristica","Mejora de CaracterÃ­stica",FeatData.FeatCategory.GENERAL,4,"",0,
		"+2 a 1 caracterÃ­stica O +1 a 2 caracterÃ­sticas. Repetible. MÃ¡ximo 20.",
		{},{})
	_f("observador","Observador",FeatData.FeatCategory.GENERAL,4,"int",13,
		"+1 INT/SAB. Pericia/competencia en InvestigaciÃ³n, PercepciÃ³n e IntuiciÃ³n. Estudiar como bonus.",
		{"int":1},{})
	_f("perforador","Perforador",FeatData.FeatCategory.GENERAL,4,"",0,
		"+1 FUE/DES. Relanzar 1 dado de daÃ±o perforante 1/turno. CrÃ­tico: +1 dado extra.",
		{"str":1},{})
	_f("proteccion","ProtecciÃ³n",FeatData.FeatCategory.GENERAL,4,"",0,
		"+1 FUE/DES. +1 CA y salvaciones.",
		{"str":1},{})
	_f("rebanador","Rebanador",FeatData.FeatCategory.GENERAL,4,"",0,
		"+1 FUE/DES. Reducir velocidad 3m en golpe cortante 1/turno. CrÃ­tico: desventaja sus ataques prÃ³ximo turno.",
		{"str":1},{})
	_f("resiliente","Resiliente",FeatData.FeatCategory.GENERAL,4,"",0,
		"+1 caracterÃ­stica sin save. Competencia en esa tirada de salvaciÃ³n.",
		{},{})
	_f("resistente","Resistente",FeatData.FeatCategory.GENERAL,4,"",0,
		"+1 CON. Ventaja en tiradas de muerte. AcciÃ³n bonus: gastar dado de golpe para curar.",
		{"con":1},{})
	_f("telepÃ¡tico","TelepÃ¡tico",FeatData.FeatCategory.GENERAL,4,"",0,
		"+1 INT/SAB/CAR. ComunicaciÃ³n telepÃ¡tica 18m. Detectar Pensamientos siempre preparado.",
		{"int":1},{})
	_f("tele_quinetico","TelequinÃ©tico",FeatData.FeatCategory.GENERAL,4,"",0,
		"+1 INT/SAB/CAR. Mano de Mago invisible +9m. Bonus: empujar 9m DC 8+mod+BC.",
		{"int":1},{})
	_f("tirador_primera","Tirador de Primera",FeatData.FeatCategory.GENERAL,4,"dex",13,
		"+1 DES. Ignorar cobertura media/tres cuartos a distancia. Sin desventaja en melÃ© ni largo alcance.",
		{"dex":1},{})
	_f("triturador","Triturador",FeatData.FeatCategory.GENERAL,4,"",0,
		"+1 FUE/CON. Mover 1,5m en golpe contundente 1/turno. CrÃ­tico: ventaja prÃ³ximo turno atacantes.",
		{"str":1},{})
	_f("veloz","Veloz",FeatData.FeatCategory.GENERAL,4,"dex",13,
		"+1 DES/CON. +3m velocidad. Sin coste extra en terreno difÃ­cil al correr. Desventaja en AoO vs ti.",
		{"dex":1},{})

# ============================================================
# ESTILOS DE COMBATE
# ============================================================
func _register_combat_style_feats() -> void:
	_f("estilo_dos_manos","Combate a Dos Manos",FeatData.FeatCategory.ESTILO_COMBATE,0,"",0,
		"Relanzar 1-2 en dado de daÃ±o con armas a dos manos.",{},{})
	_f("estilo_armas_arrojadizas","Armas Arrojadizas",FeatData.FeatCategory.ESTILO_COMBATE,0,"",0,
		"+2 daÃ±o con armas arrojadizas a distancia.",{},{})
	_f("estilo_dos_armas","Lucha con Dos Armas",FeatData.FeatCategory.ESTILO_COMBATE,0,"",0,
		"AÃ±adir DES al daÃ±o del ataque de bonus con arma ligera.",{},{})
	_f("estilo_combate_sin_armas","Combate Sin Armas",FeatData.FeatCategory.ESTILO_COMBATE,0,"",0,
		"Golpes sin armas 1d6 (o 1d8 a mano libre)+FUE. 1d4 daÃ±o al agarrado por turno.",{},{})
	_f("estilo_defensa","Defensa",FeatData.FeatCategory.ESTILO_COMBATE,0,"",0,
		"+1 CA mientras llevas cualquier armadura.",{},{"bonus_ac":1})
	_f("estilo_duelo","Duelo",FeatData.FeatCategory.ESTILO_COMBATE,0,"",0,
		"+2 daÃ±o en melÃ© con arma de una mano sin otra arma.",{},{})
	_f("estilo_intercepcion","IntercepciÃ³n",FeatData.FeatCategory.ESTILO_COMBATE,0,"",0,
		"ReacciÃ³n: reducir daÃ±o a aliado cercano en 1d10+BC.",{},{})
	_f("estilo_lucha_ciega","Lucha a Ciegas",FeatData.FeatCategory.ESTILO_COMBATE,0,"",0,
		"VisiÃ³n ciega 1m.",{},{})
	_f("estilo_proteccion","Estilo ProtecciÃ³n",FeatData.FeatCategory.ESTILO_COMBATE,0,"",0,
		"ReacciÃ³n: desventaja en ataque a aliado a 1,5m. Requiere escudo.",{},{})
	_f("estilo_tiro_arco","Tiro con Arco",FeatData.FeatCategory.ESTILO_COMBATE,0,"",0,
		"+2 a tiradas de ataque a distancia.",{},{})

# ============================================================
# DONES Ã‰PICOS (nivel 19+)
# ============================================================
func _register_epic_gifts() -> void:
	_f("don_fortaleza","Don de Fortaleza",FeatData.FeatCategory.DON_EPICO,19,"",0,
		"+1 caracterÃ­stica (mÃ¡x 30). +40 PG mÃ¡ximos. +mod CON al recuperar PG.",{},{})
	_f("don_habilidad","Don de Habilidad",FeatData.FeatCategory.DON_EPICO,19,"",0,
		"+1 caracterÃ­stica (mÃ¡x 30). Competencia todas las habilidades. Pericia 1 habilidad.",{},{})
	_f("don_pericia_combate","Don de Pericia en Combate",FeatData.FeatCategory.DON_EPICO,19,"",0,
		"+1 caracterÃ­stica (mÃ¡x 30). Convertir fallo en acierto 1/turno.",{},{})
	_f("don_recuperacion","Don de RecuperaciÃ³n",FeatData.FeatCategory.DON_EPICO,19,"",0,
		"+1 caracterÃ­stica (mÃ¡x 30). Mantenerse a 1 PG 1/descanso largo. Reserva de 10d10 PG.",{},{})
	_f("don_velocidad","Don de Velocidad",FeatData.FeatCategory.DON_EPICO,19,"",0,
		"+1 caracterÃ­stica (mÃ¡x 30). Bonus: destrabarse+fin de agarre. +9m velocidad.",{},{})
	_f("don_vision_verdadera","Don de VisiÃ³n Verdadera",FeatData.FeatCategory.DON_EPICO,19,"",0,
		"+1 caracterÃ­stica (mÃ¡x 30). VisiÃ³n verdadera 18m.",{},{})
	_f("don_ataque_imparable","Don de Ataque Imparable",FeatData.FeatCategory.DON_EPICO,19,"",0,
		"+1 FUE/DES (mÃ¡x 30). DaÃ±o ignora resistencia. 20 en d20 = daÃ±o extra.",{},{})
	_f("don_viaje_dimensional","Don de Viaje Dimensional",FeatData.FeatCategory.DON_EPICO,19,"",0,
		"+1 caracterÃ­stica (mÃ¡x 30). Teletransporte 9m tras acciÃ³n/magia.",{},{})

# ============================================================
# HELPER
# ============================================================
func _f(id: String, name: String, cat: FeatData.FeatCategory, min_level: int,
		prereq_ability: String, prereq_val: int, desc: String,
		ability_bonuses: Dictionary, profs: Dictionary) -> void:
	var f := FeatData.new()
	f.feat_id = id; f.display_name = name; f.category = cat
	f.min_level = min_level; f.prerequisite_ability = prereq_ability
	f.prerequisite_value = prereq_val; f.description = desc
	f.ability_score_bonuses = ability_bonuses
	_feats[id] = f
