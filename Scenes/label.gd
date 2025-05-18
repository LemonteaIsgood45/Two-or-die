extends Label

func _process(delta: float) -> void:
	self.text = str(GameState.current_mode)
