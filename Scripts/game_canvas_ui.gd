extends Control

func _process(delta: float) -> void:
	if GameState.current_mode == GameState.GameMode.WIN:
		$CanvasLayer/ColorRect.visible = true
		%Label.text = "DEFUSED"
	elif GameState.current_mode == GameState.GameMode.LOSE:
		$CanvasLayer/ColorRect.visible = true
		%Label.text = "EXPLODED"

func _on_global_setting_button_down() -> void:
	GameState.game_controller.change_gui_scene("res://Scenes/GUI/setting.tscn", false)

func _on_wintest_button_down() -> void:
	GameState.current_mode = GameState.GameMode.WIN
	$CanvasLayer/ColorRect.visible = true
	%Label.text = "DEFUSED"

func _on_losetest_button_down() -> void:
	GameState.current_mode = GameState.GameMode.LOSE
	$CanvasLayer/ColorRect.visible = true
	%Label.text = "EXPLODED"

func _on_win_home_button_down() -> void:
	GameState.game_controller.change_gui_scene("res://Scenes/GUI/menu_ui.tscn")
	GameState.game_controller.change_3d_scene("res://Scenes/back_ground.tscn")
	GameState.current_mode = GameState.GameMode.HOME
