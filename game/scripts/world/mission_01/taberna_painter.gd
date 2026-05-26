## taberna_painter.gd
## Genera la escena visual de la taberna con tiles isometricos.
##
## Para regenerar la escena: añadir @tool al principio, reabrir la escena en Godot,
## quitar @tool y guardar. Asi se preservan los cambios manuales entre regeneraciones.
##
## Offsets calibrados (espacio local, scale=4, se multiplican x4 en pantalla):
##   FLOOR  iso_floor_wood.png  (thin tile)  → -18
##   WALL   iso_wall_stone.png  (block)      → -16
##   OBJECT mesas/barriles/barra            → -36
extends Node2D

const TILE_W  := 256
const TILE_H  := 128

const ISO_FLOOR  := "res://assets/tilesets/taberna_custom/iso_floor_wood.png"

## Muros Kenney 256x512 — proporcion correcta (panel vertical, no cubo).
## Tinte oscuro via modulate para el estilo grimdark.
## PENDIENTE: reemplazar con assets PixelLab propios cuando haya creditos.
const WALL_COLOR := Color(0.30, 0.33, 0.45)
const KEN_DIR    := "res://assets/tilesets/kenney_dungeon/Isometric/"
const WALL_NW     := KEN_DIR + "stoneWallAged_E.png"      ## pared izq-trasera
const WALL_NE     := KEN_DIR + "stoneWallAged_N.png"      ## pared der-trasera
const WALL_CORNER := KEN_DIR + "stoneWallCorner_N.png"    ## esquina interior NW+NE
const WALL_DOOR   := KEN_DIR + "stoneWallDoor_E.png"      ## puerta en pared NW
## Color de muebles: tinte calido oscuro para el interior de la taberna
const OBJ_TABLE   := "res://assets/tilesets/taberna_custom/table_round.png"
const OBJ_BARREL  := "res://assets/tilesets/taberna_custom/barrels.png"
const OBJ_BAR     := "res://assets/tilesets/taberna_custom/iso_bar_counter.png"
const OBJ_FIRE    := "res://assets/tilesets/taberna_custom/fireplace.png"

const ROOM_MIN := 1
const ROOM_MAX := 8

func _ready() -> void:
	if Engine.is_editor_hint():
		_build()
	else:
		## En runtime: corregir z-indices guardados por versiones anteriores del @tool.
		## Sprites con z >= 200 son objetos con la formula antigua (*640).
		## Los actualizamos a 1000+posicion_y+1 para depth sorting correcto.
		## Sprites con z < 40 = suelo, z 40-199 = paredes → no tocar (ya correctos).
		_fix_runtime_depths()

func _fix_runtime_depths() -> void:
	for child in get_children():
		if child is Sprite2D:
			var s := child as Sprite2D
			if s.z_index >= 200:
				s.z_index = 1000 + int(s.position.y) + 1

func iso_pos(mx: int, my: int) -> Vector2:
	return Vector2((mx - my) * TILE_W / 2.0, (mx + my) * TILE_H / 2.0)

func iso_z(mx: int, my: int, layer: int = 0) -> int:
	## Z isometrico preciso. Limites: [-4096, 4096]. Valores usados: -30 a 2025.
	##
	##  layer 0 (suelo):   z = (mx+my)*2            rango [-30 a 32]  SIEMPRE abajo
	##  layer 1 (paredes): z = (mx+my)*10 + 2        rango [12 a 162] encima suelo
	##  layer 2 (objetos): z = 1000 + (mx+my)*64 + 1 rango [1065 a 2025] precision 1px
	##
	## Personaje usa: 1000 + int(position.y)         rango [1064 a 2024]
	## A igual Y: objeto z = personaje z + 1 → objeto ligeramente delante.
	## Cuando personaje avanza 1px: su z > objeto → aparece encima. Precision exacta.
	match layer:
		0: return (mx + my) * 2
		1: return (mx + my) * 10 + 2
		_: return 1000 + (mx + my) * 64 + 1

func _build() -> void:
	var old: Array[Node] = []
	for child in get_children():
		if child is Sprite2D:
			old.append(child)
	for node in old:
		node.free()
	_ensure_nav_nodes()
	_paint_floor()
	_paint_walls()
	_paint_objects()

