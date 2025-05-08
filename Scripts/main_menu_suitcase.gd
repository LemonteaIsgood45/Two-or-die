extends Node3D

@export var turn_speed = 0.01

func _process(delta: float) -> void:
	rotate_y(turn_speed)
