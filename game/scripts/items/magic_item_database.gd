## magic_item_database.gd
## Base de datos de objetos mágicos (D&D 2024).
## 124 objetos base + descripciones completas letras A–Z.

extends Node

var _items: Dictionary = {}

func _ready() -> void:
	_register_all()
	_register_descriptions_A()
	_register_descriptions_B()
	_register_descriptions_C()
	_register_descriptions_D()
	_register_descriptions_E()
	_register_descriptions_F()
	_register_descriptions_G()
	_register_descriptions_H()
	_register_descriptions_I()
	_register_descriptions_J()
	_register_descriptions_K()
	_register_descriptions_L()
	_register_descriptions_M()
	_register_descriptions_N()
	_register_descriptions_O()
	_register_descriptions_P()
	_register_descriptions_Q()
	_register_descriptions_R()
	_register_descriptions_S()
	_register_descriptions_T()
	_register_descriptions_U()
	_register_descriptions_V()
	_register_descriptions_W()
	_register_descriptions_extra()

func get(item_id: String) -> MagicItemData: return _items.get(item_id)
func get_all() -> Array[MagicItemData]: return _items.values()
func get_by_rarity(r: ItemData.Rarity) -> Array[MagicItemData]:
	return _items.values().filter(func(x: MagicItemData) -> bool: return x.rarity == r)

func _register_all() -> void:
	_m("armadura_1", "Armadura +1", ItemData.Rarity.RARO, ItemData.ItemType.ARMOR, MagicItemData.Attunement.NONE, "+1 a la Clase de Armadura")
	_m("armadura_2", "Armadura +2", ItemData.Rarity.MUY_RARO, ItemData.ItemType.ARMOR, MagicItemData.Attunement.NONE, "+2 a la Clase de Armadura")
	_m("armadura_3", "Armadura +3", ItemData.Rarity.LEGENDARIO, ItemData.ItemType.ARMOR, MagicItemData.Attunement.NONE, "+3 a la Clase de Armadura")
	_m("arma_1", "Arma +1", ItemData.Rarity.INFRECUENTE, ItemData.ItemType.WEAPON, MagicItemData.Attunement.NONE, "+1 a tiradas de ataque y daño")
	_m("arma_2", "Arma +2", ItemData.Rarity.RARO, ItemData.ItemType.WEAPON, MagicItemData.Attunement.NONE, "+2 a tiradas de ataque y daño")
	_m("arma_3", "Arma +3", ItemData.Rarity.MUY_RARO, ItemData.ItemType.WEAPON, MagicItemData.Attunement.NONE, "+3 a tiradas de ataque y daño")
	_m("escudo_1", "Escudo +1", ItemData.Rarity.INFRECUENTE, ItemData.ItemType.SHIELD, MagicItemData.Attunement.NONE, "+1 CA adicional al escudo")
	_m("escudo_2", "Escudo +2", ItemData.Rarity.RARO, ItemData.ItemType.SHIELD, MagicItemData.Attunement.NONE, "+2 CA adicional al escudo")
	_m("escudo_3", "Escudo +3", ItemData.Rarity.MUY_RARO, ItemData.ItemType.SHIELD, MagicItemData.Attunement.NONE, "+3 CA adicional al escudo")
	_m("armadura_adamantina", "Armadura Adamantina", ItemData.Rarity.INFRECUENTE, ItemData.ItemType.ARMOR, MagicItemData.Attunement.NONE, "Los golpes críticos contra ti se vuelven normales")
	_m("armadura_de_resistencia", "Armadura de Resistencia", ItemData.Rarity.RARO, ItemData.ItemType.ARMOR, MagicItemData.Attunement.ANY, "Resistencia a un tipo de daño elegido")
	_m("armadura_elfica", "Armadura Élfica", ItemData.Rarity.RARO, ItemData.ItemType.ARMOR, MagicItemData.Attunement.NONE, "+1 CA, entrenamiento automático")
	_m("armadura_de_mithral", "Armadura de Mithral", ItemData.Rarity.INFRECUENTE, ItemData.ItemType.ARMOR, MagicItemData.Attunement.NONE, "Sin desventaja en Sigilo, sin requisito de FUE")
	_m("armadura_de_placas_de_la_etereidad", "Armadura de Placas de la Etereidad", ItemData.Rarity.LEGENDARIO, ItemData.ItemType.ARMOR, MagicItemData.Attunement.ANY, "Lanzas Forma Etérea 1/amanecer")
	_m("armadura_de_invulnerabilidad", "Armadura de Invulnerabilidad", ItemData.Rarity.LEGENDARIO, ItemData.ItemType.ARMOR, MagicItemData.Attunement.ANY, "Resistencia B/P/C; inmunidad 10min/amanecer")
	_m("malla_reluciente", "Malla Reluciente", ItemData.Rarity.COMUN, ItemData.ItemType.ARMOR, MagicItemData.Attunement.NONE, "La armadura nunca se ensucia")
	_m("armadura_abandonada", "Armadura Abandonada", ItemData.Rarity.COMUN, ItemData.ItemType.ARMOR, MagicItemData.Attunement.NONE, "Puedes quitarte la armadura como acción mágica")
	_m("armadura_humeante", "Armadura Humeante", ItemData.Rarity.COMUN, ItemData.ItemType.ARMOR, MagicItemData.Attunement.NONE, "Volutas de humo inofensivas mientras la llevas")
	_m("armadura_del_berserker", "Armadura del Berserker", ItemData.Rarity.RARO, ItemData.ItemType.ARMOR, MagicItemData.Attunement.ANY, "+1 ataque; maldita: furia en combate")
	_m("armadura_demoniaca", "Armadura Demoníaca", ItemData.Rarity.MUY_RARO, ItemData.ItemType.ARMOR, MagicItemData.Attunement.ANY, "+1 CA, idioma abisal, golpes sin armas 1d8")
	_m("cota_de_malla_elfica_encadenada", "Cota de Malla Élfica Encadenada", ItemData.Rarity.RARO, ItemData.ItemType.ARMOR, MagicItemData.Attunement.NONE, "+1 CA; competencia automática")
	_m("placa_enana", "Placa Enana", ItemData.Rarity.MUY_RARO, ItemData.ItemType.ARMOR, MagicItemData.Attunement.NONE, "+2 CA, reduce desplazamiento forzado 3m")
	_m("escamas_de_dragon", "Escamas de Dragón", ItemData.Rarity.MUY_RARO, ItemData.ItemType.ARMOR, MagicItemData.Attunement.ANY, "+1 CA, resistencia al tipo del dragón")
	_m("cuero_glamuroso_tachonado", "Cuero Glamuroso Tachonado", ItemData.Rarity.RARO, ItemData.ItemType.ARMOR, MagicItemData.Attunement.NONE, "+1 CA, aspecto ilusorio cambiable")
	_m("armadura_del_marinero", "Armadura del Marinero", ItemData.Rarity.INFRECUENTE, ItemData.ItemType.ARMOR, MagicItemData.Attunement.NONE, "Velocidad de natación, recuperas PG bajo el agua")
	_m("escudo_centinela", "Escudo Centinela", ItemData.Rarity.INFRECUENTE, ItemData.ItemType.SHIELD, MagicItemData.Attunement.NONE, "Ventaja en Iniciativa y Percepción")
	_m("escudo_de_atraccion_de_proyectiles", "Escudo de Atracción de Proyectiles", ItemData.Rarity.RARO, ItemData.ItemType.SHIELD, MagicItemData.Attunement.ANY, "Resistencia daño a distancia; maldito: atrae proyectiles")
	_m("escudo_de_la_caballeria", "Escudo de la Caballería", ItemData.Rarity.MUY_RARO, ItemData.ItemType.SHIELD, MagicItemData.Attunement.ANY, "+2 CA, golpe de escudo, campo protector")
	_m("escudo_de_proteccion_contra_proyectiles", "Escudo de Protección contra Proyectiles", ItemData.Rarity.RARO, ItemData.ItemType.SHIELD, MagicItemData.Attunement.ANY, "+2 CA vs ataques a distancia, redirigir ataques")
	_m("escudo_de_proteccion_contra_hechizos", "Escudo de Protección contra Hechizos", ItemData.Rarity.MUY_RARO, ItemData.ItemType.SHIELD, MagicItemData.Attunement.ANY, "Ventaja en saves vs conjuros, desventaja ataques de conjuro")
	_m("espada_sol", "Espada Sol", ItemData.Rarity.RARO, ItemData.ItemType.WEAPON, MagicItemData.Attunement.ANY, "+2 espada larga, 1d8 extra vs muertos vivientes, luz solar")
	_m("espada_lengua_de_fuego", "Espada Lengua de Fuego", ItemData.Rarity.RARO, ItemData.ItemType.WEAPON, MagicItemData.Attunement.ANY, "+2d6 daño de fuego mientras arde")
	_m("marca_de_nieve", "Marca de Nieve", ItemData.Rarity.MUY_RARO, ItemData.ItemType.WEAPON, MagicItemData.Attunement.ANY, "+1d6 frío, resistencia al fuego")
	_m("daga_de_veneno", "Daga de Veneno", ItemData.Rarity.RARO, ItemData.ItemType.WEAPON, MagicItemData.Attunement.NONE, "+1 ataque, veneno 2d10/amanecer")
	_m("hacha_lanzadora_enana", "Hacha Lanzadora Enana", ItemData.Rarity.MUY_RARO, ItemData.ItemType.WEAPON, MagicItemData.Attunement.ANY, "+3 ataque, 1d8 o 2d8 daño de fuerza al lanzar")
	_m("espada_bailarina", "Espada Bailarina", ItemData.Rarity.MUY_RARO, ItemData.ItemType.WEAPON, MagicItemData.Attunement.ANY, "Flota y ataca hasta 4 veces antes de regresar")
	_m("matadragones", "Matadragones", ItemData.Rarity.RARO, ItemData.ItemType.WEAPON, MagicItemData.Attunement.NONE, "+1 ataque, 3d6 extra vs dragones")
	_m("matagigantos", "Matagigantos", ItemData.Rarity.RARO, ItemData.ItemType.WEAPON, MagicItemData.Attunement.NONE, "+1 ataque, 2d6 vs gigantes, derribar DC 15")
	_m("espada_vorpal", "Espada Vorpal", ItemData.Rarity.LEGENDARIO, ItemData.ItemType.WEAPON, MagicItemData.Attunement.ANY, "+3, ignora resistencia cortante, decapitación")
	_m("espada_de_respuesta", "Espada de Respuesta", ItemData.Rarity.LEGENDARIO, ItemData.ItemType.WEAPON, MagicItemData.Attunement.ANY, "+3, reacción de ataque, ignora resistencia")
	_m("espada_de_vida_robada", "Espada de Vida Robada", ItemData.Rarity.RARO, ItemData.ItemType.WEAPON, MagicItemData.Attunement.ANY, "15 daño necrótico en 20 natural contra criaturas")
	_m("espada_viciosa", "Espada Viciosa", ItemData.Rarity.RARO, ItemData.ItemType.WEAPON, MagicItemData.Attunement.NONE, "+2d6 daño del mismo tipo en critico")
	_m("espada_afilada", "Espada Afilada", ItemData.Rarity.MUY_RARO, ItemData.ItemType.WEAPON, MagicItemData.Attunement.ANY, "Daño máximo a objetos, 14 cortante + agotamiento")
	_m("espada_de_las_heridas", "Espada de las Heridas", ItemData.Rarity.RARO, ItemData.ItemType.WEAPON, MagicItemData.Attunement.ANY, "2d6 necrótico, impide curación 1 hora")
	_m("oathbow", "Oathbow", ItemData.Rarity.MUY_RARO, ItemData.ItemType.WEAPON, MagicItemData.Attunement.ANY, "+3d6 vs enemigo jurado, desventaja otras armas")
	_m("espada_de_velocidad_cimitarra", "Espada de Velocidad (Cimitarra)", ItemData.Rarity.MUY_RARO, ItemData.ItemType.WEAPON, MagicItemData.Attunement.ANY, "+2 ataque, 1 ataque de bonus por turno")
	_m("maza_de_destruccion", "Maza de Destrucción", ItemData.Rarity.RARO, ItemData.ItemType.WEAPON, MagicItemData.Attunement.ANY, "+2d6 radiante vs infernales/muertos vivientes")
	_m("maza_del_terror", "Maza del Terror", ItemData.Rarity.RARO, ItemData.ItemType.WEAPON, MagicItemData.Attunement.ANY, "Miedo 9m DC 15, 3 cargas")
	_m("martillo_de_los_truenos", "Martillo de los Truenos", ItemData.Rarity.LEGENDARIO, ItemData.ItemType.WEAPON, MagicItemData.Attunement.ANY, "+1 ataque, 5d4 daño de fuerza con trueno")
	_m("tridente_de_mando_de_peces", "Tridente de Mando de Peces", ItemData.Rarity.INFRECUENTE, ItemData.ItemType.WEAPON, MagicItemData.Attunement.ANY, "Dominar bestia acuática DC 15")
	_m("bolsa_de_contencion", "Bolsa de Contención", ItemData.Rarity.INFRECUENTE, ItemData.ItemType.MAGIC, MagicItemData.Attunement.NONE, "Contiene 500 lbs en 64 pies cúbicos")
	_m("capa_de_invisibilidad", "Capa de Invisibilidad", ItemData.Rarity.LEGENDARIO, ItemData.ItemType.MAGIC, MagicItemData.Attunement.ANY, "Invisibilidad indefinida; 1 hora de cargas")
	_m("botas_de_la_velocidad", "Botas de la Velocidad", ItemData.Rarity.RARO, ItemData.ItemType.MAGIC, MagicItemData.Attunement.ANY, "Velocidad doble 10 min/día; desventaja ataques vs ti")
	_m("botas_de_levitacion", "Botas de Levitación", ItemData.Rarity.RARO, ItemData.ItemType.MAGIC, MagicItemData.Attunement.ANY, "Lanzas Levitar sobre ti mismo")
	_m("botas_de_elfo", "Botas de Elfo", ItemData.Rarity.INFRECUENTE, ItemData.ItemType.MAGIC, MagicItemData.Attunement.NONE, "Pasos sin ruido, ventaja en Sigilo")
	_m("botas_de_zancada_y_salto", "Botas de Zancada y Salto", ItemData.Rarity.INFRECUENTE, ItemData.ItemType.MAGIC, MagicItemData.Attunement.ANY, "Velocidad 9m, salto 9m usando 3m")
	_m("botas_de_arana", "Botas de Araña", ItemData.Rarity.INFRECUENTE, ItemData.ItemType.MAGIC, MagicItemData.Attunement.ANY, "Velocidad de escalar = velocidad")
	_m("brazales_de_arqueria", "Brazales de Arquería", ItemData.Rarity.INFRECUENTE, ItemData.ItemType.MAGIC, MagicItemData.Attunement.ANY, "Competencia y +2 daño con arcos")
	_m("brazales_de_defensa", "Brazales de Defensa", ItemData.Rarity.RARO, ItemData.ItemType.MAGIC, MagicItemData.Attunement.ANY, "+2 CA sin armadura ni escudo")
	_m("capa_de_proteccion", "Capa de Protección", ItemData.Rarity.INFRECUENTE, ItemData.ItemType.MAGIC, MagicItemData.Attunement.ANY, "+1 CA y tiradas de salvación")
	_m("capa_de_desplazamiento", "Capa de Desplazamiento", ItemData.Rarity.RARO, ItemData.ItemType.MAGIC, MagicItemData.Attunement.ANY, "Desventaja en ataques vs ti; cesa al recibir daño")
	_m("capa_de_elfo", "Capa de Elfo", ItemData.Rarity.INFRECUENTE, ItemData.ItemType.MAGIC, MagicItemData.Attunement.ANY, "Desventaja en Percepción vs ti")
	_m("cinturon_de_fuerza_de_gigante_colina", "Cinturón de Fuerza de Gigante (colina)", ItemData.Rarity.RARO, ItemData.ItemType.MAGIC, MagicItemData.Attunement.ANY, "FUE pasa a 21")
	_m("cinturon_de_fuerza_de_gigante_escarcha", "Cinturón de Fuerza de Gigante (escarcha)", ItemData.Rarity.MUY_RARO, ItemData.ItemType.MAGIC, MagicItemData.Attunement.ANY, "FUE pasa a 23")
	_m("cinturon_de_fuerza_de_gigante_fuego", "Cinturón de Fuerza de Gigante (fuego)", ItemData.Rarity.MUY_RARO, ItemData.ItemType.MAGIC, MagicItemData.Attunement.ANY, "FUE pasa a 25")
	_m("cinturon_de_fuerza_de_gigante_nube", "Cinturón de Fuerza de Gigante (nube)", ItemData.Rarity.LEGENDARIO, ItemData.ItemType.MAGIC, MagicItemData.Attunement.ANY, "FUE pasa a 27")
	_m("cinturon_de_fuerza_de_gigante_tormenta", "Cinturón de Fuerza de Gigante (tormenta)", ItemData.Rarity.LEGENDARIO, ItemData.ItemType.MAGIC, MagicItemData.Attunement.ANY, "FUE pasa a 29")
	_m("guanteletes_de_poder_del_ogro", "Guanteletes de Poder del Ogro", ItemData.Rarity.INFRECUENTE, ItemData.ItemType.MAGIC, MagicItemData.Attunement.ANY, "FUE pasa a 19")
	_m("diadema_de_intelecto", "Diadema de Intelecto", ItemData.Rarity.INFRECUENTE, ItemData.ItemType.MAGIC, MagicItemData.Attunement.ANY, "INT pasa a 19")
	_m("amuleto_de_salud", "Amuleto de Salud", ItemData.Rarity.RARO, ItemData.ItemType.MAGIC, MagicItemData.Attunement.ANY, "CON pasa a 19")
	_m("anillo_de_proteccion", "Anillo de Protección", ItemData.Rarity.RARO, ItemData.ItemType.MISC, MagicItemData.Attunement.ANY, "+1 CA y salvaciones")
	_m("anillo_de_invisibilidad", "Anillo de Invisibilidad", ItemData.Rarity.LEGENDARIO, ItemData.ItemType.MISC, MagicItemData.Attunement.ANY, "Invisibilidad indefinida")
	_m("anillo_de_tres_deseos", "Anillo de Tres Deseos", ItemData.Rarity.LEGENDARIO, ItemData.ItemType.MISC, MagicItemData.Attunement.NONE, "Lanza Deseo 3 veces, luego no mágico")
	_m("anillo_de_regeneracion", "Anillo de Regeneración", ItemData.Rarity.MUY_RARO, ItemData.ItemType.MISC, MagicItemData.Attunement.ANY, "Recuperas 1d6 PG cada 10 minutos")
	_m("anillo_de_resistencia_a_los_conjuros", "Anillo de Resistencia a los Conjuros", ItemData.Rarity.RARO, ItemData.ItemType.MISC, MagicItemData.Attunement.NONE, "Resistencia a un tipo de daño (según gema)")
	_m("anillo_de_almacenamiento_de_conjuros", "Anillo de Almacenamiento de Conjuros", ItemData.Rarity.RARO, ItemData.ItemType.MISC, MagicItemData.Attunement.ANY, "Almacena hasta nivel 5 de conjuros")
	_m("anillo_de_accion_libre", "Anillo de Acción Libre", ItemData.Rarity.RARO, ItemData.ItemType.MISC, MagicItemData.Attunement.ANY, "Sin terreno difícil, sin reducción de velocidad")
	_m("anillo_de_telekinesia", "Anillo de Telekinesia", ItemData.Rarity.MUY_RARO, ItemData.ItemType.MISC, MagicItemData.Attunement.ANY, "Lanzas Telequinesia")
	_m("anillo_de_caida_de_pluma", "Anillo de Caída de Pluma", ItemData.Rarity.RARO, ItemData.ItemType.MISC, MagicItemData.Attunement.ANY, "Caes a 18m/ronda sin daño")
	_m("anillo_de_natacion", "Anillo de Natación", ItemData.Rarity.INFRECUENTE, ItemData.ItemType.MISC, MagicItemData.Attunement.NONE, "Velocidad de natación 12m")
	_m("anillo_de_salto", "Anillo de Salto", ItemData.Rarity.INFRECUENTE, ItemData.ItemType.MISC, MagicItemData.Attunement.ANY, "Lanzas Salto sobre ti mismo")
	_m("anillo_de_mente_blindada", "Anillo de Mente Blindada", ItemData.Rarity.INFRECUENTE, ItemData.ItemType.MISC, MagicItemData.Attunement.ANY, "Inmunidad lectura de mente; guardar alma")
	_m("anillo_de_vision_x", "Anillo de Visión X", ItemData.Rarity.RARO, ItemData.ItemType.MISC, MagicItemData.Attunement.ANY, "Visión X 9m 1 minuto; riesgo de agotamiento")
	_m("baculo_del_mago", "Báculo del Mago", ItemData.Rarity.LEGENDARIO, ItemData.ItemType.MISC, MagicItemData.Attunement.ANY, "+2 ataques conjuro, 50 cargas, conjuros variados")
	_m("baculo_de_poder", "Báculo de Poder", ItemData.Rarity.MUY_RARO, ItemData.ItemType.MISC, MagicItemData.Attunement.ANY, "+2 CA/saves/ataques, conjuros, 20 cargas")
	_m("baculo_de_golpeo", "Báculo de Golpeo", ItemData.Rarity.MUY_RARO, ItemData.ItemType.MISC, MagicItemData.Attunement.ANY, "+3 bastón, 1d6 fuerza por carga, 10 cargas")
	_m("baculo_de_curacion", "Báculo de Curación", ItemData.Rarity.RARO, ItemData.ItemType.MISC, MagicItemData.Attunement.ANY, "Conjuros de curación, 10 cargas")
	_m("baculo_de_fuego", "Báculo de Fuego", ItemData.Rarity.MUY_RARO, ItemData.ItemType.MISC, MagicItemData.Attunement.ANY, "Resistencia fuego, conjuros de fuego, 10 cargas")
	_m("baculo_de_escarcha", "Báculo de Escarcha", ItemData.Rarity.MUY_RARO, ItemData.ItemType.MISC, MagicItemData.Attunement.ANY, "Resistencia frío, conjuros de frío, 10 cargas")
	_m("baculo_de_la_serpiente", "Báculo de la Serpiente", ItemData.Rarity.INFRECUENTE, ItemData.ItemType.MISC, MagicItemData.Attunement.ANY, "Cabeza de serpiente anima 1d6+3d6 daño")
	_m("varita_de_misiles_magicos", "Varita de Misiles Mágicos", ItemData.Rarity.INFRECUENTE, ItemData.ItemType.MISC, MagicItemData.Attunement.NONE, "Proyectil Mágico nv1-3, 7 cargas")
	_m("varita_de_bolas_de_fuego", "Varita de Bolas de Fuego", ItemData.Rarity.RARO, ItemData.ItemType.MISC, MagicItemData.Attunement.ANY, "Bola de Fuego nv3-5, 7 cargas")
	_m("varita_de_rayos", "Varita de Rayos", ItemData.Rarity.RARO, ItemData.ItemType.MISC, MagicItemData.Attunement.ANY, "Rayo nv3-5, 7 cargas")
	_m("varita_de_maravillas", "Varita de Maravillas", ItemData.Rarity.RARO, ItemData.ItemType.MISC, MagicItemData.Attunement.ANY, "Efecto mágico aleatorio 36m, 7 cargas")
	_m("varita_de_polimorfar", "Varita de Polimorfar", ItemData.Rarity.MUY_RARO, ItemData.ItemType.MISC, MagicItemData.Attunement.ANY, "Polimorfar DC 15, 7 cargas")
	_m("varita_de_miedo", "Varita de Miedo", ItemData.Rarity.RARO, ItemData.ItemType.MISC, MagicItemData.Attunement.ANY, "Conjuro Miedo cono 18m, 7 cargas")
	_m("varita_del_mago_de_guerra_1", "Varita del Mago de Guerra +1", ItemData.Rarity.INFRECUENTE, ItemData.ItemType.MISC, MagicItemData.Attunement.ANY, "+1 a ataques de conjuro")
	_m("varita_del_mago_de_guerra_2", "Varita del Mago de Guerra +2", ItemData.Rarity.RARO, ItemData.ItemType.MISC, MagicItemData.Attunement.ANY, "+2 a ataques de conjuro")
	_m("varita_del_mago_de_guerra_3", "Varita del Mago de Guerra +3", ItemData.Rarity.MUY_RARO, ItemData.ItemType.MISC, MagicItemData.Attunement.ANY, "+3 a ataques de conjuro")
	_m("cuentas_de_fuerza", "Cuentas de Fuerza", ItemData.Rarity.RARO, ItemData.ItemType.MAGIC, MagicItemData.Attunement.NONE, "Explosión 5d4 fuerza, esfera atrapadora")
	_m("esfera_de_aniquilacion", "Esfera de Aniquilación", ItemData.Rarity.LEGENDARIO, ItemData.ItemType.MAGIC, MagicItemData.Attunement.NONE, "Agujero 60cm destruye materia; 8d10 fuerza")
	_m("bolsa_de_trucos", "Bolsa de Trucos", ItemData.Rarity.INFRECUENTE, ItemData.ItemType.MAGIC, MagicItemData.Attunement.NONE, "Crea criaturas aleatorias de objetos mágicos")
	_m("espejo_de_trampa_vital", "Espejo de Trampa Vital", ItemData.Rarity.MUY_RARO, ItemData.ItemType.MAGIC, MagicItemData.Attunement.NONE, "Atrapa criaturas en celdas extradimensionales")
	_m("decantador_de_agua_interminable", "Decantador de Agua Interminable", ItemData.Rarity.INFRECUENTE, ItemData.ItemType.MAGIC, MagicItemData.Attunement.NONE, "Produce 1-30 galones de agua")
	_m("cubo_de_fuerza", "Cubo de Fuerza", ItemData.Rarity.RARO, ItemData.ItemType.MAGIC, MagicItemData.Attunement.ANY, "Conjuros de nv1-5, recupera 1d6 cargas/día")
	_m("agujero_portatil", "Agujero Portátil", ItemData.Rarity.RARO, ItemData.ItemType.MAGIC, MagicItemData.Attunement.NONE, "Hoyo extradimensional de 3m de profundidad")
	_m("cristal_de_bola", "Cristal de Bola", ItemData.Rarity.MUY_RARO, ItemData.ItemType.MAGIC, MagicItemData.Attunement.ANY, "Lanzas Escrutinio DC 17")
	_m("alfombra_voladora", "Alfombra Voladora", ItemData.Rarity.MUY_RARO, ItemData.ItemType.MAGIC, MagicItemData.Attunement.NONE, "Vuela a 9-24m según tamaño")
	_m("perla_de_poder", "Perla de Poder", ItemData.Rarity.INFRECUENTE, ItemData.ItemType.MAGIC, MagicItemData.Attunement.ANY, "Recuperas espacio nv3 o inferior/amanecer")
	_m("colmillo_de_pergamino_de_conjuro", "Colmillo de Pergamino de Conjuro", ItemData.Rarity.MUNDANO, ItemData.ItemType.CONSUMABLE, MagicItemData.Attunement.NONE, "Lanza el conjuro una vez, luego se deshace")
	_m("pocion_de_curacion", "Pocion de Curación", ItemData.Rarity.COMUN, ItemData.ItemType.CONSUMABLE, MagicItemData.Attunement.NONE, "Recuperas 2d4+2 PG")
	_m("pocion_de_curacion_mayor", "Pocion de Curación Mayor", ItemData.Rarity.INFRECUENTE, ItemData.ItemType.CONSUMABLE, MagicItemData.Attunement.NONE, "Recuperas 4d4+4 PG")
	_m("pocion_de_curacion_superior", "Pocion de Curación Superior", ItemData.Rarity.RARO, ItemData.ItemType.CONSUMABLE, MagicItemData.Attunement.NONE, "Recuperas 8d4+8 PG")
	_m("pocion_de_curacion_suprema", "Pocion de Curación Suprema", ItemData.Rarity.MUY_RARO, ItemData.ItemType.CONSUMABLE, MagicItemData.Attunement.NONE, "Recuperas 10d4+20 PG")
	_m("pocion_de_heroismo", "Pocion de Heroismo", ItemData.Rarity.RARO, ItemData.ItemType.CONSUMABLE, MagicItemData.Attunement.NONE, "10 PG temporales, efecto Bendición 1 hora")
	_m("pocion_de_velocidad", "Pocion de Velocidad", ItemData.Rarity.MUY_RARO, ItemData.ItemType.CONSUMABLE, MagicItemData.Attunement.NONE, "Celeridad 1 minuto, sin letargo posterior")
	_m("pocion_de_invisibilidad", "Pocion de Invisibilidad", ItemData.Rarity.RARO, ItemData.ItemType.CONSUMABLE, MagicItemData.Attunement.NONE, "Invisibilidad 1 hora; acaba al atacar")
	_m("pocion_de_gran_invisibilidad", "Pocion de Gran Invisibilidad", ItemData.Rarity.MUY_RARO, ItemData.ItemType.CONSUMABLE, MagicItemData.Attunement.NONE, "Invisibilidad 1 hora incluso atacando")
	_m("pocion_de_vuelo", "Pocion de Vuelo", ItemData.Rarity.MUY_RARO, ItemData.ItemType.CONSUMABLE, MagicItemData.Attunement.NONE, "Velocidad de vuelo = velocidad 1 hora")
	_m("pocion_de_vitalidad", "Pocion de Vitalidad", ItemData.Rarity.MUY_RARO, ItemData.ItemType.CONSUMABLE, MagicItemData.Attunement.NONE, "Elimina agotamiento, cura al máximo 24h")
	_m("pocion_de_resistencia", "Pocion de Resistencia", ItemData.Rarity.INFRECUENTE, ItemData.ItemType.CONSUMABLE, MagicItemData.Attunement.NONE, "Resistencia a un tipo de daño 1 hora")
	_m("elixir_de_salud", "Elixir de Salud", ItemData.Rarity.RARO, ItemData.ItemType.CONSUMABLE, MagicItemData.Attunement.NONE, "Cura enfermedades, elimina cegado/paralizado/envenenado")
	_m("aceite_de_nitidez", "Aceite de Nitidez", ItemData.Rarity.MUY_RARO, ItemData.ItemType.CONSUMABLE, MagicItemData.Attunement.NONE, "Cubre arma, se convierte en arma +3")
	_m("ungüento_de_keoghtom", "Ungüento de Keoghtom", ItemData.Rarity.INFRECUENTE, ItemData.ItemType.MAGIC, MagicItemData.Attunement.NONE, "Recupera 2d8+2 PG, elimina envenenado")

## Registra o actualiza un objeto mágico.
## effect: descripción mecánica breve (tooltip).
## description: descripción completa del libro (vacío hasta que se procese esa letra).
func _m(id: String, name: String, rarity: ItemData.Rarity, itype: ItemData.ItemType,
		att: MagicItemData.Attunement, effect: String, description: String = "") -> void:
	var m := MagicItemData.new()
	m.item_id = id; m.display_name = name; m.rarity = rarity
	m.item_type = itype; m.attunement = att; m.effect = effect
	m.description = description
	m.is_magical = true
	_items[id] = m

## Establece solo la descripción completa de un objeto ya registrado.
func _set_desc(id: String, desc: String) -> void:
	if _items.has(id):
		_items[id].description = desc

# ============================================================
# DESCRIPCIONES COMPLETAS — LETRA A
# ============================================================

