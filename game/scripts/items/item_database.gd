## item_database.gd
## Base de datos central de todos los objetos del juego (D&D 2024).
## Autoload. Acceso: ItemDatabase.get_weapon("espada_larga")
##
## FUENTE: Documentación DND/Equipo/EQUIPO.txt (D&D 2024)
## Las armas, armaduras y consumibles se registran en _ready().

extends Node

# ============================================================
# REGISTROS INDEXADOS POR item_id
# ============================================================
var weapons:     Dictionary = {}
var armors:      Dictionary = {}
var consumables: Dictionary = {}
var all_items:   Dictionary = {}   # índice unificado

# ============================================================
# LIFECYCLE
# ============================================================

func _ready() -> void:
	_register_weapons()
	_register_armors()
	_register_consumables()

# ============================================================
# API PÚBLICA
# ============================================================

func get_weapon(id: String)      -> WeaponData:     return weapons.get(id)
func get_armor(id: String)       -> ArmorData:      return armors.get(id)
func get_consumable(id: String)  -> ConsumableData: return consumables.get(id)
func get_item(id: String)        -> ItemData:       return all_items.get(id)

func get_all_weapons()     -> Array[WeaponData]:    return weapons.values()
func get_all_armors()      -> Array[ArmorData]:     return armors.values()
func get_all_consumables() -> Array[ConsumableData]: return consumables.values()

func get_weapons_by_category(cat: WeaponData.WeaponCategory) -> Array[WeaponData]:
	return weapons.values().filter(func(w: WeaponData) -> bool: return w.category == cat)

# ============================================================
# REGISTRO DE ARMAS (D&D 2024)
# ============================================================

