extends Node3D

var symbol_data = [
	{ "index": 0, "symbol": "Ϟ" },
	{ "index": 1, "symbol": "ϐ" },
	{ "index": 2, "symbol": "φ" },
	{ "index": 3, "symbol": "ϰ" }
]

var symbol_pressed := []
var correct := false
var finish := false

func _ready() -> void:
	randomize()

	# Create a list of indexes and shuffle it
	var shuffled_indexes = [0, 1, 2, 3]
	shuffled_indexes.shuffle()

	# Assign the symbols to labels in the shuffled order
	$Symbol_1/Label3D.text = symbol_data[shuffled_indexes[0]]["symbol"]
	$Symbol_2/Label3D.text = symbol_data[shuffled_indexes[1]]["symbol"]
	$Symbol_3/Label3D.text = symbol_data[shuffled_indexes[2]]["symbol"]
	$Symbol_4/Label3D.text = symbol_data[shuffled_indexes[3]]["symbol"]

func _process(delta: float) -> void:
	if finish:
		return  # Stop checking if already finished

	# Update all symbol inputs
	_update_pressed_state($Symbol_1)
	_update_pressed_state($Symbol_2)
	_update_pressed_state($Symbol_3)
	_update_pressed_state($Symbol_4)

	# Build expected list
	var expected = []
	for data in symbol_data:
		expected.append(data["symbol"])

	# Check logic
	if symbol_pressed == expected:
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
