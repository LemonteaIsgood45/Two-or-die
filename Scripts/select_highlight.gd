extends MeshInstance3D

@export var outline_material: Material
@export var body: PhysicsBody3D = null

func _ready() -> void:
	if body:
		body.mouse_entered.connect(_on_static_body_3d_mouse_entered)
		body.mouse_exited.connect(_on_static_body_3d_mouse_exited)
	else:
		push_error("Physics body not assigned in the inspector.")

func _on_static_body_3d_mouse_entered() -> void:
	self.material_overlay = outline_material

func _on_static_body_3d_mouse_exited() -> void:
	self.material_overlay = null