func _register_weapons() -> void:

	# ── ARMAS CUERPO A CUERPO SENCILLAS ──────────────────────

	_w("baston",       "Bastón",          1, 6, "contundente",
		WeaponData.WeaponCategory.SENCILLA_CUERPO,
		WeaponData.MasteryProperty.DERRIBAR,
		2.0, 0.2,
		{is_versatile=true, versatile_sides=8})

	_w("daga",         "Daga",            1, 4, "perforante",
		WeaponData.WeaponCategory.SENCILLA_CUERPO,
		WeaponData.MasteryProperty.MELLAR,
		0.5, 2.0,
		{is_light=true, is_finesse=true, is_thrown=true, thrown_normal_ft=20, thrown_long_ft=60})

	_w("garrote",      "Garrote",         1, 4, "contundente",
		WeaponData.WeaponCategory.SENCILLA_CUERPO,
		WeaponData.MasteryProperty.RALENTIZAR,
		1.0, 0.1,
		{is_light=true})

	_w("garrote_grande","Garrote grande",  1, 8, "contundente",
		WeaponData.WeaponCategory.SENCILLA_CUERPO,
		WeaponData.MasteryProperty.EMPUJAR,
		5.0, 0.2,
		{is_two_handed=true})

	_w("hacha_mano",   "Hacha de mano",   1, 6, "cortante",
		WeaponData.WeaponCategory.SENCILLA_CUERPO,
		WeaponData.MasteryProperty.MOLESTAR,
		1.0, 5.0,
		{is_light=true, is_thrown=true, thrown_normal_ft=20, thrown_long_ft=60})

	_w("hoz",          "Hoz",             1, 4, "cortante",
		WeaponData.WeaponCategory.SENCILLA_CUERPO,
		WeaponData.MasteryProperty.MELLAR,
		1.0, 1.0,
		{is_light=true})

	_w("jabalina",     "Jabalina",        1, 6, "perforante",
		WeaponData.WeaponCategory.SENCILLA_CUERPO,
		WeaponData.MasteryProperty.RALENTIZAR,
		1.0, 0.5,
		{is_thrown=true, thrown_normal_ft=30, thrown_long_ft=120})

	_w("lanza",        "Lanza",           1, 6, "perforante",
		WeaponData.WeaponCategory.SENCILLA_CUERPO,
		WeaponData.MasteryProperty.DEBILITAR,
		1.5, 1.0,
		{is_thrown=true, thrown_normal_ft=20, thrown_long_ft=60, is_versatile=true, versatile_sides=8})

	_w("martillo_ligero","Martillo ligero",1, 4, "contundente",
		WeaponData.WeaponCategory.SENCILLA_CUERPO,
		WeaponData.MasteryProperty.MELLAR,
		1.0, 2.0,
		{is_light=true, is_thrown=true, thrown_normal_ft=20, thrown_long_ft=60})

	_w("maza",         "Maza",            1, 6, "contundente",
		WeaponData.WeaponCategory.SENCILLA_CUERPO,
		WeaponData.MasteryProperty.DEBILITAR,
		2.0, 5.0,
		{})

	# ── ARMAS A DISTANCIA SENCILLAS ──────────────────────────

	_w("arco_corto",   "Arco corto",      1, 6, "perforante",
		WeaponData.WeaponCategory.SENCILLA_DISTANCIA,
		WeaponData.MasteryProperty.MOLESTAR,
		1.0, 25.0,
		{is_ranged=true, range_normal_ft=80, range_long_ft=320, is_two_handed=true, ammunition_type="flecha"})

	_w("ballesta_ligera","Ballesta ligera",1, 8, "perforante",
		WeaponData.WeaponCategory.SENCILLA_DISTANCIA,
		WeaponData.MasteryProperty.RALENTIZAR,
		2.5, 25.0,
		{is_ranged=true, range_normal_ft=80, range_long_ft=320, is_two_handed=true, has_reload=true, ammunition_type="virote"})

	_w("dardo",        "Dardo",           1, 4, "perforante",
		WeaponData.WeaponCategory.SENCILLA_DISTANCIA,
		WeaponData.MasteryProperty.MOLESTAR,
		0.125, 0.05,
		{is_finesse=true, is_thrown=true, thrown_normal_ft=20, thrown_long_ft=60})

	_w("honda",        "Honda",           1, 4, "contundente",
		WeaponData.WeaponCategory.SENCILLA_DISTANCIA,
		WeaponData.MasteryProperty.RALENTIZAR,
		0.0, 0.1,
		{is_ranged=true, range_normal_ft=30, range_long_ft=120, ammunition_type="proyectil"})

	# ── ARMAS CUERPO A CUERPO MARCIALES ──────────────────────

	_w("alabarda",     "Alabarda",        1,10, "cortante",
		WeaponData.WeaponCategory.MARCIAL_CUERPO,
		WeaponData.MasteryProperty.HENDER,
		3.0, 20.0,
		{is_two_handed=true, is_heavy=true, is_reach=true})

	_w("cimitarra",    "Cimitarra",       1, 6, "cortante",
		WeaponData.WeaponCategory.MARCIAL_CUERPO,
		WeaponData.MasteryProperty.MELLAR,
		1.5, 25.0,
		{is_light=true, is_finesse=true})

	_w("espada_corta", "Espada corta",    1, 6, "perforante",
		WeaponData.WeaponCategory.MARCIAL_CUERPO,
		WeaponData.MasteryProperty.MOLESTAR,
		1.0, 10.0,
		{is_light=true, is_finesse=true})

	_w("espada_larga", "Espada larga",    1, 8, "cortante",
		WeaponData.WeaponCategory.MARCIAL_CUERPO,
		WeaponData.MasteryProperty.DEBILITAR,
		1.5, 15.0,
		{is_versatile=true, versatile_sides=10})

	_w("espadon",      "Espadón",         2, 6, "cortante",
		WeaponData.WeaponCategory.MARCIAL_CUERPO,
		WeaponData.MasteryProperty.HENDER,
		3.5, 50.0,
		{is_two_handed=true, is_heavy=true})

	_w("estoque",      "Estoque",         1, 8, "perforante",
		WeaponData.WeaponCategory.MARCIAL_CUERPO,
		WeaponData.MasteryProperty.ROZAR,
		1.0, 25.0,
		{is_finesse=true})

	_w("guja",         "Guja",            1,10, "cortante",
		WeaponData.WeaponCategory.MARCIAL_CUERPO,
		WeaponData.MasteryProperty.HENDER,
		3.0, 20.0,
		{is_two_handed=true, is_heavy=true, is_reach=true})

	_w("hacha_dos_manos","Hacha a dos manos",1,12,"cortante",
		WeaponData.WeaponCategory.MARCIAL_CUERPO,
		WeaponData.MasteryProperty.HENDER,
		3.5, 30.0,
		{is_two_handed=true, is_heavy=true})

	_w("hacha_guerra", "Hacha de guerra", 1, 8, "cortante",
		WeaponData.WeaponCategory.MARCIAL_CUERPO,
		WeaponData.MasteryProperty.MOLESTAR,
		2.0, 10.0,
		{is_versatile=true, versatile_sides=10})

	_w("lanza_caballeria","Lanza de caballería",1,10,"perforante",
		WeaponData.WeaponCategory.MARCIAL_CUERPO,
		WeaponData.MasteryProperty.DERRIBAR,
		3.0, 10.0,
		{is_two_handed=true, is_heavy=true, is_reach=true})  # a dos manos salvo montado

	_w("latigo",       "Látigo",          1, 4, "cortante",
		WeaponData.WeaponCategory.MARCIAL_CUERPO,
		WeaponData.MasteryProperty.RALENTIZAR,
		1.5, 2.0,
		{is_finesse=true, is_reach=true})

	_w("lucero_alba",  "Lucero del alba", 1, 8, "perforante",
		WeaponData.WeaponCategory.MARCIAL_CUERPO,
		WeaponData.MasteryProperty.DEBILITAR,
		2.0, 15.0,
		{is_versatile=true, versatile_sides=10})

	_w("mangual",      "Mangual",         2, 4, "contundente",
		WeaponData.WeaponCategory.MARCIAL_CUERPO,
		WeaponData.MasteryProperty.DEBILITAR,
		1.0, 10.0,
		{})  # en 2024 mangual es 2d4

	_w("martillo_guerra","Martillo de guerra",1,8,"contundente",
		WeaponData.WeaponCategory.MARCIAL_CUERPO,
		WeaponData.MasteryProperty.EMPUJAR,
		2.0, 15.0,
		{is_versatile=true, versatile_sides=10})

	_w("maza_dos_manos","Maza a dos manos",2, 6, "contundente",
		WeaponData.WeaponCategory.MARCIAL_CUERPO,
		WeaponData.MasteryProperty.EMPUJAR,
		9.0, 50.0,
		{is_two_handed=true, is_heavy=true})

	_w("pica",         "Pica",            1,10, "perforante",
		WeaponData.WeaponCategory.MARCIAL_CUERPO,
		WeaponData.MasteryProperty.EMPUJAR,
		9.0, 5.0,
		{is_two_handed=true, is_heavy=true, is_reach=true})

	_w("pico_guerra",  "Pico de guerra",  1, 8, "perforante",
		WeaponData.WeaponCategory.MARCIAL_CUERPO,
		WeaponData.MasteryProperty.DEBILITAR,
		2.0, 5.0,
		{})

	_w("tridente",     "Tridente",        1, 6, "perforante",
		WeaponData.WeaponCategory.MARCIAL_CUERPO,
		WeaponData.MasteryProperty.DERRIBAR,
		2.0, 5.0,
		{is_thrown=true, thrown_normal_ft=20, thrown_long_ft=60, is_versatile=true, versatile_sides=8})

	# ── ARMAS A DISTANCIA MARCIALES ───────────────────────────

	_w("arco_largo",   "Arco largo",      1, 8, "perforante",
		WeaponData.WeaponCategory.MARCIAL_DISTANCIA,
		WeaponData.MasteryProperty.RALENTIZAR,
		1.0, 50.0,
		{is_ranged=true, range_normal_ft=150, range_long_ft=600, is_two_handed=true, is_heavy=true, ammunition_type="flecha"})

	_w("ballesta_mano","Ballesta de mano",1, 6, "perforante",
		WeaponData.WeaponCategory.MARCIAL_DISTANCIA,
		WeaponData.MasteryProperty.MOLESTAR,
		1.5, 75.0,
		{is_ranged=true, range_normal_ft=30, range_long_ft=120, is_light=true, has_reload=true, ammunition_type="virote"})

	_w("ballesta_pesada","Ballesta pesada",1,10,"perforante",
		WeaponData.WeaponCategory.MARCIAL_DISTANCIA,
		WeaponData.MasteryProperty.EMPUJAR,
		9.0, 50.0,
		{is_ranged=true, range_normal_ft=100, range_long_ft=400, is_two_handed=true, is_heavy=true, has_reload=true, ammunition_type="virote"})

	_w("cerbatana",    "Cerbatana",       1, 1, "perforante",
		WeaponData.WeaponCategory.MARCIAL_DISTANCIA,
		WeaponData.MasteryProperty.MOLESTAR,
		0.5, 10.0,
		{is_ranged=true, range_normal_ft=25, range_long_ft=100, has_reload=true, ammunition_type="dardo"})

	_w("mosquete",     "Mosquete",        1,12, "perforante",
		WeaponData.WeaponCategory.MARCIAL_DISTANCIA,
		WeaponData.MasteryProperty.RALENTIZAR,
		5.0, 500.0,
		{is_ranged=true, range_normal_ft=40, range_long_ft=120, is_two_handed=true, has_reload=true, ammunition_type="bala"})

	_w("pistola",      "Pistola",         1,10, "perforante",
		WeaponData.WeaponCategory.MARCIAL_DISTANCIA,
		WeaponData.MasteryProperty.MOLESTAR,
		1.5, 250.0,
		{is_ranged=true, range_normal_ft=30, range_long_ft=90, has_reload=true, ammunition_type="bala"})

