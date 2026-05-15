## class_feature_database.gd
## Base de datos completa de rasgos de clase D&D 2024, niveles 1-20.
## Autoload. Uso: ClassFeatureDatabase.get_features("paladin", 6)
##
## Nombres adaptados donde aplica para evitar términos registrados:
##   "Concentración de Monje" → "Energía Marcial" (el recurso)

extends Node

var _features: Dictionary = {}

func _ready() -> void:
	_register_all()

# ============================================================
# API PÚBLICA
# ============================================================

func get_features(class_id: String, level: int) -> Array[Dictionary]:
	return _features.get(class_id, {}).get(level, [])

func get_all_features_up_to(class_id: String, max_level: int) -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	for lv in range(1, max_level + 1):
		for feat in get_features(class_id, lv):
			result.append(feat)
	return result

## Devuelve los recursos de clase para inicializar CharacterStats.
func get_class_resources(class_id: String, level: int, data: CharacterData) -> Dictionary:
	var cha_mod := CharacterData.ability_modifier(data.charisma)
	var wis_mod := CharacterData.ability_modifier(data.wisdom)

	match class_id:
		"paladin":
			return {
				"lay_on_hands":    5 * level,
				"channel_divinity": 2 if level >= 6 else 1,
				"extra_attack":    2 if level >= 5 else 1,
			}
		"bardo":
			return {
				"bardic_inspiration": maxi(1, cha_mod),
				"bardic_inspiration_die": ClassFeatureDatabase._bardic_die(level),
				"bardic_inspiration_rest": "short" if level >= 5 else "long",
				"extra_attack": 1,  # Bardo no tiene Extra Attack salvo College of Valor
			}
		"guerrero":
			return {
				"second_wind":  2,
				"action_surge": 2 if level >= 17 else 1,
				"indomable":    3 if level >= 17 else (2 if level >= 13 else 1),
				"extra_attack": 4 if level >= 20 else (3 if level >= 11 else (2 if level >= 5 else 1)),
			}
		"explorador":
			return {
				"favored_enemy_uses": 3 if level >= 9 else 2,
				"extra_attack": 2 if level >= 5 else 1,
			}
		"picaro":
			return {
				"sneak_attack_dice": ceili(level / 2.0),
				"extra_attack": 1,
			}
		"monje":
			return {
				"ki_points":        level,
				"martial_arts_die": ClassFeatureDatabase._monk_die(level),
				"extra_attack":     2 if level >= 5 else 1,
				"speed_bonus_ft":   ClassFeatureDatabase._monk_speed(level),
			}
		"barbaro":
			return {
				"rage_uses":  ClassFeatureDatabase._barbarian_rage_uses(level),
				"extra_attack": 2 if level >= 5 else 1,
			}
		"hechicero":
			return {
				"sorcery_points": level,
			}
		"brujo":
			return {
				"pact_slots":      ClassFeatureDatabase._warlock_slots(level),
				"pact_slot_level": ClassFeatureDatabase._warlock_slot_level(level),
			}
		"clerigo":
			return {
				"channel_divinity": 3 if level >= 18 else (2 if level >= 6 else 1),
			}
		"druida":
			return {
				"wild_shape_uses": 2,
				"wild_shape_cr":   ClassFeatureDatabase._druid_cr(level),
			}
		"mago":
			return {
				"arcane_recovery": ceili(level / 2.0),
			}
	return {}

# ============================================================
# REGISTRO COMPLETO — todos los niveles 1-20
# ============================================================

func _register_all() -> void:
	_reg_paladin()
	_reg_bardo()
	_reg_guerrero()
	_reg_explorador()
	_reg_picaro()
	_reg_monje()
	_reg_barbaro()
	_reg_hechicero()
	_reg_brujo()
	_reg_clerigo()
	_reg_druida()
	_reg_mago()