# ─── SUELO ────────────────────────────────────────────────────────────────────

func _paint_floor() -> void:
	for mx in range(ROOM_MIN, ROOM_MAX + 1):
		for my in range(ROOM_MIN, ROOM_MAX + 1):
			var pos := iso_pos(mx, my)
			_add_sprite(int(pos.x), int(pos.y), iso_z(mx, my, 0), ISO_FLOOR, 4.0, -18)

# ─── MUROS ────────────────────────────────────────────────────────────────────
## Solo paredes traseras: NW (mx=0) y NE (my=0).
## No paredes frontales — la apertura delantera es convención isometrica estándar
## (Divinity, Baldur's Gate, Children of Morta).

## Posicion de la puerta en la pared NW (hueco en la pared)
const DOOR_MY := 4  ## my donde va la puerta en el muro NW (mx=0)

func _paint_walls() -> void:
	## REGLA ISOMETRICA: solo paredes traseras (las que la camara ve).
	## Las paredes frontales NO se ponen — el suelo define el borde delantero.
	## Esto es el estandar de todos los RPG isometricos (BG, PoE, DoS2).
	##
	## Esquema visual:
	##   [CRN]──── PARED NE ────────────────────
	##     │  \                                  \
	##  PARED  (interior)                   BARRA │
	##   NW    mesas                              │
	##  [PRT]                              barriles
	##     │  floor edge visible = borde de sala  │
	##     └──────────── suelo (8x8) ────────────-┘
	##
	## CRN = stoneWallCorner_N en (0,0): esquina donde NW y NE se unen
	## PRT = puerta en NW, my=DOOR_MY

	## ── Esquina trasera: stoneWallCorner_N en iso_pos(0,0) ──────────────
	## Muestra la union interior entre pared NW y NE. z alto para estar delante de todo.
	var corner_pos := iso_pos(0, 0)
	_add_wall(int(corner_pos.x), int(corner_pos.y), iso_z(ROOM_MIN, ROOM_MIN, 1) + 2, WALL_CORNER)

	## ── Pared NW (izquierda): mx=0, my=1..ROOM_MAX con hueco para puerta ─
	for my in range(1, ROOM_MAX + 1):
		if my == DOOR_MY:
			continue
		var pos := iso_pos(0, my)
		_add_wall(int(pos.x), int(pos.y), iso_z(ROOM_MIN, my, 1), WALL_NW)

	## Puerta en la pared NW
	var dp := iso_pos(0, DOOR_MY)
	_add_wall(int(dp.x), int(dp.y), iso_z(ROOM_MIN, DOOR_MY, 1), WALL_DOOR)

	## ── Pared NE (fondo): my=0, mx=1..ROOM_MAX ───────────────────────────
	## Empieza en mx=1 — la esquina (0,0) ya la cubre WALL_CORNER
	for mx in range(1, ROOM_MAX + 1):
		var pos := iso_pos(mx, 0)
		_add_wall(int(pos.x), int(pos.y), iso_z(mx, ROOM_MIN, 1), WALL_NE)

# ─── OBJETOS ──────────────────────────────────────────────────────────────────
## Layout de taberna con margen mínimo de 1 tile desde las paredes:
##   - 6 mesas redondas: 2 filas de 3, bien espaciadas
##   - Barra del tabernero: esquina NE interior (cerca del fondo derecho)
##   - Barriles: fondo izquierdo
## Regla: ningún objeto en mx o my <= 1 (margen de pared)
##         y ninguno en mx o my >= 8 (margen de pared NE)

## Layout basado en analisis de referencias (Pillars of Eternity, Baldur's Gate, DoS2):
##
##   mx: 1    2    3    4    5    6    7    8
## my=2: [ ] [FP ] [ ]  [ ]  [ ] [BAR][BAR][BAR]   ← chimenea NW + barra 3t NE
## my=4: [ ] [T1 ] [ ]  [ ] [T2 ] [ ]  [ ]  [ ]   ← fila mesas norte
## my=6: [ ] [T3 ] [ ]  [ ] [T4 ] [ ]  [ ]  [ ]   ← fila mesas sur (pasillo 2t libre)
## my=7: [ ]  [ ]  [ ]  [ ]  [ ]  [ ] [BRL][BRL]  ← barriles esquina SE
##
## Reglas aplicadas:
##   - Barra en pared OPUESTA a la puerta (NW door → barra en NE area, mx alto / my bajo)
##   - 4 mesas en 2 filas de 2 con 3 tiles de separacion entre filas
##   - Min 1 tile de separacion entre objetos y paredes
##   - Barriles en esquina opuesta a la barra (SE)
##   - ~25% de ocupacion = dentro del rango 30-40% con las sillas visibles