func _register_descriptions_A() -> void:
	# ── Armadura Adamantina ──────────────────────────────────
	_set_desc("armadura_adamantina",
		"Esta armadura está reforzada con adamantina, una de las sustancias más duras que existen. Mientras la llevas puesta, cualquier Golpe Crítico contra ti se convierte en un golpe normal.")

	# ── Arma Adamantina (NUEVO) ──────────────────────────────
	_m("arma_adamantina", "Arma Adamantina", ItemData.Rarity.INFRECUENTE, ItemData.ItemType.WEAPON,
		MagicItemData.Attunement.NONE,
		"Golpe crítico automático al impactar objetos",
		"Esta arma o pieza de munición está fabricada de adamantina, una de las sustancias más duras que existen. Siempre que esta arma o pieza de munición impacta a un objeto, el impacto es un Golpe Crítico.")

	# ── Jarra Alquímica (NUEVO) ──────────────────────────────
	_m("jarra_alquimica", "Jarra Alquímica", ItemData.Rarity.INFRECUENTE, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.NONE,
		"Produce hasta 8 tipos de líquidos distintos (hasta 12 galones de agua salada)",
		"Esta jarra de cerámica parece poder contener un galón de líquido y pesa 5,5 kg tanto llena como vacía. La jarra chapotea cuando se agita, aunque esté vacía.\n\nPuedes realizar una Acción Mágica y nombrar uno de los siguientes líquidos para que la jarra lo produzca: ácido (240 ml), veneno básico (120 ml), cerveza (15 l), miel (3,8 l), mayonesa (7,5 l), aceite (1 l), vinagre (7,5 l), agua dulce (30 l), agua salada (45 l) o vino (3,8 l). Tras nombrarlo, puedes descorchar la jarra como Acción de Utilizar y verter el líquido a razón de 7,5 l por minuto.\n\nUna vez que la jarra empieza a producir un líquido, no puede producir otro distinto, ni más del que ya alcanzó su máximo, hasta el siguiente amanecer.")

	# ── Munición +1/+2/+3 (descripciones) ──────────────────
	_set_desc("arma_1",
		"Tienes un bonificador a las tiradas de ataque y de daño realizadas con esta pieza de munición mágica. El bonificador lo determina la rareza de la munición. Una vez que impacta a un objetivo, la munición deja de ser mágica.\n\nEste tipo de munición se suele encontrar o vender en cantidades de diez o veinte piezas. Diez piezas equivalen en valor a una poción de la misma rareza.")
	_set_desc("arma_2",
		"Tienes un bonificador a las tiradas de ataque y de daño realizadas con esta pieza de munición mágica. El bonificador lo determina la rareza de la munición. Una vez que impacta a un objetivo, la munición deja de ser mágica.\n\nEste tipo de munición se suele encontrar o vender en cantidades de diez o veinte piezas. Diez piezas equivalen en valor a una poción de la misma rareza.")
	_set_desc("arma_3",
		"Tienes un bonificador a las tiradas de ataque y de daño realizadas con esta pieza de munición mágica. El bonificador lo determina la rareza de la munición. Una vez que impacta a un objetivo, la munición deja de ser mágica.\n\nEste tipo de munición se suele encontrar o vender en cantidades de diez o veinte piezas. Diez piezas equivalen en valor a una poción de la misma rareza.")

	# ── Munición Destructora (NUEVO) ─────────────────────────
	_m("municion_destructora", "Munición de Destrucción", ItemData.Rarity.MUY_RARO, ItemData.ItemType.AMMUNITION,
		MagicItemData.Attunement.NONE,
		"6d10 daño de Fuerza adicional vs tipo de criatura (CD 17 CON); pierde magia al impactar",
		"Esta munición mágica está diseñada para abatir criaturas de un tipo concreto, que el DJ elige o determina al azar. Si una criatura de ese tipo recibe daño de la munición, debe hacer una tirada de salvación de Constitución CD 17, sufriendo 6d10 daño de Fuerza adicional si falla, o la mitad si tiene éxito.\n\nTras infligir su daño adicional a una criatura, la munición pierde su magia.\n\nTipos posibles: aberraciones, bestias, celestiales, constructos, dragones, elementales, humanoides, feéricos, infernales, gigantes, monstruosidades, cienos, plantas, no muertos.")

	# ── Amuleto de Salud ────────────────────────────────────
	_set_desc("amuleto_de_salud",
		"Tu Constitución es 19 mientras llevas este amuleto. No tiene ningún efecto sobre ti si tu Constitución ya es 19 o superior sin él.")

	# ── Amuleto de Prueba contra la Detección (NUEVO) ────────
	_m("amuleto_prueba_deteccion", "Amuleto de Prueba contra la Detección y la Localización",
		ItemData.Rarity.INFRECUENTE, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.ANY,
		"No puedes ser objetivo de conjuros de Adivinación ni percibido por sensores de escrutinio mágico",
		"Mientras llevas este amuleto, no puedes ser objetivo de conjuros de Adivinación ni ser percibido a través de sensores de escrutinio mágico, a menos que tú lo permitas.")

	# ── Amuleto de los Planos (NUEVO) ────────────────────────
	_m("amuleto_de_los_planos", "Amuleto de los Planos", ItemData.Rarity.MUY_RARO, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.ANY,
		"Acción Mágica: INT (Arcanos) CD 15 para lanzar Desplazamiento de Plano; en fallo, teletransporte aleatorio",
		"Mientras llevas este amuleto, puedes realizar una Acción Mágica para nombrar una ubicación que conozcas en otro plano de existencia. A continuación, realiza una prueba de Inteligencia (Arcanos) CD 15. Con éxito, lanzas Desplazamiento de Plano. Con un fallo, tú y todas las criaturas y objetos a menos de 4,5 m de ti viajáis a un destino aleatorio determinado tirando 1d100:\n\n01–60: Lugar aleatorio en el plano que nombraste.\n61–70: Lugar aleatorio en un Plano Interior (1d6: 1 Aire, 2 Tierra, 3 Fuego, 4 Agua, 5 Feywild, 6 Shadowfell).\n71–80: Plano Exterior benévolo aleatorio (Arbórea, Arcadia, Tierras Bestiales, Bytopia, Elíseo, Mechanous, Monte Celestia o Ysgard).\n81–90: Plano Exterior maligno aleatorio (Abismo, Acherón, Carceri, Gehena, Hades, Limbo, los Nueve Infiernos o Pandemonium).\n91–00: Lugar aleatorio en el Plano Astral.")

	# ── Escudo Animado (NUEVO) ───────────────────────────────
	_m("escudo_animado", "Escudo Animado", ItemData.Rarity.MUY_RARO, ItemData.ItemType.SHIELD,
		MagicItemData.Attunement.ANY,
		"Acción adicional: el escudo flota y te protege solo durante 1 minuto, dejando las manos libres",
		"Mientras empuñas este escudo, puedes realizar una Acción Adicional para que se anime. El escudo salta al aire y flota en tu espacio protegiéndote como si lo estuvieras empuñando, dejando tus manos libres. El escudo permanece animado durante 1 minuto, hasta que uses una Acción Adicional para terminar el efecto, o hasta que mueras o recibas la condición Incapacitado, momento en el que el escudo cae al suelo o a tu mano si tienes una libre.")

	# ── Aparato de Kwalish (NUEVO) ──────────────────────────
	_m("aparato_kwalish", "Aparato de Kwalish", ItemData.Rarity.LEGENDARIO, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.NONE,
		"Submarino/vehículo de combate: CA 20, 200 PG, veloc. 9m/natación 9m; 10 palancas de mando",
		"Este objeto parece inicialmente un barril de hierro sellado que pesa 225 kg. Tiene un cierre oculto que puede encontrarse con una prueba de Inteligencia (Investigación) CD 20. Al soltarlo se abre una escotilla en un extremo, permitiendo que dos criaturas Medianas o más pequeñas se introduzcan dentro. Diez palancas están dispuestas en fila en el extremo interior.\n\nEl Aparato de Kwalish es un objeto Grande con: CA 20; PG 200; Velocidad 9 m, Nadar 9 m (o 0 si las patas no están extendidas); Inmunidad al daño de Veneno y Psíquico.\n\nPara usarlo como vehículo se necesita un piloto. Con la escotilla cerrada el compartimento es hermético e impermeable, con aire suficiente para 10 horas divididas entre las criaturas que respiren dentro. Puede sumergirse hasta 270 m; más profundo recibe 2d6 daño Contundente por minuto.\n\nCada turno un ocupante puede usar la Acción de Utilizar para mover hasta dos palancas. Funciones principales: extender/retraer patas, abrir/cerrar ventanas, desplegar/retraer pinzas de ataque (+8 a golpear, 2d6 contundente o agarrar CD 15), avanzar/retroceder, girar, encender focos de 9 m/18 m, subir/bajar 6 m en líquido, y abrir/cerrar la escotilla trasera.")

	# ── Armadura +1/+2/+3 (descripciones) ───────────────────
	_set_desc("armadura_1",
		"Tienes un bonificador a la Clase de Armadura mientras llevas esta armadura. El bonificador lo determina su rareza: +1 (Rara).")
	_set_desc("armadura_2",
		"Tienes un bonificador a la Clase de Armadura mientras llevas esta armadura. El bonificador lo determina su rareza: +2 (Muy Rara).")
	_set_desc("armadura_3",
		"Tienes un bonificador a la Clase de Armadura mientras llevas esta armadura. El bonificador lo determina su rareza: +3 (Legendaria).")

	# ── Malla Reluciente (Armor of Gleaming) ────────────────
	_set_desc("malla_reluciente",
		"Esta armadura nunca se ensucia.")

	# ── Armadura de Invulnerabilidad ─────────────────────────
	_set_desc("armadura_de_invulnerabilidad",
		"Tienes Resistencia al daño Contundente, Perforante y Cortante mientras llevas esta armadura.\n\nCoraza de Metal. Puedes realizar una Acción Mágica para obtener Inmunidad al daño Contundente, Perforante y Cortante durante 10 minutos o hasta que dejes de llevar la armadura. Una vez usada esta propiedad, no puede volver a usarse hasta el siguiente amanecer.")

	# ── Armadura de Resistencia ──────────────────────────────
	_set_desc("armadura_de_resistencia",
		"Tienes Resistencia a un tipo de daño mientras llevas esta armadura. El DJ elige el tipo o lo determina al azar: ácido, frío, fuego, fuerza, relámpago, necrótico, veneno, psíquico, radiante o trueno.")

	# ── Armadura de Vulnerabilidad (NUEVO) ───────────────────
	_m("armadura_de_vulnerabilidad", "Armadura de Vulnerabilidad", ItemData.Rarity.RARO, ItemData.ItemType.ARMOR,
		MagicItemData.Attunement.ANY,
		"Resistencia a Contundente, Perforante o Cortante; maldita: Vulnerabilidad a los otros dos",
		"Mientras llevas esta armadura, tienes Resistencia a uno de los siguientes tipos de daño: Contundente, Perforante o Cortante. El DJ elige el tipo o lo determina al azar.\n\nMaldición. Esta armadura está maldita, algo que solo se revela al lanzar el conjuro Identificar sobre ella o al sintonizarte con ella. Sintonizarte te maldice hasta que seas objetivo del conjuro Levantar Mídición o magia similar; quitarte la armadura no termina la maldición. Mientras estés maldito, tienes Vulnerabilidad a dos de los tres tipos de daño asociados con la armadura (no al que te otorga Resistencia).")

	# ── Escudo Atrapaflecha (NUEVO) ──────────────────────────
	_m("escudo_atrapa_flechas", "Escudo Atrapaflecha", ItemData.Rarity.RARO, ItemData.ItemType.SHIELD,
		MagicItemData.Attunement.ANY,
		"+2 CA vs ataques a distancia; reacción para interceptar ataques dirigidos a aliados adyacentes",
		"Obtienes un bonificador de +2 a la Clase de Armadura contra tiradas de ataque a distancia mientras empuñas este escudo. Este bonificador se suma al bonificador normal del escudo a la CA.\n\nSiempre que un atacante realice una tirada de ataque a distancia contra un objetivo a menos de 1,5 m de ti, puedes usar tu Reacción para convertirte en el objetivo del ataque.")

	# ── Hacha de los Señores Enanos (NUEVO) ──────────────────
	_m("hacha_senores_enanos", "Hacha de los Señores Enanos", ItemData.Rarity.LEGENDARIO, ItemData.ItemType.WEAPON,
		MagicItemData.Attunement.ANY,
		"+3 ataque/daño; 20 en d20 → +20 cortante; Lanzable (6m/18m), 1d8/2d8 fuerza extra vs gigantes; Convoca elemental de tierra 1/amanecer; +2 CON; Visión oscura 18m; Teletransporte subterráneo 1/3 días",
		"Un joven príncipe enano forjó esta arma como símbolo de unidad entre su pueblo. Adentrándose en lo más profundo de las montañas, con la ayuda de Moradin dios de la creación, primero creó cuatro grandes herramientas: el Pico de Estrella Metálica, la Fragua Corazón de la Tierra, el Yunque de los Cantos y el Martillo Modelador. Con ellas forjó el Hacha de los Señores Enanos.\n\nArma Mágica. El Hacha de los Señores Enanos es un arma mágica que otorga un bonificador de +3 a las tiradas de ataque y de daño. Cuando atacas con ella y sacas un 20 en el d20, el hacha inflige 20 daño Cortante adicional.\n\nEl hacha tiene la propiedad Arrojadiza con alcance normal de 6 m y largo de 18 m. Al impactar con un ataque a distancia inflige 1d8 daño de Fuerza adicional (o 2d8 si el objetivo es un gigante). Inmediatamente después de golpear o fallar, el arma vuela de vuelta a tu mano.\n\nBendiciones de Moradin. Mientras estés sintonizado: Visión Oscura 18 m (o +18 m si ya la tienes); Constitución +2 hasta 20; Competencia con herramientas de alquimia, albañilería y herrero; Inmunidad al daño de Veneno y Resistencia al daño de Fuego; los golpes al hacha contra objetos infligen el daño máximo posible.\n\nConvocar Elemental de Tierra. Mientras empuñas el hacha, puedes realizar una Acción Mágica para convocar un Elemental de Tierra en un espacio desocupado a menos de 9 m de ti. El elemental sigue tus órdenes y actúa justo después de ti en el orden de iniciativa. Desaparece tras 24 horas, al morir o al despedirlo con una Acción Adicional. No puedes usar esta propiedad de nuevo hasta el siguiente amanecer.\n\nViajar por las Profundidades. Puedes realizar una Acción Mágica tocando el hacha a un trozo de mampostería enana fija para lanzar Desplazamiento Planar desde el hacha. Si el destino está bajo tierra, no hay posibilidad de error ni de llegar a un lugar inesperado. No puedes usar esta propiedad de nuevo hasta que pasen 3 días.\n\nDestrucción. La única forma de destruir el hacha es fundirla en la Fragua Corazón de la Tierra donde fue creada. Debe permanecer en la fragua ardiente durante 50 años antes de sucumbir al fuego.")

# ============================================================
# DESCRIPCIONES COMPLETAS — LETRA B
# ============================================================

func _register_descriptions_B() -> void:
	# ── Escoba Bailarina de Baba Yaga (NUEVO) ────────────────
	_m("escoba_bailarina_baba_yaga", "Escoba Bailarina de Baba Yaga", ItemData.Rarity.INFRECUENTE, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.ANY,
		"Acción Mágica: se convierte en Escoba Animada bajo tu control; la comandas sin gastar acción",
		"La archehada Baba Yaga creó muchas de estas escobas mágicas. No hay dos exactamente iguales. Mientras empuñas la escoba, puedes realizar una Acción Mágica para transformarla en una Escoba Animada bajo tu control. La escoba se mueve entonces al espacio desocupado más cercano a ti. Actúa inmediatamente después de ti en el orden de iniciativa y permanece animada hasta que uses una Acción Adicional y pronuncies una palabra de mando para dejarla inanimada.\n\nEn tu turno, puedes comandar mentalmente la escoba animada si está a menos de 9 m de ti y no tienes la condición Incapacitado (no requiere acción). Decides qué acción realiza la escoba y a dónde se mueve en su siguiente turno, o le das una orden general.\n\nSi la escoba se reduce a 0 PG, se hace añicos y queda destruida. Si vuelve a su forma inanimada antes de perder todos sus PG, los recupera todos.")

	# ── Bolsa de Judías (NUEVO) ──────────────────────────────
	_m("bolsa_de_judias", "Bolsa de Judías", ItemData.Rarity.RARO, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.NONE,
		"Contiene 3d4 judías; plantar una produce efecto aleatorio; vaciar la bolsa → explosión 5d4 fuerza CD 15 DES",
		"Esta pesada bolsa de tela contiene 3d4 judías secas cuando se encuentra. La bolsa pesa 250 g independientemente de cuántas judías contenga.\n\nSi tiras una o más judías de la bolsa, explotan en una Esfera de 3 m centrada en ellas. Todas las judías volcadas son destruidas, y cada criatura en la Esfera debe superar una tirada de salvación de Destreza CD 15 o sufrir 5d4 daño de Fuerza (la mitad si tiene éxito).\n\nSi retiras una judía de la bolsa, la plantas en tierra o arena y la riegas, la judía desaparece al producir un efecto 1 minuto después. El DJ elige el efecto o lo determina al azar (1d100): 01 brotan 5d4 setas venenosas/nutritivas; 02-10 géiser de líquido 9 m de altura; 11-20 brota un Treant (alineamiento aleatorio); 21-30 estatua de piedra que difama al plantador; 31-40 hoguera de llamas verdes 24 h; 41-50 tres hongos chillones; 51-60 1d4+4 sapos rosados que se transforman en monstruos; 61-70 un Bulette hambriento emerge; 71-80 árbol frutal con 1d8 pociones aleatorias (desaparece en 1 h); 81-90 nido de huevos arcoíris (éxito CD 20 CON → +1 a puntuación más baja; fallo → 10d6 fuerza); 91-95 pirámide con no muerto y tesoro; 96-00 habichuela gigante hacia otro plano.")

	# ── Bolsa Devoradora (NUEVO) ─────────────────────────────
	_m("bolsa_devoradora", "Bolsa Devoradora", ItemData.Rarity.MUY_RARO, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.NONE,
		"Devora materia orgánica; 50% de engullir criaturas al meter la mano; tragarse un objeto al día al plano aleatorio",
		"Esta bolsa se asemeja a una Bolsa de Contención pero es una abertura alimentaria de una criatura extradimensional gigantesca. Dar la vuelta a la bolsa cierra la abertura.\n\nLa criatura extradimensional puede percibir todo lo que se mete en la bolsa. La materia animal o vegetal introducida completamente es devorada y se pierde para siempre. Cuando parte de una criatura viva entra en la bolsa (al meter la mano), hay un 50% de posibilidades de que la criatura sea arrastrada al interior. Una criatura dentro puede usar una acción para intentar escapar (Fuerza [Atletismo] CD 15). Otra criatura puede actuar para sacarla (Fuerza [Atletismo] CD 20). Cualquier criatura que empiece su turno dentro es devorada y su cuerpo destruido.\n\nLos objetos inanimados se pueden guardar (hasta 0,03 m³), pero una vez al día la bolsa traga todo su contenido y lo expulsa a otro plano. Si la bolsa es perforada o rasgada, queda destruida y todo lo que contiene es transportado al Plano Astral.")

	# ── Bolsa de Contención (Bag of Holding) — descripción ───
	_set_desc("bolsa_de_contencion",
		"Esta bolsa tiene un espacio interior considerablemente más grande que sus dimensiones exteriores: unos 60 cm cuadrados y 1,2 m de profundidad en el interior. Puede contener hasta 225 kg sin superar un volumen de 1,8 m³. Pesa 2,5 kg independientemente de su contenido. Recuperar un objeto requiere una Acción de Utilizar.\n\nSi la bolsa se sobrecarga, perfora o rasga, queda destruida y su contenido queda disperso en el Plano Astral. Si se da la vuelta, el contenido se derrama sin daños, pero hay que darle la vuelta antes de volver a usarla. Contiene aire suficiente para 10 minutos de respiración, dividido entre las criaturas que respiren dentro.\n\nIntroducir una Bolsa de Contención en un espacio extradimensional creado por una Mochila Práctica de Heward, un Agujero Portátil o similar destruye ambos objetos instantáneamente y abre una puerta al Plano Astral. Cualquier criatura en una Esfera de 3 m centrada en la puerta es absorbida a un lugar aleatorio del Plano Astral. La puerta se cierra y no puede reabrirse.")

	# ── Bolsa de Trucos — descripción ───────────────────────
	_set_desc("bolsa_de_trucos",
		"Esta bolsa de tela gris, óxido o canela parece vacía. Sin embargo, al meter la mano dentro se percibe la presencia de un pequeño objeto peludo.\n\nPuedes realizar una Acción Mágica para sacar el objeto peludo de la bolsa y lanzarlo hasta 6 m. Al aterrizar, se transforma en una criatura determinada tirando en la tabla correspondiente al color de la bolsa. La criatura desaparece al siguiente amanecer o cuando se reduce a 0 PG.\n\nLa criatura es Amistosa contigo y tus aliados, y actúa inmediatamente después de ti en el orden de iniciativa. Puedes usar una Acción Adicional para comandar cómo se mueve y qué acción realiza en su siguiente turno. Sin órdenes actúa según su naturaleza.\n\nUna vez sacados tres objetos peludos de la bolsa, no puede usarse de nuevo hasta el siguiente amanecer.\n\nBolsa Gris (1d8): 1-Comadreja, 2-Rata Gigante, 3-Tejón, 4-Jabalí, 5-Pantera, 6-Tejón Gigante, 7-Lobo Terrible, 8-Alce Gigante.\nBolsa Óxido: 1-Rata, 2-Lechuza, 3-Mastín, 4-Cabra, 5-Cabra Gigante, 6-Jabalí Gigante, 7-León, 8-Oso Pardo.\nBolsa Canela: 1-Chacal, 2-Simio, 3-Babuino, 4-Pico de Hacha, 5-Oso Negro, 6-Comadreja Gigante, 7-Hiena Gigante, 8-Tigre.")

	# ── Cuenta de Fuerza (Bead of Force) — descripción ───────
	_set_desc("cuentas_de_fuerza",
		"Esta pequeña esfera negra mide 2 cm de diámetro y pesa 30 g. Normalmente se encuentran 1d4+4 juntas.\n\nPuedes realizar una Acción Mágica para lanzar la cuenta hasta 18 m. La cuenta explota al impactar en una Esfera de 3 m y queda destruida. Cada criatura en la Esfera debe superar una tirada de salvación de Destreza CD 15 o sufrir 5d4 daño de Fuerza. Después, una esfera de fuerza transparente encierra el área durante 1 minuto. Cualquier criatura que falle la salvación y esté completamente dentro queda atrapada. Las que tengan éxito o estén parcialmente dentro son empujadas hacia fuera.\n\nSolo puede pasar aire respirable a través de la pared de la esfera. Una criatura encerrada puede usar la Acción de Utilizar para empujar la pared, moviendo la esfera hasta la mitad de su Velocidad. Pesa solo 500 g mágicamente, independientemente del peso de las criaturas dentro.")

	# ── Cuenta de Sustento (NUEVO) ───────────────────────────
	_m("cuenta_de_sustento", "Cuenta de Sustento", ItemData.Rarity.COMUN, ItemData.ItemType.CONSUMABLE,
		MagicItemData.Attunement.NONE,
		"Se disuelve en la lengua y proporciona el sustento de 1 día de raciones",
		"Esta cuenta gelatinosa sin sabor se disuelve en tu lengua y proporciona tanto sustento como 1 día de Raciones.")

	# ── Cuenta de Refresco (NUEVO) ───────────────────────────
	_m("cuenta_de_refresco", "Cuenta de Refresco", ItemData.Rarity.COMUN, ItemData.ItemType.CONSUMABLE,
		MagicItemData.Attunement.NONE,
		"Se disuelve en un líquido y lo convierte en agua fresca potable (no funciona en líquidos mágicos o venenos)",
		"Esta cuenta gelatinosa sin sabor se disuelve en un líquido, transformando hasta medio litro en agua potable fría y fresca. La cuenta no tiene efecto sobre líquidos mágicos ni sobre sustancias dañinas como venenos.")

	# ── Cinturón del Pueblo Enano (NUEVO) ────────────────────
	_m("cinturon_del_pueblo_enano", "Cinturón del Pueblo Enano", ItemData.Rarity.RARO, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.ANY,
		"+2 CON (máx. 20); idioma enano; ventaja en Persuasión con enanos; visión oscura 18m y resistencia a veneno si no eres enano",
		"Mientras llevas este cinturón, obtienes los siguientes beneficios:\n\nEnano. Conoces el idioma enano.\nAmigo del Pueblo Enano. Tienes Ventaja en las pruebas de Carisma (Persuasión) para interactuar con enanos y duergar.\nFortaleza. Tu Constitución aumenta en 2, hasta un máximo de 20.\n\nAdemás, mientras estés sintonizado con el cinturón, tienes un 50% de posibilidades cada amanecer de que te crezca una barba completa si puedes hacerlo, o una barba más espesa si ya tienes una.\n\nSi no eres enano ni duergar, obtienes estos beneficios adicionales mientras llevas el cinturón:\nVisión Oscura. Tienes Visión Oscura con un alcance de 18 m.\nResiliencia. Tienes Resistencia al daño de Veneno. También tienes Ventaja en las tiradas de salvación para evitar o terminar la condición Envenenado.")

	# ── Cinturones de Fuerza de Gigante — descripciones ──────
	_set_desc("cinturon_de_fuerza_de_gigante_colina",
		"Mientras llevas este cinturón, tu Fuerza cambia a la puntuación que otorga el cinturón (21). El objeto no tiene efecto si tu Fuerza ya es igual o superior a esa puntuación sin el cinturón.")
	_set_desc("cinturon_de_fuerza_de_gigante_escarcha",
		"Mientras llevas este cinturón, tu Fuerza cambia a la puntuación que otorga el cinturón (23). El objeto no tiene efecto si tu Fuerza ya es igual o superior a esa puntuación sin el cinturón.")
	_set_desc("cinturon_de_fuerza_de_gigante_fuego",
		"Mientras llevas este cinturón, tu Fuerza cambia a la puntuación que otorga el cinturón (25). El objeto no tiene efecto si tu Fuerza ya es igual o superior a esa puntuación sin el cinturón.")
	_set_desc("cinturon_de_fuerza_de_gigante_nube",
		"Mientras llevas este cinturón, tu Fuerza cambia a la puntuación que otorga el cinturón (27). El objeto no tiene efecto si tu Fuerza ya es igual o superior a esa puntuación sin el cinturón.")
	_set_desc("cinturon_de_fuerza_de_gigante_tormenta",
		"Mientras llevas este cinturón, tu Fuerza cambia a la puntuación que otorga el cinturón (29). El objeto no tiene efecto si tu Fuerza ya es igual o superior a esa puntuación sin el cinturón.")

	# ── Hacha del Berserker (NUEVO) ──────────────────────────
	_m("hacha_del_berserker", "Hacha del Berserker", ItemData.Rarity.RARO, ItemData.ItemType.WEAPON,
		MagicItemData.Attunement.ANY,
		"+1 ataque/daño; +1 PG máx. por nivel; maldita: desventaja con otras armas, furia involuntaria al recibir daño",
		"Obtienes un bonificador de +1 a las tiradas de ataque y de daño realizadas con esta arma mágica. Además, mientras estés sintonizado, tu máximo de PG aumenta en 1 por cada nivel que hayas alcanzado.\n\nMaldición. Esta arma está maldita y sintonizarte con ella extiende la maldición sobre ti. Mientras estés maldito, eres reacio a separarte del arma y la mantienes al alcance en todo momento. Además, tienes Desventaja en las tiradas de ataque con armas que no sean esta.\n\nSiempre que otra criatura te dañe mientras tienes el arma en posesión, debes superar una tirada de salvación de Sabiduría CD 15 o entrar en frenesí. El frenesí termina cuando empiezas tu turno y no hay criaturas a menos de 18 m de ti que puedas ver u oír.\n\nMientras estás en frenesí, la criatura más cercana que puedas ver u oír es tu enemigo. En cada uno de tus turnos, debes moverte lo más cerca posible de esa criatura y realizar la acción de Atacar contra ella. Si la criatura muere o ya no puedes verla ni oírla, la siguiente criatura más cercana se convierte en tu nuevo objetivo.")

	# ── Oscuranave / Blackrazor (NUEVO) ──────────────────────
	_m("oscuranave", "Oscuranave", ItemData.Rarity.LEGENDARIO, ItemData.ItemType.WEAPON,
		MagicItemData.Attunement.ANY,
		"+3 ataque/daño; devora almas (mata definitivamente salvo Deseo); PG temp. = PG máx. de la víctima; Lanzar Celeridad 1/amanecer (sin concentración); Ceguera 9m; sentiente",
		"Escondida en la mazmorra del Monte Pluma Blanca, Oscuranave brilla como un fragmento de cielo nocturno repleto de estrellas. Su vaina negra está decorada con piezas de obsidiana tallada.\n\nObtienes un bonificador de +3 a las tiradas de ataque y de daño. Si golpeas a un No Muerto con esta arma, sufres 1d10 daño Necrótico y el objetivo recupera 1d10 PG. Si este daño te reduce a 0 PG, Oscuranave devora tu alma.\n\nMientras empuñas esta arma, tienes Inmunidad a las condiciones Encantado y Asustado, y tienes Visión Ciega con un alcance de 9 m.\n\nDevorar Almas. Siempre que uses Oscuranave para reducir una criatura a 0 PG, la espada mata a la criatura y devora su alma a menos que sea un Constructo o un No Muerto. Una criatura cuya alma ha sido devorada solo puede ser restaurada a la vida mediante el conjuro Deseo.\n\nCuando Oscuranave devora un alma que no es la tuya, ganas PG temporales iguales al máximo de PG de la criatura abatida.\n\nCeleridad. Oscuranave puede lanzar Celeridad sobre ti, tras lo cual no puede lanzar este conjuro de nuevo hasta el siguiente amanecer. Oscuranave decide cuándo lanzarlo; el conjuro dura 1 minuto (sin Concentración) o hasta que Oscuranave decida terminarlo.\n\nSentiencia. Oscuranave es un arma sentiente Caótica Neutral con Inteligencia 17, Sabiduría 10 y Carisma 19. Habla en Común y se comunica telepáticamente. Su voz es profunda y resonante. Cree que toda la materia y energía surgieron de un vacío de energía negativa y volverán a él, y busca acelerar ese proceso devorando almas sin importar de quién sean.\n\nDestrucción. Oscuranave puede ser destruida aplastándola en los grandes engranajes de Mechanus.")

	# ── Libro de Gestas Exaltadas (NUEVO) ────────────────────
	_m("libro_de_gestas_exaltadas", "Libro de Gestas Exaltadas", ItemData.Rarity.LEGENDARIO, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.ANY,
		"80h de lectura: SAB +2, ranura de conjuro +1 nv, aureola, inmunidad Encantado/Asustado; infernales/no muertos lo leen → 24d6 radiante",
		"Este tratado definitivo sobre el bien en el multiverso figura prominentemente en muchas religiones. Tras 80 horas de lectura y estudio, el lector obtiene los siguientes beneficios permanentes mientras se esfuerce en hacer el bien:\n\nCalma Celestial. Inmunidad a las condiciones Encantado y Asustado, y Resistencia al daño Psíquico. Estos beneficios son permanentes tras el estudio.\nSabiduría Divina. Sabiduría +2 hasta máximo 24 (solo una vez).\nMagia Iluminada. Cada espacio de conjuro que gastes cuenta como si fuera de un nivel superior.\nAureola. Emites Luz Brillante en un radio de 3 m y Luz Tenue otros 3 m. Puedes suprimirla o manifestarla como Acción Adicional. Tienes Ventaja en pruebas de Carisma (Persuasión) mientras brilla. Los infernales y no muertos iluminados por ella atacan con Desventaja contra ti.\n\nSi un Infernal, un No Muerto o un servidor de un dios de los Planos Inferiores intenta leer el libro, recibe 24d6 daño Radiante (ignora Resistencia e Inmunidad). Si muere así, desaparece en un destello y es destruido.\n\nDestrucción. El libro no puede destruirse. Sin embargo, sumergirlo en el Río Estigia borra todo su contenido y lo deja sin poderes durante 1d100 años.")

	# ── Libro de la Maldad Abismal (NUEVO) ───────────────────
	_m("libro_de_la_maldad_abismal", "Libro de la Maldad Abismal", ItemData.Rarity.LEGENDARIO, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.ANY,
		"80h de lectura: +2 a característica elegida, inmunidad Agotamiento, conjuros CD 18 (Animar Muertos, Círculo de Muerte, Dominar Monstruo, Dedo de la Muerte); Ventaja en lore maligno",
		"Se cree que el lich-dios Vecna redactó este fétido manuscrito, registrando en sus páginas cada idea horrible y cada ejemplo de magia corrupta que encontró o ideó.\n\nSiempre que una criatura que no sea un Infernal ni un No Muerto se sintoniza con el libro, debe superar una salvación de Carisma CD 17 o ser transformada en una Larva bajo el control del DJ (solo Deseo puede revertirlo).\n\nTras 80 horas de estudio:\nPuntuaciones Ajustadas. Una puntuación de característica a tu elección aumenta en 2 (máx. 24); otra disminuye en 2 (mín. 3). No puede ajustarte de nuevo.\nForma Incansable. Inmunidad a la condición Agotamiento mientras el libro esté en tu persona.\nConjuros (CD 18): Animar Muertos, Círculo de Muerte, Dominar Monstruo, Dedo de la Muerte (cada uno 1/amanecer).\nSaber Vil. Ventaja en pruebas de Inteligencia para recordar información sobre el mal. Puede revelar secretos como nombres verdaderos de demonios o rituales prohibidos.\nDiscurso Vil. Acción Mágica: recitas palabras de un lenguaje muerto y corrompido. Sufres 1d12 daño Psíquico; cada criatura no infernal ni no muerta a menos de 4,5 m de ti sufre 3d6 daño Psíquico.\n\nDestrucción. Si un Solar rompe el libro en dos, queda destruido por 1d100 años. Una criatura sintonizada 100 años puede descubrir una frase que, traducida al Celestial y pronunciada en voz alta, destruye tanto al hablante como al libro en un destello de luz.")

	# ── Botas de Elfo — descripción ──────────────────────────
	_set_desc("botas_de_elfo",
		"Mientras llevas estas botas, tus pasos no producen sonido, independientemente de la superficie por la que te muevas. Además, tienes Ventaja en las pruebas de Destreza (Sigilo).")

	# ── Botas de Rastros Falsos (NUEVO) ──────────────────────
	_m("botas_de_rastros_falsos", "Botas de Rastros Falsos", ItemData.Rarity.COMUN, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.ANY,
		"Pueden dejar huellas de cualquier tipo de Humanoide de tu tamaño",
		"Mientras llevas estas botas, puedes hacer que dejen huellas como las de cualquier tipo de Humanoide de tu tamaño.")

	# ── Botas de Levitación — descripción ────────────────────
	_set_desc("botas_de_levitacion",
		"Mientras llevas estas botas, puedes lanzar Levitar sobre ti mismo.")

	# ── Botas de la Velocidad — descripción ──────────────────
	_set_desc("botas_de_la_velocidad",
		"Mientras llevas estas botas, puedes usar una Acción Adicional para hacer chasquear los tacones. Si lo haces, las botas duplican tu Velocidad y cualquier criatura que realice un Ataque de Oportunidad contra ti tiene Desventaja en la tirada de ataque. Si vuelves a chasquear los tacones, el efecto termina.\n\nCuando hayas usado la propiedad de las botas durante un total de 10 minutos, la magia deja de funcionar para ti hasta que termines un Descanso Largo.")

	# ── Botas de Zancada y Salto — descripción ───────────────
	_set_desc("botas_de_zancada_y_salto",
		"Mientras llevas estas botas, tu Velocidad se convierte en 9 m a menos que ya sea superior, y tu Velocidad no se reduce por llevar peso que supere tu capacidad de carga ni por llevar Armadura Pesada.\n\nUna vez en cada uno de tus turnos, puedes saltar hasta 9 m gastando solo 3 m de movimiento.")

	# ── Botas de las Tierras Invernales (NUEVO) ──────────────
	_m("botas_de_las_tierras_invernales", "Botas de las Tierras Invernales", ItemData.Rarity.INFRECUENTE, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.ANY,
		"Resistencia al frío; ignoras terreno difícil de hielo/nieve; toleras temperaturas de -18°C o inferiores",
		"Estas botas de piel son cómodas y se sienten cálidas. Mientras las llevas, obtienes los siguientes beneficios:\n\nResistencia al Frío. Tienes Resistencia al daño de Frío y puedes tolerar temperaturas de -18°C o inferiores sin protección adicional.\nZancada Invernal. Ignoras el Terreno Difícil creado por hielo o nieve.")

	# ── Cuenco de Mando de Elementales de Agua (NUEVO) ───────
	_m("cuenco_de_elementales_acuaticos", "Cuenco de Mando de Elementales de Agua", ItemData.Rarity.RARO, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.NONE,
		"Acción Mágica (estando a 1,5m con agua dentro): convoca Elemental de Agua durante 1h; 1/amanecer",
		"Mientras este cuenco está lleno de agua y te encuentras a menos de 1,5 m de él, puedes realizar una Acción Mágica para convocar un Elemental de Agua. El elemental aparece en el espacio desocupado más cercano al cuenco, entiende tus idiomas, obedece tus órdenes y actúa inmediatamente después de ti en el orden de iniciativa. El elemental desaparece tras 1 hora, cuando muere o cuando lo despides con una Acción Adicional. El cuenco no puede usarse de esta manera de nuevo hasta el siguiente amanecer.\n\nEl cuenco mide unos 30 cm de diámetro y la mitad de profundidad. Contiene unos 11 litros.")

	# ── Brazales de Arquería — descripción ───────────────────
	_set_desc("brazales_de_arqueria",
		"Mientras llevas estos brazales, tienes competencia con el Arco Largo y el Arco Corto, y obtienes un bonificador de +2 a las tiradas de daño realizadas con esas armas.")

	# ── Brazales de Defensa — descripción ────────────────────
	_set_desc("brazales_de_defensa",
		"Mientras llevas estos brazales, obtienes un bonificador de +2 a la Clase de Armadura si no llevas armadura ni escudo.")

	# ── Brasero de Mando de Elementales de Fuego (NUEVO) ─────
	_m("brasero_de_elementales_de_fuego", "Brasero de Mando de Elementales de Fuego", ItemData.Rarity.RARO, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.NONE,
		"Acción Mágica (a 1,5m del brasero): convoca Elemental de Fuego durante 1h; 1/amanecer",
		"Mientras te encuentres a menos de 1,5 m de este brasero, puedes realizar una Acción Mágica para convocar un Elemental de Fuego. El elemental aparece en el espacio desocupado más cercano al brasero, entiende tus idiomas, obedece tus órdenes y actúa inmediatamente después de ti en el orden de iniciativa. El elemental desaparece tras 1 hora, cuando muere o cuando lo despides con una Acción Adicional. El brasero no puede usarse de esta manera de nuevo hasta el siguiente amanecer.")

	# ── Broche de Protección (NUEVO) ─────────────────────────
	_m("broche_de_proteccion", "Broche de Protección", ItemData.Rarity.INFRECUENTE, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.ANY,
		"Resistencia al daño de Fuerza; inmunidad al daño de Proyectil Mágico",
		"Mientras llevas este broche, tienes Resistencia al daño de Fuerza e Inmunidad al daño del conjuro Proyectil Mágico.")

	# ── Escoba Voladora (NUEVO) ───────────────────────────────
	_m("escoba_voladora", "Escoba Voladora", ItemData.Rarity.INFRECUENTE, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.ANY,
		"Velocidad de vuelo 15m (9m con más de 90 kg); puede volar sola hasta 1,5 km con una orden",
		"Esta escoba de madera funciona como una escoba mundana hasta que te montas sobre ella y realizas una Acción Mágica para que flote bajo ti, momento en el que puedes montarla en el aire. Tiene una Velocidad de Vuelo de 15 m. Puede transportar hasta 180 kg, pero su Velocidad de Vuelo se reduce a 9 m mientras transporta más de 90 kg. La escoba deja de flotar cuando aterrizas o cuando dejas de montarla.\n\nCon una Acción Mágica, puedes enviar la escoba sola a un destino a menos de 1,5 km de ti si nombras el lugar y lo conoces. La escoba regresa a ti cuando realizas una Acción Mágica y pronuncias una palabra de mando, siempre que siga estando a menos de 1,5 km.")

# ============================================================
# DESCRIPCIONES COMPLETAS — LETRA C
# ============================================================