# ─────────────────────────────────────────────────────────────
func _reg_paladin() -> void:
	_add("paladin",1,"imponer_manos","Imponer las Manos","bonus","long","lay_on_hands","Bonus: cura PG del reservorio (5×nivel) o elimina envenenado (5 PG).")
	_add("paladin",1,"conjuros_paladin","Lanzamiento de Conjuros","none","long","","Conjuros divinos CHA. Medio lanzador desde nv1.")
	_add("paladin",1,"maestria_armas_pal","Maestría con Armas","none","none","","Propiedad de maestría con 2 armas. Cambiar tras descanso largo.")
	_add("paladin",2,"castigo_paladin","Castigo de Paladín","bonus","long","spell_slot","Bonus tras golpear en melé: gasta espacio → +2d8 radiante (+1d8/nv). Gratis 1/descanso.")
	_add("paladin",2,"estilo_combate_pal","Estilo de Combate","none","none","","Elige una dote de estilo de combate.")
	_add("paladin",3,"canalizar_divinidad_pal","Canalizar Divinidad","action","short","channel_divinity","Opciones según juramento. 1 uso/descanso corto (2 a partir nv6).")
	_add("paladin",3,"subclase_pal","Subclase (Juramento)","none","none","","Elige Juramento: Entrega, Gloria, Antiguos o Venganza.")
	_add("paladin",4,"mca_pal_4","Mejora de Característica","none","none","","+2 a 1 característica o +1 a 2. Máximo 20.")
	_add("paladin",5,"ataque_extra_pal","Ataque Adicional","none","none","","2 ataques al usar la acción de atacar.")
	_add("paladin",5,"corcel_fiel","Corcel Fiel","action","long","spell_slot","Lanza Encontrar Corcel sin espacio 1/descanso largo.")
	_add("paladin",6,"aura_proteccion","Aura de Protección","none","none","","Aliados en 3m (9m a nv18) suman mod CAR a sus tiradas de salvación.")
	_add("paladin",7,"aura_devocion","Aura del Juramento","none","none","","Aura del subclase activa en 3m (9m a nv18).")
	_add("paladin",8,"mca_pal_8","Mejora de Característica","none","none","","")
	_add("paladin",9,"abjurar_enemigos","Abjurar Enemigos","action","short","channel_divinity","Cono 18m: WIS o Asustado 1min. No muertos/infernales: desventaja y velocidad 0.")
	_add("paladin",10,"aura_valentia","Aura de Valentía","none","none","","Aliados en el aura son inmunes al estado Asustado.")
	_add("paladin",11,"golpes_radiantes","Golpes Radiantes","none","none","","Tus ataques de melé infligen 1d8 de daño radiante adicional.")
	_add("paladin",12,"mca_pal_12","Mejora de Característica","none","none","","")
	_add("paladin",14,"toque_sanador","Toque Sanador","bonus","long","lay_on_hands","Gastar 5 PG del reservorio elimina 1 enfermedad o estado.")
	_add("paladin",16,"mca_pal_16","Mejora de Característica","none","none","","")
	_add("paladin",18,"expansion_aura","Expansión del Aura","none","none","","Tus auras se expanden a 9m de radio.")
	_add("paladin",19,"don_epico_pal","Don Épico","none","none","","Elige dote épica (requiere nivel 19).")
	_add("paladin",20,"capstone_juramento","Cima del Juramento","none","long","spell_slot","Rasgo definitivo del subclase. Varía por juramento.")

# ─────────────────────────────────────────────────────────────
func _reg_bardo() -> void:
	_add("bardo",1,"inspiracion_bardica","Inspiración Bárdica","bonus","long","bardic_inspiration","Bonus: aliado a 18m obtiene 1 dado de inspiración (d6). Puede añadirlo a prueba d20.")
	_add("bardo",1,"conjuros_bardo","Lanzamiento de Conjuros","none","long","","Conjuros bárdicos CHA. Lanzador completo.")
	_add("bardo",2,"aprendiz_de_mucho","Aprendiz de Mucho","none","none","","Añade la mitad de tu BC (redondeado abajo) a pruebas sin competencia.")
	_add("bardo",2,"pericia_bardo","Pericia","none","none","","Pericia (×2 BC) en 2 habilidades a elección.")
	_add("bardo",3,"subclase_bardo","Subclase (Colegio)","none","none","","Elige: Danza, Conocimiento, Glamour o Valor.")
	_add("bardo",4,"mca_bardo_4","Mejora de Característica","none","none","","")
	_add("bardo",5,"fuente_inspiracion","Fuente de Inspiración","none","none","bardic_inspiration","La Inspiración Bárdica se recupera en descanso CORTO (antes era largo).")
	_add("bardo",7,"contrahechizo_bardo","Contrahechizo","reaction","none","","Reacción: cuando un aliado visible falla una tirada vs miedo o hechizo, puede tirar el dado de inspiración.")
	_add("bardo",8,"mca_bardo_8","Mejora de Característica","none","none","","")
	_add("bardo",9,"pericia_bardo_2","Pericia (adicional)","none","none","","Pericia en 2 habilidades más.")
	_add("bardo",10,"secretos_magicos","Secretos Mágicos","none","none","","Aprende 2 conjuros de cualquier lista de clase.")
	_add("bardo",12,"mca_bardo_12","Mejora de Característica","none","none","","")
	_add("bardo",16,"mca_bardo_16","Mejora de Característica","none","none","","")
	_add("bardo",18,"inspiracion_superior","Inspiración Superior","none","none","","Al tirar iniciativa con 0 dados de inspiración, recuperas 1 uso.")
	_add("bardo",19,"don_epico_bardo","Don Épico","none","none","","Elige dote épica.")
	_add("bardo",20,"palabras_de_creacion","Palabras de Creación","none","long","spell_slot","Puedes lanzar conjuros Palabra de poder sobre 2 objetivos simultáneamente.")

