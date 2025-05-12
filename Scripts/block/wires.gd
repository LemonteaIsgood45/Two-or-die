extends Node3D

@export var color: Color

@export var is_cut = false
@export var is_counted := false
var is_hover = false

func _ready():
	
	var paths = [
		"wire_with_gap/Cylinder",
		"wire_with_gap/Cylinder_001",
		"wire_cut/Cylinder",
		"copper/Cylinder_003",
		"copper2/Cylinder_003"
	]

	for path in paths:
		var mesh = get_node(path) as MeshInstance3D
		if mesh:
			if mesh.material_overlay:
				mesh.material_overlay.albedo_color = color
			else:
				var mat = StandardMaterial3D.new()
				mat.albedo_color = color
				mesh.material_overlay = mat
		else:
			push_warning("Missing mesh node at path: %s" % path)

func _process(delta: float) -> void:
	if is_cut:
		%wire_cut.visible = false

func _on_static_body_3d_mouse_entered() -> void:
	is_hover = true

func _on_static_body_3d_mouse_exited() -> void:
	is_hover = false

func _on_static_body_3d_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			is_cut = true
