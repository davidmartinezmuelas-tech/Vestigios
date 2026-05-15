## combat_grid.gd
## Gestiona la cuadrícula isométrica del combate.
## Cada casilla es 5 pies. Velocidad 30ft = 6 casillas por turno.
## Las coordenadas son Vector2i (col, fila) en espacio de grid lógico.
## La conversión a posición isométrica se hace en la capa visual.

class_name CombatGrid
extends Node

# ============================================================
# SEÑALES
# ============================================================
signal character_moved(character: BaseCharacter, from: Vector2i, to: Vector2i)

# ============================================================
# CONFIGURACIÓN
# ============================================================
const FEET_PER_TILE: int = 5

@export var grid_width: int  = 20
@export var grid_height: int = 12

# ============================================================
# ESTADO
## Mapa de ocupación: Vector2i → BaseCharacter (o null si libre)
# ============================================================
var _occupants: Dictionary = {}

# ============================================================
# INICIALIZACIÓN
# ============================================================

func clear() -> void:
	_occupants.clear()

## Coloca un personaje en una casilla al inicio del combate.
func place_character(character: BaseCharacter, cell: Vector2i) -> void:
	if not _is_in_bounds(cell):
		push_error("CombatGrid: celda fuera de límites %s" % cell)
		return
	_occupants[cell] = character
	character.grid_position = cell

# ============================================================
# MOVIMIENTO
# ============================================================

## Intenta mover un personaje a la celda destino.
## Devuelve true si el movimiento fue válido.
func move_character(character: BaseCharacter, destination: Vector2i) -> bool:
	if not _is_in_bounds(destination):
		return false
	if is_occupied(destination):
		return false

	var distance := get_distance(character.grid_position, destination)
	var max_tiles := character.stats.speed_ft / FEET_PER_TILE

	if distance > max_tiles:
		return false

	var from := character.grid_position
	_occupants.erase(from)
	_occupants[destination] = character
	character.grid_position = destination

	character_moved.emit(character, from, destination)
	return true

## Devuelve las celdas a las que puede moverse este personaje este turno.
func get_reachable_cells(character: BaseCharacter) -> Array[Vector2i]:
	var max_tiles := character.stats.speed_ft / FEET_PER_TILE
	return _flood_fill(character.grid_position, max_tiles)

# ============================================================
# CONSULTAS
# ============================================================

func is_occupied(cell: Vector2i) -> bool:
	return _occupants.has(cell) and _occupants[cell] != null

func get_occupant(cell: Vector2i) -> BaseCharacter:
	return _occupants.get(cell, null)

## Distancia de Chebyshev (movimiento en 8 direcciones, diagonales = 1 casilla).
func get_distance(a: Vector2i, b: Vector2i) -> int:
	return maxi(abs(a.x - b.x), abs(a.y - b.y))

## Devuelve todos los personajes en rango de una casilla origen.
func get_characters_in_range(origin: Vector2i, range_tiles: int) -> Array[BaseCharacter]:
	var result: Array[BaseCharacter] = []
	for cell in _occupants:
		if get_distance(origin, cell) <= range_tiles:
			var occupant := _occupants[cell] as BaseCharacter
			if occupant != null:
				result.append(occupant)
	return result

## Devuelve si dos casillas son adyacentes (incluye diagonal).
func are_adjacent(a: Vector2i, b: Vector2i) -> bool:
	return get_distance(a, b) == 1

# ============================================================
# COORDENADAS ISOMÉTRICAS (visual)
## Convierte grid lógico a posición en pantalla para Node2D.
## tile_size es el ancho del tile isométrico en píxeles.
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
		var dist: int = current["dist"]

		if dist > 0 and not is_occupied(cell):
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
		cell + Vector2i( 1,  0),
		cell + Vector2i(-1,  0),
		cell + Vector2i( 0,  1),
		cell + Vector2i( 0, -1),
		cell + Vector2i( 1,  1),
		cell + Vector2i(-1, -1),
		cell + Vector2i( 1, -1),
		cell + Vector2i(-1,  1),
	]