# ============================================================
# REGISTRO DE ARMADURAS (D&D 2024)
# ============================================================

func _register_armors() -> void:

	# ── LIGERAS ────────────────────────────────────────────────
	_a("armadura_acolchada", "Armadura acolchada", ArmorData.ArmorCategory.LIGERA,
		11, -1, 0, true, 4.0, 5.0)

	_a("armadura_cuero", "Armadura de cuero", ArmorData.ArmorCategory.LIGERA,
		11, -1, 0, false, 5.0, 10.0)

	_a("cuero_tachonado", "Armadura de cuero tachonado", ArmorData.ArmorCategory.LIGERA,
		12, -1, 0, false, 6.5, 45.0)

	# ── MEDIAS ─────────────────────────────────────────────────
	_a("armadura_pieles", "Armadura de pieles", ArmorData.ArmorCategory.MEDIA,
		12, 2, 0, false, 6.0, 10.0)

	_a("camisa_malla", "Camisa de malla", ArmorData.ArmorCategory.MEDIA,
		13, 2, 0, false, 10.0, 50.0)

	_a("cota_escamas", "Cota de escamas", ArmorData.ArmorCategory.MEDIA,
		14, 2, 0, true, 22.5, 50.0)

	_a("coraza", "Coraza", ArmorData.ArmorCategory.MEDIA,
		14, 2, 0, false, 10.0, 400.0)

	_a("media_armadura", "Media armadura", ArmorData.ArmorCategory.MEDIA,
		15, 2, 0, true, 20.0, 750.0)

	# ── PESADAS ────────────────────────────────────────────────
	_a("cota_guarnecida", "Cota guarnecida", ArmorData.ArmorCategory.PESADA,
		14, 0, 0, true, 20.0, 30.0)

	_a("cota_malla", "Cota de mallas", ArmorData.ArmorCategory.PESADA,
		16, 0, 13, true, 27.5, 75.0)

	_a("armadura_bandas", "Armadura de bandas", ArmorData.ArmorCategory.PESADA,
		17, 0, 15, true, 30.0, 200.0)

	_a("armadura_placas", "Armadura de placas", ArmorData.ArmorCategory.PESADA,
		18, 0, 15, true, 32.5, 1500.0)

	# ── ESCUDO ─────────────────────────────────────────────────
	_a("escudo", "Escudo", ArmorData.ArmorCategory.ESCUDO,
		2, -1, 0, false, 3.0, 10.0)

