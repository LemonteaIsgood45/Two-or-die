extends RefCounted

class_name Lobby

var hostID: int
var players: Dictionary = {}

func _init(id) -> void:
	hostID = id

func add_player(id, name):
	players[id] = {
		"name": name,
		"id": id,
		"index": players.size() + 1
	}
	return players[id]
