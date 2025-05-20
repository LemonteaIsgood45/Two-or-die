extends Node

var position_lookup = {
	"YES": "middle_left",
	"FIRST": "top_right",
	"DISPLAY": "bottom_right",
	"OKAY": "top_right",
	"SAYS": "bottom_right",
	"NOTHING": "middle_left",
	"": "bottom_left",
	"BLANK": "middle_right",
	"NO": "bottom_right",
	"LED": "middle_left",
	"LEAD": "bottom_right",
	"READ": "middle_right",
	"RED": "middle_right",
	"REED": "bottom_left",
	"LEED": "bottom_left",
	"HOLD ON": "bottom_right",
	"YOU": "middle_right",
	"YOU ARE": "bottom_right",
	"YOUR": "middle_right",
	"YOU'RE": "middle_right",
	"UR": "top_left",
	"THERE": "bottom_right",
	"THEY'RE": "bottom_left",
	"THEIR": "middle_right",
	"THEY ARE": "middle_left",
	"SEE": "bottom_right",
	"C": "top_right",
	"CEE": "bottom_right"
}

var label_sequences = {
	"READY": ["YES", "OKAY", "WHAT", "MIDDLE", "LEFT", "PRESS", "RIGHT", "BLANK", "READY", "NO", "FIRST", "UHHH", "NOTHING", "WAIT"],
	"FIRST": ["LEFT", "OKAY", "YES", "MIDDLE", "NO", "RIGHT", "NOTHING", "UHHH", "WAIT", "READY", "BLANK", "WHAT", "PRESS", "FIRST"],
	"NO": ["BLANK", "UHHH", "WAIT", "FIRST", "WHAT", "READY", "RIGHT", "YES", "NOTHING", "LEFT", "PRESS", "OKAY", "NO", "MIDDLE"],
	"BLANK": ["WAIT", "RIGHT", "OKAY", "MIDDLE", "BLANK", "PRESS", "READY", "NOTHING", "NO", "WHAT", "LEFT", "UHHH", "YES", "FIRST"],
	"NOTHING": ["UHHH", "RIGHT", "OKAY", "MIDDLE", "YES", "BLANK", "NO", "PRESS", "LEFT", "WHAT", "WAIT", "FIRST", "NOTHING", "READY"],
	"YES": ["OKAY", "RIGHT", "UHHH", "MIDDLE", "FIRST", "WHAT", "PRESS", "READY", "NOTHING", "YES", "LEFT", "BLANK", "NO", "WAIT"],
	"WHAT": ["UHHH", "WHAT", "LEFT", "NOTHING", "READY", "BLANK", "MIDDLE", "NO", "OKAY", "FIRST", "WAIT", "YES", "PRESS", "RIGHT"],
	"UHHH": ["READY", "NOTHING", "LEFT", "WHAT", "OKAY", "YES", "RIGHT", "NO", "PRESS", "BLANK", "UHHH", "MIDDLE", "WAIT", "FIRST"],
	"LEFT": ["RIGHT", "LEFT", "FIRST", "NO", "MIDDLE", "YES", "BLANK", "WHAT", "UHHH", "WAIT", "PRESS", "READY", "OKAY", "NOTHING"],
	"RIGHT": ["YES", "NOTHING", "READY", "PRESS", "NO", "WAIT", "WHAT", "RIGHT", "MIDDLE", "LEFT", "UHHH", "BLANK", "OKAY", "FIRST"],
	"MIDDLE": ["BLANK", "READY", "OKAY", "WHAT", "NOTHING", "PRESS", "NO", "WAIT", "LEFT", "MIDDLE", "RIGHT", "FIRST", "UHHH", "YES"],
	"OKAY": ["MIDDLE", "NO", "FIRST", "YES", "UHHH", "NOTHING", "WAIT", "OKAY", "LEFT", "READY", "BLANK", "PRESS", "WHAT", "RIGHT"],
	"WAIT": ["UHHH", "NO", "BLANK", "OKAY", "YES", "LEFT", "FIRST", "PRESS", "WHAT", "WAIT", "NOTHING", "READY", "RIGHT", "MIDDLE"],
	"PRESS": ["RIGHT", "MIDDLE", "YES", "READY", "PRESS", "OKAY", "NOTHING", "UHHH", "BLANK", "LEFT", "FIRST", "WHAT", "NO", "WAIT"],
	"YOU": ["SURE", "YOU ARE", "YOUR", "YOU'RE", "NEXT", "UH HUH", "UR", "HOLD", "WHAT?", "YOU", "UH UH", "LIKE", "DONE", "U"],
	"YOU ARE": ["YOUR", "NEXT", "LIKE", "UH HUH", "WHAT?", "DONE", "UH UH", "HOLD", "YOU", "U", "YOU'RE", "SURE", "UR", "YOU ARE"],
	"YOUR": ["UH UH", "YOU ARE", "UH HUH", "YOUR", "NEXT", "UR", "SURE", "U", "YOU'RE", "YOU", "WHAT?", "HOLD", "LIKE", "DONE"],
	"YOU'RE": ["YOU", "YOU'RE", "UR", "NEXT", "UH UH", "YOU ARE", "U", "YOUR", "WHAT?", "UH HUH", "SURE", "DONE", "LIKE", "HOLD"],
	"UR": ["DONE", "U", "UR", "UH HUH", "WHAT?", "SURE", "YOUR", "HOLD", "YOU'RE", "LIKE", "NEXT", "UH UH", "YOU ARE", "YOU"],
	"U": ["UH HUH", "SURE", "NEXT", "WHAT?", "YOU'RE", "UR", "UH UH", "DONE", "U", "YOU", "LIKE", "HOLD", "YOU ARE", "YOUR"],
	"UH HUH": ["UH HUH", "YOUR", "YOU ARE", "YOU", "DONE", "HOLD", "UH UH", "NEXT", "SURE", "LIKE", "YOU'RE", "UR", "U", "WHAT?"],
	"UH UH": ["UR", "U", "YOU ARE", "YOU'RE", "NEXT", "UH UH", "DONE", "YOU", "UH HUH", "LIKE", "YOUR", "SURE", "HOLD", "WHAT?"],
	"WHAT?": ["YOU", "HOLD", "YOU'RE", "YOUR", "U", "DONE", "UH UH", "LIKE", "YOU ARE", "UH HUH", "UR", "NEXT", "WHAT?", "SURE"],
	"DONE": ["SURE", "UH HUH", "NEXT", "WHAT?", "YOUR", "UR", "YOU'RE", "HOLD", "LIKE", "YOU", "U", "YOU ARE", "UH UH", "DONE"],
	"NEXT": ["WHAT?", "UH HUH", "UH UH", "YOUR", "HOLD", "SURE", "NEXT", "LIKE", "DONE", "YOU ARE", "UR", "YOU'RE", "U", "YOU"],
	"HOLD": ["YOU ARE", "U", "DONE", "UH UH", "YOU", "UR", "SURE", "WHAT?", "YOU'RE", "NEXT", "HOLD", "UH HUH", "YOUR", "LIKE"],
	"SURE": ["YOU ARE", "DONE", "LIKE", "YOU'RE", "YOU", "HOLD", "UH HUH", "UR", "SURE", "U", "WHAT?", "NEXT", "YOUR", "UH UH"],
	"LIKE": ["YOU'RE", "NEXT", "U", "UR", "HOLD", "DONE", "UH UH", "WHAT?", "UH HUH", "YOU", "LIKE", "SURE", "YOU ARE", "YOUR"]
}