# ============================================================
# REGISTRO DE CONSUMIBLES (D&D 2024)
# ============================================================

func _register_consumables() -> void:

	# ── POCIONES ───────────────────────────────────────────────
	_c_potion("pocion_curacion",        "Poción de Curación",         2, 4, 2,  0.5, 50.0)
	_c_potion("pocion_curacion_mayor",  "Poción de Curación (mayor)", 4, 4, 4,  0.5, 300.0)
	_c_potion("pocion_curacion_excelente","Poción de Curación (excelente)",8,4,8, 0.5, 500.0)
	_c_potion("pocion_curacion_suprema","Poción de Curación (suprema)",10,4,20, 0.5, 1350.0)

	# ── VENENOS (D&D 2024) ────────────────────────────────────
	# Fuente: Documentación DND/Poison.txt
	_c("veneno_basico",          "Veneno básico",                 ConsumableData.ConsumableType.POISON, 1,0,0,0,0.0,0.1,100.0,   "Herida. Desventaja en ataques/pruebas hasta curado.")
	_c("sangre_asesino",         "Sangre de asesino",             ConsumableData.ConsumableType.POISON, 1,1,12,0,0.0,0.1,150.0,  "Ingestión. CD 10 CON: 1d12 veneno + envenenado 24h.")
	_c("humos_othur",            "Humos de Othur quemado",        ConsumableData.ConsumableType.POISON, 1,3,6,0,0.0,0.1,500.0,   "Inhalado. CD 13 CON: 3d6 veneno + repetir save; fallo -1d6; 3 éxitos acaban.")
	_c("mucosidad_carr",         "Mucosidad de ciempiés carroñero",ConsumableData.ConsumableType.POISON,1,0,0,0,0.0,0.1,200.0,   "Contacto. CD 13 CON: envenenado 1min + paralizado mientras envenenado.")
	_c("esencia_eter",           "Esencia de éter",               ConsumableData.ConsumableType.POISON, 1,0,0,0,0.0,0.1,300.0,   "Inhalado. CD 15 CON: envenenado 8h + inconsciente mientras envenenado.")
	_c("aguijón_lolth",          "Aguijón de Lolth",              ConsumableData.ConsumableType.POISON, 1,0,0,0,0.0,0.1,200.0,   "Herida. CD 13 CON: envenenado 1h (fallo por 5+: inconsciente).")
	_c("malicia",                "Malicia",                       ConsumableData.ConsumableType.POISON, 1,0,0,0,0.0,0.1,250.0,   "Inhalado. CD 15 CON: envenenado 1h + cegado mientras envenenado.")
	_c("lagrimas_medianoche",    "Lágrimas de medianoche",        ConsumableData.ConsumableType.POISON, 1,9,6,0,0.0,0.1,1500.0,  "Ingestión. Sin efecto hasta medianoche: 9d6 veneno (CD 17 CON mitad).")
	_c("aceite_taggit",          "Aceite de Taggit",              ConsumableData.ConsumableType.POISON, 1,0,0,0,0.0,0.1,400.0,   "Contacto. CD 13 CON: envenenado 24h + inconsciente mientras envenenado.")
	_c("tintura_palida",         "Tintura pálida",                ConsumableData.ConsumableType.POISON, 1,1,6,0,0.0,0.1,250.0,   "Ingestión. CD 16 CON: 1d6 veneno + envenenado; repetir 24h; 7 éxitos acaban.")
	_c("veneno_sierpe_purpura",  "Veneno de sierpe de púrpura",   ConsumableData.ConsumableType.POISON, 1,10,6,0,0.0,0.1,2000.0, "Herida. CD 21 CON: 10d6 veneno (mitad si éxito).")
	_c("veneno_serpiente",       "Veneno de serpiente",           ConsumableData.ConsumableType.POISON, 1,3,6,0,0.0,0.1,200.0,   "Herida. CD 11 CON: 3d6 veneno (mitad si éxito).")
	_c("torpor",                 "Torpor",                        ConsumableData.ConsumableType.POISON, 1,0,0,0,0.0,0.1,600.0,   "Ingestión. CD 15 CON: envenenado 4d6 horas + velocidad a la mitad.")
	_c("suero_verdad",           "Suero de la verdad",            ConsumableData.ConsumableType.POISON, 1,0,0,0,0.0,0.1,150.0,   "Ingestión. CD 11 CON: envenenado 1h + no puede mentir conscientemente.")
	_c("veneno_wyvern",          "Veneno de wyvern",              ConsumableData.ConsumableType.POISON, 1,7,6,0,0.0,0.1,1200.0,  "Herida. CD 14 CON: 7d6 veneno (mitad si éxito).")

	# ── MUNICIÓN ───────────────────────────────────────────────
	_c("flechas",    "Flechas (x20)",   ConsumableData.ConsumableType.AMMUNITION, 20, 0,0,0, 0.0, 0.5,  1.0, "")
	_c("virotes",    "Virotes (x20)",   ConsumableData.ConsumableType.AMMUNITION, 20, 0,0,0, 0.0, 0.75, 1.0, "")
	_c("proyectiles","Proyectiles (x20)",ConsumableData.ConsumableType.AMMUNITION,20, 0,0,0, 0.0, 0.15, 1.0, "")
	_c("balas_af",   "Balas (x10)",     ConsumableData.ConsumableType.AMMUNITION, 10, 0,0,0, 0.0, 0.3,  3.0, "")
	_c("dardos_cerb","Dardos (x50)",    ConsumableData.ConsumableType.AMMUNITION, 50, 0,0,0, 0.0, 0.5,  1.0, "")

	# ── EQUIPO DE AVENTURERO ───────────────────────────────────
	_c("antorcha",   "Antorcha",        ConsumableData.ConsumableType.ADVENTURING, 1, 0,0,0, 0.0, 0.5,  0.01, "Ilumina 6m, 12m tenue durante 1 hora.")
	_c("raciones",   "Raciones (1 día)",ConsumableData.ConsumableType.ADVENTURING, 1, 0,0,0, 0.0, 0.5,  0.5,  "Comida para 1 día.")
	_c("antitoxina", "Antitoxina",      ConsumableData.ConsumableType.ADVENTURING, 1, 0,0,0, 0.0, 0.5,  50.0, "Ventaja en salvaciones contra veneno durante 1 hora.")
	_c("kit_curador","Útiles de sanador",ConsumableData.ConsumableType.ADVENTURING,10,0,0,0, 0.0, 1.5,  5.0,  "Estabilizar a una criatura con 0 PG sin tirada.")
	_c("aceite",     "Aceite",          ConsumableData.ConsumableType.ADVENTURING, 1, 0,0,0, 0.0, 0.5,  0.1,  "Cubre una superficie 1.5m² o hace 5 daño fuego al encenderse.")
	_c("acido",      "Ácido",           ConsumableData.ConsumableType.ADVENTURING, 1, 0,0,0, 0.0, 0.5,  25.0, "Lanzar: 2d6 daño ácido (sal. DES CD 8+DES+BC).")
	_c("agua_bendita","Agua bendita",   ConsumableData.ConsumableType.ADVENTURING, 1, 0,0,0, 0.0, 0.5,  25.0, "2d8 daño radiante a muertos vivientes e infernales.")
	_c("fuego_alquimista","Fuego de alquimista",ConsumableData.ConsumableType.ADVENTURING,1,0,0,0,0.0,0.5,50.0,"1d4 fuego/turno hasta apagarse (acción).")
	_c("cuerda",     "Cuerda (15m)",    ConsumableData.ConsumableType.ADVENTURING, 1, 0,0,0, 0.0, 2.0,  1.0,  "")
	_c("escalera",   "Escalera (3m)",   ConsumableData.ConsumableType.ADVENTURING, 1, 0,0,0, 0.0, 6.0,  0.1,  "")

