extends VBoxContainer

func _process(delta: float) -> void:
	volumn_update()


func volumn_update():
	var volumn = $Volumn/HSlider.value
	var music_volumn = $Music/HSlider.value
	var sfx_volume = $Sfx/HSlider.value
	var voice_chat_volumn = $VoiceChat/HSlider.value
	
	GlobalAudio.volumn = volumn
	GlobalAudio.music_volume = music_volumn
	GlobalAudio.sfx_volume = sfx_volume
	GlobalAudio.voice_chat_volumn = voice_chat_volumn