var display_words = [
	"YES", "FIRST", "DISPLAY", "OKAY", "SAYS", "NOTHING", "", "BLANK", "NO",
	"LED", "LEAD", "READ", "RED", "REED", "LEED", "HOLD ON", "YOU", "YOU ARE",
	"YOUR", "YOU'RE", "UR", "THERE", "THEY'RE", "THEIR", "THEY ARE", "SEE", "C", "CEE"
]

var display
var buttons
var result

var label_pool = label_sequences.keys()

var strike = []
var correct
var finish

# Example use:
func _ready():
	for i in range(1, 7):
		var btn = get_node("text_%d" % i)
		btn.pressed.connect(Callable(self, "_on_button_pressed"))
	
	randomize()  # Ensure randomness
	display = get_random_display_word()
	buttons = get_random_buttons()
	result = get_button_to_press(display, buttons)
	update_button_label(display, buttons)
	
	print("Display: ", display)
	print("Buttons: ", buttons)
	print("Press this button: ", result)

func _process(delta: float) -> void:
	if strike.count(true) >= 2 and strike.size() == 3:
		correct = true
		finish = true
		$state.correct = correct
		$state.finish = finish
	elif strike.size() == 3:
		correct = false
		finish = true
		$state.correct = correct
		$state.finish = finish
	pass 

