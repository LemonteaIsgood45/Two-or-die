extends Node3D

var rng: RandomNumberGenerator

var current_mode: GameMode = GameMode.HOME

var players = {}

var role = "Defuser"

var time_pressed_number
var correct_symbol

#MODE

enum GameMode { HOME, WAITING, PLAYING, SETTING, WIN, LOSE }

signal mode_changed(new_mode)

func set_mode(new_mode: GameMode):
	if new_mode != current_mode:
		current_mode = new_mode
		emit_signal("mode_changed", new_mode)

func is_mode(mode: GameMode) -> bool:
	return current_mode == mode

@rpc("any_peer", "call_local")
func assign_role(_role):
	role = _role

#Wires

var wire_colors = [Color.RED, Color.BLUE, Color.YELLOW, Color.WHITE, Color.GREEN]

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
	
# SYMBOLS

func generate_symbols():
	var greek_symbols = [
		'α', 'β', 'γ', 'δ', 'ε', 'ζ', 'η', 'θ', 'ι', 'κ', 'λ', 'μ', 'ν', 'ξ', 'ο', 'π', 'ρ', 'σ', 'τ', 'υ', 'φ', 'χ', 'ψ', 'ω',
		'ϐ', 'ϑ', 'ϒ', 'ϓ', 'ϔ', 'ϕ', 'ϖ', 'ϗ',
		'Ͱ', 'ͱ', 'Ϙ', 'ϙ', 'Ϛ', 'ϛ', 'Ϝ', 'ϝ', 'Ϟ', 'ϟ',
		'Ϡ', 'ϡ', 'ϰ', 'ϱ', 'ϲ', 'ϳ'
	]
	
	var picked_symbols = []
	while picked_symbols.size() < 4:
		var symbol = greek_symbols[randi() % greek_symbols.size()]
		if symbol not in picked_symbols:
			picked_symbols.append(symbol)
	
	picked_symbols.shuffle()
	
	var result = []
	for i in range(picked_symbols.size()):
		result.append({ "index": i, "symbol": picked_symbols[i] })
	
	return result

# 4 character block

func generate_4_character_block() -> Array:
	var alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
	var chosen := []
	randomize()

	while chosen.size() < 4:
		var letter = alphabet[randi() % alphabet.length()]
		if letter not in chosen:
			chosen.append(letter)
	
	return chosen
