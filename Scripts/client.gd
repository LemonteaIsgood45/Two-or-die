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

var peer = WebSocketMultiplayerPeer.new()

var id = 0

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	peer.poll()
	if peer.get_available_packet_count() > 0:
		var packet = peer.get_packet()
		if packet != null:
			var dataString = packet.get_string_from_utf8()
			var data = JSON.parse_string(dataString)
			print(data)
			if data.message == message.id:
				id = data.id
				print("My id is: " + str(id))
	pass
	

func connect_to_server(ip):
	peer.create_client("ws://127.0.0.1:8915")
	print("Started client")


func _on_start_client_button_down() -> void:
	connect_to_server("")
	pass # Replace with function body.


func _on_button_button_down() -> void:
	var message = {
		"message": message.join,
		"data": "test"
	}
	var messageBytes = JSON.stringify(message).to_utf8_buffer()
	peer.put_packet(messageBytes)
	pass # Replace with function body.
