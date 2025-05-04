extends Node3D

@export var color: Color = Color(1, 1, 1)

@export var is_pressed = false

func _ready():
	var mat = StandardMaterial3D.new()
	mat.albedo_color = color


func _process(delta: float) -> void:
	if is_pressed == true:
		%wire_cut.visible = false