# ─────────────────────────────────────────────────────────────
func _reg_guerrero() -> void:
	_add("guerrero",1,"estilo_combate_gue","Estilo de Combate","none","none","","Elige dote de estilo de combate.")
	_add("guerrero",1,"maestria_armas_gue","Maestría con Armas","none","none","","Propiedad de maestría con 3 armas. Cambiar tras descanso largo.")
	_add("guerrero",1,"tomar_aliento","Tomar Aliento","bonus","short","second_wind","Bonus: recupera 1d10+nivel PG. 2 usos; recupera 1 en corto, todos en largo.")
	_add("guerrero",2,"accion_subita","Acción Súbita","none","short","action_surge","1 acción adicional este turno (no de magia). 1 uso/descanso corto.")
	_add("guerrero",2,"mente_tactica","Mente Táctica","none","short","second_wind","Al fallar prueba de característica: gasta 1 uso de Tomar Aliento para relanzar.")
	_add("guerrero",3,"subclase_gue","Subclase","none","none","","Elige: Campeón, Maestro Combate, Caballero Arcano o Guerrero Psiónico.")
	_add("guerrero",4,"mca_gue_4","Mejora de Característica","none","none","","")
	_add("guerrero",5,"ataque_extra_gue","Ataque Adicional","none","none","","2 ataques al usar la acción de atacar.")
	_add("guerrero",5,"desplazamiento_tactico","Desplazamiento Táctico","none","none","","Al usar Acción Súbita, moverse sin provocar AoO.")
	_add("guerrero",6,"mca_gue_6","Mejora de Característica","none","none","","")
	_add("guerrero",8,"mca_gue_8","Mejora de Característica","none","none","","")
	_add("guerrero",9,"indomable","Indomable","reaction","long","indomable","Reacción: relanza una tirada de salvación fallida. 1 uso/descanso largo.")
	_add("guerrero",9,"maestro_tactico","Maestro Táctico","none","none","","Puedes reemplazar la propiedad de maestría de un arma 1×turno.")
	_add("guerrero",11,"ataque_extra_extra","Tres Ataques","none","none","","3 ataques al usar la acción de atacar.")
	_add("guerrero",12,"mca_gue_12","Mejora de Característica","none","none","","")
	_add("guerrero",13,"ataques_estudiados","Ataques Estudiados","none","none","","Al fallar contra una criatura, tienes ventaja en el siguiente ataque vs ella.")
	_add("guerrero",14,"mca_gue_14","Mejora de Característica","none","none","","")
	_add("guerrero",16,"mca_gue_16","Mejora de Característica","none","none","","")
	_add("guerrero",17,"accion_subita_2","Acción Súbita (mejorada)","none","short","action_surge","Ahora 2 usos antes de descansar.")
	_add("guerrero",19,"don_epico_gue","Don Épico","none","none","","Elige dote épica.")
	_add("guerrero",20,"cuatro_ataques","Cuatro Ataques","none","none","","4 ataques al usar la acción de atacar.")

# ─────────────────────────────────────────────────────────────
func _reg_explorador() -> void:
	_add("explorador",1,"conjuros_exp","Lanzamiento de Conjuros","none","long","","Conjuros de naturaleza SAB. Medio lanzador desde nv1.")
	_add("explorador",1,"enemigo_predilecto","Enemigo Predilecto","bonus","long","favored_enemy_uses","Marca del Cazador siempre preparada. Lanzar 2× gratis/descanso largo.")
	_add("explorador",1,"maestria_armas_exp","Maestría con Armas","none","none","","Propiedad de maestría con 2 armas.")
	_add("explorador",2,"estilo_combate_exp","Estilo de Combate","none","none","","Elige dote de estilo de combate o Guerrero Druídico (2 trucos druida).")
	_add("explorador",2,"explorador_habil","Explorador Hábil","none","none","","Aprendes 2 idiomas. Pericia en 1 habilidad.")
	_add("explorador",3,"subclase_exp","Subclase","none","none","","Elige: Acechador Penumbra, Cazador, Errante Feérico o Señor Bestias.")
	_add("explorador",4,"mca_exp_4","Mejora de Característica","none","none","","")
	_add("explorador",5,"ataque_extra_exp","Ataque Adicional","none","none","","2 ataques al usar la acción de atacar.")
	_add("explorador",6,"caminante_mundo","Caminante del Mundo","none","none","","Velocidad +3m. Velocidad de escalar y nadar = velocidad normal.")
	_add("explorador",8,"mca_exp_8","Mejora de Característica","none","none","","")
	_add("explorador",9,"pericia_exp","Pericia","none","none","","Pericia en 2 habilidades más.")
	_add("explorador",12,"mca_exp_12","Mejora de Característica","none","none","","")
	_add("explorador",13,"marcado_cazador","Marcado por el Cazador","none","none","","Causar daño a la Marca del Cazador no rompe la concentración.")
	_add("explorador",14,"velo_naturaleza","Velo de Naturaleza","action","long","nature_veil","Acción: te vuelves invisible hasta inicio de tu siguiente turno. 1/descanso largo.")
	_add("explorador",16,"mca_exp_16","Mejora de Característica","none","none","","")
	_add("explorador",17,"cazador_preciso","Cazador Preciso","none","none","","Ventaja en tiradas de ataque vs la criatura con tu Marca del Cazador.")
	_add("explorador",18,"sentidos_salvajes","Sentidos Salvajes","none","none","","Visión ciega 9m basada en tu conexión con la naturaleza.")
	_add("explorador",19,"don_epico_exp","Don Épico","none","none","","Elige dote épica.")
	_add("explorador",20,"azote_enemigos","Azote de Enemigos","none","none","","El dado de daño de Marca del Cazador se convierte en 1d10.")

