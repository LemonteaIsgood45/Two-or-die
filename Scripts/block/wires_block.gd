extends Node3D

@onready var BASE_WIRE = preload("res://Scenes/wires.tscn")

var correct := false

var wires_data 
var correct_cut_index
var wires_cut = 0

var wire_nodes = [] # Stores instances and their index

func _ready() -> void:
	var parent = get_parent()
	wires_data = generate_wires()
	var serial_number = parent.serial_number
	correct_cut_index = determine_wire_to_cut(wires_data, serial_number)
	
	
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

var wire_colors = ["red", "blue", "yellow", "white", "black"]

# Function to generate wires for a module, returns array of wire objects
func generate_wires(min_wires = 3, max_wires = 6):
	var total_wires = randi_range(min_wires, max_wires)
	var wires = []
	
	for i in range(total_wires):
		var wire = {
			"index": i,
			"color": wire_colors[randi() % wire_colors.size()],
		}
		wires.append(wire)
	
	return wires

func determine_wire_to_cut(wires, serial_number):
	var last_digit_odd = int(serial_number[-1]) % 2 == 1
	
	# Count wires by color
	var red_wires = []
	var blue_wires = []
	var yellow_wires = []
	var white_wires = []
	var black_wires = []
	
	for i in range(wires.size()):
		var wire = wires[i]
		match wire.color:
			"red": red_wires.append(i)
			"blue": blue_wires.append(i)
			"yellow": yellow_wires.append(i)
			"white": white_wires.append(i)
			"black": black_wires.append(i)
	
	# Apply rules based on number of wires
	match wires.size():
		3: # 3 wires
			if red_wires.size() == 0:
				return 1 # Cut the second wire
			elif wires[-1].color == "white":
				return wires.size() - 1 # Cut the last wire
			elif blue_wires.size() > 1:
				return blue_wires[-1] # Cut the last blue wire
			else:
				return wires.size() - 1 # Cut the last wire
				
		4: # 4 wires
			if red_wires.size() > 1 and last_digit_odd:
				return red_wires[-1] # Cut the last red wire
			elif wires[-1].color == "yellow" and red_wires.size() == 0:
				return 0 # Cut the first wire
			elif blue_wires.size() == 1:
				return 0 # Cut the first wire
			elif yellow_wires.size() > 1:
				return yellow_wires[-1] # Cut the last yellow wire
			else:
				return 1 # Cut the second wire
				
		5: # 5 wires
			if wires[-1].color == "black" and last_digit_odd:
				return 3 # Cut the fourth wire
			elif red_wires.size() == 1 and yellow_wires.size() > 1:
				return 0 # Cut the first wire
			elif black_wires.size() == 0:
				return 1 # Cut the second wire
			else:
				return 0 # Cut the first wire
				
		6: # 6 wires
			if yellow_wires.size() == 0 and last_digit_odd:
				return 2 # Cut the third wire
			elif yellow_wires.size() == 1 and white_wires.size() > 1:
				return 3 # Cut the fourth wire
			elif red_wires.size() == 0:
				return wires.size() - 1 # Cut the last wire
			else:
				return 3 # Cut the fourth wire
	
	# Fallback (shouldn't reach here if rules are exhaustive)
	return 0
