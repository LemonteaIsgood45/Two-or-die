extends Control


#func _process(delta: float) -> void:
	#if GameState.current_mode == GameState.GameMode.PLAYING:
		#self.hide()
	#else:
		#self.show()

func _on_online_game_button_pressed() -> void:
	pass # Replace with function body.

#LAN
func _on_lan_game_button_pressed() -> void:
	$LAN2.show()

func _on_lan_back_button_button_down() -> void:
	$LAN2.hide()

#SETTING
func _on_setting_button_pressed() -> void:
	$Setting.show()

func _on_setting_back_button_pressed() -> void:
	$Setting.hide()

func _on_account_button_pressed() -> void:
	pass # Replace with function body.

func _on_exit_button_pressed() -> void:
	get_tree().quit()
