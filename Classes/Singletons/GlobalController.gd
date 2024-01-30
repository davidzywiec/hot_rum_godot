extends Node

signal start_game_signal

#Phase of the game
@onready var game_phase = GamePhase.new()

#Game Variables
var round_index = -1
var round_card_number = [7,8,9,10,11,11,12,13]
var new_scene : PackedScene = load("res://Scenes/CardZone/card_zone.tscn")

#Discard Data
var discard_pile : Array = []
var current_discard_card : Card

#Player Pickup Requests
var player_pickup_request : Array[bool] = [false, false, false, false]
var players_picked_up = 0

#Meld Types
enum MELD_TYPE { SET, RUN, RUN_OF_7 }
var meld_type_string : Array = ["Set", "Run", "Run of 7"]

#Send the signal to the GameController and to the UIController to start the game
func start_game():
	emit_signal("start_game_signal")


#Clear the requests in the player pickup array.
func clear_requests():
	player_pickup_request = [false, false, false, false]
	
func get_meld_string(meld : MELD_TYPE) -> String:
	return meld_type_string[meld]
