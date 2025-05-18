extends Node3D

var symbol_columns = [
	# Column 1
	["𐌒", "Ѧ", "ƛ", "ϟ", "Ѭ", "ϗ", "Ͽ"],
	# Column 2
	["Ӭ", "𐌒", "Ͽ", "Ҩ", "☆", "ϗ", "¿"],
	# Column 3
	["©", "Ѽ", "Ҩ", "Ж", "Ԇ", "ƛ", "☆"],
	# Column 4
	["б", "¶", "Ѣ", "Ѭ", "Ж", "¿", "ټ"],
	# Column 5
	["Ψ", "ټ", "Ѣ", "Ͼ", "¶", "ѯ", "★"],
	# Column 6
	["б", "Ӭ", "҂", "ӕ", "Ψ", "Й", "Ω"]
]

# The four symbols displayed on the keypad in the current game
var current_keypad_symbols = []
# The column that contains all four symbols
var correct_column = -1
# The correct order to press the buttons
var correct_sequence = []

var symbol_pressed := []
var correct := false
var finish := false

func _ready() -> void:
	randomize()
	initialize()

	# Assign the symbols to labels in the shuffled order
	$Symbol_1/Label3D.text = current_keypad_symbols[0]
	$Symbol_2/Label3D.text = current_keypad_symbols[1]
	$Symbol_3/Label3D.text = current_keypad_symbols[2]
	$Symbol_4/Label3D.text = current_keypad_symbols[3]

func _process(delta: float) -> void:
	if finish:
		return  # Stop checking if already finished

	# Update all symbol inputs
	_update_pressed_state($Symbol_1)
	_update_pressed_state($Symbol_2)
	_update_pressed_state($Symbol_3)
	_update_pressed_state($Symbol_4)

	# Check logic
	if symbol_pressed == correct_sequence:
		correct = true
		finish = true
		$state.correct = correct
		$state.finish = finish
		print("SYMBOL: correct!!!")
	elif symbol_pressed.size() == 4:
		# 4 selected, but wrong order
		correct = false
		finish = true
		$state.correct = correct
		$state.finish = finish
		print("SYMBOL: NOT CORRECT!!!")

func _update_pressed_state(symbol_node: Node) -> void:
	var label = symbol_node.get_node("Label3D")
	var text = label.text

	if symbol_node.is_pressed:
		if text not in symbol_pressed:
			symbol_pressed.append(text)
	else:
		if text in symbol_pressed:
			symbol_pressed.erase(text)

# Initialize the module with random symbols
func initialize():
	# Select a random column
	correct_column = randi() % symbol_columns.size()
	
	# Use 4 random symbols from the selected column
	var column_symbols = symbol_columns[correct_column].duplicate()
	column_symbols.shuffle()
	current_keypad_symbols = []
	for i in range(4):
		current_keypad_symbols.append(column_symbols[i])
	
	# Determine the correct sequence based on the original order in the column
	determine_correct_sequence()

# Determine the correct sequence to press the buttons
func determine_correct_sequence():
	correct_sequence = []
	var column = symbol_columns[correct_column]
	
	# For each symbol in the column (in original order)
	for symbol in column:
		# If this symbol is in our current keypad, add its position to the sequence
		if symbol in current_keypad_symbols:
			correct_sequence.append(current_keypad_symbols[current_keypad_symbols.find(symbol)])
	
	print(correct_sequence)

# Check if a sequence of button presses is correct
func check_sequence(pressed_sequence):
	if pressed_sequence.size() != 4:
		return false
	
	for i in range(4):
		if pressed_sequence[i] != correct_sequence[i]:
			return false
	
	return true