# ============================================================
# HELPERS PRIVADOS DE REGISTRO
# ============================================================

func _w(id: String, name: String, dice_count: int, dice_sides: int, dtype: String,
		cat: WeaponData.WeaponCategory, mastery: WeaponData.MasteryProperty,
		weight: float, price: float, props: Dictionary) -> void:

	var w := WeaponData.new()
	w.item_id           = id
	w.display_name      = name
	w.item_type         = ItemData.ItemType.WEAPON
	w.damage_dice_count = dice_count
	w.damage_dice_sides = dice_sides
	w.damage_type       = dtype
	w.category          = cat
	w.mastery           = mastery
	w.weight_kg         = weight
	w.price_gp          = price

	for key in props:
		w.set(key, props[key])

	weapons[id] = w
	all_items[id] = w

func _a(id: String, name: String, cat: ArmorData.ArmorCategory,
		base_ac: int, max_dex: int, req_str: int,
		stealth_dis: bool, weight: float, price: float) -> void:

	var a := ArmorData.new()
	a.item_id              = id
	a.display_name         = name
	a.item_type            = ItemData.ItemType.ARMOR
	a.armor_category       = cat
	a.base_ac              = base_ac
	a.max_dex_bonus        = max_dex
	a.requires_strength    = req_str
	a.stealth_disadvantage = stealth_dis
	a.weight_kg            = weight
	a.price_gp             = price

	armors[id] = a
	all_items[id] = a

