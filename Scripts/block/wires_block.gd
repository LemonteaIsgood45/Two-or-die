extends Node3D

@onready var BASE_WIRE = preload("res://Scenes/wires.tscn")

var serial_number

var correct := false

var wires_data 
var correct_cut_index
var wires_cut = 0

var wire_nodes = [] # Stores instances and their index

func _ready() -> void:
	var parent = get_parent()
	wires_data = GameState.generate_wires()
	serial_number = parent.serial_number
	correct_cut_index = GameState.determine_wire_to_cut(wires_data, serial_number)
	
	
	for wire_info in wires_data:
		var wire = BASE_WIRE.instantiate()
		var color = get_color_from_name(wire_info["color"])

		if color.a == 0:
			push_error("Unknown color: %s" % wire_info["color"])
			continue

		wire.color = color
		wire.position = Vector3(0.009, 0.069, get_z_position(wire_info["index"]))
		wire.rotation_degrees.y = -10.3
		wire.is_counted = false  # Add tracking for cut detection

		add_child(wire)
		wire_nodes.append({"wire": wire, "index": wire_info["index"]})


func _process(_delta: float) -> void:
	for entry in wire_nodes:
		var wire = entry["wire"]
		var index = entry["index"]

		if wire.is_cut and not wire.is_counted:
			wire.is_counted = true
			wires_cut += 1
			if index == correct_cut_index and wires_cut == 1:
				correct = true
				%state.correct = correct
				%state.finish = true
				
				print("Wire block corrected")
			else:
				correct = false
				%state.correct = correct
				%state.finish = true
				
				print("Wire block failed")



func get_z_position(index):
	match index:
		0:
			return (%left_1.position.z + %right_1.position.z - 0.013) / 2
		1:
			return (%left_2.position.z + %right_2.position.z - 0.013) / 2
		2:
			return (%left_3.position.z + %right_3.position.z - 0.013) / 2
		3:
			return (%left_4.position.z + %right_4.position.z - 0.013) / 2
		4:
			return (%left_5.position.z + %right_5.position.z - 0.013) / 2
		5:
			return (%left_6.position.z + %right_6.position.z - 0.013) / 2
		6:
			return (%left_7.position.z + %right_7.position.z - 0.013) / 2


func get_color_from_name(color: String) -> Color:
	match color.to_lower():
		"red": return Color(1, 0, 0)
		"blue": return Color(0, 0, 1)
		"green": return Color(0, 1, 0)
		"yellow": return Color(1, 1, 0)
		"white": return Color(1, 1, 1)
		"black": return Color(0, 0, 0)
		_: return Color(0, 0, 0, 0)  # Invalid color = transparent
