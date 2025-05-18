extends Control

var chat_expanded := false
var chat_messages: Array[String] = []
var original_panel_size: Vector2
var original_panel_pos: Vector2

func _ready():
	original_panel_size = $Panel.size
	original_panel_pos = $Panel.position

@rpc("any_peer", "call_local")
func receive_message(msg: String, sender_name: String):
	var full_message = sender_name + ": " + msg
	chat_messages.append(full_message)
	update_chat_log()

func update_chat_log():
	var expanded_height = original_panel_size.y * 4

	if chat_expanded:
		$Panel/ChatLog.text = "\n".join(chat_messages)

		# Resize panel
		$Panel.size = Vector2(original_panel_size.x, expanded_height)
		# Move panel upward
		$Panel.position = original_panel_pos - Vector2(0, expanded_height - original_panel_size.y)

		# Resize ChatLog inside the panel
		$Panel/ChatLog.size = Vector2(original_panel_size.x, expanded_height)
	else:
		$Panel/ChatLog.text = chat_messages[-1] if chat_messages.size() > 0 else ""

		# Restore panel
		$Panel.size = original_panel_size
		$Panel.position = original_panel_pos

		# Restore ChatLog size
		$Panel/ChatLog.size = original_panel_size



func send_message(player_name):
	var msg = $ChatInput.text
	if msg != "":
		rpc("receive_message", msg, player_name)
		$ChatInput.text = ""

func _on_send_button_button_down() -> void:
	var my_id = multiplayer.get_unique_id()
	if GameState.players.has(my_id):
		send_message(GameState.players[my_id].name)
	else:
		print("Couldn't find my own player data to send chat message.")

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		var mouse_pos = get_viewport().get_mouse_position()
		if $Panel/ChatLog.get_global_rect().has_point(mouse_pos):
			chat_expanded = true
		else:
			chat_expanded = false
		update_chat_log()