func _paint_objects() -> void:
	## ── Chimenea: esquina NW interior (opuesta a la barra) ───────────────
	_place_obj(2, 2, OBJ_FIRE, 4.0, -36)

	## ── Barra del bar: 3 piezas junto a pared NE (mx alto, my bajo) ──────
	## iso_bar_counter.png: block tile 64px, scale=4.0, skip_bottom=12
	## skip_bottom elimina la franja de suelo gris incorporada en el asset
	for bx: int in [6, 7, 8]:
		var bp := iso_pos(bx, 2)
		_add_sprite(int(bp.x), int(bp.y), iso_z(bx, 2, 2), OBJ_BAR, 4.0, -36, 0, 12)

	## ── Mesas: 2 filas de 2, separadas por pasillo de 2 tiles ───────────
	## Separacion entre mesas: 3 tiles (mx=2 y mx=5 → gap de 2 en mx=3-4)
	## Ninguna mesa toca la pared (min 1 tile libre al exterior)
	var tables: Array[Vector2i] = [
		Vector2i(2, 4), Vector2i(5, 4),  ## fila norte
		Vector2i(2, 6), Vector2i(5, 6),  ## fila sur
	]
	for t: Vector2i in tables:
		_place_obj(t.x, t.y, OBJ_TABLE, 4.0, -36)

	## ── Barriles: esquina SE (mx alto, my alto = frente derecho) ─────────
	## Alejados de la barra, en zona de servicio trasera
	_place_obj(7, 7, OBJ_BARREL, 4.0, -36)
	_place_obj(8, 7, OBJ_BARREL, 4.0, -36)

func _place_obj(mx: int, my: int, tex: String, sc: float, off_y: int) -> void:
	var pos := iso_pos(mx, my)
	_add_sprite(int(pos.x), int(pos.y), iso_z(mx, my, 2), tex, sc, off_y)

# ─── NAVEGACION ───────────────────────────────────────────────────────────────

func _ensure_nav_nodes() -> void:
	if get_node_or_null("NavigationRegion2D") == null:
		_add_navigation()
	var obs: Array[Node] = []
	for child in get_children():
		if child is NavigationObstacle2D:
			obs.append(child)
	for o in obs:
		o.free()
	_add_obstacles()

func _tile_diamond_hole(mx: int, my: int, margin: int = 15) -> PackedVector2Array:
	var cx: float = (mx - my) * 128.0
	var cy: float = (mx + my) * 64.0 + 64.0
	return PackedVector2Array([
		Vector2(cx,                cy - 64 + margin),
		Vector2(cx - 128 + margin, cy + margin),
		Vector2(cx,                cy + 64 - margin),
		Vector2(cx + 128 - margin, cy + margin),
	])

func _add_navigation() -> void:
	var nav := NavigationRegion2D.new()
	nav.name = "NavigationRegion2D"
	var poly := NavigationPolygon.new()
	## Correccion -80 en Y: la superficie visual del suelo isometrico esta
	## ~80px por encima de la posicion del nodo del tile.
	var dy := -80
	poly.add_outline(PackedVector2Array([
		iso_pos(1, 1) + Vector2(0,   64 + dy),
		iso_pos(8, 1) + Vector2(64,  32 + dy),
		iso_pos(8, 8) + Vector2(0,   64 + dy),
		iso_pos(1, 8) + Vector2(-64, 32 + dy),
	]))
	## Huecos para objetos solidos (sin paso): barra, mesas, chimenea, barriles
	var blocked: Array[Vector2i] = [
		Vector2i(2,2),                          ## chimenea
		Vector2i(6,2), Vector2i(7,2), Vector2i(8,2),  ## barra (3 piezas)
		Vector2i(2,4), Vector2i(5,4),           ## mesas fila norte
		Vector2i(2,6), Vector2i(5,6),           ## mesas fila sur
		Vector2i(7,7), Vector2i(8,7),           ## barriles
	]
	for p: Vector2i in blocked:
		poly.add_outline(_tile_diamond_hole(p.x, p.y))
	poly.make_polygons_from_outlines()
	nav.navigation_polygon = poly
	add_child(nav)
	nav.owner = get_tree().edited_scene_root