func _register_descriptions_C() -> void:
	# ── Vela de Invocación (NUEVO) ───────────────────────────
	_m("vela_de_invocacion", "Vela de Invocación", ItemData.Rarity.MUY_RARO, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.ANY,
		"Mientras arde: ventaja en pruebas D20; clérigos/druidas lanzan conjuros nv1 sin gastar espacio; o lanzar Portal (destruye la vela)",
		"La magia de esta vela se activa cuando se enciende, lo que requiere una Acción Mágica. Tras arder 4 horas, la vela queda destruida. Puedes apagarla antes para usarla más tarde; deduce el tiempo en incrementos de 1 minuto de su tiempo total de combustión.\n\nMientras esté encendida, la vela emite Luz Tenue en un radio de 9 m. Mientras estés en esa luz, tienes Ventaja en las pruebas D20. Además, un Clérigo o Druida en la luz puede lanzar conjuros de nivel 1 que tenga preparados sin gastar espacios de conjuro.\n\nAlternativamente, cuando enciendas la vela por primera vez, puedes lanzar Portal con ella. Hacerlo destruye la vela. El portal creado enlaza con un Plano Exterior elegido por el DJ o determinado al azar (1d100): 01–05 el Abismo, 06–10 Acherón, 11–17 Arbórea, 18–25 Arcadia, 26–33 Tierras Bestiales, 34–41 Bytopia, 42–46 Carceri, 47–54 Elíseo, 55–59 Gehena, 60–64 Hades, 65–69 Limbo, 70–77 Mechanus, 78–85 Monte Celestia, 86–90 los Nueve Infiernos, 91–95 Pandemonium, 96–00 Ysgard.")

	# ── Vela de las Profundidades (NUEVO) ────────────────────
	_m("vela_de_las_profundidades", "Vela de las Profundidades", ItemData.Rarity.COMUN, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.NONE,
		"La llama no se apaga bajo el agua; da luz y calor como una vela normal",
		"La llama de esta vela no se apaga cuando se sumerge en agua. Emite luz y calor como una vela normal.")

	# ── Capa del Charlatán (NUEVO) ───────────────────────────
	_m("capa_del_charlatan", "Capa del Charlatán", ItemData.Rarity.RARO, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.NONE,
		"Acción Mágica: lanzar Puerta Dimensional 1/amanecer; dejas humo en el espacio que abandonas",
		"Esta capa huele levemente a azufre. Mientras la llevas, puedes usarla para lanzar Puerta Dimensional como Acción Mágica. Esta propiedad no puede usarse de nuevo hasta el siguiente amanecer.\n\nCuando te teletransportas con ese conjuro, dejas atrás una nube de humo. El espacio que abandonaste queda Ligeramente Oscurecido por ese humo hasta el final de tu siguiente turno.")

	# ── Gorro de Respiración Acuática (NUEVO) ────────────────
	_m("gorro_de_respiracion_acuatica", "Gorro de Respiración Acuática", ItemData.Rarity.INFRECUENTE, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.NONE,
		"Acción Mágica bajo el agua: crea burbuja de aire a tu alrededor para respirar normalmente",
		"Mientras llevas este gorro bajo el agua, puedes realizar una Acción Mágica para crear una burbuja de aire alrededor de tu cabeza. Esta burbuja te permite respirar con normalidad bajo el agua. La burbuja permanece contigo hasta que te quites el gorro o ya no estés bajo el agua.")

	# ── Alfombra Voladora — descripción ──────────────────────
	_set_desc("alfombra_voladora",
		"Puedes hacer que esta alfombra levite y vuele realizando una Acción Mágica y usando la palabra de mando de la alfombra. Se mueve según tus instrucciones si estás a menos de 9 m de ella.\n\nExisten cuatro tamaños de Alfombra Voladora. El DJ elige el tamaño o lo determina al azar:\n01–20 (0,9 m × 1,5 m): capacidad 90 kg, velocidad de vuelo 24 m\n21–55 (1,2 m × 1,8 m): capacidad 180 kg, velocidad de vuelo 18 m\n56–80 (1,5 m × 2,1 m): capacidad 270 kg, velocidad de vuelo 12 m\n81–00 (1,8 m × 2,7 m): capacidad 360 kg, velocidad de vuelo 9 m\n\nUna alfombra puede transportar hasta el doble del peso indicado, pero su velocidad se reduce a la mitad si lleva más de su capacidad normal.")

	# ── Armadura Abandonada — descripción ───────────────────
	_set_desc("armadura_abandonada",
		"Puedes quitarte esta armadura como Acción Mágica.")

	# ── Armadura Humeante — descripción ─────────────────────
	_set_desc("armadura_humeante",
		"Se elevan volutas de humo inofensivo e inodoro de esta armadura mientras se lleva puesta.")

	# ── Caldero de Renacimiento (NUEVO) ─────────────────────
	_m("caldero_de_renacimiento", "Caldero de Renacimiento", ItemData.Rarity.MUY_RARO, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.SPECIFIC,
		"Foco de conjuros; elabora Poción de Curación Mayor 1/descanso largo; resucita cadáver Humanoide con 90 kg de sal en 8h (1/7 días)",
		"Este pequeño caldero tiene escenas en relieve de héroes en sus lados de hierro fundido. Puedes usarlo como Foco de Conjuros para tus conjuros, y funciona como componente para el conjuro Escrutinio.\n\nElaborar Poción. Al terminar un Descanso Largo, puedes usar el caldero para crear una Poción de Curación (mayor), lo que lleva 1 minuto. La poción dura 24 horas y luego pierde su magia si no se consume.\n\nResucitar Muerto. Como Acción Mágica, puedes hacer que el caldero crezca lo suficiente para que una criatura Mediana pueda agacharse dentro. Puedes hacer que el caldero vuelva a su tamaño normal con una Acción Mágica, desplazando sin daño a lo que no quepa al espacio desocupado más cercano.\n\nSi colocas el cadáver de un Humanoide en el caldero y lo cubres con 90 kg de sal (10 monedas de oro) durante al menos 8 horas, la sal se consume y la criatura vuelve a la vida como con Resucitar Muerto al siguiente amanecer. Una vez usada esta propiedad, no puede volver a usarse en 7 días.")

	# ── Incensario de Mando de Elementales de Aire (NUEVO) ──
	_m("incensario_de_elementales_de_aire", "Incensario de Mando de Elementales de Aire", ItemData.Rarity.RARO, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.NONE,
		"Acción Mágica (balanceando): convoca Elemental de Aire durante 1h; 1/amanecer",
		"Mientras balanceas suavemente este incensario, puedes realizar una Acción Mágica para convocar un Elemental de Aire. El elemental aparece en el espacio desocupado más cercano al incensario, entiende tus idiomas, obedece tus órdenes y actúa inmediatamente después de ti en el orden de iniciativa. El elemental desaparece tras 1 hora, cuando muere o cuando lo despides con una Acción Adicional. El incensario no puede usarse de esta manera de nuevo hasta el siguiente amanecer.")

	# ── Dado del Charlatán (NUEVO) ───────────────────────────
	_m("dado_del_charlatan", "Dado del Charlatán", ItemData.Rarity.COMUN, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.ANY,
		"Cuando lo lanzas, puedes controlar qué número sale",
		"Siempre que lances este dado de seis caras, puedes controlar qué número muestra.")

	# ── Carillón de Apertura (NUEVO) ─────────────────────────
	_m("carillon_de_apertura", "Carillón de Apertura", ItemData.Rarity.RARO, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.NONE,
		"Acción Mágica: golpear el carillón lanza Abrir cerraduras (tono audible a 90m); 10 usos",
		"Este tubo metálico hueco mide unos 30 cm de largo y pesa 0,5 kg. Como Acción Mágica, puedes golpear el carillón para lanzar Abrir cerraduras. El sonido de golpeteo habitual del conjuro es reemplazado por el tono claro y resonante del carillón, audible hasta a 90 m.\n\nEl carillón puede usarse 10 veces. Tras el décimo uso, se agrieta y queda inútil.")

	# ── Círculo de Destellos (NUEVO) ─────────────────────────
	_m("circulo_de_destellos", "Círculo de Destellos", ItemData.Rarity.INFRECUENTE, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.NONE,
		"Mientras lo llevas: lanzar Rayo Abrasador (+5 a golpear) 1/amanecer",
		"Mientras llevas este círculo, puedes lanzar Rayo Abrasador con él (+5 a golpear). El círculo no puede lanzar este conjuro de nuevo hasta el siguiente amanecer.")

	# ── Capa de Araña (NUEVO) ────────────────────────────────
	_m("capa_de_arana", "Capa de Araña", ItemData.Rarity.MUY_RARO, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.ANY,
		"Resistencia veneno; velocidad de escalar = velocidad; inmune a telarañas; lanzar Telaraña área doble 1/amanecer",
		"Esta fina prenda está hecha de seda negra entretejida con tenues hilos plateados. Mientras la llevas, obtienes los siguientes beneficios.\n\nResistencia al Veneno. Tienes Resistencia al daño de Veneno.\nEscalar Arañas. Tienes una Velocidad de Escalar igual a tu Velocidad y puedes moverte hacia arriba, hacia abajo y por superficies verticales y a lo largo de techos, dejando las manos libres.\nAndar por Telarañas. No puedes quedar atrapado en telarañas de ningún tipo y puedes moverte a través de ellas como si fueran Terreno Difícil.\nTelaraña. Puedes lanzar Telaraña (CD de salvación 13). La telaraña creada por el conjuro ocupa el doble de su área normal. Una vez usada esta propiedad, no puede usarse de nuevo hasta el siguiente amanecer.")

	# ── Capa Ondeante (NUEVO) ────────────────────────────────
	_m("capa_ondeante", "Capa Ondeante", ItemData.Rarity.COMUN, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.NONE,
		"Acción Adicional: la capa ondea dramáticamente durante 1 minuto",
		"Mientras llevas esta capa, puedes realizar una Acción Adicional para que ondee dramáticamente durante 1 minuto.")

	# ── Capa de Desplazamiento — descripción ────────────────
	_set_desc("capa_de_desplazamiento",
		"Mientras llevas esta capa, proyecta mágicamente una ilusión que te hace parecer estar de pie en un lugar cercano a tu ubicación real, lo que provoca que cualquier criatura tenga Desventaja en las tiradas de ataque contra ti. Si recibes daño, la propiedad deja de funcionar hasta el inicio de tu siguiente turno. Esta propiedad se suprime mientras tu Velocidad es 0.")

	# ── Capa de Elfo — descripción ───────────────────────────
	_set_desc("capa_de_elfo",
		"Mientras llevas esta capa, las pruebas de Sabiduría (Percepción) realizadas para perciberte tienen Desventaja, y tú tienes Ventaja en las pruebas de Destreza (Sigilo).")

	# ── Capa de Invisibilidad — descripción ─────────────────
	_set_desc("capa_de_invisibilidad",
		"Esta capa tiene 3 cargas y recupera 1d3 cargas gastadas diariamente al amanecer. Mientras llevas la capa, puedes realizar una Acción Mágica para ponerte la capucha y gastar 1 carga para obtener la condición Invisible durante 1 hora. El efecto termina antes si te bajas la capucha (no se requiere acción) o dejas de llevar la capa.")

	# ── Capa de Muchas Modas (NUEVO) ─────────────────────────
	_m("capa_de_muchas_modas", "Capa de Muchas Modas", ItemData.Rarity.COMUN, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.NONE,
		"Acción Adicional: cambia el estilo, color y apariencia de la capa",
		"Mientras llevas esta capa, puedes realizar una Acción Adicional para cambiar el estilo, el color y la calidad aparente de la prenda. El peso de la capa no cambia. Independientemente de su apariencia, la capa no puede ser otra cosa que una capa. Aunque puede duplicar la apariencia de otras capas mágicas, no obtiene sus propiedades mágicas.")

	# ── Capa de Protección — descripción ────────────────────
	_set_desc("capa_de_proteccion",
		"Obtienes un bonificador de +1 a la Clase de Armadura y a las tiradas de salvación mientras llevas esta capa.")

	# ── Capa del Murciélago (NUEVO) ──────────────────────────
	_m("capa_del_murcielago", "Capa del Murciélago", ItemData.Rarity.RARO, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.ANY,
		"Ventaja en Sigilo; en penumbra/oscuridad velocidad vuelo 12m; Polimorfar en murciélago 1/amanecer",
		"Mientras llevas esta capa, tienes Ventaja en las pruebas de Destreza (Sigilo). En un área de Luz Tenue u Oscuridad, puedes sujetar los bordes de la capa para obtener una Velocidad de Vuelo de 12 m. Si en algún momento dejas de sujetar los bordes mientras vuelas de esta manera, o si ya no estás en Luz Tenue u Oscuridad, pierdes esta Velocidad de Vuelo.\n\nMientras llevas la capa en un área de Luz Tenue u Oscuridad, puedes lanzar Polimorfar sobre ti mismo transformándote en un Murciélago. En esa forma conservas tus puntuaciones de Inteligencia, Sabiduría y Carisma. La capa no puede usarse de esta manera de nuevo hasta el siguiente amanecer.")

	# ── Capa de la Raya Manta (NUEVO) ────────────────────────
	_m("capa_de_la_raya_manta", "Capa de la Raya Manta", ItemData.Rarity.INFRECUENTE, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.ANY,
		"Puedes respirar bajo el agua; velocidad de natación 18m",
		"Mientras llevas esta capa, puedes respirar bajo el agua y tienes una Velocidad de Natación de 18 m.")

	# ── Amuleto de Relojería (NUEVO) ─────────────────────────
	_m("amuleto_de_relojeria", "Amuleto de Relojería", ItemData.Rarity.COMUN, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.NONE,
		"1/amanecer: al atacar, en lugar de tirar el d20 obtén un 10",
		"Este amuleto de cobre contiene pequeños engranajes entrelazados y está alimentado por magia de Mechanus. Cuando realizas una tirada de ataque mientras llevas el amuleto, puedes renunciar a tirar el d20 para obtener un 10 en el dado. Una vez usada esta propiedad, no puede volver a usarse hasta el siguiente amanecer.")

	# ── Ropa de Reparación (NUEVO) ───────────────────────────
	_m("ropa_de_reparacion", "Ropa de Reparación", ItemData.Rarity.COMUN, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.NONE,
		"El conjunto se repara mágicamente del desgaste diario; las piezas destruidas no se reparan",
		"Este elegante conjunto se repara mágicamente para contrarrestar el desgaste diario. Las piezas del conjunto que sean destruidas no pueden repararse de esta manera.")

	# ── Cristal de Bola — descripción ────────────────────────
	_set_desc("cristal_de_bola",
		"Mientras tocas este orbe de cristal, puedes lanzar Escrutinio (CD de salvación 17) con él.")

	# ── Cristal de Bola de Lectura Mental (NUEVO) ────────────
	_m("cristal_de_bola_lectura_mental", "Cristal de Bola de Lectura Mental", ItemData.Rarity.LEGENDARIO, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.ANY,
		"Lanzar Escrutinio CD 17; además Detectar Pensamientos CD 17 en criaturas visibles en el sensor",
		"Mientras tocas este orbe de cristal, puedes lanzar Escrutinio (CD de salvación 17) con él. Además, puedes lanzar Detectar Pensamientos (CD de salvación 17) eligiendo como objetivo criaturas que puedas ver a menos de 9 m del sensor del conjuro. No necesitas Concentración en este Detectar Pensamientos para mantenerlo durante su duración, pero termina si el conjuro Escrutinio termina.")

	# ── Cristal de Bola de Telepatía (NUEVO) ─────────────────
	_m("cristal_de_bola_telepatia", "Cristal de Bola de Telepatía", ItemData.Rarity.LEGENDARIO, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.ANY,
		"Escrutinio CD 17; comunicación telepática con criaturas en el sensor; Sugestión CD 17 1/amanecer",
		"Mientras tocas este orbe de cristal, puedes lanzar Escrutinio (CD de salvación 17) con él. Además, puedes comunicarte telepáticamente con criaturas que puedas ver a menos de 9 m del sensor del conjuro. También puedes lanzar Sugestión (CD de salvación 17) a través del sensor sobre una de esas criaturas. No necesitas Concentración para mantener la Sugestión, pero termina si el Escrutinio termina. No puedes lanzar Sugestión de esta manera de nuevo hasta el siguiente amanecer.")

	# ── Cristal de Bola de Visión Verdadera (NUEVO) ──────────
	_m("cristal_de_bola_vision_verdadera", "Cristal de Bola de Visión Verdadera", ItemData.Rarity.LEGENDARIO, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.ANY,
		"Escrutinio CD 17; Visión Verdadera 36m centrada en el sensor",
		"Mientras tocas este orbe de cristal, puedes lanzar Escrutinio (CD de salvación 17) con él. Además, tienes Visión Verdadera con un alcance de 36 m centrada en el sensor del conjuro.")

	# ── Cubo de Fuerza — descripción ─────────────────────────
	_set_desc("cubo_de_fuerza",
		"Este cubo mide unos 2,5 cm. Cada cara tiene una marca distinta. Puedes presionar una de esas caras, gastar las cargas requeridas y así lanzar el conjuro asociado (CD 17), tal como se muestra en la tabla de Caras del Cubo de Fuerza.\n\nEl cubo comienza con 10 cargas y recupera 1d6 cargas gastadas diariamente al amanecer.\n\nConjuros (coste en cargas): Armadura de Mago (1), Escudo (1), Cabaña Minúscula de Leomund (3), Santuario Privado de Mordenkainen (4), Esfera Resistente de Otiluke (4), Muro de Fuerza (5).")

	# ── Cubo de Convocación (NUEVO) ──────────────────────────
	_m("cubo_de_convocacion", "Cubo de Convocación", ItemData.Rarity.RARO, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.NONE,
		"Acción Mágica: girar la manivela invoca criatura aleatoria (nv5, CD 17, +9); 1/amanecer",
		"Este pequeño cubo parece una caja de sorpresa. Cuando giras su manivela como Acción Mágica, suena una melodía alegre, la tapa se abre, una criatura aparece en el espacio desocupado más cercano y la tapa se cierra. La tapa no puede abrirse de otra manera.\n\nTira 1d6 para determinar el conjuro de convocación (nv5, CD 17, bonificador de ataque +9, sin Concentración): 1 Convocar Aberración, 2 Convocar Bestia, 3 Convocar Constructo, 4 Convocar Dragón, 5 Convocar Elemental, 6 Convocar Feérico. Una vez que el cubo convoca una criatura, no puede volver a hacerlo hasta el siguiente amanecer.")

	# ── Puerta Cúbica (NUEVO) ────────────────────────────────
	_m("puerta_cubica", "Puerta Cúbica", ItemData.Rarity.LEGENDARIO, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.NONE,
		"3 cargas; presionar cara → Portal al plano vinculado; presionar dos veces → Desplazamiento de Plano; recupera 1d3/amanecer",
		"Este cubo mide 7,5 cm y irradia energía mágica palpable. Las seis caras del cubo están vinculadas cada una a un plano de existencia diferente, uno de los cuales es el Plano Material.\n\nEl cubo tiene 3 cargas y recupera 1d3 cargas gastadas diariamente al amanecer. Como Acción Mágica, puedes gastar 1 carga para lanzar uno de los siguientes conjuros:\n\nPortal. Presionando una cara, lanzas Portal abriendo un portal al plano vinculado a esa cara.\nDesplazamiento de Plano. Presionando una cara dos veces, lanzas Desplazamiento de Plano transportando a los objetivos al plano vinculado a esa cara.")

# ============================================================
# DESCRIPCIONES COMPLETAS — LETRA D
# ============================================================

func _register_descriptions_D() -> void:
	# ── Fortaleza Instantánea de Daern (NUEVO) ───────────────
	_m("fortaleza_instantanea_de_daern", "Fortaleza Instantánea de Daern", ItemData.Rarity.RARO, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.ANY,
		"Acción Mágica: estatuilla 2,5cm → torre adamantina 6×6×9m (CA 20, 100 PG); revertir si vacía",
		"Como Acción Mágica, puedes colocar esta estatuilla de adamantina de 2,5 cm en el suelo y, usando una palabra de mando, hacer que crezca rápidamente hasta convertirse en una torre cuadrada de adamantina. Repitiendo la palabra de mando, la torre se revierte a forma de estatuilla, lo que solo funciona si la torre está vacía.\n\nLa torre mide 6 m por lado y 9 m de altura, con aspilleras en todos los lados y un parapeto en la cima. Su interior está dividido en dos plantas, con una escalera o rampa (tu elección) que las conecta. Esta escalera o rampa termina en una trampilla que conduce al tejado. Cuando se crea, la torre tiene una única puerta al nivel del suelo en el lado que te da la cara. La puerta solo se abre con tu orden, que puedes dar como Acción Adicional. Es inmune al conjuro Abrir cerraduras y magia similar.\n\nLa magia impide que la torre se vuelque. El tejado, la puerta y las paredes tienen CA 20; PG 100; Inmunidad al daño Contundente, Perforante y Cortante (salvo el causado por equipos de asedio); y Resistencia al resto de daños. Reducir la torre a forma de estatuilla no repara el daño. Solo el conjuro Deseo puede reparar la torre (cada lanzamiento restaura todos sus PG).")

	# ── Daga de Veneno — descripción ────────────────────────
	_set_desc("daga_de_veneno",
		"Obtienes un bonificador de +1 a las tiradas de ataque y de daño con esta arma mágica.\n\nPuedes realizar una Acción Adicional para cubrir mágicamente la hoja con veneno. El veneno permanece durante 1 minuto o hasta que un ataque con esta arma golpee a una criatura. Esa criatura debe superar una tirada de salvación de Constitución CD 15 o sufrir 2d10 daño de Veneno y tener la condición Envenenado durante 1 minuto. El arma no puede usarse de esta manera de nuevo hasta el siguiente amanecer.")

	# ── Espada Bailarina — descripción ───────────────────────
	_set_desc("espada_bailarina",
		"Puedes realizar una Acción Adicional para lanzar esta arma mágica al aire. Cuando lo haces, el arma empieza a levitar, vuela hasta 9 m y ataca a una criatura de tu elección a menos de 1,5 m de ella. El arma usa tu tirada de ataque y añade tu modificador de característica al daño.\n\nMientras el arma levita, puedes realizar una Acción Adicional para hacer que vuele hasta 9 m a otro punto a menos de 9 m de ti. Como parte de la misma Acción Adicional, puedes hacer que el arma ataque a una criatura a menos de 1,5 m.\n\nTras atacar por cuarta vez, el arma vuela de regreso a ti e intenta regresar a tu mano. Si no tienes ninguna mano libre, cae al suelo en tu espacio. Si el arma no tiene un camino despejado hacia ti, se mueve lo más cerca posible y luego cae al suelo. También deja de levitar si la agarras o si estás a más de 9 m de ella.")

	# ── Amuleto del Fragmento Oscuro (NUEVO) ─────────────────
	_m("amuleto_del_fragmento_oscuro", "Amuleto del Fragmento Oscuro", ItemData.Rarity.COMUN, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.SPECIFIC,
		"Foco para conjuros de Brujo; 1/descanso largo: intentar lanzar un truco desconocido de Brujo (INT Arcanos CD 10)",
		"Este amuleto está hecho de un fragmento de material resistente de un reino extraplanar. Mientras lo llevas, obtienes los siguientes beneficios.\n\nFoco de Conjuros. Puedes usar el amuleto como Foco de Conjuros para tus conjuros de Brujo.\n\nConjuro Desconocido. Como Acción Mágica, puedes intentar lanzar un truco que no conozcas. El truco debe estar en la lista de conjuros de Brujo y tener un tiempo de lanzamiento de acción. Realizas una prueba de Inteligencia (Arcanos) CD 10. Con éxito, lanzas el conjuro. Con un fallo, el conjuro fracasa y la acción se desperdicia. En cualquier caso, no puedes volver a usar esta propiedad hasta terminar un Descanso Largo.")

	# ── Decantador de Agua Interminable — descripción ────────
	_set_desc("decantador_de_agua_interminable",
		"Este frasco tapado chapotea cuando se agita, como si contuviera agua. Pesa 1 kg.\n\nPuedes realizar una Acción Mágica para retirar el tapón y pronunciar una de tres palabras de mando, tras lo cual sale agua dulce o salada (tu elección) del frasco. El agua deja de salir al inicio de tu siguiente turno.\n\nPalabras de mando:\nSalpicadura. El decantador produce 4 litros de agua.\nFuente. El decantador produce 20 litros de agua.\nGéiser. El decantador produce 120 litros de agua que brotan formando una Línea de 9 m de largo y 30 cm de ancho. Si sostienes el decantador, puedes apuntar el géiser en cualquier dirección. Una criatura de tu elección en la Línea debe superar una tirada de salvación de Fuerza CD 13 o sufrir 1d4 de daño Contundente y tener la condición Tumbada. También puedes apuntar a un objeto en la Línea que no se lleve ni se cargue y que pese menos de 90 kg; el objeto es derribado por el géiser.")

	# ── Mazo de Ilusiones (NUEVO) ────────────────────────────
	_m("mazo_de_ilusiones", "Mazo de Ilusiones", ItemData.Rarity.INFRECUENTE, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.NONE,
		"34 cartas; lanzar al suelo → ilusión de criatura aleatoria hasta que se dispele o mueva la carta",
		"Esta caja contiene un conjunto de cartas. Una baraja completa tiene 34 cartas: 32 que representan criaturas específicas y dos con una superficie espejada. Una baraja encontrada como tesoro suele tener 1d20−1 cartas menos.\n\nLa magia de la baraja solo funciona si las cartas se sacan al azar. Puedes realizar una Acción Mágica para sacar una carta al azar y lanzarla al suelo a un punto a menos de 9 m de ti. Sobre la carta lanzada aparece una ilusión de una criatura (determinada tirando en la tabla del Mazo de Ilusiones) y permanece hasta que se dispele. La criatura ilusoria parece y se comporta como real, pero no puede causar daño. Mientras estés a menos de 36 m de la criatura ilusoria y puedas verla, puedes realizar una Acción Mágica para moverla hasta 9 m de su carta.\n\nCualquier interacción física con la criatura ilusoria revela que es falsa, porque los objetos la atraviesan. Una criatura puede realizar la acción Estudiar para inspeccionarla visualmente y, con una prueba de Inteligencia (Investigación) CD 15 exitosa, identificarla como ilusión. La ilusión dura hasta que su carta se mueve o la ilusión se dispela. Cuando la ilusión termina, la imagen en su carta desaparece y esa carta no puede volver a usarse.")

	# ── Mazo de Muchas Cosas (NUEVO) ─────────────────────────
	_m("mazo_de_muchas_cosas", "Mazo de Muchas Cosas", ItemData.Rarity.LEGENDARIO, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.NONE,
		"Baraja de 13 o 22 cartas; declara cuántas sacar; cada carta tiene efecto inmediato y permanente",
		"Este mazo contiene cartas de marfil o vitela. La mayoría (75%) tienen trece cartas, pero algunas tienen veintidós. Antes de sacar una carta debes declarar cuántas sacarás. Si no sacas el número declarado en 1 hora, las cartas restantes salen solas y su efecto se aplica de inmediato.\n\nEfectos principales:\nBalance: sube un atributo 2 puntos (máx. 22), baja otro 2.\nCometa: si reduces a un enemigo elegido a 0 PG en combate → ventaja en tiradas de muerte 1 año.\nDonjon: quedas atrapado en suspensión animada en una esfera extradimensional.\nEuryale: −2 a tiradas de salvación permanentemente.\nDestinos: borra un evento de tu historia (usar antes de morir).\nLlamas: un diablo poderoso se convierte en tu enemigo.\nTonto: Desventaja en pruebas D20 72h; saca otra carta.\nGema: joyas por valor de 50.000 mo.\nBuffón: Ventaja en pruebas D20 72h, o dos cartas extra.\nLlave: arma mágica Rara o superior aparece en tu persona.\nCaballero: un Caballero leal aparece para servirte.\nLuna: ganas la capacidad de lanzar Deseo 1d3 veces.\nRompecabezas: reduces INT o SAB en 1d4+1; saca 1 carta extra.\nBribón: un PNJ se vuelve hostil hacia ti en secreto.\nRuina: pierdes toda tu riqueza no mágica.\nSabio: puedes hacer una pregunta en meditación y recibir respuesta verdadera.\nCalavera: un Avatar de la Muerte aparece y te ataca solo a ti.\nEstrella: aumenta un atributo en 2 (máx. 24).\nSol: un objeto mágico aparece + 10 PG temporales cada amanecer.\nGarras: todos tus objetos mágicos se desintegran.\nTrono: competencia y maestría en Historia, Perspicacia, Intimidación o Persuasión; ganas un pequeño fuerte.\nVacío: tu alma queda atrapada en un objeto; tu cuerpo inerte.")

	# ── Defensor — descripción ───────────────────────────────
	_m("defensor", "Defensor", ItemData.Rarity.LEGENDARIO, ItemData.ItemType.WEAPON,
		MagicItemData.Attunement.ANY,
		"+3 ataque/daño; puedes transferir parte o todo el bonificador a la CA hasta tu siguiente turno",
		"Obtienes un bonificador de +3 a las tiradas de ataque y de daño realizadas con esta arma mágica.\n\nLa primera vez que atacas con el arma en cada uno de tus turnos, puedes transferir parte o todo el bonificador del arma a tu Clase de Armadura. Por ejemplo, podrías reducir el bonificador a ataques y daño a +1 y obtener un bonificador de +2 a la CA. Los bonificadores ajustados permanecen en vigor hasta el inicio de tu siguiente turno, aunque debes sostener el arma para obtener el bonificador a la CA.")

	# ── Armadura Demoníaca — descripción ────────────────────
	_set_desc("armadura_demoniaca",
		"Mientras llevas esta armadura, obtienes un bonificador de +1 a la Clase de Armadura, y conoces el idioma Abisal. Además, los guanteletes con garras de la armadura permiten que tus Golpes Desarmados infligen 1d8 de daño Cortante en lugar del daño Contundente habitual, y obtienes un bonificador de +1 a las tiradas de ataque y de daño de tus Golpes Desarmados.\n\nMaldición. Una vez que te pones esta armadura maldita, no puedes quitártela a menos que seas objetivo del conjuro Levantar Maldición o magia similar. Mientras llevas la armadura, tienes Desventaja en las tiradas de ataque contra demonios y en las tiradas de salvación contra sus conjuros y habilidades especiales.")

	# ── Demonómicón de Iggwilv (NUEVO) ───────────────────────
	_m("demonomicon_de_iggwilv", "Demonómicón de Iggwilv", ItemData.Rarity.LEGENDARIO, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.ANY,
		"Artefacto: lore demoníaco con ventaja; atrapar Infernales en páginas; maximizar daño vs Infernales; 8 cargas de conjuros",
		"Este tratado, redactado por la archimaga Iggwilv, documenta las capas y habitantes del Abismo y es ampliamente considerado el tomo de demonología más completo y blasfemo del multiverso.\n\nLore Abisal. Puedes consultar el Demonómicón cuando realizas una prueba de Inteligencia para obtener información sobre demonios o una prueba de Sabiduría (Supervivencia) relacionada con el Abismo. Cuando lo haces, tienes Ventaja en la prueba.\n\nContención. Las diez primeras páginas están en blanco. Como Acción Mágica, puedes elegir un Infernal atrapado en el área de un conjuro Círculo Mágico. El Infernal debe superar una tirada de salvación de Carisma CD 20 con Desventaja o quedar atrapado en una de las páginas en blanco. Esta acción no puede repetirse hasta el siguiente amanecer.\n\nCaptura de Almas. Al terminar un Descanso Largo, si el libro está en el mismo plano que tú, una criatura atrapada puede intentar poseerte (tirada de salvación de Carisma CD 20).\n\nEnsarce. Mientras llevas el libro, tus conjuros Círculo Mágico (solo Infernales) y Vínculo Planar (objetivo Infernal) se lanzan al nivel 9.\n\nAzote Infernal. Mientras llevas el libro, cuando lanzas un conjuro contra un Infernal, usas el resultado máximo posible en las tiradas de daño.\n\nConjuros (8 cargas, CD 20): Círculo Mágico (1), Recipiente Mágico (3), Aliado Planar (3), Vínculo Planar (2), Desplazamiento de Plano al Abismo (3), Convocar Diablo (3), Risa de Tasha (0).\n\nDestrucción. Seis señores demoníacos diferentes deben rasgar cada uno un sexto del libro. Si esto ocurre, las páginas reaparecen en 24 horas.")

	# ── Grilletes Dimensionales (NUEVO) ──────────────────────
	_m("grilletes_dimensionales", "Grilletes Dimensionales", ItemData.Rarity.RARO, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.NONE,
		"Acción Utilizar: ponerlos a criatura Incapacitada; impide movimiento extradimensional; Fuerza DC 30 cada 30 días para liberarse",
		"Puedes realizar una Acción de Utilizar para colocar estos grilletes en una criatura con la condición Incapacitada. Los grilletes se ajustan para adaptarse a una criatura de tamaño Pequeño a Grande. Los grilletes impiden que una criatura encadenada use cualquier método de movimiento extradimensional, incluida la teletransportación o el viaje a un plano diferente. No impiden que la criatura pase a través de un portal interdimensional.\n\nTú y cualquier criatura que designes cuando uses los grilletes podéis realizar una Acción de Utilizar para quitarlos. Una vez cada 30 días, la criatura encadenada puede realizar una prueba de Fuerza (Atletismo) CD 30. Con éxito, la criatura se libera y destruye los grilletes.")

	# ── Escamas de Dragón — descripción ─────────────────────
	_set_desc("escamas_de_dragon",
		"Mientras llevas esta armadura, obtienes un bonificador de +1 a la Clase de Armadura, tienes Ventaja en las tiradas de salvación contra las armas de aliento de los Dragones, y tienes Resistencia a un tipo de daño determinado por el tipo de dragón que proporcionó las escamas.\n\nTipos de dragón y resistencia: Negro (Ácido), Azul (Relámpago), Latón (Fuego), Bronce (Relámpago), Cobre (Ácido), Dorado (Fuego), Verde (Veneno), Rojo (Fuego), Plateado (Frío), Blanco (Frío).\n\nAdemás, puedes enfocar tus sentidos como Acción Mágica para conocer la distancia y dirección al dragón más cercano a menos de 48 km que sea del mismo tipo que la armadura. Esta acción no puede repetirse hasta el siguiente amanecer.")

	# ── Matadragones — descripción ───────────────────────────
	_set_desc("matadragones",
		"Obtienes un bonificador de +1 a las tiradas de ataque y de daño realizadas con esta arma mágica.\n\nEl arma inflige 3d6 de daño adicional del tipo del arma si el objetivo es un Dragón.")

	# ── Yelmo de Terror (NUEVO) ──────────────────────────────
	_m("yelmo_de_terror", "Yelmo de Terror", ItemData.Rarity.COMUN, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.NONE,
		"Mientras lo llevas, tus ojos brillan en rojo y el resto de tu cara queda oculto en sombra",
		"Mientras llevas este temible yelmo de acero, tus ojos brillan en rojo y el resto de tu cara queda oculto en sombra.")

	# ── Globo Flotante (NUEVO) ───────────────────────────────
	_m("globo_flotante", "Globo Flotante", ItemData.Rarity.INFRECUENTE, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.NONE,
		"Emite Luz o Luz Diurna (1/amanecer); puede flotar a 1,5m del suelo y seguirte a 18m",
		"Esta pequeña esfera de vidrio grueso pesa 0,5 kg. Si estás a menos de 18 m de ella, puedes ordenarle que emita luz equivalente al conjuro Luz o Luz Diurna (tu elección). Una vez usado, el efecto de Luz Diurna no puede volver a usarse hasta el siguiente amanecer.\n\nPuedes emitir otra orden como Acción Mágica para hacer que el globo iluminado suba al aire y flote a no más de 1,5 m del suelo. El globo se mantiene así hasta que tú u otra criatura lo agarre. Si te alejas más de 18 m del globo flotante, te sigue hasta estar a 18 m de ti. Toma la ruta más corta para hacerlo. Si se le impide moverse, el globo desciende suavemente al suelo y queda inactivo, y su luz se apaga.")

	# ── Polvo de Desaparición (NUEVO) ────────────────────────
	_m("polvo_de_desaparicion", "Polvo de Desaparición", ItemData.Rarity.INFRECUENTE, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.NONE,
		"Un uso: tú y criaturas/objetos en 3m → condición Invisible 2d4 minutos; cesa al atacar o lanzar conjuro",
		"Este polvo parece arena fina. Hay suficiente para un uso. Cuando realizas una Acción de Utilizar para lanzar el polvo al aire, tú y cada criatura y objeto en una Emanación de 3 m originada en ti obtienen la condición Invisible durante 2d4 minutos. La duración es la misma para todos los sujetos y el polvo se consume cuando surte efecto. Inmediatamente después de que una criatura afectada realice una tirada de ataque, infinja daño o lance un conjuro, la condición Invisible termina para esa criatura.")

	# ── Polvo de Sequedad (NUEVO) ─────────────────────────────
	_m("polvo_de_sequedad", "Polvo de Sequedad", ItemData.Rarity.INFRECUENTE, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.NONE,
		"1d6+4 pizcas; cada pizca convierte hasta 3m³ de agua en una canica; romperla libera el agua; +10d6 necrótico a elementales de agua CD 13",
		"Este pequeño paquete contiene 1d6+4 pizcas de polvo. Como Acción de Utilizar, puedes esparcir una pizca sobre el agua, convirtiendo hasta un Cubo de 4,5 m de agua en una canica del tamaño de una bolita, que flota o descansa cerca de donde se esparció el polvo. El peso de la canica es insignificante. Una criatura puede realizar una Acción de Utilizar para golpear la canica contra una superficie dura, haciendo que se rompa y libere el agua que absorbió el polvo.\n\nComo Acción de Utilizar, puedes esparcir una pizca del polvo sobre un Elemental a menos de 1,5 m de ti compuesto principalmente de agua (como un Elemental de Agua). Tal criatura expuesta realiza una tirada de salvación de Constitución CD 13, sufriendo 10d6 de daño Necrótico si falla o la mitad si tiene éxito.")

	# ── Polvo de Estornudo y Asfixia (NUEVO) ─────────────────
	_m("polvo_de_estornudo_y_asfixia", "Polvo de Estornudo y Asfixia", ItemData.Rarity.INFRECUENTE, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.NONE,
		"Un uso: tú y todos en 9m → CD 15 CON o Incapacitado y asfixiándose; repite el save al fin de cada turno",
		"Encontrado en un pequeño recipiente, este polvo parece Polvo de Desaparición, e Identificar lo revela como tal. Hay suficiente para un uso.\n\nComo Acción de Utilizar, puedes lanzar el polvo al aire, obligando a ti y a todas las criaturas en una Emanación de 9 m originada en ti a realizar una tirada de salvación de Constitución CD 15. Los Constructos, Elementales, Cienos, Plantas y No Muertos superan la tirada automáticamente.\n\nSi falla la tirada, una criatura empieza a estornudar de forma incontrolable; tiene la condición Incapacitada y está asfixiándose. La criatura repite la tirada al final de cada uno de sus turnos, terminando el efecto en sí misma con un éxito. El efecto también termina para cualquier criatura objetivo del conjuro Restauración Menor.")

	# ── Placa Enana — descripción ────────────────────────────
	_set_desc("placa_enana",
		"Mientras llevas esta armadura, obtienes un bonificador de +2 a la Clase de Armadura. Además, si un efecto te mueve en contra de tu voluntad a lo largo del suelo, puedes usar una Reacción para reducir la distancia que te mueven hasta 3 m.")

	# ── Hacha Lanzadora Enana — descripción ─────────────────
	_set_desc("hacha_lanzadora_enana",
		"Obtienes un bonificador de +3 a las tiradas de ataque y de daño realizadas con esta arma mágica. Tiene la propiedad Arrojadiza con alcance normal de 6 m y largo de 18 m. Cuando golpeas con un ataque a distancia usando esta arma, inflige 1d8 de daño de Fuerza adicional (o 2d8 si el objetivo es un Gigante). Inmediatamente después de golpear o fallar, el arma vuelve volando a tu mano.")

# ============================================================
# DESCRIPCIONES COMPLETAS — LETRA E
# ============================================================

