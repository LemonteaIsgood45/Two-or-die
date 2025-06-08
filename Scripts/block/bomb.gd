extends Node3D

const ROTATION_STEP := 5.0
const ROTATION_SPEED := 80.0

@onready var timerBlock = load("res://Scenes/timer_block.tscn")
@onready var wiresBlock = load("res://Scenes/wires_block.tscn")
@onready var buttonBlock = load("res://Scenes/button_block_1.tscn")
@onready var symbolBlock = load("res://Scenes/symbols_block.tscn")
@onready var textBlock = load("res://Scenes/text_block.tscn")
@onready var charBlock = load("res://Scenes/text_4_char_block.tscn")

var block1Pos = Vector3(0.15, 0, 0.07)
var block2Pos = Vector3(0, 0, 0.07)
var block3Pos = Vector3(-0.15, 0, 0.07)
var block4Pos = Vector3(0.15, 0, -0.07)
var block5Pos = Vector3(0, 0, -0.07)
var block6Pos = Vector3(-0.15, 0, -0.07)

var serial_number 
var battery_count 
@onready var timer
var has_car_indicator: bool = false
var has_frk_indicator: bool = false

func _ready() -> void:
	if GameState.role == "Instructor":
		$Up.visible = false
		$Down.visible = false
		$Right.visible = false
		$Left.visible = false
		$ResetRotation.visible = false
	
	# Enable mouse input processing
	set_process_input(true)
	
	serial_number = generate_random_serial_number()
	generate_random_battery()
	
	if randf() > 0.5:
		has_car_indicator = true
		has_frk_indicator = false
	else:
		has_car_indicator = false
		has_frk_indicator = true
	
	var block1 = timerBlock.instantiate()
	add_child(block1)
	var block2 = wiresBlock.instantiate()
	add_child(block2)
	var block3 = buttonBlock.instantiate()
	add_child(block3)
	var block4 = symbolBlock.instantiate()
	add_child(block4)
	var block5 = textBlock.instantiate()
	add_child(block5)
	var block6 = charBlock.instantiate()
	add_child(block6)
	block1.position = block1Pos
	block2.position = block2Pos
	block3.position = block3Pos
	block4.position = block4Pos
	block5.position = block5Pos
	block6.position = block6Pos
	
	$CSGBox3D/BombLabel.text = serial_number

func _process(delta: float) -> void:
	if Input.is_action_pressed("rotate_up"):
		rotation_degrees.x = clamp(rotation_degrees.x - ROTATION_SPEED * delta, -80, 80)
	if Input.is_action_pressed("rotate_down"):
		rotation_degrees.x = clamp(rotation_degrees.x + ROTATION_SPEED * delta, -80, 80)
	if Input.is_action_pressed("rotate_left"):
		rotation_degrees.z += ROTATION_SPEED * delta
	if Input.is_action_pressed("rotate_right"):
		rotation_degrees.z -= ROTATION_SPEED * delta

	if GameState.current_mode == GameState.GameMode.PLAYING:
		var incorrect_finished_blocks := 0
		var total_finished := 0

		for block in get_tree().get_nodes_in_group("puzzle_block"):
			if "finish" in block and "correct" in block:
				if block.finish:
					total_finished += 1
					if not block.correct:
						incorrect_finished_blocks += 1


		if incorrect_finished_blocks >= 1:
			GameState.current_mode = GameState.GameMode.LOSE
		elif total_finished == 5:
			GameState.current_mode = GameState.GameMode.WIN


func generate_random_serial_number() -> String:
	var letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ123456789"
	var serial_number = ""
	
	for i in range(6):
		serial_number += letters[randi() % letters.length()]
	
	serial_number += str(randi() % 10)  # Adds a single digit (0-9) at the end
	
	return serial_number

func generate_random_battery():
	var battery_count = randi() % 6  # 0 to 5 inclusive
	print("BATTERIES: " + str(battery_count))

	var max_per_placeholder = 2
	var placeholders = 3
	
	var values = split_with_max_limit(battery_count, placeholders, max_per_placeholder)
	
	# Assign to placeholders
	$Placeholder_1/Node3D.number_of_batteries = values[0]
	$Placeholder_2/Node3D.number_of_batteries = values[1]
	$Placeholder_3/Node3D.number_of_batteries = values[2]
	
	print("Assigned: ", values)

func split_with_max_limit(total: int, slots: int, max_per_slot: int) -> Array:
	var result = []
	
	# Create a list of slots and initialize with 0
	for i in range(slots):
		result.append(0)

	# Assign batteries one at a time to random valid slots
	for i in range(total):
		var attempts = 0
		while true:
			var index = randi() % slots
			if result[index] < max_per_slot:
				result[index] += 1
				break
			attempts += 1
			if attempts > 10:
				break  # just in case (shouldn't happen)
	
	return result


func reset_rotation():
	rotation_degrees = Vector3.ZERO


func _on_up_button_down() -> void:
	Input.action_press("rotate_up")


func _on_up_button_up() -> void:
	Input.action_release("rotate_up")


func _on_down_button_down() -> void:
	Input.action_press("rotate_down")


func _on_down_button_up() -> void:
	Input.action_release("rotate_down")


func _on_right_button_down() -> void:
	Input.action_press("rotate_left")


func _on_right_button_up() -> void:
	Input.action_release("rotate_left")


func _on_left_button_down() -> void:
	Input.action_press("rotate_right")


func _on_left_button_up() -> void:
	Input.action_release("rotate_right")


func _on_reset_rotation_pressed() -> void:
	self.reset_rotation()
