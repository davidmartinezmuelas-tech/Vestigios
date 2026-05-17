## combat_grid.gd
## Gestiona la cuadrícula isométrica del combate.
## Cada casilla es 5 pies. Velocidad 30ft = 6 casillas por turno.
##
## SISTEMA DE COBERTURA (D&D 2024):
##   NONE          →  +0 CA
##   HALF          →  +2 CA y tiradas salvación DES
##   THREE_QUARTERS → +5 CA y tiradas salvación DES
##   FULL          →  no se puede atacar al objetivo

class_name CombatGrid
extends Node

# ============================================================
# SEÑALES
# ============================================================
signal character_moved(character: BaseCharacter, from: Vector2i, to: Vector2i)

# ============================================================
# CONSTANTES
# ============================================================
const FEET_PER_TILE: int = 5

## Valores de cobertura — usados en CombatResolver
const COVER_NONE: int           = 0
const COVER_HALF: int           = 2   # +2 CA y saves DES
const COVER_THREE_QUARTERS: int = 5   # +5 CA y saves DES
const COVER_FULL: int           = -1  # no atacable

@export var grid_width:  int = 20
@export var grid_height: int = 12

# ============================================================
# ESTADO
# ============================================================
## Vector2i → BaseCharacter
var _occupants: Dictionary = {}
## Vector2i → int (nivel de cobertura que proporciona esa celda al defenderse desde ella)
## Una casilla con cobertura ALTA protege al que está detrás de ella, no al que la ocupa.
var _cover_cells: Dictionary = {}
## Vector2i → bool
var _solid_cells: Dictionary = {}

## Trampas ocultas: Vector2i → {dc:int, damage_dice:String, damage_type:String, triggered:bool}
var _trap_cells: Dictionary = {}
## Objetos del entorno: Vector2i → {name:String, description:String, revealed:bool, effect_id:String}
## effect_id referencia un efecto especial que puede desencadenarse (barril, lámpara, columna...)
var _env_objects: Dictionary = {}

# ============================================================
# SETUP
# ============================================================

func clear() -> void:
	_occupants.clear()
	_cover_cells.clear()
	_solid_cells.clear()
	_trap_cells.clear()
	_env_objects.clear()

## Registra una trampa oculta en una celda.
## dc: dificultad para detectarla. damage_dice: p.ej "2d6". damage_type: "perforante".
func set_trap(cell: Vector2i, dc: int, damage_dice: String, damage_type: String) -> void:
	_trap_cells[cell] = {"dc": dc, "damage_dice": damage_dice, "damage_type": damage_type, "triggered": false, "revealed": false}

## Registra un objeto del entorno interactuable.
## effect_id: clave que el CombatManager usará para resolver el efecto.
func set_env_object(cell: Vector2i, obj_name: String, description: String, effect_id: String) -> void:
	_env_objects[cell] = {"name": obj_name, "description": description, "revealed": false, "effect_id": effect_id}

## Devuelve todas las trampas en rango de una posición (sin importar si están reveladas).
func get_traps_in_range(origin: Vector2i, range_tiles: int) -> Array[Vector2i]:
	var result: Array[Vector2i] = []
	for cell in _trap_cells:
		if get_distance(origin, cell) <= range_tiles:
			result.append(cell)
	return result

## Devuelve todos los objetos del entorno en rango.
func get_env_objects_in_range(origin: Vector2i, range_tiles: int) -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	for cell in _env_objects:
		if get_distance(origin, cell) <= range_tiles:
			var obj: Dictionary = _env_objects[cell].duplicate()
			obj["cell"] = cell
			result.append(obj)
	return result

## Marca una trampa como revelada (visible para el jugador).
func reveal_trap(cell: Vector2i) -> void:
	if _trap_cells.has(cell):
		_trap_cells[cell]["revealed"] = true