func _register_descriptions_E() -> void:
	# ── Cuerno de Oído (NUEVO) ───────────────────────────────
	_m("cuerno_de_oido", "Cuerno de Oído", ItemData.Rarity.COMUN, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.NONE,
		"Mientras lo acercas al oído, suprime los efectos de la condición Ensordecido",
		"Mientras acercas este cuerno a tu oído, suprime los efectos de la condición Ensordecido en ti.")

	# ── Botella del Efrit (NUEVO) ────────────────────────────
	_m("botella_del_efrit", "Botella del Efrit", ItemData.Rarity.MUY_RARO, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.NONE,
		"Acción Mágica: abrir la botella → el Efrit surge (1d10: 1=ataca, 2–9=obedece 1h, 10=otorga un Deseo)",
		"Cuando realizas una Acción Mágica para retirar el tapón de esta botella pintada de latón, una nube de humo espeso brota de ella. Al final de tu turno, el humo desaparece con un destello de fuego inofensivo y un Efrit aparece en un espacio desocupado a menos de 9 m de ti.\n\nLa primera vez que se abre la botella, el DJ tira 1d10: 1 = el efrit te ataca durante 5 rondas y luego desaparece, y la botella pierde su magia; 2–9 = el efrit entiende tus idiomas y obedece tus órdenes durante 1 hora, después de lo cual regresa a la botella (no puede volver a abrirse en 24 horas; las dos siguientes veces también tiene este efecto; la cuarta vez el efrit escapa y desaparece); 10 = el efrit entiende tus idiomas y puede lanzar Deseo una vez para ti, luego desaparece y la botella pierde su magia.")

	# ── Cadena del Efrit (NUEVO) ─────────────────────────────
	_m("cadena_del_efrit", "Cadena del Efrit", ItemData.Rarity.LEGENDARIO, ItemData.ItemType.ARMOR,
		MagicItemData.Attunement.ANY,
		"+3 CA; inmunidad al fuego; conoces Primordial; puedes caminar sobre roca fundida",
		"Mientras llevas esta armadura, obtienes un bonificador de +3 a la Clase de Armadura, tienes Inmunidad al daño de Fuego y conoces el idioma Primordial. Además, puedes estar de pie y moverte por roca fundida como si fuera terreno sólido.")

	# ── Gema Elemental (NUEVO) ───────────────────────────────
	_m("gema_elemental", "Gema Elemental", ItemData.Rarity.INFRECUENTE, ItemData.ItemType.CONSUMABLE,
		MagicItemData.Attunement.NONE,
		"Acción Utilizar: romper la gema → convoca el elemental correspondiente durante 1h",
		"Esta gema contiene una mota de energía elemental. Cuando realizas una Acción de Utilizar para romper la gema, un elemental es convocado y la gema deja de ser mágica. El elemental aparece en el espacio desocupado más cercano a la gema rota, entiende tus idiomas, obedece tus órdenes y actúa inmediatamente después de ti en el orden de iniciativa. El elemental desaparece tras 1 hora, cuando muere o cuando lo despides con una Acción Adicional.\n\nTipo de gema y elemental: Zafiro azul → Elemental de Aire; Esmeralda → Elemental de Agua; Corindón rojo → Elemental de Fuego; Diamante amarillo → Elemental de Tierra.")

	# ── Elixir de Salud — descripción ───────────────────────
	_set_desc("elixir_de_salud",
		"Cuando bebes esta poción, quedas curado de todas las contagios mágicos. Además, las siguientes condiciones terminan en ti: Cegado, Ensordecido, Paralizado y Envenenado.\n\nEl líquido rojo transparente tiene pequeñas burbujas de luz en su interior.")

	# ── Cota de Malla Élfica Encadenada — descripción ────────
	_set_desc("cota_de_malla_elfica_encadenada",
		"Obtienes un bonificador de +1 a la Clase de Armadura mientras llevas esta armadura. Se considera que tienes entrenamiento con esta armadura incluso si careces de entrenamiento con armadura Media o Pesada.")

	# ── Libro de Conjuros Perdurable (NUEVO) ─────────────────
	_m("libro_de_conjuros_perdurable", "Libro de Conjuros Perdurable", ItemData.Rarity.COMUN, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.NONE,
		"El libro y su contenido no pueden ser dañados por fuego o agua; no se deteriora con el tiempo",
		"Este libro de conjuros, junto con todo lo escrito en sus páginas, no puede ser dañado por fuego o agua. Además, el libro de conjuros no se deteriora con la edad.")

	# ── Arco de Energía (NUEVO) ──────────────────────────────
	_m("arco_de_energia", "Arco de Energía", ItemData.Rarity.MUY_RARO, ItemData.ItemType.WEAPON,
		MagicItemData.Attunement.ANY,
		"+1 ataque/daño; genera flechas de energía dorada (daño de Fuerza); flecha de retención CD 15 FUE o flecha de transporte (teletransporta objetivo 3m)",
		"Obtienes un bonificador de +1 a las tiradas de ataque y de daño realizadas con esta arma mágica, que no tiene cuerda. Cada vez que extiendes el brazo en posición de disparo, aparece una flecha mágica de energía dorada, lista para disparar. Las flechas producidas por esta arma infligen daño de Fuerza en lugar de daño Perforante y desaparecen después de golpear o fallar.\n\nFlecha de Retención. Siempre que uses esta arma para realizar un ataque a distancia contra una criatura, puedes intentar retener al objetivo en lugar de infligir daño. Si la flecha golpea, el objetivo debe superar una tirada de salvación de Fuerza CD 15 u obtener la condición Restringido durante 1 minuto. Como acción, una criatura Restringida puede realizar una prueba de Fuerza (Atletismo) CD 20 para intentar romper la restricción.\n\nFlecha de Transporte. Como Acción Mágica, puedes disparar una flecha de energía hacia un objetivo que puedas ver a menos de 18 m. El objetivo puede ser una criatura Mediana o más pequeña dispuesta, u un objeto lo suficientemente pequeño para caber en un Cubo de 1,5 m. La flecha teletransporta al objetivo a un espacio desocupado que puedas ver a menos de 3 m de ti.\n\nEscalera de Energía. Como Acción Mágica, puedes lanzar una ráfaga de flechas hacia una pared a menos de 18 m. Las flechas forman una escalera mágica de hasta 18 m de longitud que dura 1 minuto.")

	# ── Armadura Encantada (NUEVO) ───────────────────────────
	_m("armadura_encantada", "Armadura Encantada", ItemData.Rarity.INFRECUENTE, ItemData.ItemType.ARMOR,
		MagicItemData.Attunement.ANY,
		"Contiene un conjuro nv0–8 de Abjuración o Ilusión; 6 cargas; gastar 1 carga para lanzarlo; rareza varía según nivel del conjuro",
		"Un conjuro de nivel 8 o inferior está vinculado a esta armadura. El conjuro se determina al crearla y debe pertenecer a la escuela de Abjuración o Ilusión. La armadura tiene 6 cargas y recupera 1d6 cargas gastadas diariamente al amanecer. Mientras la llevas, puedes gastar 1 carga para lanzar su conjuro.\n\nEl nivel del conjuro determina la CD de salvación, el bonificador de ataque y la rareza de la armadura: Truco/1 → Infrecuente (CD 13, +5); 2–3 → Rara (CD 13–15, +5–7); 4–5 → Muy Rara (CD 15–17, +7–9); 6–8 → Legendaria (CD 17–18, +9–10).")

	# ── Bastón Encantado (NUEVO) ─────────────────────────────
	_m("baculo_encantado", "Báculo Encantado", ItemData.Rarity.INFRECUENTE, ItemData.ItemType.MISC,
		MagicItemData.Attunement.SPELLCASTER,
		"Contiene un conjuro nv0–8 de cualquier escuela; 6 cargas; gastar 1 carga para lanzarlo",
		"Un conjuro de nivel 8 o inferior está vinculado a este báculo. El conjuro se determina al crearlo y puede ser de cualquier escuela de magia. El báculo tiene 6 cargas y recupera 1d6 cargas gastadas diariamente al amanecer. Mientras lo sostienes, puedes gastar 1 carga para lanzar su conjuro. Si gastas la última carga, tira 1d20: con un 1, el báculo pierde sus propiedades y se convierte en un Bastón de madera no mágico.\n\nEl nivel del conjuro determina la CD, el bonificador de ataque y la rareza del báculo: Truco/1 → Infrecuente (CD 13, +5); 2–3 → Raro (CD 13–15, +5–7); 4–5 → Muy Raro (CD 15–17, +7–9); 6–8 → Legendario (CD 17–18, +9–10).")

	# ── Arma Encantada (NUEVO) ───────────────────────────────
	_m("arma_encantada", "Arma Encantada", ItemData.Rarity.INFRECUENTE, ItemData.ItemType.WEAPON,
		MagicItemData.Attunement.ANY,
		"Contiene un conjuro nv0–8 de Conjuración/Adivinación/Evocación/Nigromancia/Transmutación; 6 cargas para lanzarlo",
		"Un conjuro de nivel 8 o inferior está vinculado a esta arma. El conjuro se determina al crearla y debe pertenecer a la escuela de Conjuración, Adivinación, Evocación, Nigromancia o Transmutación. El arma tiene 6 cargas y recupera 1d6 cargas gastadas diariamente al amanecer. Mientras la sostienes, puedes gastar 1 carga para lanzar su conjuro.\n\nEl nivel determina rareza: Truco/1 → Infrecuente (CD 13, +5); 2–3 → Raro (CD 13–15, +5–7); 4–5 → Muy Raro (CD 15–17, +7–9); 6–8 → Legendario (CD 17–18, +9–10).")

	# ── Ojo Sustituto (NUEVO) ────────────────────────────────
	_m("ojo_sustituto", "Ojo Sustituto", ItemData.Rarity.COMUN, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.NONE,
		"Reemplaza un ojo real perdido; puedes ver a través de él; insertarlo/quitarlo como Acción Mágica",
		"Este ojo mágico reemplaza a uno real que se haya perdido o extirpado. Mientras el Ojo Sustituto está incrustado en tu cuenca ocular, puedes ver a través del pequeño orbe como si fuera tu ojo natural. Puedes insertar o quitar el Ojo Sustituto como Acción Mágica, y no puede quitarse en contra de tu voluntad mientras estés vivo.")

	# ── Botella de Humo Perpetuo (NUEVO) ─────────────────────
	_m("botella_de_humo_perpetuo", "Botella de Humo Perpetuo", ItemData.Rarity.INFRECUENTE, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.NONE,
		"Acción Mágica: abrir/cerrar; abierta crea nube de humo que crece hasta 36m Emanación en 10min; el humo persiste 10min al cerrar",
		"Como Acción Mágica, puedes abrir o cerrar esta botella.\n\nAl abrirla, un humo espeso brota formando una nube que llena una Emanación de 18 m originada en la botella. El área dentro del humo está Totalmente Oscurecida. Cada minuto que la botella permanece abierta, el tamaño de la Emanación aumenta 3 m hasta alcanzar su máximo de 36 m.\n\nCerrar la botella hace que la nube quede fija hasta que se disperse en 10 minutos. Un viento fuerte (como el creado por el conjuro Ráfaga de Viento) la dispersa en 1 minuto.")

	# ── Hacha Ejecutora (NUEVO) ──────────────────────────────
	_m("hacha_ejecutora", "Hacha Ejecutora", ItemData.Rarity.MUY_RARO, ItemData.ItemType.WEAPON,
		MagicItemData.Attunement.NONE,
		"+1 ataque/daño; +2d6 Cortante adicional vs Humanoides; ganas PG temporales = daño extra infligido",
		"Obtienes un bonificador de +1 a las tiradas de ataque y de daño realizadas con esta arma mágica.\n\nCualquier Humanoide al que golpees con el arma sufre 2d6 de daño Cortante adicional, y obtienes PG temporales iguales al daño extra infligido.")

	# ── Ojo y Mano de Vecna (NUEVO) ─────────────────────────
	_m("ojo_y_mano_de_vecna", "Ojo y Mano de Vecna", ItemData.Rarity.LEGENDARIO, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.ANY,
		"Artefacto: alineación NE; Visión Verdadera 72m (ojo); FUE 20 + 2d8 frío (mano); +STR 4 con cinturón gigante; Regeneración; Deseo 1/30 días",
		"Vecna era un poderoso mago que forjó un terrible imperio. Para prevenir su muerte se convirtió en liche. Un teniente traicionero llamado Kas puso fin a su reinado. De Vecna solo quedaron una mano y un ojo.\n\nPropiedades del Ojo (alinea a NE): Visión Verdadera 72 m; 8 cargas (recupera 1d4+4/amanecer) para lanzar: Clarividencia (2), Corona de Locura (1), Desintegrar (4), Dominar Monstruo (5), Mirada Paralizadora (4); Visión X 9 m 1min (Acción Mágica). Atunement: insertarlo en tu cuenca → se injerta; si se quita mueres.\n\nPropiedades de la Mano (alinea a NE): Fuerza 20 si no es superior; +2d8 de Frío en ataques con la mano o arma en ella; 8 cargas para: Dedo de la Muerte (5), Dormir (1), Ralentizar (2), Teletransporte (3). Cada uso → Sugestión sobre ti para que cometas un acto malvado (CD 18). Atunement: presionarla en el muñón → se injerta; si se quita mueres.\n\nPropiedades combinadas (ambos): Iniciativa con Ventaja; Acción Mágica → objetivo a 1,5 m realiza CD 18 CON (fallo → 7d6 necrótico, si muere → cieno verde); inmunidad a Veneno; Regeneración 1d10 PG/turno si tienes al menos 1 PG; Deseo 1 vez cada 30 días.\n\nDestrucción: si la misma criatura tiene ambos artefactos y es abatida por la Espada de Kas, ambos estallan en llamas y son destruidos.")

	# ── Ojos de Encantamiento (NUEVO) ────────────────────────
	_m("ojos_de_encantamiento", "Ojos de Encantamiento", ItemData.Rarity.INFRECUENTE, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.ANY,
		"3 cargas; gastar 1–3 cargas para lanzar Encantar Persona (CD 13, sube nivel con cargas); recupera todas/amanecer",
		"Estas lentes de cristal se colocan sobre los ojos. Tienen 3 cargas. Mientras las llevas, puedes gastar 1 o más cargas para lanzar Encantar Persona (CD 13). Por 1 carga, lanzas el conjuro de nivel 1. Aumentas el nivel del conjuro en 1 por cada carga adicional que gastes. Las lentes recuperan todas las cargas gastadas diariamente al amanecer.")

	# ── Ojos de Visión Diminuta (NUEVO) ──────────────────────
	_m("ojos_de_vision_diminuta", "Ojos de Visión Diminuta", ItemData.Rarity.INFRECUENTE, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.NONE,
		"Visión mejorada hasta 30 cm: Visión Oscura 30 cm y Ventaja en Investigación en ese rango",
		"Estas lentes de cristal se colocan sobre los ojos. Mientras las llevas, tu visión mejora significativamente hasta un alcance de 30 cm, otorgándote Visión Oscura dentro de ese rango y Ventaja en las pruebas de Inteligencia (Investigación) realizadas para examinar algo dentro de ese rango.")

	# ── Ojos del Águila (NUEVO) ──────────────────────────────
	_m("ojos_del_aguila", "Ojos del Águila", ItemData.Rarity.INFRECUENTE, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.NONE,
		"Ventaja en Percepción basada en vista; distingues detalles de criaturas muy lejanas si están en campo abierto",
		"Estas lentes de cristal se colocan sobre los ojos. Mientras las llevas, tienes Ventaja en las pruebas de Sabiduría (Percepción) que dependen de la vista. En condiciones de clara visibilidad, puedes distinguir detalles de criaturas y objetos extremadamente lejanos de al menos 60 cm de tamaño.")

# ============================================================
# DESCRIPCIONES COMPLETAS — LETRA F
# ============================================================

func _register_descriptions_F() -> void:
	# ── Figurilla de Poder Maravilloso (NUEVO) ───────────────
	_m("figurilla_griffon_de_bronce", "Figurilla de Poder: Grifón de Bronce", ItemData.Rarity.RARO, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.NONE,
		"Acción Mágica: se convierte en Grifón durante 6h; 5 días antes de volver a usarse",
		"Esta estatuilla de bronce de un grifón rampante puede convertirse en un Grifón durante hasta 6 horas. Una vez usada, no puede volver a usarse hasta que pasen 5 días.\n\nEl Grifón es Amistoso contigo y tus aliados, entiende tus idiomas, obedece tus órdenes y actúa inmediatamente después de ti en el orden de iniciativa. Si no das órdenes, el grifón se defiende pero no realiza otras acciones. Cuando el grifón es reducido a 0 PG o expira la duración, regresa a forma de figurilla.")

	_m("figurilla_mosca_de_ebano", "Figurilla de Poder: Mosca de Ébano", ItemData.Rarity.RARO, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.NONE,
		"Acción Mágica: se convierte en Mosca Gigante (montura) durante 12h; 2 días antes de volver a usarse",
		"Esta estatuilla de ébano, tallada como un moscardón, puede convertirse en una Mosca Gigante durante hasta 12 horas y puede usarse como montura. Una vez usada, no puede volver a usarse hasta que pasen 2 días.")

	_m("figurilla_leones_dorados", "Figurilla de Poder: Leones Dorados", ItemData.Rarity.RARO, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.NONE,
		"Par; cada uno se convierte en León durante 1h; 7 días antes de volver a usarse",
		"Estas estatuillas doradas de leones siempre se crean en pares. Puedes usar una figurilla o ambas a la vez. Cada una puede convertirse en un León durante hasta 1 hora. Una vez que un león ha sido usado, no puede volver a usarse hasta que pasen 7 días.")

	_m("figurilla_cabras_de_marfil", "Figurilla de Poder: Cabras de Marfil", ItemData.Rarity.RARO, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.NONE,
		"Conjunto de 3: Cabra del Terror (3h, 15 días recarga), Cabra Viajera (24 cargas, 7 días), Cabra de Tribulación (3h, 30 días)",
		"Estas estatuillas de marfil siempre se crean en conjuntos de tres. Cada cabra es distinta.\n\nCabra del Terror: se convierte en una Cabra Gigante durante 3h. No puede atacar, pero puedes quitarle los cuernos para usarlos como armas: un cuerno se convierte en una Lanza +1, el otro en una Espada Larga +2. Mientras la montas, cualquier criatura Hostil que comience su turno en una Emanación de 9 m debe superar CD 15 SAB o estar Asustada 1 min. Recarga: 15 días.\n\nCabra Viajera: se convierte en una cabra Grande con las estadísticas de un Caballo de Montura. Tiene 24 cargas; cada hora gasta 1. Recarga al 0: 7 días.\n\nCabra de Tribulación: se convierte en Cabra Gigante durante 3h. Recarga: 30 días.")

	_m("figurilla_elefante_de_marmol", "Figurilla de Poder: Elefante de Mármol", ItemData.Rarity.RARO, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.NONE,
		"Acción Mágica: se convierte en Elefante durante 24h; 7 días antes de volver a usarse",
		"Esta estatuilla de mármol se parece a un elefante trompeteando. Puede convertirse en un Elefante durante hasta 24 horas. Una vez usada, no puede volver a usarse hasta que pasen 7 días.")

	_m("figurilla_corcel_obsidiana", "Figurilla de Poder: Corcel de Obsidiana", ItemData.Rarity.MUY_RARO, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.NONE,
		"Acción Mágica: se convierte en Pesadilla durante 24h; 10% de ignorar órdenes; 5 días antes de volver a usarse",
		"Este caballo de obsidiana pulida puede convertirse en una Pesadilla durante hasta 24 horas. La pesadilla solo se defiende. Una vez usado, no puede volver a usarse hasta que pasen 5 días.\n\nLa figurilla tiene un 10% de probabilidad cada vez que la usas de ignorar tus órdenes. Si montas la pesadilla mientras ignora tus órdenes, tú y ella sois transportados instantáneamente a un lugar aleatorio en el plano de Hades, donde la pesadilla regresa a forma de figurilla.")

	_m("figurilla_perro_de_onix", "Figurilla de Poder: Perro de Ónix", ItemData.Rarity.RARO, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.NONE,
		"Acción Mágica: se convierte en Mastín (INT 8, habla Común, Visión Ciega 18m) durante 6h; 7 días recarga",
		"Esta estatuilla de ónix de un perro puede convertirse en un Mastín durante hasta 6 horas. El mastín tiene Inteligencia 8 y puede hablar Común. También tiene Visión Ciega con alcance de 18 m. Una vez usada, no puede volver a usarse hasta que pasen 7 días.")

	_m("figurilla_buho_serpentino", "Figurilla de Poder: Búho Serpentino", ItemData.Rarity.RARO, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.NONE,
		"Acción Mágica: se convierte en Búho Gigante durante 8h; comunicación telepática ilimitada con el búho; 2 días recarga",
		"Esta estatuilla de serpentino de un búho puede convertirse en un Búho Gigante durante hasta 8 horas. El búho puede comunicarse telepáticamente contigo a cualquier distancia si estáis en el mismo plano. Una vez usada, no puede volver a usarse hasta que pasen 2 días.")

	_m("figurilla_cuervo_de_plata", "Figurilla de Poder: Cuervo de Plata", ItemData.Rarity.INFRECUENTE, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.NONE,
		"Acción Mágica: se convierte en Cuervo durante 12h; puedes lanzar Mensajero Animal sobre él; 2 días recarga",
		"Esta estatuilla de plata de un cuervo puede convertirse en un Cuervo durante hasta 12 horas. Una vez usada, no puede volver a usarse hasta que pasen 2 días. Mientras esté en forma de cuervo, la figurilla te otorga la capacidad de lanzar Mensajero Animal sobre él.")

	# ── Lengua de Fuego — descripción ───────────────────────
	_set_desc("espada_lengua_de_fuego",
		"Mientras sostienes esta arma mágica, puedes realizar una Acción Adicional y usar una palabra de mando para que llamas envuelvan la parte dañina del arma. Estas llamas emiten Luz Brillante en un radio de 12 m y Luz Tenue en 12 m adicionales. Mientras el arma esté en llamas, inflige 2d6 de daño de Fuego adicional al impactar. Las llamas duran hasta que realizas una Acción Adicional para repetir la orden, o hasta que sueltas, guardas o enfundas el arma.")

	# ── Barco Plegable (NUEVO) ───────────────────────────────
	_m("barco_plegable", "Barco Plegable", ItemData.Rarity.RARO, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.NONE,
		"Caja de madera 30×15×15 cm: 1ª orden → bote de remos; 2ª orden → barco de quilla; 3ª orden → vuelve a caja",
		"Este objeto parece una caja de madera de 30 cm de largo, 15 cm de ancho y 15 cm de profundidad. Pesa 2 kg y flota. Se puede abrir para guardar cosas dentro. También tiene tres palabras de mando, cada una requiere una Acción Mágica.\n\nPrimera Palabra. La caja se despliega en un Bote de Remos.\nSegunda Palabra. La caja se despliega en un Barco de Quilla.\nTercera Palabra. El Barco Plegable se vuelve a plegar en una caja si no hay criaturas a bordo.")

	# ── Marca de Nieve — descripción ────────────────────────
	_set_desc("marca_de_nieve",
		"Cuando golpeas con una tirada de ataque usando esta arma mágica, el objetivo sufre 1d6 de daño de Frío adicional. Además, mientras sostienes el arma, tienes Resistencia al daño de Fuego.\n\nEn temperaturas heladas, el arma emite Luz Brillante en un radio de 3 m y Luz Tenue en 3 m adicionales.\n\nCuando desenfundas esta arma, puedes apagar todas las llamas no mágicas en un radio de 9 m de ti. Una vez usada esta propiedad, no puede volver a usarse en 1 hora.")

# ============================================================
# DESCRIPCIONES COMPLETAS — LETRA G
# ============================================================

func _register_descriptions_G() -> void:
	# ── Guanteletes de Poder del Ogro — descripción ──────────
	_set_desc("guanteletes_de_poder_del_ogro",
		"Tu Fuerza es 19 mientras llevas estos guanteletes. No tienen ningún efecto si tu Fuerza ya es 19 o superior sin ellos.")

	# ── Gema de Brillo (NUEVO) ───────────────────────────────
	_m("gema_de_brillo", "Gema de Brillo", ItemData.Rarity.INFRECUENTE, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.NONE,
		"50 cargas; 1ª orden: luz 9m sin gasto; 2ª orden: rayo cegador CD 15 (1 carga); 3ª orden: cono 9m cegador (5 cargas)",
		"Este prisma tiene 50 cargas. Mientras lo sostienes, puedes realizar una Acción Mágica y usar una de tres palabras de mando para causar uno de los siguientes efectos:\n\nPrimera Palabra de Mando. La gema emite Luz Brillante en un radio de 9 m y Luz Tenue en 9 m adicionales. No gasta una carga. Dura hasta que realizas una Acción Adicional para repetir la orden o usas otra función de la gema.\n\nSegunda Palabra de Mando. Gastas 1 carga y la gema dispara un brillante rayo de luz sobre una criatura a menos de 18 m. La criatura debe superar una tirada de salvación de Constitución CD 15 u obtener la condición Cegado durante 1 minuto. La criatura repite la tirada al final de cada uno de sus turnos.\n\nTercera Palabra de Mando. Gastas 5 cargas y la gema estalla con luz intensa en un Cono de 9 m. Cada criatura en el Cono realiza una tirada como si hubiera sido golpeada por el rayo de la segunda orden.\n\nCuando se gastan todas las cargas, la gema se vuelve una joya no mágica que vale 50 mo.")

	# ── Gema de Visión (NUEVO) ───────────────────────────────
	_m("gema_de_vision", "Gema de Visión", ItemData.Rarity.RARO, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.ANY,
		"3 cargas; gastar 1: Visión Verdadera 36m durante 10 min mirando a través de la gema; recupera 1d3/amanecer",
		"Esta gema tiene 3 cargas. Como Acción Mágica, puedes gastar 1 carga. Durante los siguientes 10 minutos, tienes Visión Verdadera hasta 36 m cuando miras a través de la gema.\n\nLa gema recupera 1d3 cargas gastadas diariamente al amanecer.")

	# ── Matagigantos — descripción ───────────────────────────
	_set_desc("matagigantos",
		"Obtienes un bonificador de +1 a las tiradas de ataque y de daño realizadas con esta arma mágica.\n\nCuando golpeas a un Gigante con esta arma, el Gigante sufre 2d6 de daño adicional del tipo del arma y debe superar una tirada de salvación de Fuerza CD 15 o tener la condición Tumbado.")

	# ── Cuero Glamuroso Tachonado — descripción ─────────────
	_set_desc("cuero_glamuroso_tachonado",
		"Mientras llevas esta armadura, obtienes un bonificador de +1 a la Clase de Armadura. También puedes realizar una Acción Adicional para hacer que la armadura adopte la apariencia de un conjunto normal de ropa u otro tipo de armadura. Decides su aspecto (incluyendo color, estilo y accesorios), pero la armadura conserva su volumen y peso normales. La apariencia ilusoria dura hasta que uses esta propiedad de nuevo o te quites la armadura.")

	# ── Guantes de Intercepción de Proyectiles (NUEVO) ───────
	_m("guantes_de_intercepcion_de_proyectiles", "Guantes de Intercepción de Proyectiles", ItemData.Rarity.INFRECUENTE, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.ANY,
		"Reacción: si te impacta un proyectil, reduce el daño en 1d10 + mod DES (mano libre); si reduces a 0 puedes atrapar el proyectil",
		"Si te golpea una tirada de ataque realizada con un arma de Alcance o Arrojada mientras llevas estos guantes, puedes usar una Reacción para reducir el daño en 1d10 más tu modificador de Destreza si tienes una mano libre. Si reduces el daño a 0, puedes atrapar la munición o el arma si es lo suficientemente pequeña para sostenerla en esa mano.")

	# ── Guantes de Natación y Escalada (NUEVO) ───────────────
	_m("guantes_de_natacion_y_escalada", "Guantes de Natación y Escalada", ItemData.Rarity.INFRECUENTE, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.ANY,
		"Velocidades de Escalar y Nadar iguales a tu Velocidad; +5 a Atletismo para escalar o nadar",
		"Mientras llevas estos guantes, tienes una Velocidad de Escalar y una Velocidad de Nadar iguales a tu Velocidad, y obtienes un bonificador de +5 a las pruebas de Fuerza (Atletismo) realizadas para escalar o nadar.")

	# ── Guantes de Ladrón (NUEVO) ────────────────────────────
	_m("guantes_de_ladron", "Guantes de Ladrón", ItemData.Rarity.INFRECUENTE, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.NONE,
		"Imperceptibles mientras se llevan; +5 a Juego de Manos",
		"Estos guantes son imperceptibles mientras se llevan. Mientras los llevas, obtienes un bonificador de +5 a las pruebas de Destreza (Juego de Manos).")

	# ── Gafas de la Noche (NUEVO) ────────────────────────────
	_m("gafas_de_la_noche", "Gafas de la Noche", ItemData.Rarity.INFRECUENTE, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.NONE,
		"Visión Oscura 18m; si ya tienes Visión Oscura, la amplía en 18m",
		"Mientras llevas estas lentes oscuras, tienes Visión Oscura hasta 18 m. Si ya tienes Visión Oscura, llevar las gafas aumenta su alcance en 18 m.")

# ============================================================
# DESCRIPCIONES COMPLETAS — LETRA H
# ============================================================

func _register_descriptions_H() -> void:
	# ── Ojo de Hag (NUEVO) ───────────────────────────────────
	_m("ojo_de_hag", "Ojo de Hag", ItemData.Rarity.INFRECUENTE, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.NONE,
		"3 cargas; gastar 1: Visión Oscura (solo tú) o Ver Invisibilidad; cualquier hag del aquelarre puede ver a través de él (Concentración)",
		"Un Ojo de Hag tiene 3 cargas. Mientras llevas o sostienes este objeto, puedes gastar 1 carga para lanzar Visión Oscura (solo sobre ti mismo) o Ver Invisibilidad. El Ojo de Hag recupera todas las cargas gastadas diariamente al amanecer.\n\nSensor del Aquelarre. El Ojo de Hag suele confiarse a un secuaz de un hag para su custodia. Como Acción Mágica, un hag que pertenezca al aquelarre que creó el Ojo puede ver lo que ve el Ojo si el hag y el Ojo están en el mismo plano. Este efecto dura mientras el hag mantenga la Concentración. Múltiples hags del aquelarre pueden ver a través del Ojo simultáneamente.")

	# ── Martillo de los Truenos — descripción ───────────────
	_set_desc("martillo_de_los_truenos",
		"Obtienes un bonificador de +1 a las tiradas de ataque y de daño realizadas con esta arma mágica.\n\nEl arma tiene 5 cargas. Puedes gastar 1 carga y realizar un ataque a distancia con el arma lanzándola con la propiedad Arrojadiza con alcance normal de 6 m y largo de 18 m. Si el ataque impacta, el arma libera un trueno audible a 90 m. El objetivo y todas las criaturas a menos de 9 m de él (excepto tú) deben superar una tirada de salvación de Constitución CD 17 u obtener la condición Aturdido hasta el final de tu siguiente turno. Inmediatamente después de golpear o fallar, el arma vuelve volando a tu mano. El arma recupera 1d4+1 cargas gastadas diariamente al amanecer.\n\nBane de Gigantes. Mientras estés sintonizado y lleves un Cinturón de Fuerza de Gigante o Guanteletes de Poder del Ogro: cuando saques un 20 en una tirada de ataque con esta arma contra un Gigante, ese Gigante debe superar CD 17 CON o morir; además, la puntuación de Fuerza del cinturón/guanteletes aumenta en 4 (máx. 30).")

	# ── Sombrero de Disfraz (NUEVO) ──────────────────────────
	_m("sombrero_de_disfraz", "Sombrero de Disfraz", ItemData.Rarity.INFRECUENTE, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.ANY,
		"Mientras lo llevas: lanzar Disfrazarse a voluntad; termina si te lo quitas",
		"Mientras llevas este sombrero, puedes lanzar el conjuro Disfrazarse. El conjuro termina si te quitas el sombrero.")

	# ── Sombrero de Muchos Conjuros (NUEVO) ──────────────────
	_m("sombrero_de_muchos_conjuros", "Sombrero de Muchos Conjuros", ItemData.Rarity.MUY_RARO, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.SPECIFIC,
		"Foco de conjuros; 1/descanso corto o largo: intentar lanzar conjuro desconocido de Mago con tirada INT (Arcanos) CD 10+nivel",
		"Este sombrero en punta tiene las siguientes propiedades.\n\nFoco de Conjuros. Mientras sostienes el sombrero, puedes usarlo como Foco de Conjuros para tus conjuros de Mago.\n\nConjuro Desconocido. Mientras sostienes el sombrero, puedes intentar lanzar un conjuro de nivel 1+ que no conozcas. El conjuro debe estar en la lista de conjuros de Mago, ser de un nivel que puedas lanzar, y no tener componentes materiales de más de 1.000 mo. Gastas un espacio de conjuro del nivel correspondiente y realizas una prueba de Inteligencia (Arcanos) CD 10 + nivel del conjuro. Con éxito, lanzas el conjuro normalmente. Con fallo, no lo lanzas y se produce un efecto aleatorio (1d100): 01–50 conjuro aleatorio; 51–55 aturdido 1 turno; 56–60 mariposas 1 min; 61–65 sacas objeto inofensivo; 66–70 intoxicado 1h; 71–75 petrificado 1 turno; 76–80 sacas otro objeto; 81–85 aparece criatura 1h; 86–90 enjambre de murciélagos; 91–95 portal planar; 96–00 sacas objeto mágico.")

	# ── Sombrero de Alimañas (NUEVO) ─────────────────────────
	_m("sombrero_de_alimanhas", "Sombrero de Alimañas", ItemData.Rarity.COMUN, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.NONE,
		"3 cargas; gastar 1: convocar Murciélago, Rana o Rata (Indiferente, no bajo tu control); recupera todas/amanecer",
		"Este sombrero tiene 3 cargas. Mientras sostienes el sombrero, puedes realizar una Acción Mágica para gastar 1 carga y convocar a tu elección un Murciélago, una Rana o una Rata. La criatura aparece mágicamente en el sombrero e intenta alejarse de ti lo más rápido posible. La criatura es Indiferente hacia ti y otras criaturas, no está bajo tu control. Se comporta como una criatura ordinaria de su tipo y desaparece tras 1 hora o cuando es reducida a 0 PG. El sombrero recupera todas las cargas gastadas diariamente al amanecer.")

	# ── Sombrero de Magia (NUEVO) ────────────────────────────
	_m("sombrero_de_magia", "Sombrero de Magia", ItemData.Rarity.COMUN, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.SPECIFIC,
		"Foco para conjuros de Mago; 1/descanso largo: intentar truco de Mago desconocido (INT Arcanos CD 10)",
		"Este sombrero cónico está adornado con lunas y estrellas. Mientras lo llevas, obtienes los siguientes beneficios.\n\nFoco de Conjuros. Puedes usar el sombrero como Foco de Conjuros para tus conjuros de Mago.\n\nConjuro Desconocido. Como Acción Mágica, puedes intentar lanzar un truco que no conozcas. El truco debe estar en la lista de conjuros de Mago y tener un tiempo de lanzamiento de acción. Realizas una prueba de Inteligencia (Arcanos) CD 10. Con éxito, lanzas el conjuro. Con fallo, el conjuro fracasa. No puedes volver a usar esta propiedad hasta terminar un Descanso Largo.")

	# ── Diadema de Intelecto — descripción ───────────────────
	_set_desc("diadema_de_intelecto",
		"Tu Inteligencia es 19 mientras llevas esta diadema. No tiene ningún efecto sobre ti si tu Inteligencia ya es 19 o superior sin ella.")

	# ── Yelmo de Brillantez (NUEVO) ──────────────────────────
	_m("yelmo_de_brillantez", "Yelmo de Brillantez", ItemData.Rarity.MUY_RARO, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.ANY,
		"Diamantes/rubíes/ópalo de fuego/ópalos: Luz Diurna, Bola de Fuego, Prisma Prismático, Muro de Fuego; Resistencia fuego; 1d6 radiante a No Muertos/amanecer",
		"Este yelmo está engastado con 1d10 diamantes, 2d10 rubíes, 3d10 ópalos de fuego y 4d10 ópalos. Cualquier gema arrancada del yelmo se convierte en polvo. Cuando se retiran o destruyen todas las gemas, el yelmo pierde su magia.\n\nMientras lo llevas:\nLuz de Diamante. Mientras tenga al menos un diamante, el yelmo emite una Emanación de 9 m. Cuando haya al menos un No Muerto en esa área, la Emanación se llena de Luz Tenue. Cualquier No Muerto que comience su turno en el área sufre 1d6 de daño Radiante.\nLlamaradas de Ópalo de Fuego. Como Acción Mágica, puedes hacer que un arma que sostienes estalle en llamas (10d12 fuego al impactar). Las llamas duran hasta que las apagagas o sueltas el arma.\nResistencia de Rubí. Resistencia al daño de Fuego.\nConjuros (CD 18): Luz Diurna (ópalo), Bola de Fuego (ópalo de fuego), Prisma Prismático (diamante), Muro de Fuego (rubí). La gema usada se destruye.\n\nAl recibir daño de Fuego por fallar una tirada de salvación, tira 1d20: con un 1, el yelmo emite rayos y es destruido.")

	# ── Yelmo de Comprensión de Idiomas (NUEVO) ──────────────
	_m("yelmo_de_comprension_de_idiomas", "Yelmo de Comprensión de Idiomas", ItemData.Rarity.INFRECUENTE, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.NONE,
		"Mientras lo llevas: lanzar Comprensión de Idiomas a voluntad",
		"Mientras llevas este yelmo, puedes lanzar Comprensión de Idiomas desde él.")

	# ── Yelmo de Telepatía (NUEVO) ───────────────────────────
	_m("yelmo_de_telepatia", "Yelmo de Telepatía", ItemData.Rarity.INFRECUENTE, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.ANY,
		"Telepatía 9m; Detectar Pensamientos o Sugestión CD 13 (1/amanecer cada uno)",
		"Mientras llevas este yelmo, tienes telepatía con alcance de 9 m y puedes lanzar Detectar Pensamientos o Sugestión (CD de salvación 13) desde él. Una vez que se lanza cualquiera de los dos conjuros desde el yelmo, ese conjuro no puede volver a lanzarse desde él hasta el siguiente amanecer.")

	# ── Yelmo de Teletransportación (NUEVO) ──────────────────
	_m("yelmo_de_teletransportacion", "Yelmo de Teletransportación", ItemData.Rarity.RARO, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.ANY,
		"3 cargas; gastar 1: lanzar Teletransporte; recupera 1d3/amanecer",
		"Este yelmo tiene 3 cargas. Mientras lo llevas, puedes gastar 1 carga para lanzar Teletransporte desde él. El yelmo recupera 1d3 cargas gastadas diariamente al amanecer.")

	# ── Mochila Práctica de Heward (NUEVO) ───────────────────
	_m("mochila_practica_de_heward", "Mochila Práctica de Heward", ItemData.Rarity.RARO, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.NONE,
		"3 compartimentos extradimensionales (90kg/7m³ laterales + 225kg/18m³ central); recuperar objeto = Acción de Utilizar o Adicional; el objeto buscado siempre está encima",
		"Esta mochila tiene una bolsa central y dos bolsas laterales, cada una de las cuales es un espacio extradimensional. Cada bolsa lateral puede contener hasta 90 kg de material sin superar un volumen de 7 m³. La bolsa central puede contener hasta 225 kg de material sin superar un volumen de 18 m³. La mochila siempre pesa 2,5 kg independientemente de su contenido.\n\nRecuperar un objeto de la mochila requiere una Acción de Utilizar o una Acción Adicional (tu elección). Cuando metes la mano en la mochila buscando un objeto específico, ese objeto siempre está mágicamente encima.\n\nSi se sobrecarga, perfora o rasga alguna de sus bolsas, la mochila se rompe y es destruida y su contenido se pierde para siempre. Si se introduce en un espacio extradimensional como una Bolsa de Contención, ambos objetos son destruidos instantáneamente y se abre un portal al Plano Astral.")

	# ── Bolsita de Especias de Heward (NUEVO) ─────────────────
	_m("bolsita_de_especias_de_heward", "Bolsita de Especias de Heward", ItemData.Rarity.COMUN, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.NONE,
		"10 cargas; gastar 1: nombrar condimento no mágico y extraer una pizca suficiente para una comida; recupera 1d6+4/amanecer",
		"Esta bolsita de cinturón parece vacía y tiene 10 cargas. Mientras la sostienes, puedes realizar una Acción Mágica para gastar 1 carga, nombrar cualquier condimento alimenticio no mágico y retirar una pizca del condimento deseado. Una pizca es suficiente para sazonar una sola comida. La bolsita recupera 1d6+4 cargas gastadas diariamente al amanecer.")

	# ── Campeón Santo (NUEVO) ────────────────────────────────
	_m("campeon_santo", "Campeón Santo", ItemData.Rarity.LEGENDARIO, ItemData.ItemType.WEAPON,
		MagicItemData.Attunement.SPECIFIC,
		"+3 ataque/daño; +2d10 radiante vs Infernales/No Muertos; Emanación 3m → aliados con Ventaja en saves mágicos (30m a nivel 17+)",
		"Obtienes un bonificador de +3 a las tiradas de ataque y de daño realizadas con esta arma mágica. Cuando golpeas a un Infernal o a un No Muerto con ella, esa criatura sufre 2d10 de daño Radiante adicional.\n\nMientras sostienes el arma desenvainada, crea una Emanación de 3 m originada en ti. Tú y todas las criaturas Amistosas en la Emanación tenéis Ventaja en las tiradas de salvación contra conjuros y otros efectos mágicos. Si tienes 17 o más niveles en la clase de Paladín, el tamaño de la Emanación aumenta a 9 m.")

	# ── Cuerno de la Detonación (NUEVO) ──────────────────────
	_m("cuerno_de_la_detonacion", "Cuerno de la Detonación", ItemData.Rarity.RARO, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.NONE,
		"Acción Mágica: Cono 9m → CD 15 CON (fallo: 5d8 trueno + Ensordecido 1 min); 20% explota hiriendo al usuario",
		"Puedes realizar una Acción Mágica para soplar el cuerno, que emite un estruendoso estallido en un Cono de 9 m audible a 180 m. Cada criatura en el Cono realiza una tirada de salvación de Constitución CD 15. Si la falla, sufre 5d8 de daño de Trueno y obtiene la condición Ensordecido durante 1 minuto. Si la supera, solo sufre la mitad del daño. Objetos de cristal o cristalino en el Cono que no se lleven ni carguen sufren 10d8 de daño de Trueno.\n\nCada uso tiene un 20% de probabilidad de hacer que el cuerno explote. La explosión inflige 10d6 de daño de Fuerza al usuario y destruye el cuerno.")

	# ── Cuerno de Alarma Silenciosa (NUEVO) ──────────────────
	_m("cuerno_de_alarma_silenciosa", "Cuerno de Alarma Silenciosa", ItemData.Rarity.COMUN, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.NONE,
		"4 cargas; gastar 1: una criatura elegida a menos de 180m oye el cuerno (nadie más); recupera 1d4/amanecer",
		"Este cuerno tiene 4 cargas y recupera 1d4 cargas gastadas diariamente al amanecer. Como Acción Mágica, puedes soplar el cuerno gastando 1 carga. Una criatura de tu elección oye el sonido del cuerno, siempre que esa criatura esté a menos de 180 m del cuerno. Ninguna otra criatura oye el cuerno.")

	# ── Cuerno de Valhalla (NUEVO) ───────────────────────────
	_m("cuerno_de_valhalla", "Cuerno de Valhalla", ItemData.Rarity.RARO, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.NONE,
		"Acción Mágica: convoca 2–5 espíritus Berserker de Ysgard durante 1h; 7 días entre usos; requisito varía según el metal",
		"Puedes realizar una Acción Mágica para soplar este cuerno. En respuesta, espíritus de guerreros de Ysgard aparecen en espacios desocupados a menos de 18 m de ti. Cada espíritu usa el bloque de estadísticas de Berserker y regresa a Ysgard tras 1 hora o al caer a 0 PG. Si soplas el cuerno sin cumplir el requisito, los espíritus te atacan.\n\nTipos (1d100): 01–40 Plata (2 espíritus, sin requisito); 41–75 Latón (3 espíritus, competencia con todas las armas simples); 76–90 Bronce (4 espíritus, entrenamiento con armadura media); 91–00 Hierro (5 espíritus, competencia con todas las armas marciales). Una vez usado, no puede volver a usarse hasta que pasen 7 días.")

	# ── Herraduras del Céfiro (NUEVO) ────────────────────────
	_m("herraduras_del_cefiro", "Herraduras del Céfiro", ItemData.Rarity.MUY_RARO, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.NONE,
		"Juego de 4; la montura flota 10 cm; cruza agua/lava; sin huellas; ignora terreno difícil; viaja 12h/día sin agotamiento",
		"Estas herraduras vienen en un juego de cuatro. Como Acción Mágica, puedes tocar una herradura al casco de un caballo u otra criatura similar, y la herradura se fija al casco. Quitar una herradura también requiere una Acción Mágica.\n\nMientras las cuatro herraduras estén fijadas, permiten a la criatura moverse normalmente mientras flota 10 cm sobre una superficie. La criatura puede cruzar o estar sobre superficies no sólidas o inestables, como agua o lava. La criatura no deja rastros e ignora el Terreno Difícil. Además, puede viajar hasta 12 horas al día sin ganar niveles de Agotamiento por viaje prolongado.")

	# ── Herraduras de Velocidad (NUEVO) ──────────────────────
	_m("herraduras_de_velocidad", "Herraduras de Velocidad", ItemData.Rarity.RARO, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.NONE,
		"Juego de 4; mientras estén puestas en la misma criatura: Velocidad +9m",
		"Estas herraduras vienen en un juego de cuatro. Como Acción Mágica, puedes tocar una herradura al casco de un caballo u otra criatura similar, y la herradura se fija. Quitar una herradura también requiere una Acción Mágica.\n\nMientras las cuatro herraduras estén fijadas a la misma criatura, su Velocidad aumenta en 9 m.")

