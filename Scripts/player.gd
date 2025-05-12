extends Node3D

var role: String = ""

func _ready():
	# Only make the camera current if this player is the local player
	if multiplayer.get_unique_id() == get_multiplayer_authority():
		$Camera3D.make_current()
