extends Control

@onready var mic_icon := $MicIcon
@onready var volume_bar := $VolumeBar

var volume_smoothed := 0.0

func _process(delta: float) -> void:
	var bus_index = AudioServer.get_bus_index("voice_chat")
	var db = AudioServer.get_bus_peak_volume_left_db(bus_index, 0)

	if db < -60.0:		db = -60.0  # Clamp noise floor

	var volume_linear = db_to_linear(db)
	var curved = pow(volume_linear, 0.5)  # Boost quiet parts

	volume_smoothed = lerp(volume_smoothed, curved, 0.1)
	update_visual(volume_smoothed)

func update_visual(volume: float) -> void:
	var clamped = clamp(volume, 0.0, 1.0)
	mic_icon.modulate.a = 0.5 + clamped * 0.5
	volume_bar.value = clamped * volume_bar.max_value