# ============================================================
# DESCRIPCIONES COMPLETAS — LETRA I
# ============================================================

func _register_descriptions_I() -> void:
	# ── Vara Inamovible (NUEVO) ──────────────────────────────
	_m("vara_inamovible", "Vara Inamovible", ItemData.Rarity.INFRECUENTE, ItemData.ItemType.MISC,
		MagicItemData.Attunement.NONE,
		"Acción Utilizar: presionar botón → la vara queda fija en el espacio (soporta hasta 3.600 kg); otra Acción Utilizar la libera",
		"Esta vara de hierro tiene un botón en un extremo. Puedes realizar una Acción de Utilizar para presionar el botón, lo que hace que la vara quede mágicamente fija en su lugar. Hasta que tú u otra criatura realice una Acción de Utilizar para presionar el botón de nuevo, la vara no se mueve, aunque desafíe la gravedad. Puede soportar hasta 3.600 kg de peso. Más peso hace que la vara se desactive y caiga. Una criatura puede realizar una Acción de Utilizar para realizar una prueba de Fuerza (Atletismo) CD 30, moviendo la vara fija hasta 3 m con éxito.")

	# ── Instrumento de Ilusiones (NUEVO) ────────────────────
	_m("instrumento_de_ilusiones", "Instrumento de Ilusiones", ItemData.Rarity.COMUN, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.NONE,
		"Mientras tocas: Acción Mágica para crear efectos visuales ilusorios inofensivos en una Emanación de 1,5m (4,5m si eres Bardo)",
		"Mientras tocas este instrumento musical, puedes realizar una Acción Mágica para crear efectos visuales ilusorios inofensivos dentro de una Emanación de 1,5 m originada en el instrumento. Si eres Bardo, el tamaño de la Emanación aumenta a 4,5 m. Los efectos mágicos no tienen sustancia ni sonido, y son obviamente ilusorios. Los efectos terminan cuando dejas de tocar.")

	# ── Instrumento de Escritura (NUEVO) ─────────────────────
	_m("instrumento_de_escritura", "Instrumento de Escritura", ItemData.Rarity.COMUN, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.NONE,
		"3 cargas; gastar 1: escribir mensaje mágico de 6 palabras en superficie visible a 9m; si eres Bardo +7 palabras y el mensaje brilla; desaparece en 24h",
		"Este instrumento musical tiene 3 cargas y recupera todas las cargas gastadas diariamente al amanecer. Mientras lo tocas, puedes realizar una Acción Mágica para gastar 1 carga y escribir un mensaje mágico en un objeto o superficie no mágica que puedas ver a menos de 9 m. El mensaje puede tener hasta seis palabras y está escrito en un idioma que conozcas. Si eres Bardo, puedes escribir siete palabras adicionales y hacer que el mensaje brille débilmente, permitiendo verlo en Oscuridad no mágica. El conjuro Disipar Magia sobre el mensaje lo borra. De lo contrario, el mensaje desaparece tras 24 horas.")

	# ── Instrumento de los Bardos (NUEVO) ────────────────────
	_m("instrumento_de_los_bardos_arpa_anstruth", "Arpa Anstruth", ItemData.Rarity.MUY_RARO, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.SPECIFIC,
		"Conjuros: Volar, Invisibilidad, Levitar, Protección del Bien y el Mal, Curar Heridas nv5, Tormenta de Hielo, Muro de Espinos (1/amanecer c/u)",
		"Un Instrumento de los Bardos es superior a un instrumento ordinario en todos los sentidos. Una criatura que intente tocar el instrumento sin estar sintonizada debe superar una tirada de salvación de Sabiduría CD 15 o recibir 2d4 de daño Psíquico.\n\nPuedes tocar el instrumento para lanzar uno de sus conjuros. Una vez usado para lanzar un conjuro, no puede volver a usarse para lanzar ese conjuro hasta el siguiente amanecer. Conjuros comunes: Volar, Invisibilidad, Levitar, Protección del Bien y el Mal. Conjuros del Arpa Anstruth: Curar Heridas (nivel 5), Tormenta de Hielo, Muro de Espinos.")

	_m("instrumento_de_los_bardos_mandolina_canaith", "Mandolina Canaith", ItemData.Rarity.RARO, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.SPECIFIC,
		"Conjuros: Volar, Invisibilidad, Levitar, Protección del Bien y el Mal, Curar Heridas nv3, Disipar Magia, Protección de Energía (relámpago)",
		"Una Mandolina Canaith es un Instrumento de los Bardos de rareza Rara. Conjuros comunes: Volar, Invisibilidad, Levitar, Protección del Bien y el Mal. Conjuros específicos: Curar Heridas (nivel 3), Disipar Magia, Protección de Energía (solo daño de Relámpago).")

	_m("instrumento_de_los_bardos_lira_cli", "Lira Cli", ItemData.Rarity.RARO, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.SPECIFIC,
		"Conjuros: Volar, Invisibilidad, Levitar, Protección del Bien y el Mal, Dar Forma a la Piedra, Muro de Fuego, Barrera de Viento",
		"Una Lira Cli es un Instrumento de los Bardos de rareza Rara. Conjuros comunes: Volar, Invisibilidad, Levitar, Protección del Bien y el Mal. Conjuros específicos: Dar Forma a la Piedra, Muro de Fuego, Barrera de Viento.")

	_m("instrumento_de_los_bardos_laud_doss", "Laúd Doss", ItemData.Rarity.INFRECUENTE, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.SPECIFIC,
		"Conjuros: Volar, Invisibilidad, Levitar, Protección del Bien y el Mal, Amistad con los Animales, Protección de Energía (fuego), Protección contra el Veneno",
		"Un Laúd Doss es un Instrumento de los Bardos de rareza Infrecuente. Conjuros comunes: Volar, Invisibilidad, Levitar, Protección del Bien y el Mal. Conjuros específicos: Amistad con los Animales, Protección de Energía (solo Fuego), Protección contra el Veneno.")

	_m("instrumento_de_los_bardos_bandore_fochlucan", "Bandore Fochlucan", ItemData.Rarity.INFRECUENTE, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.SPECIFIC,
		"Conjuros: Volar, Invisibilidad, Levitar, Protección del Bien y el Mal, Enredar, Fuego de Hada, Bastón de Madera, Hablar con los Animales",
		"Un Bandore Fochlucan es un Instrumento de los Bardos de rareza Infrecuente. Conjuros comunes: Volar, Invisibilidad, Levitar, Protección del Bien y el Mal. Conjuros específicos: Enredar, Fuego de Hada, Bastón de Madera, Hablar con los Animales.")

	_m("instrumento_de_los_bardos_cistern_mac_fuirmidh", "Cítara Mac-Fuirmidh", ItemData.Rarity.INFRECUENTE, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.SPECIFIC,
		"Conjuros: Volar, Invisibilidad, Levitar, Protección del Bien y el Mal, Corteza, Curar Heridas, Niebla Arcana",
		"Una Cítara Mac-Fuirmidh es un Instrumento de los Bardos de rareza Infrecuente. Conjuros comunes: Volar, Invisibilidad, Levitar, Protección del Bien y el Mal. Conjuros específicos: Corteza, Curar Heridas, Niebla Arcana.")

	_m("instrumento_de_los_bardos_arpa_ollamh", "Arpa Ollamh", ItemData.Rarity.LEGENDARIO, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.SPECIFIC,
		"Conjuros: Volar, Invisibilidad, Levitar, Protección del Bien y el Mal, Confusión, Controlar el Tiempo, Tormenta de Fuego",
		"Un Arpa Ollamh es un Instrumento de los Bardos de rareza Legendaria. Conjuros comunes: Volar, Invisibilidad, Levitar, Protección del Bien y el Mal. Conjuros específicos: Confusión, Controlar el Tiempo, Tormenta de Fuego.")

	# ── Piedra Ioun (NUEVO) ──────────────────────────────────
	_m("piedra_ioun_absorcion", "Piedra Ioun de Absorción", ItemData.Rarity.MUY_RARO, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.ANY,
		"Reacción: anular conjuro de nivel 4 o inferior; 20 niveles antes de apagarse",
		"Mientras este elipsoide lavanda pálido orbita tu cabeza, puedes usar una Reacción para cancelar un conjuro de nivel 4 o inferior lanzado por una criatura que puedas ver. Un conjuro cancelado no tiene efecto. Una vez que ha cancelado 20 niveles de conjuros, se apaga, se vuelve gris opaco y pierde su magia.")

	_m("piedra_ioun_agilidad", "Piedra Ioun de Agilidad", ItemData.Rarity.MUY_RARO, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.ANY,
		"Tu Destreza aumenta en 2 (máx. 20) mientras orbita tu cabeza",
		"Tu Destreza aumenta en 2, hasta un máximo de 20, mientras esta esfera rojo oscuro orbita tu cabeza.")

	_m("piedra_ioun_conciencia", "Piedra Ioun de Conciencia", ItemData.Rarity.RARO, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.ANY,
		"Ventaja en Iniciativa y pruebas de Percepción mientras orbita tu cabeza",
		"Mientras este romboide azul oscuro orbita tu cabeza, tienes Ventaja en los lanzamientos de Iniciativa y en las pruebas de Sabiduría (Percepción).")

	_m("piedra_ioun_fortaleza", "Piedra Ioun de Fortaleza", ItemData.Rarity.MUY_RARO, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.ANY,
		"Tu Constitución aumenta en 2 (máx. 20) mientras orbita tu cabeza",
		"Tu Constitución aumenta en 2, hasta un máximo de 20, mientras este romboide rosado orbita tu cabeza.")

	_m("piedra_ioun_absorcion_mayor", "Piedra Ioun de Gran Absorción", ItemData.Rarity.LEGENDARIO, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.ANY,
		"Reacción: anular conjuro de nivel 8 o inferior; 20 niveles antes de apagarse",
		"Mientras este elipsoide lavanda y verde marmolado orbita tu cabeza, puedes usar una Reacción para cancelar un conjuro de nivel 8 o inferior lanzado por una criatura que puedas ver. Una vez que ha cancelado 20 niveles de conjuros, se apaga y pierde su magia.")

	_m("piedra_ioun_perspicacia", "Piedra Ioun de Perspicacia", ItemData.Rarity.MUY_RARO, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.ANY,
		"Tu Sabiduría aumenta en 2 (máx. 20) mientras orbita tu cabeza",
		"Tu Sabiduría aumenta en 2, hasta un máximo de 20, mientras esta esfera azul incandescente orbita tu cabeza.")

	_m("piedra_ioun_intelecto", "Piedra Ioun de Intelecto", ItemData.Rarity.MUY_RARO, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.ANY,
		"Tu Inteligencia aumenta en 2 (máx. 20) mientras orbita tu cabeza",
		"Tu Inteligencia aumenta en 2, hasta un máximo de 20, mientras esta esfera escarlata y azul marmolada orbita tu cabeza.")

	_m("piedra_ioun_liderazgo", "Piedra Ioun de Liderazgo", ItemData.Rarity.MUY_RARO, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.ANY,
		"Tu Carisma aumenta en 2 (máx. 20) mientras orbita tu cabeza",
		"Tu Carisma aumenta en 2, hasta un máximo de 20, mientras esta esfera rosada y verde marmolada orbita tu cabeza.")

	_m("piedra_ioun_maestria", "Piedra Ioun de Maestría", ItemData.Rarity.LEGENDARIO, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.ANY,
		"Tu Bonificador de Competencia aumenta en 1 mientras orbita tu cabeza",
		"Tu Bonificador de Competencia aumenta en 1 mientras este prisma verde pálido orbita tu cabeza.")

	_m("piedra_ioun_proteccion", "Piedra Ioun de Protección", ItemData.Rarity.RARO, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.ANY,
		"+1 a la Clase de Armadura mientras orbita tu cabeza",
		"Obtienes un bonificador de +1 a la Clase de Armadura mientras este prisma de color rosa polvoriento orbita tu cabeza.")

	_m("piedra_ioun_regeneracion", "Piedra Ioun de Regeneración", ItemData.Rarity.LEGENDARIO, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.ANY,
		"Recuperas 15 PG al final de cada hora que orbite tu cabeza si tienes al menos 1 PG",
		"Recuperas 15 PG al final de cada hora que este huso blanco nacarado orbita tu cabeza, si tienes al menos 1 PG.")

	_m("piedra_ioun_reserva", "Piedra Ioun de Reserva", ItemData.Rarity.RARO, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.ANY,
		"Almacena hasta 4 niveles de conjuros; cualquier lanzador puede cargar conjuros nv1–4 en ella; puedes lanzarlos mientras orbita",
		"Este prisma de color púrpura vibrante almacena conjuros lanzados en él, reteniéndolos hasta que los uses. La piedra puede almacenar hasta 4 niveles de conjuros a la vez. Cuando se encuentra, contiene 1d4 niveles de conjuros almacenados elegidos por el DJ.\n\nCualquier criatura puede lanzar un conjuro de nivel 1 a 4 en la piedra tocándola mientras lanza el conjuro. El conjuro no tiene efecto, salvo que queda almacenado en la piedra. Si la piedra no puede contenerlo, el conjuro se gasta sin efecto. Mientras la piedra orbita tu cabeza, puedes lanzar cualquier conjuro almacenado en ella usando el nivel de espacio, la CD, el bonificador de ataque y la característica de conjuros del lanzador original.")

	_m("piedra_ioun_fuerza", "Piedra Ioun de Fuerza", ItemData.Rarity.MUY_RARO, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.ANY,
		"Tu Fuerza aumenta en 2 (máx. 20) mientras orbita tu cabeza",
		"Tu Fuerza aumenta en 2, hasta un máximo de 20, mientras este romboide azul pálido orbita tu cabeza.")

	_m("piedra_ioun_sustento", "Piedra Ioun de Sustento", ItemData.Rarity.RARO, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.ANY,
		"No necesitas comer ni beber mientras orbita tu cabeza",
		"No necesitas comer ni beber mientras este huso transparente orbita tu cabeza.")

	# ── Bandas de Hierro de Bilarro (NUEVO) ──────────────────
	_m("bandas_de_hierro_de_bilarro", "Bandas de Hierro de Bilarro", ItemData.Rarity.RARO, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.NONE,
		"Acción Mágica: lanzar la esfera a criatura Enorme o menor visible a 18m; tirada de ataque DEX+competencia; golpe → Restringido hasta que la liberes; 1/amanecer",
		"Esta esfera de hierro oxidado mide 7,5 cm de diámetro y pesa 0,5 kg. Puedes realizar una Acción Mágica para lanzar la esfera a una criatura Enorme o más pequeña que puedas ver a menos de 18 m de ti. Al moverse por el aire, la esfera se abre en una maraña de bandas metálicas.\n\nRealiza una tirada de ataque a distancia con un bonificador igual a tu modificador de Destreza más tu Bonificador de Competencia. Si impactas, el objetivo obtiene la condición Restringido hasta que realices una Acción Adicional para ordenar su liberación. Fallar hace que las bandas se contraigan y vuelvan a ser una esfera.\n\nUna criatura que pueda tocar las bandas puede realizar una acción para hacer una prueba de Fuerza (Atletismo) CD 20 para romperlas. Con éxito, el objeto se destruye y la criatura Restringida queda libre. Una vez usadas, las bandas no pueden volver a usarse hasta el siguiente amanecer.")

	# ── Frasco de Hierro (NUEVO) ─────────────────────────────
	_m("frasco_de_hierro", "Frasco de Hierro", ItemData.Rarity.LEGENDARIO, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.NONE,
		"Acción Mágica: atrapar criatura nativa de otro plano (CD 17 SAB) en el frasco; liberar → obedece 1h; capacidad: 1 criatura",
		"Mientras sostienes este frasco de hierro con tapón de latón, puedes realizar una Acción Mágica para elegir una criatura que puedas ver a menos de 18 m. Si el frasco está vacío y el objetivo es nativo de un plano de existencia distinto al que estás, el objetivo debe superar una tirada de salvación de Sabiduría CD 17 o quedar atrapado en el frasco. Una criatura que ya haya sido atrapada por el frasco tiene Ventaja en la tirada. Una vez atrapada, la criatura permanece en el frasco hasta que sea liberada y no envejece.\n\nPuedes realizar una Acción Mágica para retirar el tapón y liberar a la criatura, que obedece tus órdenes durante 1 hora. Al final de la duración actúa según su naturaleza. Si el frasco contiene una criatura y le ordenas hacer algo que probablemente resulte en su muerte, se defiende pero no realiza otras acciones.")

# ============================================================
# DESCRIPCIONES COMPLETAS — LETRA J
# ============================================================

func _register_descriptions_J() -> void:
	# ── Jabalina de Relámpago (NUEVO) ────────────────────────
	_m("jabalina_de_relampago", "Jabalina de Relámpago", ItemData.Rarity.INFRECUENTE, ItemData.ItemType.WEAPON,
		MagicItemData.Attunement.NONE,
		"Cada ataque puede infligir daño de Relámpago en lugar de Perforante; lanzar a <36m: Rayo de 1,5m × 36m (4d6 relámpago CD 13 DES); 1/amanecer",
		"Cada vez que realizas una tirada de ataque con esta arma mágica y golpeas, puedes hacer que infliga daño de Relámpago en lugar de Perforante.\n\nRayo. Cuando lanzas esta arma a un objetivo a no más de 36 m, puedes renunciar a realizar una tirada de ataque y en cambio convertir el arma en un rayo. Este rayo forma una Línea de 1,5 m de ancho entre tú y el objetivo. El objetivo y todas las criaturas en la Línea (excepto tú) realizan una tirada de salvación de Destreza CD 13, sufriendo 4d6 de daño de Relámpago si fallan o la mitad si tienen éxito. Inmediatamente después, el arma reaparece en tu mano. Esta propiedad no puede volver a usarse hasta el siguiente amanecer.")

# ============================================================
# DESCRIPCIONES COMPLETAS — LETRA K
# ============================================================

func _register_descriptions_K() -> void:
	# ── Ungüento de Keoghtom — descripción ───────────────────
	_set_desc("ungüento_de_keoghtom",
		"Este frasco de cristal de 7,5 cm de diámetro contiene 1d4+1 dosis de una mezcla espesa que huele levemente a aloe. El frasco y su contenido pesan 250 g.\n\nComo Acción de Utilizar, puedes tragar una dosis del ungüento o aplicarla a una criatura a menos de 1,5 m de ti. La criatura que lo recibe recupera 2d8+2 PG y deja de tener la condición Envenenado.")

# ============================================================
# DESCRIPCIONES COMPLETAS — LETRA L
# ============================================================

func _register_descriptions_L() -> void:
	# ── Linterna de Revelación (NUEVO) ───────────────────────
	_m("linterna_de_revelacion", "Linterna de Revelación", ItemData.Rarity.INFRECUENTE, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.NONE,
		"Mientras está encendida: Luz Brillante 9m + Tenue 9m; criaturas y objetos invisibles son visibles en la Luz Brillante; puedes bajar la capucha",
		"Mientras está encendida, esta linterna con capucha arde 6 horas con 0,5 litros de aceite, emitiendo Luz Brillante en un radio de 9 m y Luz Tenue en 9 m adicionales. Las criaturas y los objetos invisibles son visibles siempre que estén en la Luz Brillante de la linterna. Puedes realizar una Acción de Utilizar para bajar la capucha, reduciendo la luz de la linterna a Luz Tenue en un radio de 1,5 m.")

	# ── Cerradura de Truco (NUEVO) ───────────────────────────
	_m("cerradura_de_truco", "Cerradura de Truco", ItemData.Rarity.COMUN, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.NONE,
		"Parece una cerradura normal; los tumbleres se ajustan mágicamente: Desventaja en pruebas de Destreza para ganzuarla",
		"Esta cerradura parece una Cerradura normal (del tipo descrito en el capítulo 6 del Manual del Jugador) y viene con una sola llave. Los tumbleres de esta cerradura se ajustan mágicamente para frustrar a los ladrones. Las pruebas de Destreza realizadas para ganzuarla tienen Desventaja.")

	# ── Hoja de la Suerte (NUEVO) ────────────────────────────
	_m("hoja_de_la_suerte", "Hoja de la Suerte", ItemData.Rarity.LEGENDARIO, ItemData.ItemType.WEAPON,
		MagicItemData.Attunement.ANY,
		"+1 ataque/daño y +1 a salvaciones; 1/amanecer repetir tirada D20 fallida (no Incapacitado); 1d3 cargas de Deseo; pierde Deseo si se quedan sin cargas",
		"Obtienes un bonificador de +1 a las tiradas de ataque y de daño realizadas con esta arma mágica. Mientras el arma esté en tu persona, obtienes también un bonificador de +1 a las tiradas de salvación.\n\nSuerte. Si el arma está en tu persona, puedes invocar su suerte (sin acción requerida) para repetir una prueba D20 fallida si no tienes la condición Incapacitado. Debes usar el segundo resultado. Una vez usada esta propiedad, no puede volver a usarse hasta el siguiente amanecer.\n\nDeseo. El arma tiene 1d3 cargas. Mientras la sostienes, puedes gastar 1 carga y lanzar Deseo desde ella. Una vez usada, esta propiedad no puede volver a usarse hasta el siguiente amanecer. El arma pierde esta propiedad si no le quedan cargas.")

	# ── Laúd de Golpeteo Atronador (NUEVO) ───────────────────
	_m("laud_de_golpeteo_atronador", "Laúd de Golpeteo Atronador", ItemData.Rarity.MUY_RARO, ItemData.ItemType.WEAPON,
		MagicItemData.Attunement.NONE,
		"+2d8 daño de Trueno al golpear; si eres Bardo puedes usar mod CARis en lugar de mod FUE al atacar con él",
		"Este laúd reforzado puede blandirse como un mágico Garrote que inflige 2d8 de daño de Trueno adicional al golpear.\n\nCantar y Golpear. Si eres Bardo, puedes usar tu modificador de Carisma en lugar de tu modificador de Fuerza cuando realizas una tirada de ataque cuerpo a cuerpo con el laúd, siempre que cantes o tararees mientras atacas.")

# ============================================================
# DESCRIPCIONES COMPLETAS — LETRA M
# ============================================================

func _register_descriptions_M() -> void:
	# ── Maza de Destrucción — descripción ───────────────────
	_set_desc("maza_de_destruccion",
		"Cuando golpeas a un Infernal o a un No Muerto con esta arma mágica, esa criatura sufre 2d6 de daño Radiante adicional. Si el objetivo tiene 25 PG o menos después de recibir este daño, debe superar una tirada de salvación de Sabiduría CD 15 o ser destruido. Si supera la tirada, obtiene la condición Asustado hasta el final de tu siguiente turno.\n\nLuz. Mientras sostienes esta arma, emite Luz Brillante en un radio de 6 m y Luz Tenue en 6 m adicionales.")

	# ── Maza del Castigo (NUEVO: Mace of Smiting) ────────────
	_m("maza_del_castigo", "Maza del Castigo", ItemData.Rarity.RARO, ItemData.ItemType.WEAPON,
		MagicItemData.Attunement.NONE,
		"+1 ataque/daño (+3 vs Constructos); 20 natural → +7 contundente (o +14 y posible destrucción si Constructo ≤25 PG)",
		"Obtienes un bonificador de +1 a las tiradas de ataque y de daño realizadas con esta arma mágica. El bonificador aumenta a +3 cuando usas el arma para atacar a un Constructo.\n\nCuando sacas un 20 en una tirada de ataque realizada con esta arma, el objetivo sufre 7 de daño Contundente adicional, o 14 de daño Contundente si es un Constructo. Si un Constructo tiene 25 PG o menos después de recibir este daño, es destruido.")

	# ── Maza del Terror — descripción ───────────────────────
	_set_desc("maza_del_terror",
		"Esta arma mágica tiene 3 cargas y recupera 1d3 cargas gastadas diariamente al amanecer. Mientras sostienes el arma, puedes realizar una Acción Mágica y gastar 1 carga para liberar una ola de terror desde ella. Cada criatura de tu elección a menos de 9 m debe superar una tirada de salvación de Sabiduría CD 15 u obtener la condición Asustada durante 1 minuto. Mientras está Asustada, la criatura debe gastar sus turnos intentando alejarse lo más posible de ti y no puede realizar Ataques de Oportunidad. Solo puede usar la acción Correr o intentar escapar de un efecto que le impida moverse. Si no tiene adónde ir, puede usar la acción Esquivar. Al final de cada uno de sus turnos, la criatura repite la tirada, terminando el efecto con éxito.")

	# ── Manto de Resistencia a los Conjuros (NUEVO) ──────────
	_m("manto_de_resistencia_a_los_conjuros", "Manto de Resistencia a los Conjuros", ItemData.Rarity.RARO, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.ANY,
		"Ventaja en tiradas de salvación contra conjuros mientras llevas esta capa",
		"Tienes Ventaja en las tiradas de salvación contra conjuros mientras llevas esta capa.")

	# ── Manual de Salud Corporal (NUEVO) ─────────────────────
	_m("manual_de_salud_corporal", "Manual de Salud Corporal", ItemData.Rarity.MUY_RARO, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.NONE,
		"48h de estudio en 6 días: CON +2 (máx. 30); el libro pierde magia 100 años",
		"Este libro contiene consejos de salud y nutrición, y sus palabras están cargadas de magia. Si pasas 48 horas durante un período de 6 días o menos estudiando el contenido del libro y practicando sus pautas, tu Constitución aumenta en 2, hasta un máximo de 30. El manual pierde entonces su magia pero la recupera en un siglo.")

	# ── Manual de Ejercicio Beneficioso (NUEVO) ──────────────
	_m("manual_de_ejercicio_beneficioso", "Manual de Ejercicio Beneficioso", ItemData.Rarity.MUY_RARO, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.NONE,
		"48h de estudio en 6 días: FUE +2 (máx. 30); el libro pierde magia 100 años",
		"Este libro describe ejercicios de acondicionamiento físico, y sus palabras están cargadas de magia. Si pasas 48 horas durante un período de 6 días o menos estudiando el contenido del libro y practicando sus pautas, tu Fuerza aumenta en 2, hasta un máximo de 30. El manual pierde entonces su magia pero la recupera en un siglo.")

	# ── Manual de Construcción de Gólems (NUEVO) ─────────────
	_m("manual_de_construccion_de_golems", "Manual de Construcción de Gólems", ItemData.Rarity.MUY_RARO, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.NONE,
		"Para lanzadores con 2+ espacios de nv5; crear un gólem (30–120 días, 50.000–100.000 mo); el libro se consume",
		"Este tomo contiene la información y los encantamientos necesarios para fabricar un tipo particular de gólem. Para descifrar y usar el manual, debes ser un lanzador de conjuros con al menos dos espacios de conjuro de nivel 5. Una criatura que no pueda usar el manual e intente leerlo recibe 6d6 de daño Psíquico.\n\nPara crear un gólem, debes pasar el tiempo indicado trabajando sin interrupción con el manual a mano y descansando no más de 8 horas al día, y pagar el coste indicado en suministros. Tipos: Gólem de Arcilla (30 días, 65.000 mo), Gólem de Carne (60 días, 50.000 mo), Gólem de Hierro (120 días, 100.000 mo), Gólem de Piedra (90 días, 80.000 mo). El libro se consume en llamas élficas al terminar.")

	# ── Manual de Rapidez de Acción (NUEVO) ──────────────────
	_m("manual_de_rapidez_de_accion", "Manual de Rapidez de Acción", ItemData.Rarity.MUY_RARO, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.NONE,
		"48h de estudio en 6 días: DES +2 (máx. 30); el libro pierde magia 100 años",
		"Este libro contiene ejercicios de coordinación y equilibrio, y sus palabras están cargadas de magia. Si pasas 48 horas durante un período de 6 días o menos estudiando el contenido del libro y practicando sus pautas, tu Destreza aumenta en 2, hasta un máximo de 30. El manual pierde entonces su magia pero la recupera en un siglo.")

	# ── Armadura del Marinero — descripción ─────────────────
	_set_desc("armadura_del_marinero",
		"Mientras llevas esta armadura, tienes una Velocidad de Natación igual a tu Velocidad. Además, si comienzas tu turno bajo el agua con 0 PG, recuperas inmediatamente 1d4 PG. La armadura no puede curar a nadie de nuevo hasta el siguiente amanecer.\n\nLa armadura está decorada con motivos de peces y conchas.")

	# ── Medallón de los Pensamientos (NUEVO) ─────────────────
	_m("medallon_de_los_pensamientos", "Medallón de los Pensamientos", ItemData.Rarity.INFRECUENTE, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.ANY,
		"5 cargas; gastar 1: Detectar Pensamientos CD 13; recupera 1d4/amanecer",
		"El medallón tiene 5 cargas. Mientras lo llevas, puedes gastar 1 carga para lanzar Detectar Pensamientos (CD de salvación 13) desde él. El medallón recupera 1d4 cargas gastadas diariamente al amanecer.")

	# ── Espejo de Trampa Vital — descripción ────────────────
	_set_desc("espejo_de_trampa_vital",
		"Cuando este espejo de 1,2 m de alto y 60 cm de ancho es visto indirectamente, su superficie muestra imágenes tenues de criaturas. Pesa 22,5 kg y tiene CA 11; PG 10; Inmunidad al daño de Veneno y Psíquico; y Vulnerabilidad al daño Contundente.\n\nSi el espejo está colgado en una superficie vertical y estás a menos de 1,5 m de él, puedes realizar una Acción Mágica y usar una palabra de mando para activarlo. Permanece activo hasta que uses una Acción Mágica y repitas la palabra para desactivarlo.\n\nCualquier criatura que no seas tú que vea su reflejo en el espejo activo a menos de 9 m debe superar una tirada de salvación de Carisma CD 15 o quedar atrapada, junto con todo lo que lleve puesto, en una de las doce celdas extradimensionales del espejo.\n\nUna celda extradimensional es una extensión infinita llena de niebla espesa que reduce la visibilidad a 3 m. Las criaturas atrapadas no envejecen ni necesitan comer, beber o dormir. Solo pueden escapar con magia de viaje planar.\n\nSi el espejo se hace añicos, todas las criaturas que contiene son liberadas.")

	# ── Armadura de Mithral — descripción ───────────────────
	_set_desc("armadura_de_mithral",
		"El mithral es un metal ligero y flexible. La armadura fabricada con esta sustancia puede llevarse debajo de ropa normal. Si la armadura normalmente impone Desventaja en las pruebas de Destreza (Sigilo) o tiene un requisito de Fuerza, la versión de mithral de la armadura no tiene ninguno de esos requisitos.")

	# ── Hoja de Luna (NUEVO) ─────────────────────────────────
	_m("hoja_de_luna", "Hoja de Luna", ItemData.Rarity.LEGENDARIO, ItemData.ItemType.WEAPON,
		MagicItemData.Attunement.ANY,
		"Legendaria; elegida por el arma; +1 ataque/daño (hasta +3 con runas); runas adicionales con propiedades variables; sentiente NE de alineamiento del creador",
		"De todas las armas mágicas creadas por los elfos, una de las más apreciadas es una Hoja de Luna. En tiempos antiguos, casi todas las casas nobles élficas poseían una. Con el tiempo, algunas han desaparecido.\n\nCada Hoja de Luna desea un portador cuya disposición y objetivos sean compatibles con los suyos. Si intentas sintonizarte con una que no te quiere, el arma te maldice: Desventaja en pruebas D20 durante 24 horas.\n\nUna Hoja de Luna tiene una runa por cada portador al que ha servido voluntariamente (normalmente 1d6+1). La primera runa otorga +1 a las tiradas de ataque y de daño. Cada runa adicional otorga una propiedad adicional (1d100): 01–60 aumentar bonificador de ataque hasta +3; 61–75 +1d6 de daño de Fuerza por impacto; 76–80 propiedad Arrojadiza; 81–85 crítico en 19–20; 86–95 cegar criaturas en 9m (Acción Adicional, CD 15 CON, 1/descanso); 96–99 propiedades de Anillo de Almacenamiento de Conjuros; 00 convocar entidad espectral como Sombra (Feérico, Neutral, actúa bajo tu mando).\n\nSentiencia: INT 12, SAB 10, CAR 12. Visión Oscura 36 m. Comunica por emociones y visiones.")

	# ── Espada Tocada por la Luna (NUEVO) ────────────────────
	_m("espada_tocada_por_la_luna", "Espada Tocada por la Luna", ItemData.Rarity.COMUN, ItemData.ItemType.WEAPON,
		MagicItemData.Attunement.NONE,
		"En Oscuridad: la hoja desenvainada emite luz de luna (Luz Brillante 4,5m + Tenue 4,5m)",
		"En Oscuridad, la hoja desenvainada de esta arma emite luz de luna, creando Luz Brillante en un radio de 4,5 m y Luz Tenue en 4,5 m adicionales.")

	# ── Llave Misteriosa (NUEVO) ─────────────────────────────
	_m("llave_misteriosa", "Llave Misteriosa", ItemData.Rarity.COMUN, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.NONE,
		"5% de probabilidad de abrir cualquier cerradura en la que se inserte; luego desaparece",
		"Un signo de interrogación está tallado en la cabeza de esta llave. La llave tiene un 5% de probabilidad de abrir cualquier cerradura en la que se inserte. Una vez que abre algo, la llave desaparece.")