func _c_potion(id: String, name: String,
		dice_count: int, dice_sides: int, bonus: int,
		weight: float, price: float) -> void:
	var c := ConsumableData.new()
	c.item_id         = id
	c.display_name    = name
	c.item_type       = ItemData.ItemType.CONSUMABLE
	c.consumable_type = ConsumableData.ConsumableType.POTION
	c.heal_dice_count = dice_count
	c.heal_dice_sides = dice_sides
	c.heal_bonus      = bonus
	c.weight_kg       = weight
	c.price_gp        = price
	c.description     = "Recuperas %dd%d+%d PG (acción adicional)." % [dice_count, dice_sides, bonus]
	consumables[id]   = c
	all_items[id]     = c

func _c(id: String, name: String, ctype: ConsumableData.ConsumableType,
		uses: int, hdice: int, dsides: int, hbonus: int,
		weight: float, wkg: float, price: float, desc: String) -> void:
	var c := ConsumableData.new()
	c.item_id         = id
	c.display_name    = name
	c.item_type       = ItemData.ItemType.CONSUMABLE
	c.consumable_type = ctype
	c.uses            = uses
	c.heal_dice_count = hdice
	c.heal_dice_sides = dsides
	c.heal_bonus      = hbonus
	c.weight_kg       = wkg
	c.price_gp        = price
	c.description     = desc
	consumables[id]   = c
	all_items[id]     = c
