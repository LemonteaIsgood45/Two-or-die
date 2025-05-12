extends Node

enum message{
	id,
	join,
	userConnected,
	userDisconnected,
	lobby,
	candidate,
	offer,
	answer,
	checkin
}

var characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"

var users = {}
var lobbies = {}

var peer = WebSocketMultiplayerPeer.new()

func _ready() -> void:
	peer.peer_connected.connect(peer_connected)
	peer.peer_disconnected.connect(peer_disconnected)


func _process(delta: float) -> void:
	peer.poll()
	if peer.get_available_packet_count() > 0:
		var packet = peer.get_packet()
		if packet != null:
			var dataString = packet.get_string_from_utf8()
			var data = JSON.parse_string(dataString)
			print(data)
	pass

func peer_connected(id):
	print("Peer connected: " + str(id))
	users[id] = {
		"id": id,
		"message": message.id
	}
	peer.get_peer(id).put_packet(JSON.stringify(users[id]).to_utf8_buffer())
	pass

func peer_disconnected(id):
	pass

func join_lobby(userId, lobbyId):
	var result = ""
	if lobbyId == "":
		lobbyId = result
		lobbies[lobbyId] = Lobby.new(userId)

func generate_random_string():
	var result = ""
	for i in range(32):
		var randomIndex = randi() % characters.length()
		result += characters[randomIndex]
	return result

func start_server():
	peer.create_server(8915)
	print("Started server")


func _on_start_server_button_down() -> void:
	start_server()
	pass # Replace with function body.


func _on_button_2_button_down() -> void:
	#var message = {
		#"message": message.id,
		#"data": "test"
	#}
	#var messageBytes = JSON.stringify(message).to_utf8_buffer()
	#peer.put_packet(messageBytes)
	pass # Replace with function body.