# ============================================================
# DESCRIPCIONES COMPLETAS — LETRA N
# ============================================================

func _register_descriptions_N() -> void:
	# ── Manto de la Naturaleza (NUEVO) ───────────────────────
	_m("manto_de_la_naturaleza", "Manto de la Naturaleza", ItemData.Rarity.INFRECUENTE, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.SPECIFIC,
		"Foco para conjuros de Druida y Explorador; en área Ligeramente Oscurecida: esconderse como Acción Adicional incluso si te observan directamente",
		"Esta capa cambia de color y textura para mimetizarse con el terreno que te rodea. Mientras la llevas, puedes usarla como Foco de Conjuros para tus conjuros de Druida y Explorador.\n\nMientras estés en un área Ligeramente Oscurecida, puedes Esconderte como Acción Adicional aunque estés siendo observado directamente.")

	# ── Collar de Adaptación (NUEVO) ─────────────────────────
	_m("collar_de_adaptacion", "Collar de Adaptación", ItemData.Rarity.INFRECUENTE, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.ANY,
		"Puedes respirar normalmente en cualquier ambiente; Ventaja en saves para evitar/terminar la condición Envenenado",
		"Mientras llevas este collar, puedes respirar normalmente en cualquier ambiente, y tienes Ventaja en las tiradas de salvación realizadas para evitar o terminar la condición Envenenado.")

	# ── Collar de Bolas de Fuego (NUEVO) ─────────────────────
	_m("collar_de_bolas_de_fuego", "Collar de Bolas de Fuego", ItemData.Rarity.RARO, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.NONE,
		"1d6+3 cuentas; Acción Mágica: lanzar 1+ cuentas a 18m → Bola de Fuego nv3 CD 15 (+1d6/cuenta adicional, máx. 12d6)",
		"Este collar tiene 1d6+3 cuentas colgando de él. Puedes realizar una Acción Mágica para desprencer una cuenta y lanzarla hasta 18 m. Cuando llega al final de su trayectoria, la cuenta detona como una Bola de Fuego de nivel 3 (CD de salvación 15).\n\nPuedes lanzar varias cuentas, o incluso el collar entero, a la vez. Cuando lo haces, aumenta el daño de la Bola de Fuego en 1d6 por cada cuenta adicional (máximo 12d6).")

	# ── Collar de Cuentas de Oración (NUEVO) ─────────────────
	_m("collar_de_cuentas_de_oracion", "Collar de Cuentas de Oración", ItemData.Rarity.RARO, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.SPECIFIC,
		"1d4+2 cuentas mágicas; gastar 1 como Acción Adicional para lanzar conjuro; 1/amanecer cada cuenta",
		"Este collar tiene 1d4+2 cuentas mágicas hechas de aguamarina, perla negra o topacio. También tiene muchas cuentas no mágicas. Para usar una, debes llevar el collar. Cada cuenta contiene un conjuro que puedes lanzar como Acción Adicional usando tu CD de salvación. Una vez lanzado, esa cuenta no puede volver a usarse hasta el siguiente amanecer.\n\nTipos de cuentas (1d20): 1–6 Bendición; 7–12 Curar Heridas (nivel 2); 13–16 Restauración Mayor; 17–18 Resplandor Sagrado; 19 Guardián de la Fe; 20 Caminar sobre el Viento.")

	# ── Roba-Nueve-Vidas (NUEVO) ─────────────────────────────
	_m("roba_nueve_vidas", "Roba-Nueve-Vidas", ItemData.Rarity.MUY_RARO, ItemData.ItemType.WEAPON,
		MagicItemData.Attunement.ANY,
		"+2 ataque/daño; 1d8+1 cargas: si objetivo <100 PG y sacas 20 → CD 15 CON o muere (pierde 1 carga)",
		"Obtienes un bonificador de +2 a las tiradas de ataque y de daño realizadas con esta arma mágica.\n\nRobo de Vida. El arma tiene 1d8+1 cargas. Cuando atacas a una criatura con menos de 100 PG con esta arma y sacas un 20 en el d20, la criatura debe superar una tirada de salvación de Constitución CD 15 o ser abatida instantáneamente. Los Constructos y los No Muertos superan la tirada automáticamente. El arma pierde 1 carga si la criatura es abatida. Cuando al arma no le quedan cargas, pierde esta propiedad.")

	# ── Pigmentos Maravillosos de Nolzur (NUEVO) ─────────────
	_m("pigmentos_maravillosos_de_nolzur", "Pigmentos Maravillosos de Nolzur", ItemData.Rarity.MUY_RARO, ItemData.ItemType.CONSUMABLE,
		MagicItemData.Attunement.NONE,
		"1d4 botes + pincel; usar 1 bote: pintar objetos 3D en 6m³ durante 10 min (Concentración) → se vuelven reales; máx. 500 mo de valor total",
		"Esta caja de madera fina contiene 1d4 botes de pigmento y un pincel (peso total 0,5 kg).\n\nUsando el pincel y gastando 1 bote de pigmento, puedes pintar cualquier número de objetos tridimensionales y elementos de terreno (paredes, puertas, árboles, flores, armas, telarañas y fosos), siempre que todos estén confinados en un Cubo de 6 m. El proceso lleva 10 minutos (independientemente del número de elementos), durante los cuales debes permanecer en el Cubo, y requiere Concentración.\n\nCuando el trabajo está hecho, todos los objetos y elementos pintados se vuelven reales. Pintar una puerta en una pared crea una puerta real que puede abrirse. Pintar un foso crea un foso real.\n\nNingún objeto creado puede tener un valor superior a 25 mo, y el valor total de todos los objetos creados por un bote no puede superar los 500 mo. Si pinta objetos de mayor valor, parecen auténticos, pero una inspección cercana revela que están hechos de pasta u otro material sin valor.\n\nSi pinta una forma de energía como fuego o relámpago, la energía se disipa en cuanto terminas el cuadro, sin causar daño.")

# ============================================================
# DESCRIPCIONES COMPLETAS — LETRA O
# ============================================================

func _register_descriptions_O() -> void:
	# ── Oathbow — descripción ────────────────────────────────
	_set_desc("oathbow",
		"Cuando encasillas una flecha en este arco, susurra en élfico: «Derrota veloz a mis enemigos». Cuando usas esta arma para realizar un ataque a distancia, puedes pronunciar las palabras de mando: «Muerte veloz a quien me ha agraviado». El objetivo de tu ataque se convierte en tu enemigo jurado hasta que muera o amanezca 7 días después. Solo puedes tener un enemigo jurado a la vez.\n\nCuando realizas una tirada de ataque a distancia con esta arma contra tu enemigo jurado, tienes Ventaja en la tirada. Además, tu objetivo no se beneficia de Cobertura Parcial ni de Cobertura de Tres Cuartos, y no sufres Desventaja por distancia larga. Si el ataque impacta, tu enemigo jurado sufre 3d6 de daño Perforante adicional.\n\nMientras tu enemigo jurado viva, tienes Desventaja en las tiradas de ataque con todas las demás armas.")

	# ── Aceite de Etereidad (NUEVO) ──────────────────────────
	_m("aceite_de_etereidad", "Aceite de Etereidad", ItemData.Rarity.RARO, ItemData.ItemType.CONSUMABLE,
		MagicItemData.Attunement.NONE,
		"1 vial cubre criatura Mediana o menor; aplicar en 10 min → efecto Forma Etérea durante 1h",
		"Un vial de este aceite puede cubrir una criatura Mediana o más pequeña, junto con el equipo que lleva puesto y carga (se necesita un vial adicional por cada categoría de tamaño superior a Mediano). Aplicar el aceite lleva 10 minutos. La criatura afectada obtiene entonces el efecto del conjuro Forma Etérea durante 1 hora.\n\nSe forman gotas de este aceite gris nublado en el exterior de su recipiente y se evaporan rápidamente.")

	# ── Aceite de Nitidez — descripción ─────────────────────
	_set_desc("aceite_de_nitidez",
		"Un vial de este aceite puede cubrir un arma Cuerpo a Cuerpo o veinte piezas de munición, pero solo munición y armas Cuerpo a Cuerpo que no sean mágicas y que infligian daño Cortante o Perforante son afectadas. Aplicar el aceite lleva 1 minuto, tras lo cual el aceite se filtra mágicamente en lo que recubre, convirtiendo el arma cubierta en un Arma +3 o la munición cubierta en Munición +3.\n\nEste aceite transparente y gelatinoso brilla con pequeños fragmentos ultrafinos de plata.")

	# ── Aceite de Deslizamiento (NUEVO) ──────────────────────
	_m("aceite_de_deslizamiento", "Aceite de Deslizamiento", ItemData.Rarity.INFRECUENTE, ItemData.ItemType.CONSUMABLE,
		MagicItemData.Attunement.NONE,
		"1 vial cubre criatura Mediana o menor; efecto Libertad de Movimiento 8h; o verter en suelo → cuadrado 3m de Engrasar 8h",
		"Un vial de este aceite puede cubrir una criatura Mediana o más pequeña, junto con el equipo que lleva puesto y carga. Aplicar el aceite lleva 10 minutos. La criatura afectada obtiene entonces el efecto del conjuro Libertad de Movimiento durante 8 horas.\n\nAlternativamente, el aceite puede verterse en el suelo como Acción Mágica, donde cubre un cuadrado de 3 m duplicando el efecto del conjuro Engrasar en esa área durante 8 horas.")

	# ── Orbe de Dirección (NUEVO) ────────────────────────────
	_m("orbe_de_direccion", "Orbe de Dirección", ItemData.Rarity.COMUN, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.NONE,
		"Puede usarse como Foco Arcano; Acción Mágica: determinar el norte magnético",
		"Este orbe puede usarse como Foco Arcano.\n\nMientras sostienes este orbe, puedes realizar una Acción Mágica para determinar cuál es el norte magnético. No sucede nada si el orbe se usa en un lugar que no tiene norte magnético.")

	# ── Orbe del Dragón (NUEVO) ──────────────────────────────
	_m("orbe_del_dragon", "Orbe del Dragón", ItemData.Rarity.LEGENDARIO, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.ANY,
		"Artefacto: controlar el orbe (CD 15 CAR o ser Encantado); conjuros (7 cargas, CD 18); Convocar Dragones 40 millas 1/hora",
		"Hace mucho tiempo, en el escenario de Dragonlance, elfos y humanos libraron una terrible guerra contra dragones cromáticos. Cuando el mundo parecía condenado, los magos de las Torres de Alta Hechicería se reunieron y forjaron cinco Orbes del Dragón. Cada orbe contiene la esencia de un dragón malvado.\n\nMientras estés sintonizado con un orbe, puedes realizar una Acción Mágica para observar su interior. Debes hacer una tirada de salvación de Carisma CD 15. Con éxito, controlas el orbe mientras permanezcas sintonizado. Con un fallo, el orbe te impone la condición Encantado.\n\nMientras estás Encantado por el orbe, no puedes terminar voluntariamente tu sintonización, y el orbe lanza Sugestión sobre ti a voluntad (CD 18), instándote a trabajar hacia sus fines.\n\nConjuros (7 cargas, CD 18): Curar Heridas nv9 (4), Luz Diurna (1), Escudo de la Muerte (2), Detectar Magia (0), Escrutinio CD 18 (3).\n\nConvocar Dragones. Puedes realizar una Acción Mágica para hacer que el orbe emita una llamada telepática que se extiende 64 km en todas direcciones. Los dragones cromáticos en el área sienten la compulsión de venir al orbe. Una vez usada esta propiedad, no puede volver a usarse durante 1 hora.\n\nDestrucción: el Orbe tiene CA 20 y se destruye si recibe daño de un Arma +3 o del conjuro Desintegrar.")

	# ── Orbe del Tiempo (NUEVO) ──────────────────────────────
	_m("orbe_del_tiempo", "Orbe del Tiempo", ItemData.Rarity.COMUN, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.NONE,
		"Puede usarse como Foco Arcano; Acción Mágica: determinar si es mañana, tarde, noche o noche cerrada (solo en Plano Material)",
		"Este orbe puede usarse como Foco Arcano.\n\nMientras sostienes el orbe, puedes realizar una Acción Mágica para determinar si es por la mañana, por la tarde, por la noche o de noche. Esta propiedad solo funciona en el Plano Material.")

# ============================================================
# DESCRIPCIONES COMPLETAS — LETRA P
# ============================================================

func _register_descriptions_P() -> void:
	_set_desc("perla_de_poder",
		"Mientras esta perla esté en tu persona, puedes realizar una Acción Mágica para recuperar un espacio de conjuro gastado de nivel 3 o inferior. Una vez usada la perla, no puede volver a usarse hasta el siguiente amanecer.")
	_set_desc("armadura_de_placas_de_la_etereidad",
		"Mientras llevas esta armadura, puedes realizar una Acción Mágica y usar una palabra de mando para obtener el efecto del conjuro Forma Etérea. El conjuro termina inmediatamente si te quitas la armadura o repites la palabra de mando. Esta propiedad no puede usarse de nuevo hasta el siguiente amanecer.")
	_set_desc("agujero_portatil",
		"Este fino paño negro, suave como la seda, está doblado hasta las dimensiones de un pañuelo. Se despliega en una lámina circular de 1,8 m de diámetro.\n\nPuedes realizar una Acción Mágica para desplegar el Agujero Portátil y colocarlo sobre una superficie sólida, creando un agujero extradimensional de 3 m de profundidad. El espacio cilíndrico existe en otro plano de existencia. Puedes cerrarlo tomando los bordes y doblándolo.\n\nSi el agujero se coloca dentro de un espacio extradimensional creado por una Bolsa de Contención, Mochila Práctica o similar, ambos objetos se destruyen y se abre una puerta al Plano Astral.")
	_set_desc("pocion_de_curacion",
		"Recuperas 2d4+2 PG al beber esta poción. El líquido rojo brilla cuando se agita.")
	_set_desc("pocion_de_curacion_mayor",
		"Recuperas 4d4+4 PG al beber esta poción. El líquido rojo brilla cuando se agita.")
	_set_desc("pocion_de_curacion_superior",
		"Recuperas 8d4+8 PG al beber esta poción. El líquido rojo brilla cuando se agita.")
	_set_desc("pocion_de_curacion_suprema",
		"Recuperas 10d4+20 PG al beber esta poción. El líquido rojo brilla cuando se agita.")
	_set_desc("pocion_de_heroismo",
		"Al beber esta poción, ganas 10 PG temporales que duran 1 hora. Durante el mismo tiempo, estás bajo el efecto del conjuro Bendición (sin Concentración). El líquido azul burbujea y humea como si hirviera.")
	_set_desc("pocion_de_velocidad",
		"Al beber esta poción, obtienes el efecto del conjuro Celeridad durante 1 minuto (sin Concentración) sin sufrir la ola de letargo que suele seguir al efecto. El líquido amarillo está rayado de negro y gira solo.")
	_set_desc("pocion_de_invisibilidad",
		"El recipiente parece vacío pero se siente como si contuviera líquido. Al beberla, tienes la condición Invisible durante 1 hora. El efecto termina antes si realizas una tirada de ataque, infliges daño o lanzas un conjuro.")
	_set_desc("pocion_de_gran_invisibilidad",
		"El recipiente parece vacío pero se siente como si contuviera líquido. Al beberla, tienes la condición Invisible durante 1 hora. A diferencia de la invisibilidad normal, el efecto no termina al atacar o lanzar conjuros.")
	_set_desc("pocion_de_vuelo",
		"Al beber esta poción, obtienes una Velocidad de Vuelo igual a tu Velocidad durante 1 hora y puedes planear. Si estás en el aire cuando el efecto termina, caes a menos que tengas otro medio de mantenerte aloft. El líquido claro flota en la parte superior con impurezas blancas nubladas.")
	_set_desc("pocion_de_vitalidad",
		"Al beber esta poción, elimina todos tus niveles de Agotamiento y termina la condición Envenenado. Durante las siguientes 24 horas, recuperas el número máximo de PG por cada Dado de Golpe que gastes. El líquido carmesí pulsa con una luz tenue.")
	_set_desc("pocion_de_resistencia",
		"Al beber esta poción, tienes Resistencia a un tipo de daño durante 1 hora. El DJ elige el tipo o lo determina al azar: ácido, frío, fuego, fuerza, relámpago, necrótico, veneno, psíquico, radiante o trueno.")
	_m("perfume_de_fascinacion", "Perfume de Fascinación", ItemData.Rarity.COMUN, ItemData.ItemType.CONSUMABLE,
		MagicItemData.Attunement.NONE,
		"Aplicar 1 uso: Ventaja en Engaño y Persuasión vs criaturas a 1,5m durante 1h",
		"Este pequeño frasco contiene perfume mágico suficiente para un uso. Puedes realizar una Acción Mágica para aplicarte el perfume; su efecto dura 1 hora. Durante ese tiempo, tienes Ventaja en todas las pruebas de Carisma (Engaño y Persuasión) para influir en una criatura a menos de 1,5 m de ti.")
	_m("colgante_de_salud", "Colgante de Salud", ItemData.Rarity.INFRECUENTE, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.ANY,
		"Acción Mágica: recuperar 2d4+2 PG 1/amanecer; Ventaja en salvaciones vs Envenenado",
		"Mientras llevas este colgante, puedes realizar una Acción Mágica para recuperar 2d4+2 PG. Una vez usada esta propiedad, no puede volver a usarse hasta el siguiente amanecer.\n\nAdemás, tienes Ventaja en las tiradas de salvación para evitar o terminar la condición Envenenado mientras llevas el colgante.")
	_m("colgante_prueba_veneno", "Colgante de Prueba contra el Veneno", ItemData.Rarity.RARO, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.ANY,
		"Inmunidad a la condición Envenenado y al daño de Veneno",
		"Esta delicada cadena de plata tiene un colgante de gema negra de talla brillante. Mientras la llevas, tienes Inmunidad a la condición Envenenado y al daño de Veneno.")
	_m("colgante_cierre_heridas", "Colgante de Cierre de Heridas", ItemData.Rarity.INFRECUENTE, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.ANY,
		"Tiradas de muerte: resultado 9 o menos se convierte en 10; dados de golpe curan el doble",
		"Mientras llevas este colgante, obtienes los siguientes beneficios:\n\nPreservación de Vida. Cada vez que hagas una Tirada de Muerte, puedes cambiar un resultado de 9 o inferior a 10, convirtiendo un fallo en éxito.\nCuración Natural Mejorada. Cada vez que tires un Dado de Golpe para recuperar PG, doblas el número de PG que restaura.")
	_m("filtro_de_amor", "Filtro de Amor", ItemData.Rarity.INFRECUENTE, ItemData.ItemType.CONSUMABLE,
		MagicItemData.Attunement.NONE,
		"La próxima criatura que veas en 10min tras beberlo te Encanta durante 1h",
		"La próxima vez que veas a una criatura en los 10 minutos siguientes a beber este filtro, quedas Encantado por esa criatura y tienes la condición Encantado durante 1 hora. Este líquido rosado y efervescente contiene una burbuja con forma de corazón.")
	_m("pipa_de_monstruos_de_humo", "Pipa de Monstruos de Humo", ItemData.Rarity.COMUN, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.NONE,
		"Fumándola, Acción Mágica: exhalar una nube de humo con forma de criatura (cabe en cubo de 30cm)",
		"Mientras fumas esta pipa, puedes realizar una Acción Mágica para exhalar una bocanada de humo con la forma de una criatura, como un dragón, una flumph o un slaad. La forma debe caber en un cubo de 30 cm y pierde su forma tras unos segundos, convirtiéndose en una bocanada ordinaria de humo.")
	_m("pipas_del_terror", "Pipas del Terror", ItemData.Rarity.INFRECUENTE, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.NONE,
		"3 cargas; tocar: criaturas a elección en 9m → Asustadas 1min (CD 15 SAB) si fallan",
		"Estas pipas tienen 3 cargas y recuperan 1d3 cargas gastadas diariamente al amanecer. Puedes realizar una Acción Mágica para tocarlas y gastar 1 carga creando una melodía espeluznante. Cada criatura a tu elección a menos de 9 m de ti debe superar una tirada de salvación de Sabiduría CD 15 o tener la condición Asustado durante 1 minuto. Una criatura que falle repite la salvación al final de cada uno de sus turnos, terminando el efecto en sí misma con éxito. Una criatura que tenga éxito es inmune al efecto de estas pipas durante 24 horas.")
	_m("pipas_de_las_alcantarillas", "Pipas de las Alcantarillas", ItemData.Rarity.INFRECUENTE, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.ANY,
		"3 cargas; tocar como AM + AB gastar 1-3 cargas: convocar Enjambre de Ratas por carga; controlar enjambres amistosos",
		"Mientras estas pipas estén en tu persona, las ratas ordinarias y las ratas gigantes son Indiferentes hacia ti.\n\nLas pipas tienen 3 cargas y recuperan 1d3 gastadas al amanecer. Si tocas las pipas como Acción Mágica, puedes usar una Acción Adicional para gastar 1-3 cargas, convocando un Enjambre de Ratas por carga gastada si hay suficientes ratas a menos de 800 m.\n\nCada vez que un Enjambre de Ratas no controlado llega a menos de 9 m mientras tocas, hace una tirada de salvación de Sabiduría CD 15. Si falla, el enjambre se vuelve Amistoso mientras sigas tocando. Los enjambres amistosos obedecen tus órdenes.")
	_m("palo_de_pesca", "Palo de Pesca", ItemData.Rarity.COMUN, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.NONE,
		"Funciona como vara; Acción Mágica: se transforma en caña de pescar con anzuelo y carrete",
		"Este objeto funciona como una vara. Mientras lo sostienes, puedes realizar una Acción Mágica para transformarlo en una caña de pescar con anzuelo, sedal y carrete, o para que la caña vuelva a ser una vara.")
	_m("palo_plegable", "Palo Plegable", ItemData.Rarity.COMUN, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.NONE,
		"Funciona como vara; Acción Mágica: se colapsa a 30cm para guardar, o vuelve a vara",
		"Este objeto funciona como una vara. Mientras lo sostienes, puedes realizar una Acción Mágica para colapsarlo hasta un bastón de 30 cm (el peso no cambia) o para que el bastón vuelva a ser una vara. El bastón solo se alarga hasta donde el espacio circundante lo permita.")
	_m("pocion_de_amistad_animal", "Poción de Amistad Animal", ItemData.Rarity.INFRECUENTE, ItemData.ItemType.CONSUMABLE,
		MagicItemData.Attunement.NONE,
		"Al beberla: lanzas Amistad con los Animales nv3 (CD 13)",
		"Al beber esta poción, puedes lanzar la versión de nivel 3 del conjuro Amistad con los Animales (CD salvación 13). Agitar el líquido turbio de la poción revela pequeños fragmentos: una escama de pez, una pluma de colibrí, una garra de gato o un pelo de ardilla.")
	_m("pocion_de_clarividencia", "Poción de Clarividencia", ItemData.Rarity.RARO, ItemData.ItemType.CONSUMABLE,
		MagicItemData.Attunement.NONE,
		"Al beberla: efecto del conjuro Clarividencia sin Concentración",
		"Al beber esta poción, obtienes el efecto del conjuro Clarividencia (sin Concentración requerida). Un globo ocular flota en el líquido amarillento pero desaparece cuando se abre la poción.")
	_m("pocion_de_escalar", "Poción de Escalar", ItemData.Rarity.COMUN, ItemData.ItemType.CONSUMABLE,
		MagicItemData.Attunement.NONE,
		"Velocidad de Escalar = Velocidad durante 1h; Ventaja en pruebas de Atletismo para trepar",
		"Al beber esta poción, obtienes una Velocidad de Escalar igual a tu Velocidad durante 1 hora. Durante ese tiempo, tienes Ventaja en las pruebas de Fuerza (Atletismo) para trepar. El líquido está separado en capas marrón, plateada y gris.")
	_m("pocion_de_comprension", "Poción de Comprensión", ItemData.Rarity.COMUN, ItemData.ItemType.CONSUMABLE,
		MagicItemData.Attunement.NONE,
		"Al beberla: efecto de Comprender Idiomas durante 1h",
		"Al beber esta poción, obtienes el efecto del conjuro Comprender Idiomas durante 1 hora. El líquido claro contiene fragmentos de sal y hollín arremolinados.")
	_m("pocion_de_disminucion", "Poción de Disminución", ItemData.Rarity.RARO, ItemData.ItemType.CONSUMABLE,
		MagicItemData.Attunement.NONE,
		"Efecto 'reducir' de Agrandar/Reducir durante 1d4h (sin Concentración)",
		"Al beber esta poción, obtienes el efecto de 'reducir' del conjuro Agrandar/Reducir durante 1d4 horas (sin Concentración requerida). El líquido rojo de la poción se contrae continuamente a un punto y luego se expande.")
	_m("pocion_de_aliento_de_fuego", "Poción de Aliento de Fuego", ItemData.Rarity.INFRECUENTE, ItemData.ItemType.CONSUMABLE,
		MagicItemData.Attunement.NONE,
		"Acción Adicional: exhalar fuego a objetivo a 9m (4d6 fuego CD 13 DES); 3 usos o 1h",
		"Tras beber esta poción, puedes usar una Acción Adicional para exhalar fuego hacia un objetivo a menos de 9 m. El objetivo hace una tirada de salvación de Destreza CD 13, sufriendo 4d6 daño de Fuego si falla o la mitad si tiene éxito. El efecto termina tras exhalar fuego tres veces o cuando pase 1 hora. El líquido naranja parpadea y el humo llena la parte superior del recipiente.")
	_m("pocion_de_forma_gaseosa", "Poción de Forma Gaseosa", ItemData.Rarity.RARO, ItemData.ItemType.CONSUMABLE,
		MagicItemData.Attunement.NONE,
		"Efecto Forma Gaseosa durante 1h (sin Concentración); termina con Acción Adicional",
		"Al beber esta poción, obtienes el efecto del conjuro Forma Gaseosa durante 1 hora (sin Concentración requerida) o hasta que termines el efecto como Acción Adicional. El recipiente parece contener niebla que se mueve como agua.")
	_m("pocion_de_fuerza_de_gigante_colina", "Poción de Fuerza de Gigante (colina)", ItemData.Rarity.INFRECUENTE, ItemData.ItemType.CONSUMABLE,
		MagicItemData.Attunement.NONE, "FUE 21 durante 1h", "Tu puntuación de Fuerza cambia a 21 durante 1 hora. Sin efecto si tu FUE ya es 21+.")
	_m("pocion_de_fuerza_de_gigante_escarcha", "Poción de Fuerza de Gigante (escarcha)", ItemData.Rarity.RARO, ItemData.ItemType.CONSUMABLE,
		MagicItemData.Attunement.NONE, "FUE 23 durante 1h", "Tu puntuación de Fuerza cambia a 23 durante 1 hora. Sin efecto si tu FUE ya es 23+.")
	_m("pocion_de_fuerza_de_gigante_fuego", "Poción de Fuerza de Gigante (fuego)", ItemData.Rarity.RARO, ItemData.ItemType.CONSUMABLE,
		MagicItemData.Attunement.NONE, "FUE 25 durante 1h", "Tu puntuación de Fuerza cambia a 25 durante 1 hora. Sin efecto si tu FUE ya es 25+.")
	_m("pocion_de_fuerza_de_gigante_nube", "Poción de Fuerza de Gigante (nube)", ItemData.Rarity.MUY_RARO, ItemData.ItemType.CONSUMABLE,
		MagicItemData.Attunement.NONE, "FUE 27 durante 1h", "Tu puntuación de Fuerza cambia a 27 durante 1 hora. Sin efecto si tu FUE ya es 27+.")
	_m("pocion_de_fuerza_de_gigante_tormenta", "Poción de Fuerza de Gigante (tormenta)", ItemData.Rarity.LEGENDARIO, ItemData.ItemType.CONSUMABLE,
		MagicItemData.Attunement.NONE, "FUE 29 durante 1h", "Tu puntuación de Fuerza cambia a 29 durante 1 hora. Sin efecto si tu FUE ya es 29+.")
	_m("pocion_de_crecimiento", "Poción de Crecimiento", ItemData.Rarity.INFRECUENTE, ItemData.ItemType.CONSUMABLE,
		MagicItemData.Attunement.NONE,
		"Efecto 'agrandar' de Agrandar/Reducir durante 10min (sin Concentración)",
		"Al beber esta poción, obtienes el efecto de 'agrandar' del conjuro Agrandar/Reducir durante 10 minutos (sin Concentración requerida). El líquido rojo se expande continuamente desde un punto y luego se contrae.")
	_m("pocion_de_invulnerabilidad", "Poción de Invulnerabilidad", ItemData.Rarity.RARO, ItemData.ItemType.CONSUMABLE,
		MagicItemData.Attunement.NONE,
		"Resistencia a todo el daño durante 1 minuto",
		"Durante 1 minuto tras beber esta poción, tienes Resistencia a todo el daño. El líquido siruposo de esta poción parece hierro licuado.")
	_m("pocion_de_longevidad", "Poción de Longevidad", ItemData.Rarity.MUY_RARO, ItemData.ItemType.CONSUMABLE,
		MagicItemData.Attunement.NONE,
		"Edad física -1d6+6 años (mín. 13); cada uso posterior: 10% acumulativo de envejecer en vez de rejuvenecer",
		"Al beber esta poción, tu edad física se reduce en 1d6+6 años, hasta un mínimo de 13 años. Cada vez que bebas una Poción de Longevidad posteriormente, hay un 10% acumulativo de que en su lugar envejezcas 1d6+6 años. Suspendido en el líquido ámbar hay un pequeño corazón que, contra toda razón, sigue latiendo.")
	_m("pocion_de_lectura_mental", "Poción de Lectura Mental", ItemData.Rarity.RARO, ItemData.ItemType.CONSUMABLE,
		MagicItemData.Attunement.NONE,
		"Efecto Detectar Pensamientos (CD 13) durante 10min (sin Concentración)",
		"Al beber esta poción, obtienes el efecto del conjuro Detectar Pensamientos (CD salvación 13) durante 10 minutos (sin Concentración requerida). El líquido denso y púrpura tiene una nube ovalada de rosa flotando en él.")
	_m("pocion_de_veneno", "Poción de Veneno", ItemData.Rarity.INFRECUENTE, ItemData.ItemType.CONSUMABLE,
		MagicItemData.Attunement.NONE,
		"Parece una poción beneficiosa; al beberla: 4d6 veneno + CD 13 CON o Envenenado 1h",
		"Esta mezcla parece, huele y sabe como una Poción de Curación u otra poción beneficiosa. Sin embargo, es en realidad veneno enmascarado por magia ilusoria. Identificar revela su verdadera naturaleza.\n\nSi bebes esta poción, sufres 4d6 daño de Veneno y debes superar una tirada de salvación de Constitución CD 13 o tener la condición Envenenado durante 1 hora.")
	_m("pocion_de_pugilismo", "Poción de Pugilismo", ItemData.Rarity.INFRECUENTE, ItemData.ItemType.CONSUMABLE,
		MagicItemData.Attunement.NONE,
		"Golpes Desarmados infligen 1d6 daño de Fuerza extra durante 10 minutos",
		"Tras beber esta poción, cada Golpe Desarmado que realices inflige 1d6 daño de Fuerza adicional en un impacto. Este efecto dura 10 minutos. Esta poción es un líquido verde espeso que sabe a espinacas.")
	_m("pocion_de_respiracion_acuatica", "Poción de Respiración Acuática", ItemData.Rarity.INFRECUENTE, ItemData.ItemType.CONSUMABLE,
		MagicItemData.Attunement.NONE,
		"Puedes respirar bajo el agua durante 24 horas",
		"Puedes respirar bajo el agua durante 24 horas tras beber esta poción. El líquido verde nublado huele a mar y tiene una burbuja parecida a una medusa flotando en él.")
	_m("maceta_del_despertar", "Maceta del Despertar", ItemData.Rarity.COMUN, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.NONE,
		"Plantar un arbusto ordinario y dejarlo crecer 30 días: se convierte en Arbusto Despierto amistoso",
		"Si plantas un arbusto ordinario en esta maceta de arcilla de 4,5 kg y lo dejas crecer durante 30 días, el arbusto se transforma mágicamente en un Arbusto Despierto al final de ese tiempo. Cuando el arbusto despierta, sus raíces rompen la maceta, destruyéndola.\n\nEl arbusto despierto es Amistoso hacia ti y obedece tus órdenes. Sin órdenes, no hace nada.")
	_m("miembro_prostetico", "Miembro Prostético", ItemData.Rarity.COMUN, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.NONE,
		"Reemplaza un miembro perdido; funciona idénticamente; se puede quitar/poner como Acción Mágica",
		"Este objeto mágico reemplaza un miembro perdido: una mano, un brazo, un pie, una pierna o parte similar del cuerpo. Mientras el miembro prostético está unido, funciona idénticamente a la parte que reemplaza. Puedes desunirlo o unirlo como Acción Mágica, y no puede ser removido contra tu voluntad mientras estés vivo.")

# ============================================================
# DESCRIPCIONES COMPLETAS — LETRA Q
# ============================================================

func _register_descriptions_Q() -> void:
	_m("pluma_ancla", "Pluma de Quaal (Ancla)", ItemData.Rarity.INFRECUENTE, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.NONE,
		"Acción Mágica: tocar barco → inmovilizado 24h; tocar de nuevo cancela el efecto",
		"Puedes realizar una Acción Mágica para tocar el token a un bote o barco. Durante las siguientes 24 horas, el navío no puede ser movido por ningún medio. Tocar el token al navío de nuevo termina el efecto. Cuando el efecto termina, el token desaparece.")
	_m("pluma_pajaro", "Pluma de Quaal (Pájaro)", ItemData.Rarity.RARO, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.NONE,
		"Acción Mágica: invocar un Roc enorme no atacante; transporta 225kg a 26km/h hasta 230km/día",
		"Puedes realizar una Acción Mágica para lanzar el token 1,5 m al aire. El token desaparece y un enorme pájaro multicolor ocupa su lugar. El pájaro tiene las estadísticas de un Roc, pero no puede atacar. Obedece tus órdenes simples y puede transportar hasta 225 kg volando a su velocidad máxima (26 km/h, máximo 230 km/día con descanso de 1h cada 3h de vuelo) o 450 kg a la mitad de velocidad. El pájaro desaparece tras volar su distancia máxima diaria o si cae a 0 PG.")
	_m("pluma_abanico", "Pluma de Quaal (Abanico)", ItemData.Rarity.INFRECUENTE, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.NONE,
		"En barco, Acción Mágica: abanico gigante crea viento fuerte que acelera el navío +8km/h durante 8h",
		"Si estás en un bote o barco, puedes realizar una Acción Mágica para lanzar el token hasta 3 m al aire. El token desaparece y un abanico gigante batiente ocupa su lugar. El abanico flota y crea un viento fuerte que puede llenar las velas de un barco, aumentando su velocidad en 8 km/h durante 8 horas.")
	_m("pluma_barca_cisne", "Pluma de Quaal (Barca Cisne)", ItemData.Rarity.RARO, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.NONE,
		"Acción Mágica (en masa de agua 18m+): barca en forma de cisne 15m × 6m, autopropulsada a 10km/h durante 24h",
		"Puedes realizar una Acción Mágica para tocar el token a una masa de agua de al menos 18 m de diámetro. El token desaparece y una barca de 15 m de largo y 6 m de ancho en forma de cisne ocupa su lugar. La barca se autopropulsa y se mueve por el agua a 10 km/h. Puedes realizar una Acción Mágica para ordenarle moverse o girar hasta 90 grados. La barca permanece 24 horas y luego desaparece.")
	_m("pluma_arbol", "Pluma de Quaal (Árbol)", ItemData.Rarity.INFRECUENTE, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.NONE,
		"Al aire libre, Acción Mágica: brota un roble no mágico de 18m de alto con copa de 6m de radio",
		"Debes estar al aire libre para usar este token. Puedes realizar una Acción Mágica para tocarlo a un espacio desocupado en el suelo. El token desaparece y en su lugar brota un roble no mágico de 18 m de alto con un tronco de 1,5 m de diámetro y ramas que se extienden 6 m en radio.")
	_m("pluma_latigo", "Pluma de Quaal (Látigo)", ItemData.Rarity.RARO, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.NONE,
		"Acción Mágica: látigo flotante; Acción Adicional: ataque de conjuro +9, 1d6+5 fuerza, rango 3m; dura 1h",
		"Puedes realizar una Acción Mágica para lanzar el token a un punto a menos de 3 m. El token desaparece y un látigo flotante ocupa su lugar. Puedes usar una Acción Adicional para hacer un ataque de conjuro cuerpo a cuerpo contra una criatura a menos de 3 m del látigo, con un bonificador de ataque de +9. Si impacta, el objetivo sufre 1d6+5 daño de Fuerza.\n\nComo Acción Adicional, puedes dirigir el látigo para que vuele hasta 6 m y repita el ataque contra una criatura a menos de 3 m. El látigo desaparece tras 1 hora, cuando uses una Acción Mágica para despedirlo, o cuando mueras o tengas la condición Incapacitado.")
	_m("baston_del_acrobata", "Bastón del Acróbata", ItemData.Rarity.MUY_RARO, ItemData.ItemType.WEAPON,
		MagicItemData.Attunement.ANY,
		"+2 ataque/daño; forma bastón/vara 3m/barra 15cm; Ventaja en Acrobacias; reacción +5 CA; Lanzable 9m/36m",
		"Tienes un bonificador de +2 a las tiradas de ataque y de daño con esta arma mágica.\n\nMientras sostienes esta arma, puedes emitir Luz Tenue verde hasta 3 m, como Acción Adicional o tras tirar Iniciativa, o apagarla.\n\nCon una Acción Adicional puedes cambiar su forma: bastón de cuarterstaff, vara de 3 m, o barra de 15 cm. Solo se alarga hasta donde el espacio lo permita.\n\nAsistencia Acrobática (bastón o vara). Ventaja en pruebas de Destreza (Acrobacias).\nDesviación (solo bastón). Reacción cuando eres golpeado: +5 a CA contra ese ataque. Recarga: descanso corto o largo.\nArrojadiza (solo bastón). Propiedad Arrojadiza alcance 9m/36m; vuelve a tu mano tras atacar.")
	_m("carcaj_de_ehlonna", "Carcaj de Ehlonna", ItemData.Rarity.INFRECUENTE, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.NONE,
		"3 compartimentos extradimensionales: 60 flechas/virotes, 18 jabalinas, 6 objetos largos; pesa siempre 1kg",
		"Cada uno de los tres compartimentos del carcaj conecta a un espacio extradimensional, permitiéndole contener numerosos objetos sin pesar más de 1 kg. El compartimento más corto puede contener hasta 60 Flechas, Virotes o similares. El mediano hasta 18 Jabalinas o similares. El más largo hasta 6 objetos largos como arcos, bastones o lanzas.\n\nPuedes sacar cualquier objeto que contenga el carcaj como si lo hicieras de un carcaj o vaina normal.")

