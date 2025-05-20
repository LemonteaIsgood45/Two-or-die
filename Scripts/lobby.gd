extends Control

signal player_kicked(playerId: String)

var defuser = {}
var instructor = {}

var guestID

func _ready():
	update_lobby(defuser, instructor)
	update_status()
	pass

func _process(delta: float) -> void:
	defuser = {}
	instructor = {}

	for player_id in GameState.players:
		var player = GameState.players[player_id]
		if player.role == "Defuser":
			defuser = player
		elif player.role == "Instructor":
			instructor = player

	update_lobby(defuser, instructor)
	update_status()

# Called when a player joins the lobby
@rpc("any_peer", "call_local")
func join_in_lobby(data):
	print("Player joining lobby with data: ", data)
	if multiplayer.is_server():
		if !GameState.players.has(data.id):
			GameState.players[data.id] = data
			# Broadcast this new player to all clients
			broadcast_player_joined.rpc(data)

# This is called on all clients to update lobby with a new player
@rpc("any_peer", "call_local")
func broadcast_player_joined(data):
	print("Received player data: ", data)

	if data.id != multiplayer.get_unique_id():
		guestID = data.id

	if data.role == "Defuser":
		defuser = data
	elif data.role == "Instructor":
		instructor = data

	print("Current defuser: ", defuser)
	print("Current instructor: ", instructor)
	update_status()
	update_lobby(defuser, instructor)

# Switch roles button pressed
@rpc("authority", "call_remote")
func on_switch_spot_pressed():
	if multiplayer.is_server():
		switch_roles()
	else:
		rpc_id(1, "on_switch_spot_pressed")  # Call the server (peer_id 1)

# Switches the player roles
func switch_roles():
	if GameState.players.size() < 2:
		print("Both players must join first to switch.")
		return
	
	# Swap roles between two players
	var player_ids = GameState.players.keys()
	var player_a = GameState.players[player_ids[0]]
	var player_b = GameState.players[player_ids[1]]

	var temp_role = player_a.role
	player_a.role = player_b.role
	player_b.role = temp_role

	# Save updated roles back
	GameState.players[player_ids[0]] = player_a
	GameState.players[player_ids[1]] = player_b

	# Notify all clients about updated roles
	for id in player_ids:
		broadcast_player_joined.rpc(GameState.players[id])
	
	sync_players.rpc(GameState.players)

@rpc("authority", "call_remote")
func sync_players(players_dict):
	print("Syncing players: ", players_dict)
	GameState.players = players_dict
	update_status()
	update_lobby(defuser, instructor)

# Updates the UI status labels with current player information
func update_status():
	if defuser.size() > 0:
		$DefuserLabel.text = defuser.name
	#else:
		#$DefuserLabel.text = "Waiting for Defuser..."
		
	if instructor.size() > 0:
		$InstructorLabel.text = instructor.name
	#else:
		#$InstructorLabel.text = "Waiting for Instructor..."
		
	$StatusLabel.text = "Current Roles:\n"
	for player_id in GameState.players:
		var player = GameState.players[player_id]
		$StatusLabel.text += str(player.name) + ": " + player.role + "\n"

# Updates visual elements in lobby based on player information
func update_lobby(defuser_in, instructor_in):
	if defuser_in.size() > 0:
		%DefuserIcon.visible = true
	else: 
		%DefuserIcon.visible = false
		
	if instructor_in.size() > 0:
		%InstructorIcon.visible = true
	else: 
		%InstructorIcon.visible = false


func _on_switch_spot_pressed() -> void:
	on_switch_spot_pressed()
	pass # Replace with function body.


func _on_kick_button_down() -> void:
	if !multiplayer.is_server():
		return  # Only the host can kick players

	for player_id in GameState.players:
		if player_id != multiplayer.get_unique_id():  # Don't kick the host
			player_kicked.emit(player_id)  # Emit signal to MultiplayerScene
			break
