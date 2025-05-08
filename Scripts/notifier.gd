extends Node3D

@export var correct := false
@export var finish := false

func _process(_delta: float) -> void:
	var mesh_instance = %CSGSphere3D

	if mesh_instance.material is StandardMaterial3D:
		# Duplicate the material if not already unique
		if mesh_instance.material.resource_local_to_scene == false:
			mesh_instance.material = mesh_instance.material.duplicate()
			mesh_instance.material.resource_local_to_scene = true

		var sphere_material: StandardMaterial3D = mesh_instance.material as StandardMaterial3D

		if not finish:
			sphere_material.albedo_color = Color(0.2, 0.2, 0.2)
		elif finish and correct:
			sphere_material.albedo_color = Color(0, 1, 0)
		else:
			sphere_material.albedo_color = Color(1, 0, 0)
