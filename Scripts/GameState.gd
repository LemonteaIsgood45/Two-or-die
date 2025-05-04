extends Node3D

var rng: RandomNumberGenerator


var current_mode: GameMode = GameMode.MENU

var player_name

var time_pressed_number
var correct_symbol

#MODE

enum GameMode { MENU, WAITING, PLAYING, PAUSED, GAME_OVER }

signal mode_changed(new_mode)

func set_mode(new_mode: GameMode):
	if new_mode != current_mode:
		current_mode = new_mode
		emit_signal("mode_changed", new_mode)

func is_mode(mode: GameMode) -> bool:
	return current_mode == mode

#Wires

var wire_colors = [Color.RED, Color.BLUE, Color.YELLOW]

func generate_wires():
	var total_wires = randi_range(4, 7)
	var correct_wire_count = randi_range(1, total_wires - 1)
	var correct_indices = []

	while correct_indices.size() < correct_wire_count:
		var idx = randi_range(0, total_wires - 1)
		if idx not in correct_indices:
			correct_indices.append(idx)

	var wires = []
	for i in total_wires:
		var wire = {
			"index": i,
			"color": wire_colors[randi() % wire_colors.size()],
			"is_correct": i in correct_indices
		}
		wires.append(wire)
	return wires
