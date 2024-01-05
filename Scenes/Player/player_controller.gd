extends Node2D

#Player controller should do the actions for the current player at the computer.

#What player does the computer control?
@export var player_index = 0
@onready var players = get_tree().get_nodes_in_group("Player")


#Controllers
var roundControllerScene
@onready var game_controller = $"../GameController"
@onready var game_ui := $"../UIController"

func _ready():
	game_ui.player_index = player_index
	call_deferred("set_player_names")
	
#Set player names
func set_player_names():
	for index in range(players.size()):
		if players[index].is_player:
			players[index].name = " [ME] " + players[index].name 
		else:
			players[index].name = " [BOT] " + players[index].name 
			
		game_ui.set_player_names(index, players[index].name)
	