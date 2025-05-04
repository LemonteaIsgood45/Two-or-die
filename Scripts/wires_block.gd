extends Node3D

@onready var BASE_WIRE = preload("res://Scenes/wires.tscn")

var number_of_wires = 3
var wires_color = ["RED", "RED", "RED"]
var correct_color
var correct_index

var finish
var correct

var wires = []

func setup(_number_of_wires, _wires_color, _correct_color, _correct_index):
	number_of_wires = _number_of_wires
	wires_color = _wires_color
	correct_color = _correct_color
	correct_index = _correct_index

func _ready() -> void:
	wires.resize(number_of_wires)
	for i in range(number_of_wires):
		var pos = Vector3(0, 0.09, 0.04 - i * randf_range(0.015, 0.025))
		if wires_color[i] == "RED":
			wires[i] = BASE_WIRE.instantiate()
			wires[i].color = Color(1, 0, 0)
			add_child(wires[i])
			wires[i].position = pos