# ─────────────────────────────────────────────────────────────
func _reg_picaro() -> void:
	_add("picaro",1,"ataque_furtivo","Ataque Furtivo","none","none","sneak_attack_dice","1d6 extra con arma sutil/distancia si ventaja o aliado adyacente. Escala +1d6 c/2 niveles.")
	_add("picaro",1,"jerga_ladrones","Jerga de Ladrones","none","none","","Conoces la jerga de ladrones y otro idioma.")
	_add("picaro",1,"maestria_armas_pic","Maestría con Armas","none","none","","Propiedad de maestría con 2 armas.")
	_add("picaro",1,"pericia_pic","Pericia","none","none","","Pericia (×2 BC) en 2 habilidades.")
	_add("picaro",2,"accion_astuta","Acción Astuta","bonus","none","","Bonus: Correr, Destrabarse o Esconderse.")
	_add("picaro",3,"punteria_certera","Puntería Certera","action","none","","Acción: ventaja en próximo ataque, velocidad 0 hasta fin turno.")
	_add("picaro",3,"subclase_pic","Subclase","none","none","","Elige: Asesino, Ladrón, Embaucador Arcano o Rebanaalmas.")
	_add("picaro",4,"mca_pic_4","Mejora de Característica","none","none","","")
	_add("picaro",5,"esquiva_asombrosa","Esquiva Asombrosa","reaction","none","","Reacción: al ser golpeado, reduce el daño a la mitad.")
	_add("picaro",5,"golpe_astuto","Golpe Astuto","none","none","","Al infligir Ataque Furtivo: añade efecto retirando dados (Retirada, Tropiezo o Veneno).")
	_add("picaro",7,"evasion_pic","Evasión","none","none","","Sin daño si superas salvación DES, mitad si fallas.")
	_add("picaro",7,"talentos_fiables","Talentos Fiables","none","none","","Tratar 9 o menos en d20 como 10 en pruebas de habilidad con competencia.")
	_add("picaro",8,"mca_pic_8","Mejora de Característica","none","none","","")
	_add("picaro",10,"mca_pic_10","Mejora de Característica","none","none","","")
	_add("picaro",11,"golpe_astuto_mejorado","Golpe Astuto Mejorado","none","none","","Puedes usar 2 efectos de Golpe Astuto por ataque.")
	_add("picaro",12,"mca_pic_12","Mejora de Característica","none","none","","")
	_add("picaro",14,"golpes_taimados","Golpes Taimados","none","none","","Nuevas opciones para Golpe Astuto.")
	_add("picaro",15,"mente_escurridiza","Mente Escurridiza","none","none","","Competencia en tiradas de salvación de Sabiduría y Carisma.")
	_add("picaro",16,"mca_pic_16","Mejora de Característica","none","none","","")
	_add("picaro",18,"elusivo","Elusivo","none","none","","Ningún ataque tiene ventaja contra ti salvo que estés incapacitado.")
	_add("picaro",19,"don_epico_pic","Don Épico","none","none","","Elige dote épica.")
	_add("picaro",20,"golpe_de_suerte","Golpe de Suerte","none","short","","1/descanso corto: convierte un fallo en un éxito en una tirada de ataque.")

