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
	
#--------------------------------------------LABEL, BATTERY----------------------------------------------

func generate_random_serial_number() -> String:
	var letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ123456789"
	var serial_number = ""
	
	for i in range(6):
		serial_number += letters[randi() % letters.length()]
	
	serial_number += str(randi() % 10)  # Adds a single digit (0-9) at the end
	
	return serial_number


#-----------------------------------------------WIRES----------------------------------------------------

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

# Function to determine which wire should be cut based on the module rules
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
