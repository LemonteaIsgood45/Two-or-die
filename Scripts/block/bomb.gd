extends Node3D

var is_dragging := false
var last_mouse_position := Vector2()
var rotation_speed := 0.005  # Adjust this value to control rotation sensitivity

@onready var block1Scene = load("res://Scenes/Suitcase_block.tscn")
@onready var block2Scene = load("res://Scenes/Suitcase_block.tscn")
@onready var block3Scene = load("res://Scenes/Suitcase_block.tscn")
@onready var block4Scene = load("res://Scenes/Suitcase_block.tscn")
@onready var block5Scene = load("res://Scenes/Suitcase_block.tscn")
@onready var block6Scene = load("res://Scenes/Suitcase_block.tscn")
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
var timer
var has_car_indicator: bool = false
var has_frk_indicator: bool = false

func _ready() -> void:
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

func generate_random_serial_number() -> String:
	var letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ123456789"
	var serial_number = ""
	
	for i in range(6):
		serial_number += letters[randi() % letters.length()]
	
	serial_number += str(randi() % 10)  # Adds a single digit (0-9) at the end
	
	return serial_number

func generate_random_battery():
	battery_count = randi() % 5

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				# Start dragging
				is_dragging = true
				last_mouse_position = event.position
			else:
				# Stop dragging
				is_dragging = false
	
	elif event is InputEventMouseMotion and is_dragging:
		# Calculate mouse movement delta
		var delta = event.position - last_mouse_position
		last_mouse_position = event.position
		
		# Rotate the object based on mouse movement
		rotate_z(delta.x * rotation_speed)  # Horizontal movement rotates around Y axis
		rotate_x(-delta.y * rotation_speed)  # Vertical movement rotates around X axis
		
		# Optional: Clamp rotation on X axis to prevent flipping over
		var current_rotation = rotation_degrees
		current_rotation.x = clamp(current_rotation.x, -80, 80)
		rotation_degrees = current_rotation

func reset_rotation():
	rotation_degrees = Vector3.ZERO
