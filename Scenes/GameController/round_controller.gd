extends Node2D

#Set Controllers
@onready var game_controller = $"../GameController"
@onready var game_ui := $"../UIController"

#Set Rule Manager
@onready var rules_mgr = Rules_Manager.new()

var current_player :int = 0
var player_count = 0
var current_round = 0
var round_card_number = [7,8,9,10,11,11,12,13]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


#Start the round by dealing the cards to the players
func start_round():
	#Deal the cards
	deal_cards_to_players()
	game_controller.set_discard_card(null,true)
	set_rules_text()
	

#Deal cards to the players
func deal_cards_to_players():
	for player in game_controller.players:
		player.hand = game_controller.deck.deal_hand(round_card_number[current_round])
		player_count += 1
		if player.is_player:
			player.add_card_to_game(true)


#Set the round rules in the text
func set_rules_text():
	if game_ui.has_method("on_update_label_text"):
		game_ui.on_update_label_text(rules_mgr.get_current_rule(current_round))