# ─────────────────────────────────────────────────────────────
func _reg_monje() -> void:
	_add("monje",1,"artes_marciales","Artes Marciales","none","none","","Sin armadura: ataque sin armas bonus; dado marcial; usar DES en lugar de FUE.")
	_add("monje",1,"defensa_sin_armadura_mj","Defensa sin Armadura","none","none","","Sin armadura ni escudo: CA = 10 + DES + SAB.")
	_add("monje",2,"energia_marcial","Energía Marcial","none","short","ki_points","Puntos = nivel. Ráfaga de Golpes (1pt: 2 ataques bonus), Paso Viento, Defensa Paciente.")
	_add("monje",2,"metabolismo_asombroso","Metabolismo Asombroso","none","long","","Al tirar iniciativa: recupera todos los puntos de Energía Marcial + cura PG. 1/largo.")
	_add("monje",2,"movimiento_sin_armadura","Movimiento sin Armadura","none","none","","Velocidad +3m sin armadura/escudo (más a niveles altos).")
	_add("monje",3,"desviar_ataques","Desviar Ataques","reaction","none","","Reacción: reducir daño de un ataque en 1d10+DES+nivel. A 0: lanzar de vuelta.")
	_add("monje",3,"subclase_mj","Subclase","none","none","","Elige: Mano Abierta, Misericordia, Sombra o Elementos.")
	_add("monje",4,"caida_lenta","Caída Lenta","reaction","none","","Reacción: reduce daño por caída en 5×nivel.")
	_add("monje",4,"mca_mj_4","Mejora de Característica","none","none","","")
	_add("monje",5,"ataque_extra_mj","Ataque Adicional","none","none","","2 ataques al usar la acción de atacar.")
	_add("monje",5,"golpe_aturdidor","Golpe Aturdidor","none","none","ki_points","Tras golpear: gasta 1 punto → CON save o Aturdido hasta inicio siguiente turno.")
	_add("monje",6,"golpes_potenciados","Golpes Potenciados","none","none","","Elige: tus golpes son mágicos O +1 daño de fuerza.")
	_add("monje",7,"evasion_mj","Evasión","none","none","","Sin daño si superas salvación DES, mitad si fallas.")
	_add("monje",9,"movimiento_acrobatico","Movimiento Acrobático","none","none","","Puedes moverte por superficies verticales y líquidos sin caer.")
	_add("monje",10,"autorestablecimiento","Autorrestablecimiento","none","none","","Al inicio de tu turno: elimina asustado, envenenado o hechizado.")
	_add("monje",10,"concentracion_agudizada","Energía Agudizada","none","none","","Mejoras a Defensa Paciente, Paso del Viento y Ráfaga de Golpes.")
	_add("monje",13,"desviar_energia","Desviar Energía","reaction","none","","Desviar ataques ahora funciona con cualquier tipo de daño.")
	_add("monje",14,"superviviente_disciplinado","Superviviente Disciplinado","none","none","","Competencia en todas las tiradas de salvación.")
	_add("monje",15,"concentracion_perfecta","Energía Perfecta","none","none","ki_points","Si tienes 3 puntos o menos al inicio de tu turno, recuperas hasta 4.")
	_add("monje",16,"mca_mj_16","Mejora de Característica","none","none","","")
	_add("monje",18,"defensa_superior","Defensa Superior","bonus","long","ki_points","Bonus: gasta 3 puntos → resistencia a todos los daños excepto fuerza por 1 minuto.")
	_add("monje",19,"don_epico_mj","Don Épico","none","none","","Elige dote épica.")
	_add("monje",20,"cuerpo_y_mente","Cuerpo y Mente","none","none","","Destreza y Sabiduría +4, máximo 25.")

# ─────────────────────────────────────────────────────────────
func _reg_barbaro() -> void:
	_add("barbaro",1,"defensa_sin_armadura_bar","Defensa sin Armadura","none","none","","Sin armadura: CA = 10 + DES + CON.")
	_add("barbaro",1,"furia","Furia","bonus","long","rage_uses","Bonus: 1 minuto. Bonus daño FUE, resistencia B/P/C, ventaja pruebas FUE.")
	_add("barbaro",1,"maestria_armas_bar","Maestría con Armas","none","none","","Propiedad de maestría con 2 armas.")
	_add("barbaro",2,"ataque_temerario","Ataque Temerario","none","none","","Al inicio del turno: ventaja en ataques FUE; desventaja en ataques vs ti.")
	_add("barbaro",2,"sentir_peligro","Sentir el Peligro","none","none","","Ventaja en tiradas de salvación DES contra efectos que puedas ver.")
	_add("barbaro",3,"conocimiento_primigenio","Conocimiento Primigenio","none","none","","Nueva competencia de habilidad. FUE puede reemplazar otras características.")
	_add("barbaro",3,"subclase_bar","Subclase (Senda)","none","none","","Elige: Árbol del Mundo, Berserker, Corazón Salvaje o Fanático.")
	_add("barbaro",4,"mca_bar_4","Mejora de Característica","none","none","","")
	_add("barbaro",5,"ataque_extra_bar","Ataque Adicional","none","none","","2 ataques al usar la acción de atacar.")
	_add("barbaro",5,"movimiento_rapido","Movimiento Rápido","none","none","","Velocidad +3m sin armadura pesada.")
	_add("barbaro",7,"instinto_salvaje","Instinto Salvaje","none","none","","Ventaja en tiradas de iniciativa.")
	_add("barbaro",7,"salto_instintivo","Salto Instintivo","action","none","rage_uses","Cuando un aliado termina su turno, puedes moverte hasta tu velocidad como reacción.")
	_add("barbaro",8,"mca_bar_8","Mejora de Característica","none","none","","")
	_add("barbaro",9,"golpe_brutal","Golpe Brutal","none","none","","Al usar Ataque Temerario y golpear: +1d10 daño + efectos especiales a elección.")
	_add("barbaro",11,"furia_implacable","Furia Implacable","none","long","rage_uses","Cuando la Furia termina y tienes 0 PG, recuperas la mitad de tus PG máximos. 1/largo.")
	_add("barbaro",12,"mca_bar_12","Mejora de Característica","none","none","","")
	_add("barbaro",13,"golpe_brutal_2","Golpe Brutal Mejorado","none","none","","Nuevas opciones para Golpe Brutal.")
	_add("barbaro",14,"presencia_intimidante","Presencia Intimidante","action","long","rage_uses","Acción: criaturas hostiles en 9m deben superar SAB save o quedan Asustadas 1min.")
	_add("barbaro",15,"furia_persistente","Furia Persistente","none","long","rage_uses","Al tirar iniciativa con 0 usos de Furia, recuperas 1 uso.")
	_add("barbaro",16,"mca_bar_16","Mejora de Característica","none","none","","")
	_add("barbaro",17,"golpe_brutal_3","Golpe Brutal Supremo","none","none","","Golpe Brutal da 2d10 y puedes elegir 2 efectos diferentes.")
	_add("barbaro",18,"poderio_indomito","Poderío Indómito","none","none","","Si tiras menos de tu mod FUE en prueba de FUE, usa el mod de FUE en su lugar.")
	_add("barbaro",19,"don_epico_bar","Don Épico","none","none","","Elige dote épica.")
	_add("barbaro",20,"campeon_primordial","Campeón Primordial","none","none","","FUE y CON +4, máximo 25. Usos de Furia: ilimitados.")