func _on_button_pressed(button_name: String) -> void:
	var position_map = {
		"text_1": "top_left",
		"text_2": "top_right",
		"text_3": "middle_left",
		"text_4": "middle_right",
		"text_5": "bottom_left",
		"text_6": "bottom_right"
	}

	var position = position_map.get(button_name)
	var label_pressed = buttons.get(position)

	print("Button pressed:", button_name)
	print("Position:", position)
	print("Label on button:", label_pressed)

	if label_pressed == result:
		strike.append(true)
	else:
		strike.append(false)
	
	strike_display()
	print(strike)
	
#	Updating label atfer pressed
	if strike.size() < 3:
		display = get_random_display_word()
		buttons = get_random_buttons()
		result = get_button_to_press(display, buttons)
		update_button_label(display, buttons)
	
	print("Display: ", display)
	print("Buttons: ", buttons)
	print("Press this button: ", result)

func strike_display():
	var strike_nodes = [$Strike_1, $Strike_2, $Strike_3]

	for i in range(min(strike.size(), 3)):
		if strike[i] == true:
			strike_nodes[i].material.albedo_color = Color(0, 1, 0)
		elif strike[i] == false:
			strike_nodes[i].material.albedo_color = Color(1, 0, 0) 


func update_button_label(displayed_word: String, buttons: Dictionary) -> void:
	await animate_label_text($DisplayText/Label3D, displayed_word)
	await get_tree().create_timer(0.1).timeout

	var label_nodes = [
		$text_1/Label3D,
		$text_2/Label3D,
		$text_3/Label3D,
		$text_4/Label3D,
		$text_5/Label3D,
		$text_6/Label3D
	]

	var keys = ["top_left", "top_right", "middle_left", "middle_right", "bottom_left", "bottom_right"]

	for i in range(label_nodes.size()):
		var label = label_nodes[i]
		var text_value = buttons[keys[i]]
		await animate_label_text(label, text_value)
		await get_tree().create_timer(0.1).timeout  # delay before next label

#ANIMATED LABELS APPEAR
func animate_label_text(label: Label3D, new_text: String) -> void:
	label.text = new_text
	label.scale = Vector3(0.1, 0.1, 0.1)  # Start small

	var tween = create_tween()
	tween.tween_property(label, "scale", Vector3(1, 1, 1), 0.3).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	await tween.finished

func get_button_position(displayed_word: String) -> String:
	return position_lookup.get(displayed_word.to_upper(), "")

func get_button_to_press(displayed_word: String, buttons: Dictionary) -> String:
	var position = get_button_position(displayed_word)
	if position == "":
		return "ERROR: Invalid display word"
	
	var label = buttons.get(position, "")
	if label == "":
		return "ERROR: Button label not found for position: %s" % position

	var sequence = label_sequences.get(label.to_upper(), [])
	for word in sequence:
		for btn_label in buttons.values():
			if btn_label.to_upper() == word:
				return btn_label
	return "ERROR: No matching button found"

func get_random_display_word() -> String:
	return display_words[randi() % display_words.size()]

# Get 6 unique random button labels and assign them to positions
func get_random_buttons() -> Dictionary:
	var shuffled_labels = label_pool.duplicate()
	shuffled_labels.shuffle()
	
	var positions = [
		"top_left", "top_right",
		"middle_left", "middle_right",
		"bottom_left", "bottom_right"
	]
	
	var buttons = {}
	for i in range(positions.size()):
		buttons[positions[i]] = shuffled_labels[i]
	
	return buttons
