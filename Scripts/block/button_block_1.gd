extends Node3D

var original_position: Vector3
var is_pressed := false
var is_hovered := false

var finish := false
var correct := false

#var time
#var label
#var button_color

# Called when the node enters the scene tree for the first time.
func _ready():
	original_position = %Button.position
	%Status.material_override = StandardMaterial3D.new()
	update_label_text("Hello 3D!")
	update_button_color(Color(0.2, 0.8, 0.4))  # Set initial color (greenish)

func _process(delta: float) -> void:
	%state.finish = finish
	%state.correct = correct

# Function to change the text of the Label3D
func update_label_text(new_text: String):
	var label = %Button_label
	if label and label is Label3D:
		label.text = new_text
	else:
		push_warning("Label3D not found or incorrect type.")

# Function to change the color of the CSGBox
func update_button_color(new_color: Color):
	var box = %Button
	if box and box is CSGBox3D:
		box.material = StandardMaterial3D.new()
		box.material.albedo_color = new_color
	else:
		push_warning("CSGBox3D not found or incorrect type.")

func _on_static_body_3d_mouse_entered() -> void:
	is_hovered = true
	_update_z_position()

func _on_static_body_3d_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			is_pressed = true
		else:
			is_pressed = false
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
		%Status.material_override.albedo_color = Color(1, 0, 0, 1)
	else:
		%Button.position = original_position
		%Status.material_override.albedo_color = Color(1, 1, 1, 1)
