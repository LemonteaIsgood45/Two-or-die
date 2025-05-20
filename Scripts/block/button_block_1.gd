extends Node3D

var original_position: Vector3
var is_pressed := false
var is_hovered := false

var finish := false
var correct := false
var prev_pressed := false

var parent

var button_color: String = ""
var button_text: String = ""
var is_held: bool = false
var strip_color: String = ""


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	parent = get_parent()
	randomize_button()
	original_position = %Button.position
	%Status.material = StandardMaterial3D.new()
	update_label_text(button_text)
	update_button_color(get_color_from_name(button_color))

func _process(delta: float) -> void:
	if not finish:
		if prev_pressed and not is_pressed:
			# No need to do anything here anymore
			pass
		prev_pressed = is_pressed
	
	%state.finish = finish
	%state.correct = correct


# Function to change the text of the Label3D
func update_label_text(new_text: String):
	var label = %Button_label
	label.text = new_text
	if button_color == "black" or button_color == "blue" or button_color == "red":
		label.modulate = Color(1, 1, 1)

# Function to change the color of the CSGBox
func update_button_color(new_color: Color):
	var box = %Button
	box.material_override = StandardMaterial3D.new()
	box.material_override.albedo_color = new_color

func _on_static_body_3d_mouse_entered() -> void:
	is_hovered = true
	_update_z_position()

func _on_static_body_3d_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			is_pressed = true
			button_pressed()
		else:
			is_pressed = false
			if not finish:  # Only process if not finished
				finish = true
				correct = button_released()
		_update_z_position()

func _on_static_body_3d_mouse_exited() -> void:
	is_hovered = false
	is_pressed = false
	_update_z_position()

func _update_z_position() -> void:
	if is_pressed:
		var new_pos = original_position
		new_pos.y -= 0.007
		%Button.position = new_pos
		%Status.material.albedo_color = get_color_from_name(strip_color)
	else:
		%Button.position = original_position
		%Status.material.albedo_color = Color(0.827, 0.827, 0.827)

func get_color_from_name(name: String) -> Color:
	var color_map = {
		"red": Color(1, 0, 0),
		"blue": Color(0, 0, 1),
		"yellow": Color(1, 1, 0),
		"white": Color(1, 1, 1),
		"black": Color(0, 0, 0),
		"green": Color(0, 1, 0),
	}
	return color_map.get(name, Color(1, 0, 1))

func randomize_button():
	# Randomize button color
	var colors = ["blue", "white", "yellow", "red", "black"]
	button_color = colors[randi() % colors.size()]
	
	# Randomize button text
	var texts = ["Abort", "Detonate", "Hold", "Press", "Submit"]
	button_text = texts[randi() % texts.size()]
	
	# Randomize strip color (only visible when button is held)
	var strip_colors = ["blue", "white", "yellow", "red", "green"]
	strip_color = strip_colors[randi() % strip_colors.size()]

func button_pressed():
	var action = determine_action()
	match action:
		"hold":
			hold_button()
		"press_release":
			press_and_release()

# Called when button is released
func button_released():
	if is_held:
		is_held = false
		var should_release = should_release_held_button()
		if should_release:
			print("CORRECT! Button released at the right time.")
		else:
			print("WRONG! Button released at the wrong time.")
		return should_release
	return false

# Determine initial action based on button rules
func determine_action() -> String:
	# 1. If the button is blue and the button says "Abort", hold the button
	if button_color == "blue" and button_text == "Abort":
		return "hold"
	
	# 2. If there is more than 1 battery on the bomb and the button says "Detonate", press and release
	elif parent.battery_count > 1 and button_text == "Detonate":
		return "press_release"
	
	# 3. If the button is white and there is a lit indicator with label CAR, hold the button
	elif button_color == "white" and parent.has_car_indicator:
		return "hold"
	
	# 4. If there are more than 2 batteries and there is a lit indicator with label FRK, press and release
	elif parent.battery_count > 2 and parent.has_frk_indicator:
		return "press_release"
	
	# 5. If the button is yellow, hold the button
	elif button_color == "yellow":
		return "hold"
	
	# 6. If the button is red and the button says "Hold", press and release
	elif button_color == "red" and button_text == "Hold":
		return "press_release"
	
	# 7. If none of the above apply, hold the button
	else:
		return "hold"

# Handle press and immediate release
func press_and_release():
	print("Press and immediately release the button.")
	return true  # Success

# Handle holding the button down
func hold_button():
	is_held = true
	print("Hold the button and check the colored strip.")
	print("Strip color is: " + strip_color)
	return false  # Not done yet, need to release at the right time

# Determine when to release the held button based on strip color
func should_release_held_button() -> bool:
	var countdown_display = parent.timer
	
	# Check rules for releasing based on strip color
	match strip_color:
		"blue":
			# Release when countdown timer has a 4 in any position
			return "4" in countdown_display
		"white":
			# Release when countdown timer has a 1 in any position
			return "1" in countdown_display
		"yellow":
			# Release when countdown timer has a 5 in any position
			return "5" in countdown_display
		_:
			# Any other color: release when countdown timer has a 1 in any position
			return "1" in countdown_display
