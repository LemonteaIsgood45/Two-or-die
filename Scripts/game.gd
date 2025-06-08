extends Node3D

@export var PlayerScene: PackedScene

var game_finished := false

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
			currentPlayer.rotation_degrees = Vector3(0, 180, 0)
		elif player_data.role == "Instructor":
			currentPlayer.global_position = $Instructor.global_position
			currentPlayer.rotation_degrees = Vector3(-30, 0, 0)
	
	if GameState.role == "Instructor":
		var Instruction = load("res://Scenes/instruction.tscn").instantiate()
		add_child(Instruction)

func _process(delta):
	if multiplayer.is_server() and not game_finished:
		if GameState.current_mode == GameState.GameMode.WIN:
			request_finish_game(true)
			game_finished = true
		elif GameState.current_mode == GameState.GameMode.LOSE:
			request_finish_game(false)
			game_finished = true
	elif not multiplayer.is_server() and not game_finished:
		if GameState.current_mode == GameState.GameMode.WIN:
			client_request_finish.rpc(true)
			game_finished = true
		elif GameState.current_mode == GameState.GameMode.LOSE:
			client_request_finish.rpc(false)
			game_finished = true
	pass
	

func _unhandled_input(event):
	pass

func request_finish_game(win: bool):
	if multiplayer.is_server() and not game_finished:  # Only server should broadcast this
		print("Server requesting finish game: Win=" + str(win))
		game_finished = true
		# Synchronize to all clients including ourselves
		finish_game.rpc(win)

# This RPC is called on all clients and the server to update game state
@rpc("any_peer", "call_local", "reliable")
func finish_game(win: bool):
	if game_finished:
		return
	game_finished = true

	if win:
		GameState.current_mode = GameState.GameMode.WIN
		print("Game finished: WIN")
	else:
		GameState.current_mode = GameState.GameMode.LOSE
		print("Game finished: LOSE")

	
	# Could add additional visualization or UI updates here
	print("GameState.current_mode updated to: " + str(GameState.current_mode))

@rpc("any_peer", "reliable")
func client_request_finish(win: bool):
	if multiplayer.is_server() and not game_finished:
		print("Client", multiplayer.get_remote_sender_id(), "requested finish. Win =", win)
		request_finish_game(win)