# ─────────────────────────────────────────────────────────────
func _reg_hechicero() -> void:
	_add("hechicero",1,"conjuros_hec","Lanzamiento de Conjuros","none","long","","Conjuros innatos CAR. Lanzador completo.")
	_add("hechicero",1,"hechiceria_innata","Hechicería Innata","bonus","long","","Bonus 1 minuto: +1 CD conjuros, ventaja en tiradas de ataque de conjuro.")
	_add("hechicero",1,"subclase_hec","Subclase (Origen)","none","none","","Elige: Mente Aberrante, Magia Salvaje, Linaje Dracónico o Hechicería Mecánica.")
	_add("hechicero",2,"fuente_magia","Fuente de Magia","none","long","sorcery_points","Puntos de Hechicería (= nivel). Crear espacios o potenciar Metamagia.")
	_add("hechicero",2,"metamagia","Metamagia","none","none","sorcery_points","Elige 2 opciones: Cuidadosa, Distante, Potenciada, Acelerada, Gemelar, etc.")
	_add("hechicero",4,"mca_hec_4","Mejora de Característica","none","none","","")
	_add("hechicero",5,"recuperacion_magica_hec","Recuperación Mágica","none","short","sorcery_points","Tras descanso corto: recupera hasta nivel/2 puntos de hechicería. 1/largo.")
	_add("hechicero",7,"encarnacion_magica","Encarnación Mágica","none","long","sorcery_points","Gastar puntos de hechicería para prolongar la Hechicería Innata.")
	_add("hechicero",8,"mca_hec_8","Mejora de Característica","none","none","","")
	_add("hechicero",10,"metamagia_extra","Metamagia Adicional","none","none","","Aprendes 2 opciones de Metamagia más.")
	_add("hechicero",12,"mca_hec_12","Mejora de Característica","none","none","","")
	_add("hechicero",16,"mca_hec_16","Mejora de Característica","none","none","","")
	_add("hechicero",17,"metamagia_extra_2","Metamagia Adicional (segunda)","none","none","","Aprendes 2 opciones de Metamagia más.")
	_add("hechicero",19,"don_epico_hec","Don Épico","none","none","","Elige dote épica.")
	_add("hechicero",20,"apoteosis_arcana","Apoteosis Arcana","none","none","","Cuando usas Hechicería Innata, puedes aplicar Metamagia sin gastar puntos.")

# ─────────────────────────────────────────────────────────────
func _reg_brujo() -> void:
	_add("brujo",1,"magia_del_pacto","Magia del Pacto","none","short","pact_slots","Espacios de conjuro del pacto. Se recuperan en descanso CORTO.")
	_add("brujo",1,"invocaciones","Invocaciones Sobrenaturales","none","none","","Elige 2 invocaciones con efectos permanentes o usos especiales.")
	_add("brujo",2,"astucia_magica","Astucia Mágica","none","long","pact_slots","Ritual de 1 minuto: recupera todos los espacios de Magia de Pacto. 1/largo.")
	_add("brujo",3,"subclase_bru","Subclase (Patrón)","none","none","","Elige: Celestial, Feérico, Infernal o Primigenio.")
	_add("brujo",4,"mca_bru_4","Mejora de Característica","none","none","","")
	_add("brujo",5,"invocaciones_extra","Invocación Adicional","none","none","","Aprendes 1 invocación más.")
	_add("brujo",8,"mca_bru_8","Mejora de Característica","none","none","","")
	_add("brujo",9,"contactar_patron","Contactar Patrón","none","long","","Lanza Contactar con Otro Plano sin espacio 1/largo.")
	_add("brujo",11,"arcanum_6","Arcanum Místico (Nivel 6)","none","long","","Lanza 1 conjuro de nivel 6 sin espacio 1/descanso largo.")
	_add("brujo",12,"mca_bru_12","Mejora de Característica","none","none","","")
	_add("brujo",13,"arcanum_7","Arcanum Místico (Nivel 7)","none","long","","Lanza 1 conjuro de nivel 7 sin espacio 1/descanso largo.")
	_add("brujo",15,"arcanum_8","Arcanum Místico (Nivel 8)","none","long","","Lanza 1 conjuro de nivel 8 sin espacio 1/descanso largo.")
	_add("brujo",16,"mca_bru_16","Mejora de Característica","none","none","","")
	_add("brujo",17,"arcanum_9","Arcanum Místico (Nivel 9)","none","long","","Lanza 1 conjuro de nivel 9 sin espacio 1/descanso largo.")
	_add("brujo",19,"don_epico_bru","Don Épico","none","none","","Elige dote épica.")
	_add("brujo",20,"maestro_sobrenatural","Maestro Sobrenatural","none","long","pact_slots","Astucia Mágica recupera ahora TODOS los espacios de Magia de Pacto.")

