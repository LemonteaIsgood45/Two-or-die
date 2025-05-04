extends Node3D

var hovered_node: Node3D = null


func _on_online_game_button_pressed() -> void:
	%Camera3DDefuser.current = true
	#%MenuUI.visible = false

func _process(delta):
	var cam = get_viewport().get_camera_3d()
	var from = cam.project_ray_origin(get_viewport().get_mouse_position())
	var to = from + cam.project_ray_normal(get_viewport().get_mouse_position()) * 1000

	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.new()
	query.from = from
	query.to = to
	query.collide_with_bodies = true
	query.collide_with_areas = true

	var result = space_state.intersect_ray(query)

	# Reset previous hover
	if hovered_node and hovered_node.is_inside_tree():
		hovered_node.scale = Vector3.ONE
		hovered_node = null

	if result and result.collider and result.collider.is_in_group("hoverable"):
		hovered_node = result.collider
		hovered_node.scale = Vector3.ONE * 1.05  # Grow!

func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed:
		var cam = get_viewport().get_camera_3d()
		var from = cam.project_ray_origin(event.position)
		var to = from + cam.project_ray_normal(event.position) * 1000

		var space_state = get_world_3d().direct_space_state

		var query = PhysicsRayQueryParameters3D.new()
		query.from = from
		query.to = to
		query.collide_with_areas = true
		query.collide_with_bodies = true

		var result = space_state.intersect_ray(query)

		if result and result.collider and result.collider.is_in_group("clickable"):
			result.collider.is_pressed = true
			print("Tapped and hid:", result.collider.name)
