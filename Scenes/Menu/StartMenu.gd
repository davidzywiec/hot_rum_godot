extends Node2D

@onready var startBtn : Button = $Menu/Panel/ButtonContainer/StartBtn

func _ready():
	startBtn.pressed.connect(_on_StartBtn_pressed)

func _on_StartBtn_pressed():
	#Load the Main Game Scene
	get_tree().change_scene_to_file("res://Scenes/main.tscn")
