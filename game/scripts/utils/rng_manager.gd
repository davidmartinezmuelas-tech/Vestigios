## rng_manager.gd
## Generador de números aleatorios con seed controlable.
## Usar siempre RngManager en lugar de randf()/randi() para reproducibilidad.

extends Node

var _rng: RandomNumberGenerator = RandomNumberGenerator.new()
var _seed: int = 0

func _ready() -> void:
	randomize_seed()

# ============================================================
# SEED
# ============================================================

func randomize_seed() -> void:
	_seed = randi()
	_rng.seed = _seed

func set_seed(seed_value: int) -> void:
	_seed = seed_value
	_rng.seed = seed_value

func get_seed() -> int:
	return _seed

# ============================================================
# GENERACIÓN
# ============================================================

## Devuelve float en [0.0, 1.0)
func roll() -> float:
	return _rng.randf()

## Devuelve float en [min_val, max_val]
func randf_range(min_val: float, max_val: float) -> float:
	return _rng.randf_range(min_val, max_val)

## Devuelve int en [min_val, max_val]
func randi_range(min_val: int, max_val: int) -> int:
	return _rng.randi_range(min_val, max_val)

## Devuelve true con la probabilidad dada (0.0–1.0)
func chance(probability: float) -> bool:
	return _rng.randf() < probability

## Devuelve un elemento aleatorio del array
func pick(array: Array) -> Variant:
	if array.is_empty():
		return null
	return array[_rng.randi_range(0, array.size() - 1)]

## Baraja el array in-place
func shuffle(array: Array) -> void:
	_rng.shuffle(array)
