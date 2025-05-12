extends Control

signal found_server(ip, port, roomInfo)
signal update_server(ip, port, roomInfo)
signal joinGame(ip)

var broadcastTimer: Timer
	
var roomInfo = {"name": "name", "playerCount": 0}
var broadcaster: PacketPeerUDP
var listener: PacketPeerUDP

@export var listenPort: int = 8911
@export var broadcastPort: int = 8912
@export var broadcastAddress: String = '192.168.32.255'

@export var serverInfo: PackedScene

func _ready() -> void:
	broadcastTimer = $BroadcastTimer
	
	set_up()

func set_up():
	listener = PacketPeerUDP.new()
	
	var success =  listener.bind(listenPort)
	if success == OK:
		print("Bound to listen port:" + str(listenPort))
		$Label.text  = "Bound to listen port: true"
	else: 
		print("Failed to bind to broatcast port!")
		$Label.text  = "Bound to listen port: false"


func set_up_broadcast(name):
	roomInfo.name = name
	
	broadcaster = PacketPeerUDP.new()
	broadcaster.set_broadcast_enabled(true)
	broadcaster.set_dest_address(broadcastAddress, listenPort)
	
	var success =  broadcaster.bind(broadcastPort)
	if success == OK:
		print("Bound:" + str(broadcastPort))
	else: 
		print("Failed to bind to broatcast port!")
		
	$BroadcastTimer.start()

func _process(delta: float) -> void:
	if listener.get_available_packet_count() > 0:
		var server_ip = listener.get_packet_ip()
		var server_port = listener.get_packet_port()
		var bytes = listener.get_packet()
		var data = bytes.get_string_from_ascii()
		var roomInfo = JSON.parse_string(data)

		# Skip processing and print if playerCount == 0
		if roomInfo.playerCount == 0:
			for i in $Panel/VBoxContainer.get_children():
				if i.name == roomInfo.name:
					i.queue_free()
					print("Removed inactive server: " + roomInfo.name)
					return
			# Optionally return even if it wasn't found (no point in continuing)
			return

		# This only prints for valid/active rooms
		print("Server IP: " + server_ip + ". Server Port: " + str(server_port) + ". Room info: " + str(roomInfo))
		print("Players: " + str(GameState.players))
		print("Defuser: " + str($"../LobbyControl/LobbyScene/Lobby".defuser))
		print("Instructor: " + str($"../LobbyControl/LobbyScene/Lobby".instructor))

		for i in $Panel/VBoxContainer.get_children():
			if i.name == roomInfo.name:
				update_server.emit(server_ip, server_port, roomInfo)
				i.get_node("IP").text = server_ip
				i.get_node("PlayerCount").text = str(roomInfo.playerCount)
				return
		
		var currentInfo = serverInfo.instantiate()
		currentInfo.name = roomInfo.name
		currentInfo.get_node("Name").text = roomInfo.name
		currentInfo.get_node("IP").text = server_ip
		currentInfo.get_node("PlayerCount").text = str(roomInfo.playerCount)
		$Panel/VBoxContainer.add_child(currentInfo)
		currentInfo.joinGame.connect(func(ip):
			join_by_ip(ip)
			$"../LobbyControl".visible = true
		)
		found_server.emit(server_ip, server_port, roomInfo)

func _on_broadcast_timer_timeout() -> void:
	print("Broadcasting game")
	roomInfo.playerCount = GameState.players.size()
	var data = JSON.stringify(roomInfo)
	var packet = data.to_ascii_buffer()
	broadcaster.put_packet(packet)

func clean_up():
	listener.close()
	
	$BroadcastTimer.stop()
	if broadcaster != null:
		broadcaster.close()

func _exit_tree() -> void:
	clean_up()

func join_by_ip(ip):
	joinGame.emit(ip)
