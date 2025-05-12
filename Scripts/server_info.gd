extends HBoxContainer

signal joinGame(ip)

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass


func _on_button_button_down() -> void:
	joinGame.emit($IP.text)
