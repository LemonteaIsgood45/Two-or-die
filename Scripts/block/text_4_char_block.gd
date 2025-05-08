extends Node3D

var char_data = ["D", "A", "M", "N"]

var mock_data = ["F", "U", "C", "K"]

var finish := false
var correct := false

func _ready() -> void:
	%char_1/Character.text = mock_data[0]
	%char_2/Character.text = mock_data[1]
	%char_3/Character.text = mock_data[2]
	%char_4/Character.text = mock_data[3]

func _process(delta: float) -> void:
	change_char(%char_1, $char_1_up_button, $char_1_down_button)
	change_char(%char_2, $char_2_up_button, $char_2_down_button)
	change_char(%char_3, $char_3_up_button, $char_3_down_button)
	change_char(%char_4, $char_4_up_button, $char_4_down_button)
	
	if %char_1/Character.text == char_data[0] and %char_2/Character.text == char_data[1] and %char_3/Character.text == char_data[2]and %char_4/Character.text == char_data[3]:
		finish = true
		correct = true
		$state.finish = finish
		$state.correct = correct

func change_char(char_node: Node, up_char: Node, down_char: Node) -> void:
	var char_label = char_node.get_node("Character")
	var current_char = char_label.text

	if current_char.length() != 1:
		return

	var char_code = current_char.unicode_at(0)

	# Detect rising edge for up_char
	if up_char.is_pressed and not up_char.last_pressed:
		char_code += 1
		if char_code > "Z".unicode_at(0):
			char_code = "A".unicode_at(0)
		char_label.text = String.chr(char_code)

	# Detect rising edge for down_char
	elif down_char.is_pressed and not down_char.last_pressed:
		char_code -= 1
		if char_code < "A".unicode_at(0):
			char_code = "Z".unicode_at(0)
		char_label.text = String.chr(char_code)

	# Update last states (important!)
	up_char.last_pressed = up_char.is_pressed
	down_char.last_pressed = down_char.is_pressed
