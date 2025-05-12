extends Node3D

var is_pressed := false

# Called when the node enters the scene tree for the first time.
func _ready():
	%status.material_override = StandardMaterial3D.new()

# Function to change the text of the Label3D
func update_label_text(new_text: String):
	var label = %Label3D
	if label and label is Label3D:
		label.text = new_text
	else:
		push_warning("Label3D not found or incorrect type.")



func _on_static_body_3d_mouse_entered() -> void:
	_update_z_position()

func _on_static_body_3d_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			is_pressed = !is_pressed 
		_update_z_position()

func _on_static_body_3d_mouse_exited() -> void:
	_update_z_position()

func _update_z_position() -> void:
	if is_pressed:
		%status.material_override.albedo_color = Color(1, 0, 0, 1)
	else:
		%status.material_override.albedo_color = Color(1, 1, 1, 1)
