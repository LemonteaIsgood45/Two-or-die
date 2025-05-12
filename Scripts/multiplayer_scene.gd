extends Control

signal player_kicked(error_title: String, error_content: String)

@export var Address = "204.48.28.159"
@export var port = 8910

var peer

var connected_peers: Dictionary = {}
var player_username: String = ""

var is_in_lobby: bool = false

var has_game_started: bool = false
var has_game_ended: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	multiplayer.peer_connected.connect(peer_connected)
	multiplayer.peer_disconnected.connect(peer_disconnected)
	multiplayer.connected_to_server.connect(connected_to_server)
	multiplayer.connection_failed.connect(connection_failed)
	multiplayer.server_disconnected.connect(on_server_disconnected)

	
	if "--server" in OS.get_cmdline_args():
		hostGame()
	
	$ServerBrowser.joinGame.connect(Join_by_ip)
	$LobbyControl/LobbyScene/Lobby.player_kicked.connect(_on_lobby_player_player_kicked)

func _process(delta: float) -> void:
	if peer == null:
		$LobbyControl.hide()
	else:
		$LobbyControl.show()
	pass

# This gets called on the server and clients when a peer connects
func peer_connected(id):
	if has_game_started:
		if multiplayer.is_server():
			rpc_id(id, "kick_peer", "Game has started", "You cannot join this game, because the game has already started.")
		return

	if connected_peers.size() == 2:
		if multiplayer.is_server():
			rpc_id(id, "kick_peer", "Lobby is full", "You cannot join this game, because the lobby is full.")
		return

	connected_peers[id] = ""
	print("Player Connected " + str(id))
	
# This gets called on the server and clients when a peer disconnects
func peer_disconnected(id):
	print("Player Disconnected " + str(id))
	connected_peers.erase(id)
	GameState.players.erase(id)
	
	var players = get_tree().get_nodes_in_group("Player")
	for i in players:
		if i.name == str(id):
			i.queue_free()
			
	# Update lobby for remaining players if we're the server
	if multiplayer.is_server():
		for peer_id in connected_peers:
			if GameState.players.has(peer_id):
				var player_data = GameState.players[peer_id]
				$LobbyControl/LobbyScene/Lobby.broadcast_player_joined.rpc(player_data)

# Called only from clients when successfully connected to server
func connected_to_server():
	print("Connected to server!")
	# Send our player information to the server
	SendPlayerInformation.rpc_id(1, %LineEdit.text, multiplayer.get_unique_id(), "Instructor")

# Called only from clients when connection fails
func connection_failed():
	print("Couldn't connect to server")

func on_server_disconnected() -> void:
	if has_game_ended:
		return
	$"../../../../../background".show()
	%MenuUI.show()
	player_kicked.emit("Host Left","The game has ended because host has left.")

# RPC to synchronize player information between peers
@rpc("any_peer")
func SendPlayerInformation(name, id, role):
	if !GameState.players.has(id):
		GameState.players[id] = {
			"name": name,
			"id": id,
			"role": role
		}
	
	# If we're the server, relay this information to all connected peers
	if multiplayer.is_server():
		for i in GameState.players:
			SendPlayerInformation.rpc(GameState.players[i].name, i, GameState.players[i].role)

# RPC to kick a peer from the game
@rpc("authority")
func kick_peer(title, message):
	print("Kicked: " + title + " - " + message)
	player_kicked.emit(title, message)
	clear_peer()
	# Add UI feedback here if needed

# RPC to start the game on all peers
@rpc("authority", "call_local")
func start_game():
	var my_id = multiplayer.get_unique_id()
	if GameState.players.has(my_id):
		GameState.role = GameState.players[my_id].role
		print("Updated myself: ", GameState.players[my_id])
	else:
		print("Couldn't find my own player data.")
	var scene = load("res://Scenes/game.tscn").instantiate()
	get_tree().root.add_child(scene)
	
	$"../../../../../background".hide()
	%MenuUI.hide()
	self.hide()

# Called when the game starts
func game_started() -> void:
	if multiplayer.is_server():
		has_game_started = true
		rpc("start_game")

# Host a new game
func hostGame():
	is_in_lobby = true
	
	peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(port, 2)
	if error != OK:
		print("Cannot host: " + str(error))
		return
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	
	multiplayer.set_multiplayer_peer(peer)
	
	$"../../../../../WorldAudioManager".set_up_audio(1)
	print("Waiting for players!")

# Join an existing game by IP
func Join_by_ip(ip):
	peer = ENetMultiplayerPeer.new()
	is_in_lobby = true
	peer.create_client(ip, port)
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.set_multiplayer_peer(peer)
	
	$"../../../../../WorldAudioManager".set_up_audio(multiplayer.get_unique_id())

# Clean up networking resources
func clear_peer() -> void:
	has_game_ended = false
	has_game_started = false

	connected_peers.clear()
	GameState.players.clear()
	$LobbyControl/LobbyScene/Lobby.defuser.clear()
	$LobbyControl/LobbyScene/Lobby.instructor.clear()

	if multiplayer.multiplayer_peer:
		multiplayer.multiplayer_peer.close()
		multiplayer.multiplayer_peer = null

	peer = null

# UI button handlers
func _on_host_button_down():
	hostGame()
	
	$LobbyControl.visible = true
	
	var my_id = multiplayer.get_unique_id()
	var my_name = %LineEdit.text
	var my_role = "Defuser"

	var data = {
		"name": my_name,
		"id": my_id,
		"role": my_role
	}

	# Add host info directly to GameState.players
	GameState.players[my_id] = data
	
	# Add to lobby and broadcast to others
	$LobbyControl/LobbyScene/Lobby.broadcast_player_joined.rpc(data)
	SendPlayerInformation(my_name, my_id, my_role)
	
	print("sent player info to all")
	$ServerBrowser.set_up_broadcast(my_name + "'s server")
	print("GameState.players = ", GameState.players)

func _on_join_button_down():
	$LobbyControl.visible = true
	Join_by_ip(Address)

func _on_start_button_down() -> void:
	if multiplayer.is_server() and GameState.players.size() == 2:
		GameState.current_mode = GameState.GameMode.PLAYING
		game_started()

func _on_lobby_player_player_kicked(playerId) -> void:
	if multiplayer.is_server():
		rpc_id(playerId, "kick_peer", "Kicked", "You have been kicked from the lobby.")

func _on_back_to_lan_browser_button_down() -> void:
	if multiplayer.is_server():
		multiplayer.multiplayer_peer = null  # Stop the server
	else:
		multiplayer.multiplayer_peer = null  # Disconnect from server
	
	clear_peer()  # Your own cleanup function
	$LobbyControl.visible = false
