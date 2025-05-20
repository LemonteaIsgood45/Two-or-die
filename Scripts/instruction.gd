extends Control

@onready var image_display: TextureRect = $ScrollContainer/image_display
@onready var back_button: Button = $back_button
@onready var next_button: Button = $next_button

var image_paths: Array = []
var current_index: int = 0
var image_folder_path: String = "res://Assets/Textures/Instruction/"  # Change if needed

func _ready():
	# Load image paths
	var dir := DirAccess.open(image_folder_path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir() and file_name.get_extension().to_lower() in ["png", "jpg", "jpeg", "webp"]:
				image_paths.append(image_folder_path + file_name)
			file_name = dir.get_next()
		dir.list_dir_end()

		image_paths.sort()
		if image_paths.size() > 0:
			load_image(current_index)
	
	back_button.pressed.connect(_on_left_pressed)
	next_button.pressed.connect(_on_right_pressed)

func load_image(index: int):
	var img_path = image_paths[index]
	var tex = load(img_path)
	if tex:
		image_display.texture = tex
		image_display.custom_minimum_size = tex.get_size()  # Important for ScrollContainer


func _on_left_pressed() -> void:
	if image_paths.is_empty():
		return
	current_index = (current_index - 1 + image_paths.size()) % image_paths.size()
	load_image(current_index)


func _on_right_pressed() -> void:
	if image_paths.is_empty():
		return
	current_index = (current_index + 1) % image_paths.size()
	load_image(current_index)