# ─────────────────────────────────────────────────────────────
func _reg_clerigo() -> void:
	_add("clerigo",1,"conjuros_cle","Lanzamiento de Conjuros","none","long","","Conjuros divinos SAB. Lanzador completo.")
	_add("clerigo",1,"orden_divina","Orden Divina","none","none","","Elige: Protector (armas marciales+armadura pesada) o Taumaturgo (trucos+Conocimiento).")
	_add("clerigo",2,"canalizar_divinidad_cle","Canalizar Divinidad","action","short","channel_divinity","2 opciones: Chispa Divina (curar/dañar) o Expulsar Muertos Vivientes.")
	_add("clerigo",3,"subclase_cle","Subclase (Dominio)","none","none","","Elige dominio: Guerra, Luz, Vida o Engaño.")
	_add("clerigo",4,"mca_cle_4","Mejora de Característica","none","none","","")
	_add("clerigo",5,"abrasar_muertos_vivientes","Abrasar Muertos Vivientes","none","short","channel_divinity","Al Expulsar: criaturas afectadas también reciben daño radiante.")
	_add("clerigo",6,"canalizar_divinidad_2","Canal Divina Aumentada","none","none","","Ahora 2 usos de Canalizar Divinidad.")
	_add("clerigo",7,"golpes_benditos","Golpes Benditos","none","none","","Elige: Golpe Divino (+1d8 daño especial en melé) o Lanzamiento Potente.")
	_add("clerigo",8,"mca_cle_8","Mejora de Característica","none","none","","")
	_add("clerigo",10,"intercesion_divina","Intercesión Divina","action","long","","Lanza 1 conjuro de clérigo de nv5 o inferior sin espacio. 1/largo.")
	_add("clerigo",12,"mca_cle_12","Mejora de Característica","none","none","","")
	_add("clerigo",14,"golpes_benditos_2","Golpes Benditos Mejorados","none","none","","Golpe Divino: 2d8. Lanzamiento Potente mejorado.")
	_add("clerigo",16,"mca_cle_16","Mejora de Característica","none","none","","")
	_add("clerigo",18,"canal_divino_supremo","Canal Divino Supremo","none","none","","Ahora 3 usos de Canalizar Divinidad.")
	_add("clerigo",19,"don_epico_cle","Don Épico","none","none","","Elige dote épica.")
	_add("clerigo",20,"intercesion_mayor","Intercesión Divina Mayor","action","long","","Lanza Deseo sin espacio 1/largo. Cooldown: 2d4 descansos largos.")

# ─────────────────────────────────────────────────────────────
func _reg_druida() -> void:
	_add("druida",1,"conjuros_dru","Lanzamiento de Conjuros","none","long","","Conjuros de naturaleza SAB. Lanzador completo.")
	_add("druida",1,"druidico","Druídico","none","none","","Idioma druídico secreto. Hablar con Animales siempre preparado.")
	_add("druida",1,"orden_primigenia","Orden Primigenia","none","none","","Elige: Guardián (armas+armadura media) o Naturalista (truco+Naturaleza).")
	_add("druida",2,"companero_salvaje","Compañero Salvaje","bonus","long","spell_slot","Bonus: invoca espíritu animal familiar. Comparte turno con él.")
	_add("druida",2,"forma_salvaje","Forma Salvaje","bonus","short","wild_shape_uses","Bonus: transforma en bestia (VD según nivel). Dura horas = nivel/2. 2 usos.")
	_add("druida",3,"subclase_dru","Subclase (Círculo)","none","none","","Elige: Luna, Tierra, Estrellas o Mar.")
	_add("druida",4,"mca_dru_4","Mejora de Característica","none","none","","")
	_add("druida",5,"resurgimiento_salvaje","Resurgimiento Salvaje","none","none","spell_slot","Gastar espacio de conjuro recupera 1 uso de Forma Salvaje.")
	_add("druida",7,"furia_elemental","Furia Elemental","none","none","","Elige: Golpe Primordial (+1d8 a melé) o Lanzamiento Potente.")
	_add("druida",8,"mca_dru_8","Mejora de Característica","none","none","","")
	_add("druida",12,"mca_dru_12","Mejora de Característica","none","none","","")
	_add("druida",15,"furia_elemental_2","Furia Elemental Mejorada","none","none","","Golpe Primordial: 2d8. Lanzamiento Potente mejorado.")
	_add("druida",16,"mca_dru_16","Mejora de Característica","none","none","","")
	_add("druida",18,"conjurar_como_bestia","Conjurar como Bestia","none","none","","Puedes lanzar conjuros con componentes somáticos en Forma Salvaje.")
	_add("druida",19,"don_epico_dru","Don Épico","none","none","","Elige dote épica.")
	_add("druida",20,"archidruida","Archidruida","none","none","","Forma Salvaje: ilimitada. Convierte formas en espacios de conjuro. Longevidad.")

