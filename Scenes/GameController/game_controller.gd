extends Node2D

@onready var game_phase = GamePhase.new()
@onready var players = get_tree().get_nodes_in_group("Player")
@onready var deck = Deck.new()
@onready var rules_mgr = Rules_Manager.new()
var current_player :int = 0
var player_count = 0
var round_index = 0
var round_card_number = [7,8,9,10,11,11,12,13]

# Called when the node enters the scene tree for the first time.
func _ready():
	start_game()

#when the game starts, deal out a hand to each player.
func start_round():
	for player in players:
		player.hand = deck.deal_hand(round_card_number[round_index])
		player_count += 1
		player.print_hand()

func start_game():
	#Display the rules to the user for the round.
	rules_mgr.get_current_rule()
	#Deal the cards