## Marca un objeto del entorno como revelado.
func reveal_env_object(cell: Vector2i) -> void:
	if _env_objects.has(cell):
		_env_objects[cell]["revealed"] = true

## Devuelve si hay una trampa en la celda y si está revelada.
func is_trap_revealed(cell: Vector2i) -> bool:
	return _trap_cells.get(cell, {}).get("revealed", false)

## Devuelve los datos de una trampa (o vacío si no hay).
func get_trap(cell: Vector2i) -> Dictionary:
	return _trap_cells.get(cell, {})

## Coloca un personaje en una casilla al inicio del combate.
func place_character(character: BaseCharacter, cell: Vector2i) -> void:
	if not _is_in_bounds(cell):
		push_error("CombatGrid: celda fuera de límites %s" % cell)
		return
	_occupants[cell] = character
	character.grid_position = cell

## Marca una casilla como obstáculo que proporciona cobertura.
## cover_level: COVER_HALF, COVER_THREE_QUARTERS o COVER_FULL
## is_solid: si true, la casilla bloquea el movimiento
func set_cover(cell: Vector2i, cover_level: int, is_solid: bool = true) -> void:
	_cover_cells[cell] = cover_level
	if is_solid:
		_solid_cells[cell] = true

func clear_cover(cell: Vector2i) -> void:
	_cover_cells.erase(cell)
	_solid_cells.erase(cell)

# ============================================================
# MOVIMIENTO
# ============================================================

func move_character(character: BaseCharacter, destination: Vector2i) -> bool:
	if not _is_in_bounds(destination) or is_occupied(destination):
		return false
	if _solid_cells.get(destination, false):
		return false

	var distance := get_distance(character.grid_position, destination)
	if distance > character.stats.speed_ft / FEET_PER_TILE:
		return false

	var from := character.grid_position
	_occupants.erase(from)
	_occupants[destination] = character
	character.grid_position = destination
	character_moved.emit(character, from, destination)
	return true

func get_reachable_cells(character: BaseCharacter) -> Array[Vector2i]:
	var max_tiles := character.stats.speed_ft / FEET_PER_TILE
	return _flood_fill(character.grid_position, max_tiles)

# ============================================================
# SISTEMA DE COBERTURA
# ============================================================

## Devuelve el bonus de cobertura que recibe el TARGET cuando es atacado desde FROM.
## Valores: 0 (sin cobertura), 2 (media), 5 (tres cuartos), -1 (total — no atacable)
func get_cover_bonus(attacker_pos: Vector2i, target_pos: Vector2i) -> int:
	var line := _bresenham_line(attacker_pos, target_pos)
	var max_cover := COVER_NONE

	for cell in line:
		# Excluir las celdas de origen y destino
		if cell == attacker_pos or cell == target_pos:
			continue

		# Obstáculos sólidos del entorno
		var terrain_cover: int = _cover_cells.get(cell, COVER_NONE)
		if terrain_cover == COVER_FULL:
			return COVER_FULL
		max_cover = maxi(max_cover, terrain_cover)

		# Un personaje ocupando la celda da cobertura media
		if is_occupied(cell):
			max_cover = maxi(max_cover, COVER_HALF)

	return max_cover

## Versión semántica: devuelve si el objetivo es atacable desde esa posición.
func can_target(attacker_pos: Vector2i, target_pos: Vector2i) -> bool:
	return get_cover_bonus(attacker_pos, target_pos) != COVER_FULL

## Texto legible del nivel de cobertura para mostrar en la UI.
static func cover_label(cover_level: int) -> String:
	match cover_level:
		COVER_HALF:           return "½ Cobertura (+2 CA)"
		COVER_THREE_QUARTERS: return "¾ Cobertura (+5 CA)"
		COVER_FULL:           return "Cobertura total"
		_:                    return ""

# ============================================================
# CONSULTAS
# ============================================================

func is_occupied(cell: Vector2i) -> bool:
	return _occupants.has(cell) and _occupants[cell] != null