# ─────────────────────────────────────────────────────────────
func _reg_mago() -> void:
	_add("mago",1,"conjuros_mag","Lanzamiento de Conjuros","none","long","","Conjuros arcanos INT. Lanzador completo. Libro de hechizos: 6 + 2/nivel.")
	_add("mago",1,"adepto_rituales","Adepto en Rituales","none","none","","Lanza cualquier conjuro de tu libro marcado como ritual sin gastar espacio.")
	_add("mago",1,"recuperacion_arcana","Recuperación Arcana","none","short","arcane_recovery","Tras descanso corto: recupera espacios totalizando hasta nivel/2 (máx nivel 5).")
	_add("mago",2,"academico","Académico","none","none","","Pericia en 1 habilidad de conocimiento. Estudiar como acción adicional.")
	_add("mago",3,"subclase_mag","Subclase (Tradición)","none","none","","Elige: Abjurador, Adivino, Evocador o Ilusionista.")
	_add("mago",4,"mca_mag_4","Mejora de Característica","none","none","","")
	_add("mago",5,"memorizar_conjuro","Memorizar Conjuro","none","short","","Tras descanso corto: puedes sustituir 1 conjuro preparado por otro de tu libro.")
	_add("mago",8,"mca_mag_8","Mejora de Característica","none","none","","")
	_add("mago",12,"mca_mag_12","Mejora de Característica","none","none","","")
	_add("mago",16,"mca_mag_16","Mejora de Característica","none","none","","")
	_add("mago",18,"maestria_conjuros","Maestría sobre Conjuros","none","none","","1 conjuro nv1 y 1 conjuro nv2 se pueden lanzar sin gastar espacio (1 por turno c/u).")
	_add("mago",19,"don_epico_mag","Don Épico","none","none","","Elige dote épica.")
	_add("mago",20,"conjuros_caracteristicos","Conjuros Característicos","none","short","","2 conjuros de nivel 3 de tu libro que puedes lanzar sin espacio 1/descanso corto.")

# ============================================================
# HELPER DE REGISTRO
# ============================================================

func _add(class_id: String, level: int, feature_id: String, display_name: String,
		action_type: String, rest_type: String, resource_id: String, description: String) -> void:
	if not _features.has(class_id):
		_features[class_id] = {}
	if not _features[class_id].has(level):
		_features[class_id][level] = []
	_features[class_id][level].append({
		"id": feature_id, "name": display_name, "description": description,
		"action_type": action_type, "rest_type": rest_type,
		"resource_id": resource_id,
	})

# ============================================================
# HELPERS ESTÁTICOS DE ESCALADO
# ============================================================

static func _bardic_die(level: int) -> int:
	if level >= 15: return 12
	if level >= 10: return 10
	if level >= 5:  return 8
	return 6

static func _monk_die(level: int) -> int:
	if level >= 17: return 12
	if level >= 11: return 10
	if level >= 5:  return 8
	return 6

static func _monk_speed(level: int) -> int:
	if level >= 18: return 30
	if level >= 14: return 25
	if level >= 10: return 20
	if level >= 6:  return 15
	if level >= 2:  return 10
	return 0

static func _barbarian_rage_uses(level: int) -> int:
	if level >= 20: return 9999  # ilimitado
	if level >= 17: return 6
	if level >= 12: return 5
	if level >= 8:  return 4
	if level >= 6:  return 4
	if level >= 3:  return 3
	return 2

static func _warlock_slots(level: int) -> int:
	if level >= 17: return 4
	if level >= 11: return 3
	if level >= 2:  return 2
	return 1

static func _warlock_slot_level(level: int) -> int:
	if level >= 9:  return 5
	if level >= 7:  return 4
	if level >= 5:  return 3
	if level >= 3:  return 2
	return 1

static func _druid_cr(level: int) -> float:
	if level >= 8:  return 1.0
	if level >= 4:  return 0.5
	return 0.25
