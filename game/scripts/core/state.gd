## state.gd
## Clase base para estados de una StateMachine.
## Extender esta clase para cada estado concreto.

class_name State
extends Node

var state_machine: StateMachine = null

func enter() -> void:
	pass

func exit() -> void:
	pass

func update(_delta: float) -> void:
	pass

func physics_update(_delta: float) -> void:
	pass

func handle_input(_event: InputEvent) -> void:
	pass