func get_occupant(cell: Vector2i) -> BaseCharacter:
	return _occupants.get(cell, null)

## Distancia de Chebyshev (8 direcciones).
func get_distance(a: Vector2i, b: Vector2i) -> int:
	return maxi(abs(a.x - b.x), abs(a.y - b.y))

func get_characters_in_range(origin: Vector2i, range_tiles: int) -> Array[BaseCharacter]:
	var result: Array[BaseCharacter] = []
	for cell in _occupants:
		if get_distance(origin, cell) <= range_tiles:
			var occupant := _occupants[cell] as BaseCharacter
			if occupant != null:
				result.append(occupant)
	return result

func are_adjacent(a: Vector2i, b: Vector2i) -> bool:
	return get_distance(a, b) == 1

func is_in_bounds(cell: Vector2i) -> bool:
	return _is_in_bounds(cell)

# ============================================================
# LÍNEA DE VISIÓN
# ============================================================

## Algoritmo de Bresenham — devuelve todas las celdas entre dos puntos.
func _bresenham_line(from: Vector2i, to: Vector2i) -> Array[Vector2i]:
	var cells: Array[Vector2i] = []
	var x := from.x;  var y := from.y
	var dx: int = abs(to.x - from.x);  var dy: int = abs(to.y - from.y)
	var sx := 1 if from.x < to.x else -1
	var sy := 1 if from.y < to.y else -1
	var err: int = dx - dy

	while true:
		cells.append(Vector2i(x, y))
		if x == to.x and y == to.y:
			break
		var e2: int = 2 * err
		if e2 > -dy:
			err -= dy
			x += sx
		if e2 < dx:
			err += dx
			y += sy

	return cells

# ============================================================
# COORDENADAS ISOMÉTRICAS
# ============================================================

static func grid_to_screen(cell: Vector2i, tile_width: int, tile_height: int) -> Vector2:
	return Vector2(
		(cell.x - cell.y) * (tile_width / 2.0),
		(cell.x + cell.y) * (tile_height / 2.0)
	)

static func screen_to_grid(screen_pos: Vector2, tile_width: int, tile_height: int) -> Vector2i:
	var col := int((screen_pos.x / (tile_width / 2.0) + screen_pos.y / (tile_height / 2.0)) / 2.0)
	var row := int((screen_pos.y / (tile_height / 2.0) - screen_pos.x / (tile_width / 2.0)) / 2.0)
	return Vector2i(col, row)

# ============================================================
# INTERNO
# ============================================================

func _is_in_bounds(cell: Vector2i) -> bool:
	return cell.x >= 0 and cell.x < grid_width and cell.y >= 0 and cell.y < grid_height

func _flood_fill(origin: Vector2i, max_distance: int) -> Array[Vector2i]:
	var reachable: Array[Vector2i] = []
	var visited: Dictionary = {}
	var queue: Array = [{"cell": origin, "dist": 0}]
	visited[origin] = true

	while not queue.is_empty():
		var current = queue.pop_front()
		var cell: Vector2i = current["cell"]
		var dist: int     = current["dist"]

		if dist > 0 and not is_occupied(cell) and not _solid_cells.get(cell, false):
			reachable.append(cell)

		if dist >= max_distance:
			continue

		for neighbor in _get_neighbors(cell):
			if not visited.has(neighbor) and _is_in_bounds(neighbor):
				visited[neighbor] = true
				queue.append({"cell": neighbor, "dist": dist + 1})

	return reachable

func _get_neighbors(cell: Vector2i) -> Array[Vector2i]:
	return [
		cell + Vector2i( 1,  0), cell + Vector2i(-1,  0),
		cell + Vector2i( 0,  1), cell + Vector2i( 0, -1),
		cell + Vector2i( 1,  1), cell + Vector2i(-1, -1),
		cell + Vector2i( 1, -1), cell + Vector2i(-1,  1),
	]
