extends CSGBox3D

@onready var wireScene = preload("res://Scenes/wires.tscn")

func  _ready() -> void:
	var wire = wireScene.instantiate()
	add_child(wire)
	wire.position = Vector3(0, 0.1, 0)
