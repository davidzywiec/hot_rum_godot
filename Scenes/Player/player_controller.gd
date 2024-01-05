extends Node2D

#Player controller should do the actions for the current player at the computer.

#What player does the computer control?
@export var player_index = 0


#Controllers
var roundControllerScene
@onready var game_controller = $"../GameController"
@onready var game_ui := $"../UIController"

func _ready():
	game_ui.player_index = player_index
	