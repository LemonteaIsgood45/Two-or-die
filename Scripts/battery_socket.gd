extends Node3D

var number_of_batteries

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if number_of_batteries == 1:
		$Battery_1.visible = true
	elif number_of_batteries == 2:
		$Battery_1.visible = true
		$Battery_2.visible = true
