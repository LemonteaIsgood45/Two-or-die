extends Node

var current_state

var volumn: int
var music_volume: int
var sfx_volume: int
var voice_chat_volumn: int

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	current_state = GameState.GameMode
