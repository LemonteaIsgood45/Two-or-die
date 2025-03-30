extends Node3D

@onready var block1Scene = load("res://Scenes/Suitcase_block.tscn")
@onready var block2Scene = load("res://Scenes/Suitcase_block.tscn")
@onready var block3Scene = load("res://Scenes/Suitcase_block.tscn")
@onready var block4Scene = load("res://Scenes/Suitcase_block.tscn")
@onready var block5Scene = load("res://Scenes/Suitcase_block.tscn")
@onready var block6Scene = load("res://Scenes/Suitcase_block.tscn")

var block1Pos = Vector3(0.25, 0, 0.12)
var block2Pos = Vector3(0, 0, 0.12)
var block3Pos = Vector3(-0.25, 0, 0.12)
var block4Pos = Vector3(0.25, 0, -0.12)
var block5Pos = Vector3(0, 0, -0.12)
var block6Pos = Vector3(-0.25, 0, -0.12)

func  _ready() -> void:
	var block1 = block1Scene.instantiate()
	add_child(block1)
	var block2 = block2Scene.instantiate()
	add_child(block2)
	var block3 = block2Scene.instantiate()
	add_child(block3)
	var block4 = block1Scene.instantiate()
	add_child(block4)
	var block5 = block1Scene.instantiate()
	add_child(block5)
	var block6 = block1Scene.instantiate()
	add_child(block6)
	block1.position = block1Pos
	block2.position = block2Pos
	block3.position = block3Pos
	block4.position = block4Pos
	block5.position = block5Pos
	block6.position = block6Pos
