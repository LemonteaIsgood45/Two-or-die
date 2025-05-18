extends Node

var game_controller: GameController

var is_voice_chat_open = false

var current_mode: GameMode = GameMode.HOME

var players = {}

var role = "Defuser"

var serial_number
var timer: String
#MODE

enum GameMode { HOME, WAITING, PLAYING, SETTING, WIN, LOSE }

signal mode_changed(new_mode)

func set_mode(new_mode: GameMode):
	if new_mode != current_mode:
		current_mode = new_mode
		emit_signal("mode_changed", new_mode)

func is_mode(mode: GameMode) -> bool:
	return current_mode == mode

@rpc("any_peer", "call_local")
func assign_role(_role):
	role = _role


# 4 character block

func generate_4_character_block() -> Array:
	var alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
	var chosen := []
	randomize()

	while chosen.size() < 4:
		var letter = alphabet[randi() % alphabet.length()]
		if letter not in chosen:
			chosen.append(letter)
	
	return chosen
