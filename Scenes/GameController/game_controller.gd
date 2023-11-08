extends Node2D

@onready var game_phase = GamePhase.new()
@onready var players = get_tree().get_nodes_in_group("Player")
@onready var deck = Deck.new()
var current_player :int = 0
var player_count = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

#when the game starts, deal out a hand to each player.
func start_game():
	for player in players:
		player.hand = deck.deal_hand()
		player_count += 1