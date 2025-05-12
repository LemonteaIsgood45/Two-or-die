extends Node

@export var bg_music_player: AudioStreamPlayer
@export var player_audio_stream: AudioStreamPlayer
@export var specific_scene_instance: PackedScene

var current_state

func _ready() -> void:
	current_state = GlobalAudio.current_state
	player_audio_stream.play()
	pass

func _process(delta: float) -> void:
	update_volumn()
	if current_state != GlobalAudio.current_state:
		current_state = GlobalAudio.current_state
	pass

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var mouse_pos = event.position
		var root_window = get_tree().root  # Global root
		var clicked_control = find_control_at_pos(mouse_pos, root_window)

		if clicked_control:
			if clicked_control is Button:
				print("✅ Clicked on Button: ", clicked_control.name)
			elif clicked_control is TextEdit:
				print("✏️ Clicked on TextEdit: ", clicked_control.name)
			elif clicked_control == specific_scene_instance:
				print("🎯 Clicked on specific PackedScene instance!")
			else:
				print("🟦 Clicked on other Control: ", clicked_control.name)
		else:
			print("🕳️ Clicked on empty space or non-Control node.")

func find_control_at_pos(pos: Vector2, node: Node) -> Control:
	if node is Control and node.visible:
		if node.get_global_rect().has_point(pos):
			# Search children first (topmost)
			for child in node.get_children():
				var found = find_control_at_pos(pos, child)
				if found:
					return found
			# If no children match, return self
			return node
	# If not Control or not under point
	for child in node.get_children():
		var found = find_control_at_pos(pos, child)
		if found:
			return found
	return null



func update_music_for_scene():
	var current_state_music = "LOSE" if current_state == GameState.GameMode.LOSE else "NORMAL"
	bg_music_player["parameters/switch_to_clip"] = current_state_music

func update_player_audio(audioName: String):
	player_audio_stream["parameters/switch_to_clip"] = audioName
	
func update_volumn():
	var volumn_index = AudioServer.get_bus_index("Master")
	var music_index = AudioServer.get_bus_index("music")
	var sfx_index = AudioServer.get_bus_index("sfx")
	var voice_chat_index = AudioServer.get_bus_index("voice_chat")
	 
	AudioServer.set_bus_volume_db(volumn_index, GlobalAudio.volumn)
	AudioServer.set_bus_volume_db(music_index, GlobalAudio.music_volume)
	AudioServer.set_bus_volume_db(sfx_index, GlobalAudio.sfx_volume)
	AudioServer.set_bus_volume_db(voice_chat_index, GlobalAudio.voice_chat_volumn)
	
