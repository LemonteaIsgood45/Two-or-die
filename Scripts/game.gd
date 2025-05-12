extends Node3D

@export var PlayerScene: PackedScene

func _ready() -> void:
	for peer_id in GameState.players:
		var player_data = GameState.players[peer_id]
		var currentPlayer = PlayerScene.instantiate()
		currentPlayer.role = player_data.role
		currentPlayer.set_multiplayer_authority(peer_id)
		
		add_child(currentPlayer)
		# Set spawn position
		if player_data.role == "Defuser":
			currentPlayer.global_position = $Defuser.global_position
		elif player_data.role == "Instructor":
			currentPlayer.global_position = $Instructor.global_position


func _on_online_game_button_pressed() -> void:
	pass

func _process(delta):
	pass

func _unhandled_input(event):
	pass
	
