extends Node2D

@onready var startBtn : Button = $Menu/Panel/ButtonContainer/StartBtn
@onready var settingsBtn : Button = $Menu/Panel/ButtonContainer/SettingsBtn
@onready var exitBtn : Button = $Menu/Panel/ButtonContainer/ExitBtn
@onready var mainScene : PackedScene = preload("res://Scenes/main.tscn")
@onready var sceneManager = get_parent()

func _ready():
	startBtn.pressed.connect(_on_StartBtn_pressed)
	settingsBtn.pressed.connect(_on_SettingsBtn_pressed)
	exitBtn.pressed.connect(_on_ExitBtn_pressed)
	if sceneManager.has_method("set_current_level"):
		sceneManager.set_current_level(self)

func _on_StartBtn_pressed():
	#Load the Main Game Scene
	var new_scene = mainScene.instantiate()
	if sceneManager.has_method("move_to_next_level"):
		sceneManager.move_to_next_level(new_scene, true)

func _on_SettingsBtn_pressed():
	#Load the Settings Scene
	#get_tree().change_scene_to_file("res://Scenes/settings.tscn")
	pass

func _on_ExitBtn_pressed():
	#Quit the Game
	get_tree().quit()