# ============================================================
# DESCRIPCIONES COMPLETAS — LETRA R
# ============================================================

func _register_descriptions_R() -> void:
	_m("anillo_de_influencia_animal", "Anillo de Influencia Animal", ItemData.Rarity.RARO, ItemData.ItemType.MISC,
		MagicItemData.Attunement.NONE,
		"3 cargas; lanzar Amistad con Animales, Miedo (solo bestias) o Hablar con Animales (CD 13)",
		"Este anillo tiene 3 cargas y recupera 1d3 gastadas al amanecer. Mientras lo llevas, puedes gastar 1 carga para lanzar uno de los siguientes conjuros (CD 13): Amistad con los Animales, Miedo (afecta solo a Bestias) o Hablar con los Animales.")
	_m("anillo_de_invocacion_del_djinn", "Anillo de Invocación del Djinn", ItemData.Rarity.LEGENDARIO, ItemData.ItemType.MISC,
		MagicItemData.Attunement.ANY,
		"Acción Mágica: convocar Djinn específico; permanece con Concentración hasta 1h; si muere el djinn el anillo pierde magia",
		"Mientras llevas este anillo, puedes realizar una Acción Mágica para convocar a un Djinn particular del Plano Elemental del Aire. El djinn aparece en un espacio desocupado a menos de 36 m. Permanece mientras mantengas Concentración, hasta 1 hora, o hasta que caiga a 0 PG.\n\nMientras está convocado, el djinn es Amistoso y obedece tus órdenes. Después de que el djinn parta, no puede ser convocado de nuevo durante 24 horas, y el anillo pierde su magia si el djinn muere.")
	_m("anillo_de_mando_elemental_aire", "Anillo de Mando Elemental (Aire)", ItemData.Rarity.LEGENDARIO, ItemData.ItemType.MISC,
		MagicItemData.Attunement.ANY,
		"Ventaja vs elementales/Desventaja enemigos; Compulsión Elemental CD 18; Vuelo = Velocidad; Aurano; Resistencia Relámpago; 5 cargas conjuros",
		"Bane Elemental. Ventaja en ataques contra Elementales; ellos tienen Desventaja contra ti.\nCompulsión Elemental. Acción Mágica: un Elemental que veas a 18m hace CD 18 SAB o queda Encantado hasta tu próximo turno.\nFoco Elemental (Aire). Conoces Aurano, Resistencia al Relámpago, Velocidad de Vuelo = Velocidad.\n5 cargas (recupera 1d4+1/amanecer). Conjuros: Rayo en Cadena (3), Caída de Pluma (0), Ráfaga de Viento (2), Muro de Viento (1). CD 18.")
	_m("anillo_de_mando_elemental_tierra", "Anillo de Mando Elemental (Tierra)", ItemData.Rarity.LEGENDARIO, ItemData.ItemType.MISC,
		MagicItemData.Attunement.ANY,
		"Ventaja vs elementales; Terrano; Resistencia Ácido; moverse a través de tierra/roca; 5 cargas conjuros",
		"Bane Elemental y Compulsión Elemental como todos los anillos elementales (CD 18).\nFoco Elemental (Tierra). Conoces Terrano, Resistencia al Ácido. El terreno de escombros no es Difícil para ti. Puedes moverte a través de tierra o roca sólida como Terreno Difícil sin perturbarla; si terminas tu turno en roca sólida, eres expulsado al espacio más cercano.\n5 cargas. Conjuros: Terremoto (5), Moldear Piedra (2), Piel Pétrea (3), Muro de Piedra (3). CD 18.")
	_m("anillo_de_mando_elemental_fuego", "Anillo de Mando Elemental (Fuego)", ItemData.Rarity.LEGENDARIO, ItemData.ItemType.MISC,
		MagicItemData.Attunement.ANY,
		"Ventaja vs elementales; Ignan; Inmunidad Fuego; 5 cargas conjuros de fuego",
		"Bane Elemental y Compulsión Elemental como todos los anillos elementales (CD 18).\nFoco Elemental (Fuego). Conoces Ignan, Inmunidad al daño de Fuego.\n5 cargas. Conjuros: Manos Ardientes (1), Bola de Fuego (2), Tormenta de Fuego (4), Muro de Fuego (3). CD 18.")
	_m("anillo_de_mando_elemental_agua", "Anillo de Mando Elemental (Agua)", ItemData.Rarity.LEGENDARIO, ItemData.ItemType.MISC,
		MagicItemData.Attunement.ANY,
		"Ventaja vs elementales; Aquano; Nadar 18m; respirar agua; 5 cargas conjuros de agua",
		"Bane Elemental y Compulsión Elemental como todos los anillos elementales (CD 18).\nFoco Elemental (Agua). Conoces Aquano, Velocidad de Natación 18 m, respiras bajo el agua.\n5 cargas. Conjuros: Crear/Destruir Agua (1), Tormenta de Hielo (2), Tsunami (5), Muro de Hielo (3), Caminar sobre el Agua (2). CD 18.")
	_m("anillo_de_evasion", "Anillo de Evasión", ItemData.Rarity.RARO, ItemData.ItemType.MISC,
		MagicItemData.Attunement.ANY,
		"3 cargas; Reacción al fallar tirada de salvación de DES: gastar 1 carga para tener éxito",
		"Este anillo tiene 3 cargas y recupera 1d3 gastadas al amanecer. Cuando fallas una tirada de salvación de Destreza mientras llevas el anillo, puedes usar tu Reacción para gastar 1 carga y tener éxito en esa salvación en su lugar.")
	_set_desc("anillo_de_caida_de_pluma",
		"Cuando caes mientras llevas este anillo, desciendes 18 m por ronda y no sufres daño por caída.")
	_set_desc("anillo_de_accion_libre",
		"Mientras llevas este anillo, el Terreno Difícil no te cuesta movimiento adicional. Además, la magia no puede reducir ninguna de tus Velocidades ni causarte las condiciones Paralizado o Inmovilizado.")
	_set_desc("anillo_de_invisibilidad",
		"Mientras llevas este anillo, puedes realizar una Acción Mágica para darte la condición Invisible. Permaneces Invisible hasta que el anillo sea removido o uses una Acción Adicional para volverte visible de nuevo.")
	_set_desc("anillo_de_salto",
		"Mientras llevas este anillo, puedes lanzar Salto desde él, pero solo puedes elegirte a ti mismo como objetivo.")
	_set_desc("anillo_de_mente_blindada",
		"Mientras llevas este anillo, eres inmune a la magia que permite a otras criaturas leer tus pensamientos, determinar si mientes, conocer tu alineamiento o conocer tu tipo de criatura. Las criaturas solo pueden comunicarse telepáticamente contigo si tú lo permites.\n\nPuedes realizar una Acción Mágica para hacer que el anillo sea imperceptible hasta que uses otra Acción Mágica para hacerlo perceptible, hasta que te lo quites, o hasta que mueras.\n\nSi mueres mientras llevas el anillo, tu alma entra en él a menos que ya aloje una. Puedes permanecer en el anillo o partir al más allá. Mientras tu alma está en el anillo, puedes comunicarte telepáticamente con cualquier portador.")
	_set_desc("anillo_de_proteccion",
		"Obtienes un bonificador de +1 a la Clase de Armadura y a las tiradas de salvación mientras llevas este anillo.")
	_set_desc("anillo_de_regeneracion",
		"Mientras llevas este anillo, recuperas 1d6 PG cada 10 minutos si tienes al menos 1 PG. Si pierdes una parte del cuerpo, el anillo hace que la parte faltante vuelva a crecer y recupere plena funcionalidad tras 1d6+1 días si tienes al menos 1 PG todo ese tiempo.")
	_set_desc("anillo_de_resistencia_a_los_conjuros",
		"Tienes Resistencia a un tipo de daño mientras llevas este anillo. La gema en el anillo indica el tipo (ácido-perla, frío-turmalina, fuego-granate, fuerza-zafiro, relámpago-citrino, necrótico-azabache, veneno-amatista, psíquico-jade, radiante-topacio, trueno-espinela).")
	_m("anillo_de_estrellas_fugaces", "Anillo de Estrellas Fugaces", ItemData.Rarity.MUY_RARO, ItemData.ItemType.MISC,
		MagicItemData.Attunement.ANY,
		"Luz Danzante/Luz a voluntad; 6 cargas: Fuego de Hadas (1), Esferas de Relámpago (2), Estrellas Fugaces (1-3)",
		"Puedes lanzar Luz Danzante o Luz desde el anillo.\n\nEl anillo tiene 6 cargas y recupera 1d6 gastadas al amanecer.\nFuego de Hadas. 1 carga: lanzar Fuego de Hadas.\nEsferas de Relámpago. 2 cargas: crear hasta cuatro esferas de relámpago de 90 cm. Cada esfera aparece en un espacio desocupado a 36 m. Duran con Concentración hasta 1 min. Primera vez que una esfera llega a 1,5 m de criatura: descarga y desaparece (CD 15 DES: daño de relámpago según número de esferas: 1→4d12, 2→5d4, 3→2d6, 4→2d4).\nEstrellas Fugaces. 1-3 cargas: lanzar un punto de luz por carga a 18 m. Cada criatura en un Cubo de 4,5 m: CD 15 DES o 5d4 daño Radiante (mitad si éxito).")
	_set_desc("anillo_de_almacenamiento_de_conjuros",
		"Este anillo almacena conjuros lanzados en él, guardándolos hasta que el portador sintonizado los use. Puede almacenar hasta 5 niveles de conjuros. Cualquier criatura puede lanzar un conjuro de nivel 1-5 en el anillo tocándolo mientras lo lanza. El conjuro no tiene efecto excepto ser almacenado.\n\nMientras llevas el anillo, puedes lanzar cualquier conjuro almacenado usando el nivel, CD, bonificador y característica de conjuro del lanzador original. El conjuro lanzado ya no está almacenado.")
	_m("anillo_de_desvio_de_conjuros", "Anillo de Desvío de Conjuros", ItemData.Rarity.LEGENDARIO, ItemData.ItemType.MISC,
		MagicItemData.Attunement.ANY,
		"Ventaja en salvaciones vs conjuros; conjuros nv7 o inferior que fallen no te afectan; Reacción: devolver conjuro al lanzador",
		"Mientras llevas este anillo, tienes Ventaja en las tiradas de salvación contra conjuros. Si tienes éxito en la salvación contra un conjuro de nivel 7 o inferior, el conjuro no tiene efecto sobre ti. Si ese conjuro solo te tenía a ti como objetivo y no creaba área de efecto, puedes usar tu Reacción para desviar el conjuro de vuelta al lanzador; el lanzador debe hacer una tirada de salvación contra el conjuro usando su propia CD.")
	_set_desc("anillo_de_natacion",
		"Tienes una Velocidad de Natación de 12 m mientras llevas este anillo.")
	_set_desc("anillo_de_telekinesia",
		"Mientras llevas este anillo, puedes lanzar Telequinesia desde él.")
	_m("anillo_del_carnero", "Anillo del Carnero", ItemData.Rarity.RARO, ItemData.ItemType.MISC,
		MagicItemData.Attunement.ANY,
		"3 cargas; Acción Mágica: ataque de conjuro a distancia +7, 2d10 fuerza + empuje 1,5m por carga; o destruir objeto a 18m",
		"Este anillo tiene 3 cargas y recupera 1d3 gastadas al amanecer. Mientras llevas el anillo, puedes realizar una Acción Mágica para gastar 1-3 cargas haciendo un ataque de conjuro a distancia contra una criatura a menos de 18 m con un bonificador de +7. Si impacta, por cada carga gastada el objetivo sufre 2d10 daño de Fuerza y es empujado 1,5 m.\n\nAlternativamente, puedes gastar 1-3 cargas para intentar romper un objeto no mágico a 18 m que no se lleve puesto; el anillo hace una prueba de Fuerza con bonificador de +5 por cada carga gastada.")
	_set_desc("anillo_de_tres_deseos",
		"Mientras llevas este anillo, puedes gastar 1 de sus 3 cargas para lanzar Deseo desde él. El anillo pierde su magia cuando usas la última carga.")
	_m("anillo_de_calor", "Anillo de Calor", ItemData.Rarity.INFRECUENTE, ItemData.ItemType.MISC,
		MagicItemData.Attunement.ANY,
		"Reduce el daño de Frío recibido en 2d8; protege de temperaturas de -18°C o inferiores",
		"Si recibes daño de Frío mientras llevas este anillo, el anillo reduce el daño que recibes en 2d8.\n\nAdemás, mientras llevas este anillo, tú y todo lo que vistes y cargas no sufrís daño por temperaturas de -18°C o inferiores.")
	_m("anillo_de_caminar_sobre_el_agua", "Anillo de Caminar sobre el Agua", ItemData.Rarity.INFRECUENTE, ItemData.ItemType.MISC,
		MagicItemData.Attunement.NONE,
		"Lanzas Caminar sobre el Agua desde él, solo sobre ti mismo",
		"Mientras llevas este anillo, lanzas Caminar sobre el Agua desde él, pero solo puedes elegirte a ti mismo como objetivo.")
	_set_desc("anillo_de_vision_x",
		"Mientras llevas este anillo, puedes realizar una Acción Mágica para obtener visión de rayos X con un alcance de 9 m durante 1 minuto. Los objetos sólidos dentro de ese radio te parecen transparentes. La visión puede penetrar 30 cm de piedra, 2,5 cm de metal común o hasta 90 cm de madera o tierra. Las sustancias más gruesas o una lámina delgada de plomo bloquean la visión.\n\nCada vez que uses el anillo de nuevo antes de terminar un Descanso Largo, debes superar una tirada de salvación de Constitución CD 15 o ganar 1 nivel de Agotamiento.")
	_m("moneda_rival", "Moneda Rival", ItemData.Rarity.COMUN, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.NONE,
		"1 carga/amanecer; Acción Mágica: lanzar y tirar dado; cara par→objetivo CD 13 SAB o 2d4 psíquico + Desventaja en próximo ataque; cruz impar→tú 1d4 psíquico",
		"Esta moneda de oro tiene una criatura grabada en cada cara. Las dos criaturas deben ser rivales o enemigos famosos. La moneda tiene 1 carga y la recupera al amanecer. Puedes realizar una Acción Mágica para lanzar la moneda y gastar la carga. Tira cualquier dado: par = cara, impar = cruz.\n\nCara. Un objetivo a 18 m hace CD 13 SAB. Si falla, sufre 2d4 daño Psíquico y tiene Desventaja en su próxima tirada de ataque antes del final de su próximo turno. Con éxito, solo sufre la mitad del daño.\nCruz. Tú recibes 1d4 daño Psíquico.")
	_m("manto_de_ojos", "Manto de Ojos", ItemData.Rarity.RARO, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.ANY,
		"Visión en todas direcciones; Ventaja en Percepción (vista); Visión Oscura y Veraz 36m; desventaja: Luz/Luz Diurna → Cegado",
		"Este manto está adornado con patrones parecidos a ojos. Mientras lo llevas, obtienes los siguientes beneficios:\n\nVisión en Todas Direcciones. Ventaja en pruebas de Sabiduría (Percepción) basadas en la vista.\nSentidos Especiales. Tienes Visión Oscura y Visión Veraz con alcance de 36 m.\n\nInconvenientes. Un conjuro Luz lanzado sobre el manto o un conjuro Luz Diurna a menos de 1,5 m te da la condición Cegado durante 1 minuto. Al final de cada uno de tus turnos, haces una tirada de salvación de Constitución (CD 11 por Luz, CD 15 por Luz Diurna), terminando la condición en ti mismo con éxito.")
	_m("manto_de_colores_centelleantes", "Manto de Colores Centelleantes", ItemData.Rarity.MUY_RARO, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.ANY,
		"3 cargas; Acción Mágica: el manto emite patrones deslumbrantes; Desventaja en ataques vs ti; criaturas en Luz Brillante → CD 15 SAB o Aturdidas",
		"Este manto tiene 3 cargas y recupera 1d3 gastadas al amanecer. Mientras lo llevas, puedes realizar una Acción Mágica y gastar 1 carga para que el manto muestre un patrón de colores deslumbrantes hasta el final de tu siguiente turno. Durante ese tiempo, emite Luz Brillante en 9 m y Luz Tenue 9 m más, y las criaturas que puedan verte tienen Desventaja en las tiradas de ataque contra ti. Cualquier criatura en la Luz Brillante que pueda verte cuando se activa el poder debe superar una tirada de salvación de Sabiduría CD 15 o tener la condición Aturdido hasta que el efecto termine.")
	_m("manto_de_estrellas", "Manto de Estrellas", ItemData.Rarity.MUY_RARO, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.ANY,
		"+1 salvaciones; 6 estrellas: cada una → Proyectil Mágico nv5; Acción Mágica: entrar/salir del Plano Astral",
		"Este manto negro o azul oscuro está bordado con pequeñas estrellas blancas o plateadas. Obtienes un bonificador de +1 a las tiradas de salvación mientras lo llevas.\n\nSeis estrellas en la parte frontal superior son especialmente grandes. Mientras llevas el manto, puedes realizar una Acción Mágica para quitar una estrella y gastarla para lanzar la versión de nivel 5 de Proyectil Mágico. Al anochecer, 1d6 estrellas removidas reaparecen en el manto.\n\nMientras llevas el manto, puedes realizar una Acción Mágica para entrar en el Plano Astral junto con todo lo que vistas y cargues. Permaneces allí hasta que uses otra Acción Mágica para regresar.")
	_m("manto_del_archimago", "Manto del Archimago", ItemData.Rarity.LEGENDARIO, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.SPELLCASTER,
		"CA base 15+DES (sin armadura); Ventaja en salvaciones vs conjuros; CD conjuro y ataque de conjuro +2",
		"Este elegante manto está hecho de tela exquisita adornada con runas. Obtienes estos beneficios mientras lo llevas:\n\nArmadura. Si no llevas armadura, tu CA base es 15 + tu modificador de Destreza.\nResistencia Mágica. Tienes Ventaja en las tiradas de salvación contra conjuros y otros efectos mágicos.\nMago de Guerra. Tu CD de salvación de conjuros y tu bonificador de ataque de conjuro aumentan cada uno en 2.")
	_m("manto_de_objetos_utiles", "Manto de Objetos Útiles", ItemData.Rarity.INFRECUENTE, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.NONE,
		"Parches cosidos: Acción Mágica para desprender → objeto o criatura real; 4d4 parches adicionales aleatorios",
		"Este manto tiene parches de tela de varias formas y colores. Mientras lo llevas, puedes realizar una Acción Mágica para desprender uno de los parches, convirtiéndolo en el objeto o criatura que representa. El manto tiene dos de cada uno de los siguientes parches básicos: Linterna de Ojo de Buey (encendida), Daga, Espejo, Vara, Cuerda (enrollada), Saco.\n\nAdemás el manto tiene 4d4 parches adicionales aleatorios determinados por el DJ, entre los que puede haber: bolsa de 100 PO, cofre de plata (500 PO), puerta de hierro, 10 gemas de 100 PO, escalera de madera, caballo de montura, foso abierto, 4 Pociones de Curación, bote de remos, Pergamino de Conjuro o 2 mastines.")
	_m("vara_de_absorcion", "Vara de Absorción", ItemData.Rarity.MUY_RARO, ItemData.ItemType.MISC,
		MagicItemData.Attunement.ANY,
		"Reacción: absorber conjuro que solo te afecte a ti (almacena energía, máx. 50 niv. totales); lanzador puede convertirla en espacios de conjuro",
		"Mientras sostienes esta vara, puedes usar tu Reacción para absorber un conjuro que solo te afecte y no cree área de efecto. El efecto del conjuro se cancela y su energía queda almacenada en la vara al nivel en que fue lanzado. La vara puede absorber hasta 50 niveles en total. Una vez absorbidos 50, no puede absorber más.\n\nSi eres lanzador de conjuros, puedes convertir la energía almacenada en espacios de conjuro para lanzar conjuros que conozcas o tengas preparados, de nivel igual o inferior a tus espacios normales, máximo nivel 5.\n\nUna vara recién encontrada típicamente tiene 1d10 niveles almacenados. Si no puede absorber más y no tiene energía, pierde su magia.")
	_m("vara_de_alerta", "Vara de Alerta", ItemData.Rarity.MUY_RARO, ItemData.ItemType.MISC,
		MagicItemData.Attunement.ANY,
		"Ventaja en Percepción e Iniciativa; lanzar conjuros de detección; Aura Protectora 18m (1/amanecer, 10min)",
		"Esta vara tiene las siguientes propiedades:\n\nAlerta. Ventaja en pruebas de Sabiduría (Percepción) y en tiradas de Iniciativa.\nConjuros. Puedes lanzar desde ella: Detectar el Bien y el Mal, Detectar Magia, Detectar Veneno y Enfermedad, Ver Invisibilidad.\nAura Protectora. Acción Mágica: clavar la vara en el suelo, emitiendo Luz Brillante 18 m y Luz Tenue 18 m más durante 10 minutos. Tú y tus aliados en la Luz Brillante ganáis +1 a CA y salvaciones y podéis percibir la ubicación de criaturas Invisibles. 1/amanecer.")
	_m("vara_del_poder_senorial", "Vara del Poder Señorial", ItemData.Rarity.LEGENDARIO, ItemData.ItemType.WEAPON,
		MagicItemData.Attunement.ANY,
		"+3 maza; 6 botones: espada de fuego/hacha de batalla/lanza/escala de 15m/ariete/brújula; Drenar Vida; Paralizar; Aterrorizar",
		"Esta vara tiene cabeza con aletas y funciona como una Maza mágica que otorga +3 a las tiradas de ataque y de daño. Tiene propiedades asociadas a seis botones distintos y tres propiedades adicionales:\n\nBotones (Acción Adicional, efecto hasta presionar otro botón o el mismo):\n1: Hoja ígnea del extremo opuesto (Espada Larga o Corta, +2d6 fuego, luz 12m/12m).\n2: Hacha de Batalla con +3 ataque/daño.\n3: Lanza con haft de 1,8m y +3 ataque/daño.\n4: Palo de escalar hasta 15m con picos, barras y capacidad 1800kg.\n5: Ariete de mano (+10 a pruebas de Atletismo para romper barreras).\n6: Brújula y conocimiento de profundidad/altura.\n\nDrenar Vida. Al golpear: CD 17 CON o 4d6 necrótico adicional, tú recuperas la mitad. 1/amanecer.\nParalizar. Al golpear: CD 17 CON o Paralizado 1min. 1/amanecer.\nAterrorizar. Acción Mágica: criaturas que veas a 9m → CD 17 SAB o Asustadas 1min. 1/amanecer.")
	_m("vara_de_resurreccion", "Vara de Resurrección", ItemData.Rarity.LEGENDARIO, ItemData.ItemType.MISC,
		MagicItemData.Attunement.ANY,
		"5 cargas (recupera 1/amanecer); Sanar (1 carga) o Resurrección (5 cargas); al 0 cargas: 1d20, en 1 desaparece",
		"La vara tiene 5 cargas. Mientras la sostienes, puedes lanzar uno de los siguientes conjuros: Sanar (1 carga) o Resurrección (5 cargas). La vara recupera 1 carga gastada al amanecer. Si gastas la última, tira 1d20. Con un 1, la vara desaparece en un destello de luz radiante.")
	_m("vara_del_dominio", "Vara del Dominio", ItemData.Rarity.RARO, ItemData.ItemType.MISC,
		MagicItemData.Attunement.ANY,
		"Acción Mágica: presentar la vara → criaturas a elección a 36m CD 15 SAB o Encantadas 8h como líder; 1/amanecer",
		"Puedes realizar una Acción Mágica para presentar la vara y ordenar obediencia a cada criatura de tu elección que puedas ver a menos de 36 m. Cada objetivo debe superar una tirada de salvación de Sabiduría CD 15 o tener la condición Encantado durante 8 horas. Mientras está Encantada así, la criatura te considera su líder de confianza. Si la dañas o le ordenas algo contrario a su naturaleza, deja de estar Encantada. 1/amanecer.")
	_m("vara_de_seguridad", "Vara de Seguridad", ItemData.Rarity.MUY_RARO, ItemData.ItemType.MISC,
		MagicItemData.Attunement.NONE,
		"Acción Mágica: transportar hasta 200 criaturas voluntarias a un semiplano seguro (hasta 200 días ÷ nº criaturas); 1/10 días",
		"Mientras sostienes esta vara, puedes realizar una Acción Mágica para activarla. La vara te transporta instantáneamente a ti y hasta 199 criaturas voluntarias que puedas ver a un semiplano. El semiplano toma la forma que elijas: jardín tranquilo, taberna animada, palacio enorme, isla tropical, etc. El semiplano contiene suficiente agua y comida para sus visitantes y el entorno no puede dañarlos.\n\nPor cada hora en el semiplano, un visitante recupera PG como si hubiera gastado 1 Dado de Golpe. Las criaturas no envejecen allí, aunque el tiempo pasa normalmente. Los visitantes pueden permanecer hasta 200 días dividido por el número de criaturas presentes. Al terminar el tiempo o al usar otra Acción Mágica, todos reaparecen en su ubicación original. 1/10 días.")
	_m("vara_del_guardapacto", "Vara del Guardapacto +1", ItemData.Rarity.INFRECUENTE, ItemData.ItemType.MISC,
		MagicItemData.Attunement.SPECIFIC,
		"+1 ataques de conjuro y CD; recuperar 1 espacio de conjuro 1/descanso largo (solo Brujo)",
		"Mientras sostienes esta vara, obtienes un bonificador de +1 a las tiradas de ataque de conjuro y a la CD de salvación de tus conjuros de Brujo. Además, puedes recuperar un espacio de conjuro como Acción Mágica mientras sostienes la vara. No puedes usar esta propiedad de nuevo hasta que termines un Descanso Largo.")
	_m("vara_del_guardapacto_2", "Vara del Guardapacto +2", ItemData.Rarity.RARO, ItemData.ItemType.MISC,
		MagicItemData.Attunement.SPECIFIC,
		"+2 ataques de conjuro y CD; recuperar 1 espacio de conjuro 1/descanso largo (solo Brujo)",
		"Mientras sostienes esta vara, obtienes un bonificador de +2 a las tiradas de ataque de conjuro y a la CD de salvación de tus conjuros de Brujo. Además, puedes recuperar un espacio de conjuro como Acción Mágica. No puedes usar esta propiedad de nuevo hasta que termines un Descanso Largo.")
	_m("vara_del_guardapacto_3", "Vara del Guardapacto +3", ItemData.Rarity.MUY_RARO, ItemData.ItemType.MISC,
		MagicItemData.Attunement.SPECIFIC,
		"+3 ataques de conjuro y CD; recuperar 1 espacio de conjuro 1/descanso largo (solo Brujo)",
		"Mientras sostienes esta vara, obtienes un bonificador de +3 a las tiradas de ataque de conjuro y a la CD de salvación de tus conjuros de Brujo. Además, puedes recuperar un espacio de conjuro como Acción Mágica. No puedes usar esta propiedad de nuevo hasta que termines un Descanso Largo.")
	_m("cuerda_de_escalar", "Cuerda de Escalar", ItemData.Rarity.INFRECUENTE, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.NONE,
		"18m, aguanta 1350kg; Acción Mágica: el extremo libre se anima y mueve hasta 3m/turno; puede atarse/desatarse, hacer nudos",
		"Esta cuerda de 18 m puede sostener hasta 1350 kg. Mientras sostienes un extremo, puedes realizar una Acción Mágica para ordenar al otro extremo que se anime y se mueva hacia un destino a elección hasta la longitud de la cuerda (se mueve 3 m al turno). También puedes ordenarle que se afiance, se desafiance, haga nudos (acorta a 15 m con nudos cada 30 cm, Ventaja en pruebas para trepar) o se enrolle.\n\nLa cuerda tiene CA 20, PG 20 e Inmunidad al daño de Veneno y Psíquico. Recupera 1 PG cada 5 minutos si tiene al menos 1 PG.")
	_m("cuerda_de_enredo", "Cuerda de Enredo", ItemData.Rarity.RARO, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.NONE,
		"9m; Acción Mágica: enredar criatura a 6m (CD 15 DES o Inmovilizado); CA 20, PG 20",
		"Esta cuerda mide 9 m. Mientras sostienes un extremo, puedes realizar una Acción Mágica para ordenar al otro extremo que se lance hacia una criatura que veas a menos de 6 m. El objetivo debe superar una tirada de salvación de Destreza CD 15 o tener la condición Inmovilizado.\n\nUn objetivo Inmovilizado puede hacer una prueba CD 15 de Atletismo o Acrobacias para liberarse. La cuerda tiene CA 20, PG 20 e Inmunidad al daño de Veneno y Psíquico.")
	_m("cuerda_reparadora", "Cuerda Reparadora", ItemData.Rarity.COMUN, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.NONE,
		"50m; Acción Mágica: si los trozos se tocan, se remiendan solos; acorta si se pierde una sección",
		"Este rollo de cuerda de 15 m puede repararse cuando se corta en cualquier número de trozos más pequeños. Puedes realizar una Acción Mágica para hacer que todos los trozos en contacto entre sí y no en uso se unan de nuevo. La cuerda se acorta permanentemente si se pierde o destruye una sección.")
	_m("rubi_del_mago_de_guerra", "Rubí del Mago de Guerra", ItemData.Rarity.COMUN, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.SPELLCASTER,
		"Pegar a arma (10min): permite usar esa arma como Foco de Conjuración",
		"Grabado con runas arcanas, este rubí de 2,5 cm de diámetro te permite usar un arma Simple o Marcial como Foco de Conjuración para tus conjuros. Para que la propiedad funcione, debes pegar el rubí al arma presionándolo durante al menos 10 minutos. El rubí no puede ser removido a menos que lo despeges como Acción Mágica, el arma sea destruida o tu Sintonía termine.")


# ============================================================
# DESCRIPCIONES COMPLETAS — LETRA S
# ============================================================

