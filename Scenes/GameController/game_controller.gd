extends Node2D

@onready var game_phase = GamePhase.new()
@onready var players = get_tree().get_nodes_in_group("Player")
@onready var deck = Deck.new()
@onready var rules_mgr = Rules_Manager.new()
@onready var game_ui := $"../UIController"

var current_player :int = 0
var player_count = 0
var round_index = 0
var round_card_number = [7,8,9,10,11,11,12,13]

#Define a signal for the game controller to emit to update the rule text.
signal update_rule_text(text :String)

# Called when the node enters the scene tree for the first time.
func _ready():
	game_ui.start_game_signal.connect(start_game)

func start_game():
	#Display the rules to the user for the round.
	if game_ui.has_method("on_update_label_text"):
		game_ui.on_update_label_text(rules_mgr.get_current_rule())
	start_round()
	

#when the game starts, deal out a hand to each player.
func start_round():
	#Deal the cards
	deal_cards_to_players()


func deal_cards_to_players():
	for player in players:
		player.hand = deck.deal_hand(round_card_number[round_index])
		player_count += 1
		if player.is_player:
			player.add_to_ui()
