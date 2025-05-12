extends Camera3D

var mouse_sensitivity := 0.1
var yaw := 0.0
var pitch := 0.0
var dragging := false

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			dragging = event.pressed
			# Hide mouse while dragging
			if dragging:
				Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
			else:
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	elif event is InputEventMouseMotion and dragging:
		yaw -= event.relative.x * mouse_sensitivity
		pitch -= event.relative.y * mouse_sensitivity
		pitch = clamp(pitch, -80, 80)

		var player = get_parent()
		player.rotation_degrees.y = yaw
		rotation_degrees.x = pitch
