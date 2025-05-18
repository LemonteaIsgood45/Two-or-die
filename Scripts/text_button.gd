extends Node3D

signal pressed(button_name)

var is_pressed := false
var original_position: Vector3

func _ready() -> void:
	original_position = self.position

func _on_static_body_3d_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			is_pressed = true
			emit_signal("pressed", name)
		else:
			is_pressed = false
		_update_z_position()

func _on_static_body_3d_mouse_entered() -> void:
	_update_z_position()


func _on_static_body_3d_mouse_exited() -> void:
	_update_z_position()

func _update_z_position() -> void:
	var new_pos = original_position
	new_pos.y -= 0.005
	if is_pressed:
		self.position = new_pos
	else:
		self.position = original_position
