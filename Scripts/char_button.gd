extends Node3D

var original_position: Vector3
var is_pressed := false
var is_hovered := false

var last_pressed := false

func _ready() -> void:
	original_position = $".".position


func _on_static_body_3d_mouse_entered() -> void:
	is_hovered = true
	_update_z_position()

func _on_static_body_3d_mouse_exited() -> void:
	is_hovered = false
	is_pressed = false
	_update_z_position()

func _on_static_body_3d_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			is_pressed = true
		else:
			is_pressed = false
		_update_z_position()

func _update_z_position() -> void:
	if is_pressed:
		var new_pos = original_position
		new_pos.y -= 0.001	
		$".".position = new_pos
	else:
		$".".position = original_position
