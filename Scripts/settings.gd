extends VBoxContainer

var is_voice_chat_open = GameState.is_voice_chat_open

func _process(delta: float) -> void:
	volumn_update()
	if GameState.is_voice_chat_open == true:
		$HBoxContainer/VoiceChatLabel.text = "ON"
	else:
		$HBoxContainer/VoiceChatLabel.text = "OFF"

func volumn_update():
	var volumn = $Volumn/HSlider.value
	var music_volumn = $Music/HSlider.value
	var sfx_volume = $Sfx/HSlider.value
	var voice_chat_volumn = $VoiceChat/HSlider.value
	
	GlobalAudio.volumn = volumn
	GlobalAudio.music_volume = music_volumn
	GlobalAudio.sfx_volume = sfx_volume
	GlobalAudio.voice_chat_volumn = voice_chat_volumn


func _on_voice_chat_button_down() -> void:
	GameState.is_voice_chat_open = !GameState.is_voice_chat_open


func _on_setting_back_button_button_down() -> void:
	if GameState.current_mode == GameState.GameMode.HOME:
		GameState.game_controller.change_gui_scene("res://Scenes/GUI/menu_ui.tscn", false)
		return
	GameState.game_controller.change_gui_scene("res://Scenes/GUI/game_canvas_ui.tscn", false)
	pass # Replace with function body.