func _add_obstacles() -> void:
	var blocked: Array[Vector2i] = [
		Vector2i(2,2),
		Vector2i(6,2), Vector2i(7,2), Vector2i(8,2),
		Vector2i(2,4), Vector2i(5,4),
		Vector2i(2,6), Vector2i(5,6),
		Vector2i(7,7), Vector2i(8,7),
	]
	for p: Vector2i in blocked:
		var ob := NavigationObstacle2D.new()
		ob.radius = 80.0
		ob.avoidance_enabled = false
		ob.position = iso_pos(p.x, p.y) + Vector2(0, 64)
		add_child(ob)
		ob.owner = get_tree().edited_scene_root

# ─── SPRITE HELPER ────────────────────────────────────────────────────────────

## Helper para tiles Kenney 256x512: paredes y muebles de barra.
## scale=1.0 (tile ya es 256x512), offset=-192 (base alineada al suelo).
## color_override permite usar OBJ_COLOR para muebles en vez del WALL_COLOR de paredes.
func _add_wall(x: int, y: int, depth: int, tex_path: String,
		color_override: Color = WALL_COLOR) -> void:
	var tex: Texture2D = load(tex_path)
	if tex == null:
		push_warning("taberna_painter: no cargado " + tex_path)
		return
	var s := Sprite2D.new()
	s.texture = tex
	s.position = Vector2(x, y)
	s.scale = Vector2(1.0, 1.0)
	s.offset = Vector2(0, -192)
	s.z_index = depth
	s.modulate = color_override
	s.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	add_child(s)
	s.owner = get_tree().edited_scene_root if Engine.is_editor_hint() else null

## clip_h      → muestra solo los primeros clip_h px (recorta desde abajo)
## skip_bottom → oculta los ultimos skip_bottom px (recorta base del asset)
## crop_top    → oculta los primeros crop_top px (elimina cara superior del cubo)
##               offset_y se recalcula automaticamente para mantener la base alineada
func _add_sprite(x: int, y: int, depth: int, tex_path: String,
		sc: float, off_y: int, clip_h: int = 0, skip_bottom: int = 0, crop_top: int = 0) -> void:
	var tex: Texture2D = load(tex_path)
	if tex == null:
		push_warning("taberna_painter: no cargado " + tex_path)
		return
	var s := Sprite2D.new()
	s.texture = tex
	s.position = Vector2(x, y)
	s.scale = Vector2(sc, sc)
	s.z_index = depth
	s.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST

	var th: int = tex.get_height()
	var tw: int = tex.get_width()

	if clip_h > 0:
		s.region_enabled = true
		s.region_rect = Rect2(0, 0, tw, clip_h)
		s.offset = Vector2(0, off_y)
	elif skip_bottom > 0:
		var visible_h: int = th - skip_bottom
		s.region_enabled = true
		s.region_rect = Rect2(0, 0, tw, visible_h)
		s.offset = Vector2(0, off_y - skip_bottom / 2)
	elif crop_top > 0:
		## Elimina los primeros crop_top px (cara superior del cubo).
		## Ajusta el offset para que la BASE del muro siga alineada al suelo.
		## Derivacion: bottom = center + half_rendered_h = iso_pos.y + 64
		##   full tile: center = iso_pos.y + off_y*sc → off_y = (64 - th*sc/2) / sc
		##   crop tile: center = iso_pos.y + new_off*sc, half = (th-crop_top)*sc/2
		##   new_off = (64 - (th-crop_top)*sc/2) / sc
		var new_off_y: int = int((64.0 - (th - crop_top) * sc / 2.0) / sc)
		s.region_enabled = true
		s.region_rect = Rect2(0, crop_top, tw, th - crop_top)
		s.offset = Vector2(0, new_off_y)
	else:
		s.offset = Vector2(0, off_y)

	add_child(s)
	s.owner = get_tree().edited_scene_root if Engine.is_editor_hint() else null
