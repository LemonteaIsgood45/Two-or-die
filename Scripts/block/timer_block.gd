extends Node3D

@onready var label = %Label3D
@onready var timer = $Timer

func _ready() -> void:
	timer.start()

func timer_left_to_live():
	var time_left = timer.time_left
	var minute  = floor(time_left / 60)
	var second = int(time_left) % 60
	return [minute, second]

func _process(delta: float) -> void:
	label.text = "%02d:%02d" % timer_left_to_live()
