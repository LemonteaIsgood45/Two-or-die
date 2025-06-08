extends Control

func _process(delta: float) -> void:
	pass

func _on_online_game_button_pressed() -> void:
	pass # Replace with function body.

#LAN
func _on_lan_game_button_pressed() -> void:
	GameState.game_controller.change_gui_scene("res://Scenes/GUI/lan.tscn")
	pass

#SETTING
func _on_setting_button_pressed() -> void:
	GameState.game_controller.change_gui_scene("res://Scenes/GUI/setting.tscn")
	pass

func _on_account_button_pressed() -> void:
	pass # Replace with function body.

func _on_exit_button_pressed() -> void:
	get_tree().quit()
	pass