func _register_descriptions_S() -> void:
	_m("silla_del_caballero", "Silla del Caballero", ItemData.Rarity.INFRECUENTE, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.NONE,
		"Sobre montura: Desventaja en ataques vs montura; no puedes ser desmontado",
		"Montura Protegida. Desventaja en ataques contra la montura. Jinete Seguro. No puedes ser desmontado contra tu voluntad.")
	_m("escarabajo_de_proteccion", "Escarabajo de Proteccion", ItemData.Rarity.LEGENDARIO, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.ANY,
		"+1 CA; 12 cargas: Reaccion para convertir fallo en exito vs nigromancia/no muertos; Ventaja salvaciones conjuros",
		"+1 CA. 12 cargas: si fallas salvacion vs conjuro de Nigromancia o efecto de No Muerto, Reaccion + 1 carga = exito. El escarabajo se destruye al agotar cargas. Ventaja en salvaciones vs conjuros.")
	_set_desc("espada_de_velocidad_cimitarra",
		"+2 ataque/dano. Ademas, puedes realizar un ataque como Accion Adicional en cada uno de tus turnos.")
	_m("pergamino_de_proteccion", "Pergamino de Proteccion", ItemData.Rarity.RARO, ItemData.ItemType.CONSUMABLE,
		MagicItemData.Attunement.NONE,
		"Accion Magica: Emanacion de 1,5m/5min impide entrada y efectos de criaturas del tipo elegido",
		"Leer el pergamino como Accion Magica crea Emanacion de 1,5m/5min. Las criaturas del tipo elegido no pueden entrar ni afectar dentro. Una criatura a 1,5m puede superar el efecto con CD 15 CAR.")
	_m("piedras_de_envio", "Piedras de Envio", ItemData.Rarity.INFRECUENTE, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.NONE,
		"Par de piedras; tocando una: lanzar Enviar Mensaje al portador de la otra; 1/amanecer",
		"Vienen en pares tallados para coincidir. Tocando una puedes lanzar Enviar Mensaje al portador de la otra. 1/amanecer. Si se destruye una del par, la otra pierde su magia.")
	_set_desc("escudo_centinela", "Ventaja en Iniciativa y Percepcion mientras sostienes este Escudo.")
	_set_desc("escudo_1", "+1 a la CA mientras sostienes este Escudo, ademas del bonificador normal del escudo.")
	_set_desc("escudo_2", "+2 a la CA mientras sostienes este Escudo, ademas del bonificador normal del escudo.")
	_set_desc("escudo_3", "+3 a la CA mientras sostienes este Escudo, ademas del bonificador normal del escudo.")
	_m("escudo_de_expresion", "Escudo de Expresion", ItemData.Rarity.COMUN, ItemData.ItemType.SHIELD,
		MagicItemData.Attunement.NONE,
		"Accion Adicional para cambiar la expresion del rostro del escudo",
		"La parte frontal tiene forma de rostro. Puedes usar una Accion Adicional para cambiar su expresion.")
	_set_desc("escudo_de_atraccion_de_proyectiles",
		"Resistencia al dano de ataques a distancia.\n\nMaldicion. Sintonizarte te maldice. Cada vez que un ataque a distancia apunte a criatura a menos de 3m de ti, eres tu el objetivo en su lugar.")
	_set_desc("escudo_de_la_caballeria",
		"+2 a la CA ademas del bonificador normal.\n\nGolpe de Escudo. Al Atacar puedes hacer un ataque con el escudo (Competencia+FUE). Impacto: 2d6+2+FUE fuerza; empujar 3m o derribar si el objetivo es de tu tamano o menor.\n\nCampo Protector. Reaccion: Emanacion inmovil de 1,5m (Concentracion hasta 1min, impenetrable). 1/amanecer.")
	_set_desc("escudo_de_proteccion_contra_hechizos",
		"Ventaja en salvaciones vs conjuros; las tiradas de ataque de conjuro tienen Desventaja contra ti.")
	_m("arma_plateada", "Arma Plateada", ItemData.Rarity.COMUN, ItemData.ItemType.WEAPON,
		MagicItemData.Attunement.NONE,
		"Golpe critico vs criatura transformada: un dado de dano adicional",
		"Un proceso alquimico ha unido plata a esta arma magica. Golpe Critico vs criatura transformada: un dado de dano adicional.")
	_m("zapatillas_de_trepar", "Zapatillas de Trepar", ItemData.Rarity.INFRECUENTE, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.ANY,
		"Velocidad de Escalar = Velocidad; trepar superficies verticales y techos con manos libres",
		"Puedes moverte por superficies verticales y techos con las manos libres. Velocidad de Escalar = Velocidad. No funciona en superficies resbaladizas.")
	_set_desc("armadura_humeante", "Volutas de humo inofensivo e inodoro se elevan de esta armadura mientras se lleva puesta.")
	_m("pegamento_soberano", "Pegamento Soberano", ItemData.Rarity.LEGENDARIO, ItemData.ItemType.CONSUMABLE,
		MagicItemData.Attunement.NONE,
		"Adhesivo permanente; solo Disolvente Universal, Aceite de Etereidad o Deseo puede romperlo",
		"Sustancia viscosa blanca que forma un vinculo adhesivo permanente. Se almacena en frasco recubierto con Aceite de Deslizamiento. Una onza cubre 0,09m2 (Accion de Utilizar; tarda 1min en secar). Solo Disolvente Universal, Aceite de Etereidad o Deseo puede romperlo.")
	_m("piedra_de_la_suerte", "Piedra de la Suerte", ItemData.Rarity.INFRECUENTE, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.ANY,
		"+1 a pruebas de caracteristica y tiradas de salvacion",
		"Mientras llevas esta agata pulida, obtienes un bonificador de +1 a las pruebas de caracteristica y a las tiradas de salvacion.")
	_set_desc("espada_sol",
		"Accion Adicional: hacer surgir o desaparecer una hoja de pura radiancia. Funciona como Espada Larga con Finura. +2 ataque/dano; dano Radiante; No Muertos reciben 1d8 Radiante adicional.\n\nLuz Solar. La hoja emite Luz Brillante 4,5m y Luz Tenue 4,5m mas (luz solar). Accion Magica para expandir/reducir radios 1,5m.")
	_set_desc("espada_de_vida_robada",
		"20 natural al atacar criatura que no sea Constructo ni No Muerto: 15 dano Necrotico adicional y ganas PG temporales iguales al dano.")
	_set_desc("espada_afilada",
		"Al atacar un objeto y golpear, maximizas los dados de dano del arma. Al sacar 20 en d20 contra criatura: 14 dano Cortante adicional y gana 1 nivel de Agotamiento.")
	_set_desc("espada_de_las_heridas",
		"Al golpear, el objetivo sufre 2d6 dano Necrotico adicional y debe superar CD 15 CON o ser incapaz de recuperar PG durante 1 hora (repite la salvacion al final de cada uno de sus turnos).")
	_set_desc("esfera_de_aniquilacion",
		"Esfera de 60cm que oblitera toda materia (excepto Artefactos). Cualquier cosa que toque pero no sea engullida sufre 8d10 fuerza.\n\nControl. A 18m: Accion Magica + INT (Arcanos) CD 25 para controlar hasta tu proximo turno; si fallas, la esfera se mueve 3m hacia ti. Mientras controlas: Accion Adicional para moverla. Criaturas en su espacio: CD 19 DES o 8d10 fuerza.")
	_set_desc("colmillo_de_pergamino_de_conjuro",
		"Un Pergamino de Conjuro contiene un unico conjuro. Si esta en tu lista de conjuros, puedes lanzarlo sin componentes Materiales; se desintegra tras el lanzamiento. Si es de nivel superior, prueba de caracteristica de conjuracion CD 10 + nivel; si fallas, el conjuro desaparece sin efecto.")
	_m("baston_de_adorno", "Baston de Adorno", ItemData.Rarity.COMUN, ItemData.ItemType.MISC,
		MagicItemData.Attunement.NONE,
		"Colocar objeto Diminuto encima: flota 2,5cm de la punta (max 3 objetos)",
		"Si colocas un objeto Diminuto de no mas de 500g encima mientras lo sostienes, flota 2,5cm de la punta. Hasta 3 objetos a la vez; puedes hacerlos girar lentamente.")
	_m("baston_de_cantos_pajaros", "Baston de Cantos de Pajaros", ItemData.Rarity.COMUN, ItemData.ItemType.MISC,
		MagicItemData.Attunement.NONE,
		"10 cargas; Accion Magica: emitir sonido de ave audible hasta 36m; recupera 1d6+4/amanecer",
		"10 cargas. Accion Magica + 1 carga: emitir sonido de ave audible hasta 36m. Recupera 1d6+4/amanecer.")
	_m("baston_de_encantamiento", "Baston de Encantamiento", ItemData.Rarity.RARO, ItemData.ItemType.MISC,
		MagicItemData.Attunement.SPELLCASTER,
		"10 cargas; lanzar Encantar Persona/Orden/Comprender Idiomas; reflejar/resistir conjuros de Encantamiento",
		"10 cargas. Lanzar conjuro (1 carga, CD propia): Encantar Persona, Orden o Comprender Idiomas. Reflejar Encantamiento: si tienes exito vs Encantamiento, Reaccion + 1 carga para devolverlo. Resistir Encantamiento: convertir fallo en exito 1/amanecer. Recupera 1d8+2/amanecer.")
	_m("baston_de_flores", "Baston de Flores", ItemData.Rarity.COMUN, ItemData.ItemType.MISC,
		MagicItemData.Attunement.NONE,
		"10 cargas; Accion Magica: brotar flor en tierra a 1,5m o en el propio baston; recupera 1d6+4/amanecer",
		"10 cargas. Accion Magica + 1 carga: hacer brotar una flor en tierra a 1,5m o en el propio baston (no magica). Recupera 1d6+4/amanecer.")
	_set_desc("baculo_de_fuego",
		"Resistencia al dano de Fuego mientras sostienes este baculo. Conjuros (10 cargas, CD propia): Manos Ardientes (1), Bola de Fuego (3), Muro de Fuego (4). Recupera 1d6+4/amanecer.")
	_set_desc("baculo_de_escarcha",
		"Resistencia al dano de Frio mientras sostienes este baculo. Conjuros (10 cargas, CD propia): Nube de Niebla (1), Tormenta de Hielo (4), Cono de Frio (5), Muro de Hielo (4). Recupera 1d6+4/amanecer.")
	_set_desc("baculo_de_curacion",
		"10 cargas. Conjuros (mod. conjuracion propio): Curar Heridas (1 carga/nivel, max 4), Restauracion Menor (2), Curacion en Masa (5). Recupera 1d6+4/amanecer.")
	_set_desc("baculo_de_poder",
		"+2 CA, salvaciones y ataques de conjuro. 20 cargas. Conjuros (CD propia): Cono de Frio (5), Bola de Fuego nv5 (5), Globo de Invulnerabilidad (6), Detener Monstruo (5), Levitar (2), Rayo nv5 (5), Proyectil Magico (1), Rayo de Debilitamiento (1), Muro de Fuerza (5). Recupera 2d8+4/amanecer.\n\nGolpe Retributivo. Accion Magica: romper el baculo; explosion en Emanacion de 9m.")
	_m("baston_de_insectos", "Baston de Insectos", ItemData.Rarity.RARO, ItemData.ItemType.MISC,
		MagicItemData.Attunement.SPELLCASTER,
		"10 cargas; Nube de Insectos (1 carga, Emanacion 9m/10min); conjuros: Insecto Gigante (4), Plaga de Insectos (5)",
		"10 cargas. Nube de Insectos: Accion Magica + 1 carga, Emanacion de 9m Muy Oscurecido 10min. Conjuros (CD propia): Insecto Gigante (4), Plaga de Insectos (5). Recupera 1d6+4/amanecer.")
	_m("baston_de_la_piton", "Baston de la Piton", ItemData.Rarity.INFRECUENTE, ItemData.ItemType.MISC,
		MagicItemData.Attunement.ANY,
		"Accion Magica: el baston se convierte en Serpiente Constrictora Gigante bajo tu control",
		"Accion Magica: lanzar el baston a espacio desocupado a 3m; se convierte en Serpiente Constrictora Gigante bajo tu control. Actua justo despues de ti. Accion Adicional para revertirla (recarga 1h). Si la serpiente muere, el baston queda destruido.")
	_set_desc("baculo_de_la_serpiente",
		"Accion Adicional: convertir la cabeza en serpiente venenosa animada durante 1min. Al Atacar puedes usar la cabeza (Competencia+SAB, alcance 1,5m). Impacto: 1d6 perforante + 3d6 veneno.\n\nLa cabeza tiene CA 15, PG 20, Inmunidad a Veneno/Psiquico. Si llega a 0 PG, el baculo queda destruido.")
	_set_desc("baculo_de_golpeo",
		"+3 ataque/dano. 10 cargas. Al golpear puedes gastar hasta 3 cargas: +1d6 fuerza por carga al objetivo. Recupera 1d6+4/amanecer.")
	_m("baston_del_trueno_y_relampago", "Baston del Trueno y Relampago", ItemData.Rarity.MUY_RARO, ItemData.ItemType.WEAPON,
		MagicItemData.Attunement.ANY,
		"+2 ataque/dano; 5 propiedades 1/amanecer: Relampago (+2d6), Trueno (Aturdido CD17 CON), Rayo (9d6 linea 36m), Truenazo (2d6 Emanacion 18m)",
		"+2 ataque/dano. 5 propiedades 1/amanecer: Relampago (al golpear +2d6 relampago). Trueno (al golpear CD17 CON o Aturdido). Trueno y Relampago (Accion Adicional: ambos a la vez sin gastar sus usos). Rayo (Accion Magica: linea 1,5mx36m CD17 DES 9d6 relampago). Truenazo (Accion Magica: Emanacion 18m CD17 CON 2d6 trueno+Ensordecido 1min).")
	_m("baston_marchitador", "Baston Marchitador", ItemData.Rarity.RARO, ItemData.ItemType.WEAPON,
		MagicItemData.Attunement.ANY,
		"3 cargas; al golpear gastar 1: +2d10 necrotico + CD 15 CON o Desventaja 1h en FUE/CON",
		"3 cargas (recupera 1d3/amanecer). Al golpear, gastar 1 carga: +2d10 dano Necrotico y CD 15 CON. Si falla, Desventaja durante 1h en pruebas y salvaciones de Fuerza o Constitucion.")
	_m("piedra_de_elementales_tierra", "Piedra de Control de Elementales de Tierra", ItemData.Rarity.RARO, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.NONE,
		"Accion Magica (piedra tocando el suelo): convocar Elemental de Tierra en 9m durante 1h; 1/amanecer",
		"Mientras tocas esta piedra de 2,5kg al suelo, Accion Magica para convocar un Elemental de Tierra en espacio desocupado a 9m. Obedece tus ordenes y actua justo despues de ti. Desaparece tras 1h o cuando lo despides. 1/amanecer.")
	_m("tabla_de_espiritus", "Tabla de los Espiritus", ItemData.Rarity.MUY_RARO, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.NONE,
		"3 cargas; 1min tocando la planchette: Augurio (1 carga) o Comunion (3 cargas)",
		"Tablero con letras del alfabeto, palabras Si/No y simbolos de Bien/Mal; con planchette de madera. 3 cargas (recupera 1/amanecer). Tocando la planchette, 1 minuto para lanzar: Augurio (1 carga) o Comunion (3 cargas).")
	_m("espada_de_kas", "Espada de Kas", ItemData.Rarity.LEGENDARIO, ItemData.ItemType.WEAPON,
		MagicItemData.Attunement.ANY,
		"+3 ataque/dano; critico en 19-20; +2d10 cortante vs No Muertos; Sed de Sangre; conjuros CD18 1/amanecer; +1d10 Iniciativa; sentiente Caotico Malvado",
		"Sed de Sangre. Si no proba sangre en 1min, CD15 CAR: exito = 3d6 Psiquico; fallo = Dominado. +3 ataque/dano; critico en 19-20; +2d10 cortante vs No Muertos. +1d10 Iniciativa; transferir bonus de ataque a CA; Resistencia Necrotica. Conjuros (CD18, 1/amanecer): Llamar Relampago, Palabra Divina, Dedo de la Muerte. Sentiencia: Caotico Malvado, INT15 SAB13 CAR16.")
	_m("espada_de_venganza", "Espada de Venganza", ItemData.Rarity.INFRECUENTE, ItemData.ItemType.WEAPON,
		MagicItemData.Attunement.ANY,
		"+1 ataque/dano; maldita: Desventaja con otras armas; forzado a atacar al que te dano (CD15 SAB)",
		"+1 ataque/dano. Maldicion: eres reacio a separarte del arma; Desventaja con otras armas. Cuando una criatura te dana, debes superar CD15 SAB o atacarla hasta que caigas o ella caiga. Lanzar Destierro sobre el arma expulsa el espiritu.")
	_m("garra_silvana", "Garra Silvana", ItemData.Rarity.COMUN, ItemData.ItemType.WEAPON,
		MagicItemData.Attunement.ANY,
		"Entiendes a los Feericos y ellos te entienden; 1/amanecer: lanzar Mensaje",
		"Mientras esta arma este en tu persona, entiendes la comunicacion no escrita de todos los Feericos y ellos te entienden. Mensaje Secreto: Accion Magica para lanzar Mensaje. 1/amanecer.")

# ============================================================
# DESCRIPCIONES COMPLETAS — LETRA T
# ============================================================

func _register_descriptions_T() -> void:
	_m("talisman_de_la_bondad_pura", "Talisman de la Bondad Pura", ItemData.Rarity.LEGENDARIO, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.SPECIFIC,
		"Simbolo Sagrado; +2 ataques conjuro; 7 cargas: fisura ardiente destruye Infernal/No Muerto (CD20 DES) o 4d6 psiquico",
		"Un Infernal o No Muerto que toque el talisman sufre 8d6 Radiante, y de nuevo al final de cada turno que lo porte. Simbolo Sagrado con +2 a ataques de conjuro. 7 cargas: Accion Magica + 1 carga, CD20 DES (Desventaja si Infernal/No Muerto): fallo = destruido sin restos; exito = 4d6 Psiquico. Al gastar la ultima carga, el talisman se dispersa en destellos dorados.")
	_m("talisman_de_la_esfera", "Talisman de la Esfera", ItemData.Rarity.LEGENDARIO, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.ANY,
		"Ventaja en INT (Arcanos) para controlar Esfera de Aniquilacion; Accion Magica: moverla 3m + 3m por mod. INT",
		"Ventaja en pruebas de Inteligencia (Arcanos) para controlar una Esfera de Aniquilacion. Ademas, cuando empiezas tu turno controlando la esfera, puedes realizar una Accion Magica para moverla 3m mas un numero adicional de metros igual a 3 x tu modificador de Inteligencia.")
	_m("talisman_del_mal_supremo", "Talisman del Mal Supremo", ItemData.Rarity.LEGENDARIO, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.SPECIFIC,
		"Simbolo Sagrado (maligno); +2 ataques conjuro; 6 cargas: fisura ardiente destruye Celestial (CD20 DES) o 4d6 psiquico",
		"Criatura que no sea Infernal ni No Muerto que toque el talisman sufre 8d6 Necrotico, y de nuevo al final de cada turno. Simbolo Sagrado con +2 a ataques de conjuro. 6 cargas: Accion Magica + 1 carga, CD20 DES (Desventaja si Celestial): fallo = destruido; exito = 4d6 Psiquico. Al agotar cargas, el talisman se disuelve en limo.")
	_m("muneca_parlante", "Muneca Parlante", ItemData.Rarity.COMUN, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.ANY,
		"Durante descanso corto: programar hasta 6 frases (max 6 palabras) con condicion de activacion",
		"Mientras la muneca esta a menos de 1,5m de ti, puedes pasar un Descanso Corto diciendole que diga hasta seis frases (max 6 palabras cada una) y establecer una condicion de activacion para cada una. La condicion debe ocurrir a menos de 1,5m de la muneca. Las frases se pierden cuando tu Sintonizacion termina.")
	_m("jarra_de_la_sobriedad", "Jarra de la Sobriedad", ItemData.Rarity.COMUN, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.NONE,
		"Beber alcohol no magico de ella: no te emborrachas; sin efecto en liquidos magicos o venenos",
		"Puedes beber cerveza, vino u otra bebida alcoholica no magica de esta jarra sin emborracharte. La jarra no tiene efecto sobre liquidos magicos o sustancias daninas como venenos.")
	_m("vara_tentacular", "Vara Tentacular", ItemData.Rarity.RARO, ItemData.ItemType.WEAPON,
		MagicItemData.Attunement.ANY,
		"Accion Magica: 3 tentaculos atacan criaturas a 4,5m (+9 ataque, 1d6 psiquico); 3 impactos -> Inmovilizado + 3d6 psiquico/turno",
		"Accion Magica: dirigir tres tentaculos hacia criaturas visibles a 4,5m. Por tentaculo: tirada de ataque con +9; impacto 1d6 Psiquico. Si los tres golpean al mismo objetivo, CD15 DES o Inmovilizado hasta que estes Incapacitado, uses Accion Adicional para liberarlo o salga del alcance. Mientras Inmovilizado: 3d6 Psiquico al inicio de cada turno; repite CD al final de cada turno.")
	_m("gran_maza_atronadora", "Gran Maza Atronadora", ItemData.Rarity.MUY_RARO, ItemData.ItemType.WEAPON,
		MagicItemData.Attunement.ANY,
		"FUE 20 si sintonizado; +1d8 trueno a criaturas; +3d8 trueno a objetos; Estallido de Trueno (Cono 9m CD15 FUE); Terremoto 1/amanecer",
		"Mientras estas sintonizado, tu FUE es 20 a menos que ya sea superior. El arma inflige 1d8 Trueno adicional a criaturas y 3d8 Trueno adicional a objetos no portados.\n\nEstallido de Trueno. Accion Magica: Cono de 9m de energia atronadora, CD15 FUE o Derribado. Objetos en el Cono: 3d8 Trueno.\n\nTerremoto. Accion Magica: circulo de 15m, estructuras 50 Contundente, CD20 DES o Derribado; CD20 CON o pierde Concentracion; puedes crear fisura de 9m de profundidad/3m de ancho. 1/amanecer.")
	_m("tomo_de_pensamientos_claros", "Tomo de Pensamientos Claros", ItemData.Rarity.MUY_RARO, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.NONE,
		"48h de estudio en 6 dias: INT +2 (max 30); el libro pierde su magia y la recupera en un siglo",
		"Contiene ejercicios de memoria y logica cargados de magia. Estudiar 48h durante 6 dias o menos: Inteligencia +2 hasta maximo 30. El libro pierde su magia y la recupera en un siglo.")
	_m("tomo_de_liderazgo_e_influencia", "Tomo de Liderazgo e Influencia", ItemData.Rarity.MUY_RARO, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.NONE,
		"48h de estudio en 6 dias: CAR +2 (max 30); el libro pierde su magia y la recupera en un siglo",
		"Contiene directrices para influir y encantar a otros, cargadas de magia. Estudiar 48h durante 6 dias o menos: Carisma +2 hasta maximo 30. El libro pierde su magia y la recupera en un siglo.")
	_m("tomo_de_la_lengua_silenciada", "Tomo de la Lengua Silenciada", ItemData.Rarity.LEGENDARIO, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.SPECIFIC,
		"Libro de conjuros + Foco Arcano; Accion Adicional: lanzar conjuro del tomo sin gastar espacio ni componentes V/S; 1/amanecer",
		"Libro con lengua desecada fijada a la cubierta. Puedes usarlo como Libro de Conjuros y Foco Arcano. Accion Adicional: lanzar conjuro escrito en el tomo sin gastar espacio ni componentes Verbales o Somaticos. 1/amanecer.\n\nSolo tu puedes retirar la lengua; si lo haces, todos los conjuros escritos son borrados permanentemente. Vecna puede escribir mensajes en el libro que se desvanecen tras ser leidos.")
	_m("tomo_de_comprension", "Tomo de Comprension", ItemData.Rarity.MUY_RARO, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.NONE,
		"48h de estudio en 6 dias: SAB +2 (max 30); el libro pierde su magia y la recupera en un siglo",
		"Contiene ejercicios de intuicion e introspeccion cargados de magia. Estudiar 48h durante 6 dias o menos: Sabiduria +2 hasta maximo 30. El libro pierde su magia y la recupera en un siglo.")
	_set_desc("tridente_de_mando_de_peces",
		"3 cargas (recupera 1d3/amanecer). Mientras lo portas puedes gastar 1 carga para lanzar Dominar Bestia (CD15) sobre una Bestia con Velocidad de Natacion.")

# ============================================================
# DESCRIPCIONES COMPLETAS — LETRA U
# ============================================================

func _register_descriptions_U() -> void:
	_m("disolvente_universal", "Disolvente Universal", ItemData.Rarity.LEGENDARIO, ItemData.ItemType.CONSUMABLE,
		MagicItemData.Attunement.NONE,
		"Accion de Utilizar: verter 1+ onzas disuelve hasta 0,09m2 de adhesivo (incluyendo Pegamento Soberano)",
		"Este tubo contiene un liquido lechoso con fuerte olor a alcohol (1d6+1 onzas). Accion de Utilizar: verter 1 o mas onzas sobre una superficie al alcance. Cada onza disuelve instantaneamente hasta 0,09m2 de adhesivo, incluyendo Pegamento Soberano.")

# ============================================================
# DESCRIPCIONES COMPLETAS — LETRA V
# ============================================================

func _register_descriptions_V() -> void:
	_m("baston_del_veterano", "Baston del Veterano", ItemData.Rarity.COMUN, ItemData.ItemType.WEAPON,
		MagicItemData.Attunement.NONE,
		"Accion Adicional: transformar el baston en Espada Larga ordinaria o revertirlo",
		"Como Accion Adicional, puedes transformar este baston de paseo en una Espada Larga ordinaria o cambiarla de vuelta a un baston. Debes estar sosteniendo el objeto.")
	_set_desc("espada_viciosa",
		"Esta arma magica inflige 2d6 dano adicional a cualquier criatura que golpee. Este dano adicional es del mismo tipo que el dano normal del arma.")
	_set_desc("espada_vorpal",
		"+3 a las tiradas de ataque y dano con esta arma magica. Ignora la Resistencia al dano Cortante.\n\nCuando atacas a una criatura que tenga al menos una cabeza y sacas un 20 en el d20, le cortas una cabeza. La criatura muere si no puede sobrevivir sin ella. Inmunidad al Cortante, no necesitar cabeza, o ser demasiado grande: en su lugar sufre 30 dano Cortante adicional. La Resistencia Legendaria puede evitar la decapitacion.")

# ============================================================
# DESCRIPCIONES COMPLETAS — LETRA W
# ============================================================

func _register_descriptions_W() -> void:
	_m("municion_atronadora", "Municion Atronadora", ItemData.Rarity.COMUN, ItemData.ItemType.AMMUNITION,
		MagicItemData.Attunement.NONE,
		"La criatura golpeada hace CD 10 FUE o queda Derribada",
		"Una criatura golpeada por esta municion debe superar una tirada de salvacion de Fuerza CD 10 o tener la condicion Derribado.")
	_m("varita_de_vinculacion", "Varita de Vinculacion", ItemData.Rarity.RARO, ItemData.ItemType.MISC,
		MagicItemData.Attunement.ANY,
		"7 cargas; lanzar Detener Persona (2) o Detener Monstruo (5) CD 17; recupera 1d6+1/amanecer",
		"7 cargas. Mientras la sostienes: Detener Persona (2 cargas, CD 17) o Detener Monstruo (5 cargas, CD 17). Recupera 1d6+1/amanecer.")
	_m("varita_de_conduccion", "Varita de Conduccion", ItemData.Rarity.COMUN, ItemData.ItemType.MISC,
		MagicItemData.Attunement.NONE,
		"3 cargas; Accion Magica: crear musica orquestal (audible 36m) agitandola; recupera todas/amanecer",
		"3 cargas. Accion Magica + 1 carga: crear musica orquestal agitando la varita (audible hasta 36m); termina cuando dejas de agitar. Recupera todas las cargas al amanecer.")
	_m("varita_de_deteccion_de_enemigos", "Varita de Deteccion de Enemigos", ItemData.Rarity.RARO, ItemData.ItemType.MISC,
		MagicItemData.Attunement.ANY,
		"7 cargas; Accion Magica: 1min saber direccion (no distancia) de criatura Hostil mas cercana a 18m; recupera 1d6+1/amanecer",
		"7 cargas. Accion Magica + 1 carga: durante 1min conoces la direccion (no la distancia) de la criatura mas cercana Hostil hacia ti a menos de 18m, incluso si es Invisible, eterea, disfrazada u oculta. El efecto termina si dejas de sostener la varita. Recupera 1d6+1/amanecer.")
	_set_desc("varita_de_miedo",
		"7 cargas. Conjuros (CD 15): Orden ('huir' o 'postrarse' solo) (1 carga), Miedo en Cono de 18m (3 cargas). Recupera 1d6+1/amanecer.")
	_set_desc("varita_de_bolas_de_fuego",
		"7 cargas. Gastar 1-3 cargas para lanzar Bola de Fuego (CD 15). 1 carga = nivel 3; +1 nivel por carga adicional. Recupera 1d6+1/amanecer.")
	_set_desc("varita_de_rayos",
		"7 cargas. Gastar 1-3 cargas para lanzar Rayo (CD 15). 1 carga = nivel 3; +1 nivel por carga adicional. Recupera 1d6+1/amanecer.")
	_set_desc("varita_de_misiles_magicos",
		"7 cargas. Gastar 1-3 cargas para lanzar Proyectil Magico. 1 carga = nivel 1; +1 nivel por carga adicional. Recupera 1d6+1/amanecer.")
	_m("varita_de_orcus", "Varita de Orcus", ItemData.Rarity.LEGENDARIO, ItemData.ItemType.WEAPON,
		MagicItemData.Attunement.ANY,
		"+3 maza +2d12 necrotico; +3 CA; 7 cargas CD18 conjuros necroticos; Convocar No Muertos (15 esqueletos+15 zombis) 1/amanecer; sentiente Caotico Malvado",
		"Creada por Orcus. Sintonizarse (no siendo Orcus): CD17 CON; exito = 10d6 Necrotico; fallo = muerte (Humanoide -> Zombi). +3 maza, +2d12 Necrotico al golpear. +3 CA mientras sostienes la varita. 7 cargas (recupera 1d4+3/amanecer, CD18): Animar Muertos (1), Plaga (2), Circulo de la Muerte (3), Dedo de la Muerte (3), Matar de un Golpe (4), Hablar con los Muertos (1). Convocar No Muertos: 15 Esqueletos + 15 Zombis en 90m, obedecen hasta el amanecer. 1/amanecer. Sentiencia: Caotico Malvado, INT16 SAB12 CAR16.")
	_m("varita_de_paralisis", "Varita de Paralisis", ItemData.Rarity.RARO, ItemData.ItemType.MISC,
		MagicItemData.Attunement.SPELLCASTER,
		"7 cargas; Accion Magica: rayo azul a criatura a 18m -> CD 15 CON o Paralizado 1min; recupera 1d6+1/amanecer",
		"7 cargas. Accion Magica + 1 carga: rayo azul fino hacia criatura visible a 18m. CD15 CON o Paralizado durante 1min (repite la salvacion al final de cada turno del objetivo). Recupera 1d6+1/amanecer.")
	_set_desc("varita_de_polimorfar",
		"7 cargas. Gastar 1 carga para lanzar Polimorfar (CD 15). Recupera 1d6+1/amanecer.")
	_m("varita_de_pirotecnia", "Varita de Pirotecnia", ItemData.Rarity.COMUN, ItemData.ItemType.MISC,
		MagicItemData.Attunement.NONE,
		"7 cargas; Accion Magica: destello multicolor en punto a 36m acompanado de chasquido audible a 90m; recupera 1d6+1/amanecer",
		"7 cargas. Accion Magica + 1 carga: destello inofensivo de luz multicolor en punto a 36m, acompanado de chasquido audible hasta 90m. La luz dura solo un segundo. Recupera 1d6+1/amanecer.")
	_m("varita_de_secretos", "Varita de Secretos", ItemData.Rarity.INFRECUENTE, ItemData.ItemType.MISC,
		MagicItemData.Attunement.NONE,
		"3 cargas; Accion Magica: si hay puerta secreta o trampa a 18m, la varita pulsa y apunta a la mas cercana",
		"3 cargas (recupera 1d3/amanecer). Accion Magica + 1 carga: si hay puerta secreta o trampa a menos de 18m, la varita pulsa y apunta a la mas cercana.")
	_set_desc("varita_del_mago_de_guerra_1",
		"+1 a las tiradas de ataque de conjuro mientras sostienes esta varita. Ademas, ignoras la Cobertura Parcial al hacer tiradas de ataque de conjuro.")
	_set_desc("varita_del_mago_de_guerra_2",
		"+2 a las tiradas de ataque de conjuro mientras sostienes esta varita. Ademas, ignoras la Cobertura Parcial al hacer tiradas de ataque de conjuro.")
	_set_desc("varita_del_mago_de_guerra_3",
		"+3 a las tiradas de ataque de conjuro mientras sostienes esta varita. Ademas, ignoras la Cobertura Parcial al hacer tiradas de ataque de conjuro.")
	_m("varita_de_red", "Varita de Red", ItemData.Rarity.INFRECUENTE, ItemData.ItemType.MISC,
		MagicItemData.Attunement.SPELLCASTER,
		"7 cargas; gastar 1: lanzar Telarana (CD 13); recupera 1d6+1/amanecer",
		"7 cargas. Gastar 1 carga para lanzar Telarana (CD 13). Recupera 1d6+1/amanecer.")
	_set_desc("varita_de_maravillas",
		"7 cargas. Accion Magica + 1 carga: elegir punto a 36m; efecto determinado por 1d100 (CD 15). Efectos posibles incluyen: conjuros (Oscuridad, Fuego de Hadas, Bola de Fuego, Lentitud, Nube Fetida), quedar Aturdido, Rafaga de Viento, lluvia 1min, 600 mariposas, Rayo, agrandar criatura, criatura aleatoria, hierba 18m, objeto al Etereo, reducirte, hojas en criatura, cegarte, Invisibilidad, gemas daninas, Polimorfar criatura, petrificacion. Recupera 1d6+1/amanecer.")
	_m("ola_del_mar", "Ola del Mar", ItemData.Rarity.LEGENDARIO, ItemData.ItemType.WEAPON,
		MagicItemData.Attunement.ANY,
		"+3 ataque/dano; 21 necrotico en 20 natural; burbuja de aire bajo el agua; 3 cargas Dominar Bestia acuatica (CD20); Globo de Invulnerabilidad nv9 1/amanecer; sentiente Neutral",
		"Tridente del Monte Pluma Blanca grabado con olas y criaturas marinas. +3 ataque/dano. 20 natural: +21 Necrotico. Burbuja de aire bajo el agua para respirar normalmente. Ventaja en Iniciativa. 3 cargas (recupera 1d3/amanecer): Dominar Bestia acuatica (CD20). Globo de Invulnerabilidad nv9 1/amanecer. Sentiencia: Neutral, INT14 SAB10 CAR18; habla Acuano. Destruccion: solo en la isla de Forja Tormentosa.")
	_m("arma_de_aviso", "Arma de Aviso", ItemData.Rarity.INFRECUENTE, ItemData.ItemType.WEAPON,
		MagicItemData.Attunement.ANY,
		"Mientras este a tu alcance: despierta a los que duermen naturalmente al inicio del combate; tu y aliados a 9m teneis Ventaja en Iniciativa",
		"Mientras esta arma este a tu alcance y estes sintonizado, tu y tus aliados a menos de 9m obtienen: Alarma (despierta a quienes duermen de forma natural cuando comienza el combate, no a los dormidos por magia) y Preparacion Sobrenatural (Ventaja en tiradas de Iniciativa).")
	_m("pozo_de_muchos_mundos", "Pozo de Muchos Mundos", ItemData.Rarity.LEGENDARIO, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.NONE,
		"Accion Magica: portal bidireccional de 1,8m a otro mundo/plano (DJ decide destino); permanece hasta cerrarse; 1/1d8h",
		"Fino pano negro que se pliega hasta tamano de panuelo. Se despliega en lamina circular de 1,8m. Accion Magica: desplegarlo sobre superficie solida crea portal bidireccional de 1,8m a otro mundo o plano (DJ decide destino). El portal permanece hasta que criatura a 1,5m lo cierra doblando el pano. 1/1d8h tras cerrarse.")
	_m("aplastar", "Aplastar", ItemData.Rarity.LEGENDARIO, ItemData.ItemType.WEAPON,
		MagicItemData.Attunement.SPECIFIC,
		"+3 ataque/dano; Lanzable 18m/54m (1d8/4d8 fuerza extra vs Constructos/Elementales/Gigantes); Onda de Choque CD20 CON Aturdido 1/amanecer; detecta puertas secretas a 9m; sentiente Leal Neutral",
		"Martillo de guerra enano perdido en el Monte Pluma Blanca. Solo para enanos o criaturas sintonizadas con un Cinturon del Pueblo Enano. +3 ataque/dano. Lanzable (18m/54m): +1d8 fuerza al impactar a distancia (o +4d8 vs Constructos, Elementales o Gigantes); vuelve a tu mano. Onda de Choque: Accion Magica, CD20 CON o Aturdido 1min (repite al final de cada turno). 1/amanecer. Detecta puertas secretas a 9m. Puede lanzar Detectar el Bien y el Mal o Localizar Objeto. 1/amanecer cada uno. Sentiencia: Leal Neutral, quiere volver al clan Mightyhammer.")
	_m("abanico_del_viento", "Abanico del Viento", ItemData.Rarity.INFRECUENTE, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.NONE,
		"Lanzar Rafaga de Viento (CD 13); cada uso siguiente antes del amanecer: +20% acumulativo de no funcionar y destruirse",
		"Mientras sostienes este abanico, puedes lanzar Rafaga de Viento (CD 13). Cada vez que el abanico se usa antes del siguiente amanecer, tiene una probabilidad acumulativa del 20% de no funcionar; si falla, se rasga en tiras inutiles no magicas.")
	_m("botas_aladas", "Botas Aladas", ItemData.Rarity.INFRECUENTE, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.ANY,
		"4 cargas; Accion Magica: gastar 1 -> Velocidad de Vuelo 9m durante 1h; al expirar en el aire, desciendes 9m/ronda; recupera 1d4/amanecer",
		"4 cargas (recupera 1d4/amanecer). Accion Magica + 1 carga: Velocidad de Vuelo 9m durante 1h. Si estes volando cuando expire la duracion, desciendes a 9m por ronda hasta que aterrizas.")
	_m("alas_del_vuelo", "Alas del Vuelo", ItemData.Rarity.RARO, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.ANY,
		"Accion Magica: la capa se convierte en alas (Velocidad de Vuelo 18m) durante 1h; si caducan en el aire, caes; 1d12h de recarga",
		"Mientras llevas esta capa, puedes realizar una Accion Magica para convertir la capa en un par de alas en tu espalda. Las alas duran 1h o hasta que termines el efecto como Accion Magica; te dan Velocidad de Vuelo 18m. Si estes en el aire cuando las alas desaparecen, caes. No puedes usarlas de nuevo durante 1d12 horas.")
	_m("vendas_de_poder", "Vendas de Poder", ItemData.Rarity.INFRECUENTE, ItemData.ItemType.MAGIC,
		MagicItemData.Attunement.ANY,
		"+1 a tiradas de ataque y dano con Golpes Desarmados; los golpes infligen Fuerza o tipo normal (a elegir)",
		"Mientras llevas estas vendas, tienes un bonificador de +1 a las tiradas de ataque y de dano con tus Golpes Desarmados (+1 Infrecuente, +2 Raro, +3 Muy Raro). Esos golpes infligen a tu eleccion dano de Fuerza o su tipo normal.")

# ============================================================
# DESCRIPCIONES PENDIENTES — items de _register_all sin letra propia
# ============================================================

func _register_descriptions_extra() -> void:
	# Elven Chain — cota de malla forjada por elfos
	_set_desc("armadura_elfica",
		"Fabricada por maestros elfos, esta cota de malla es extraordinariamente ligera y elegante. Mientras la llevas, obtienes un bonificador de +1 a la Clase de Armadura. Ademas, si no tienes competencia con armaduras medianas, esta armadura te la concede automaticamente: no sufres desventaja en pruebas de Destreza ni en tiradas de sigilo por llevarla.")
	# Berserker Armor — armadura maldita que desata la furia
	_set_desc("armadura_del_berserker",
		"Esta armadura oscura parece vibrar con una energia contenida. Mientras la llevas, obtienes un bonificador de +1 a las tiradas de ataque.\n\nMaldicion. Esta armadura esta maldita; sintonizarse la extiende a ti. Mientras estes maldito eres reacio a quitartela. Siempre que recibas dano de una criatura en combate mientras la llevas, debes superar una tirada de salvacion de Sabiduria CD 15 o entrar en furia. En ese estado, debes atacar a la criatura mas cercana visible en cada uno de tus turnos hasta que no quede ninguna a menos de 18m de ti que puedas ver u oir.")
	# Shield of Protection against Projectiles — escudo deflector
	_set_desc("escudo_de_proteccion_contra_proyectiles",
		"Mientras empunias este Escudo, obtienes un bonificador de +2 a la Clase de Armadura contra tiradas de ataque a distancia. Este bonificador se suma al bonificador normal del escudo a la CA.\n\nAdemas, cuando una criatura a menos de 9m de ti recibe el impacto de un ataque a distancia, puedes usar tu Reaccion para intentar desviar el proyectil: el atacante repite la tirada de ataque con Desventaja; si falla, el ataque no tiene efecto.")
	# Sword of Answering — responde a quien te ataco
	_set_desc("espada_de_respuesta",
		"Obtienes un bonificador de +3 a las tiradas de ataque y de dano con esta espada magica. Ademas, mientras empunias la espada, puedes usar tu Reaccion para realizar un ataque cuerpo a cuerpo con ella contra cualquier criatura dentro de tu alcance que te haya infligido dano. Tienes Ventaja en la tirada de ataque, y cualquier dano que inflijas con este ataque especial ignora cualquier Inmunidad o Resistencia del objetivo a ese tipo de dano.")
	# Boots of Spider Climbing — trepar como arana
	_set_desc("botas_de_arana",
		"Mientras llevas estas botas, puedes moverte hacia arriba, hacia abajo y a traves de superficies verticales y a lo largo de techos, dejando tus manos libres. Tienes una Velocidad de Escalar igual a tu Velocidad de movimiento. Sin embargo, las botas no te permiten moverte de esta forma en superficies resbaladizas, como las cubiertas de hielo o aceite.")
	# Staff of the Magi — el baculo arcano definitivo
	_set_desc("baculo_del_mago",
		"Este baculo tiene 50 cargas y puede usarse como Baston magico con +2 a las tiradas de ataque y de dano. Mientras lo sostienes, obtienes un bonificador de +2 a las tiradas de ataque de conjuro.\n\nAbsorcion de Conjuros. Mientras sostienes el baculo, tienes Ventaja en salvaciones contra conjuros. Ademas, puedes usar tu Reaccion cuando otra criatura lance un conjuro que solo te afecte: el baculo absorbe la magia, cancela el efecto y gana cargas iguales al nivel del conjuro. Si esto llevara el total por encima de 50, el baculo explota (Golpe Retributivo).\n\nConjuros (CD propia): Cerradura Arcana (0), Convocar Elemental (7), Detectar Magia (0), Disipar Magia (3), Agrandar/Reducir (0), Bola de Fuego nv7 (7), Esfera en Llamas (2), Tormenta de Hielo (4), Invisibilidad (2), Abrir (2), Luz (0), Rayo nv7 (7), Mano del Mago (0), Pasarela (5), Desplazamiento Planar (7), Proteccion contra el Bien y el Mal (0), Telequinesia (5), Muro de Fuego (4), Telarana (2). Recupera 4d6+2/amanecer.\n\nGolpe Retributivo. Accion Magica: romper el baculo; explosion en Emanacion de 9m (fuerza x16 al portador; fuerza x6 a otros, CD 17 DES por la mitad).")
