extends Node2D

@onready var game_phase = GamePhase.new()
@onready var players = get_tree().get_nodes_in_group("Player")
@onready var deck = Deck.new()
@onready var rules_mgr = Rules_Manager.new()
@onready var game_ui := $"../UIController"
@onready var deck_area = get_tree().get_first_node_in_group("Deck Area") as Node2D
@onready var discard_card = get_tree().get_first_node_in_group("Discard Card") as Sprite2D
@export var default_card : Texture2D 

var discard_pile : Array = []
var current_discard_card : Card

var current_player :int = 0
var player_count = 0
var round_index = 0
var round_card_number = [7,8,9,10,11,11,12,13]

#Define a signal for the game controller to emit to update the rule text.
signal update_rule_text(text :String)

# Called when the node enters the scene tree for the first time.
func _ready():
	game_ui.start_game_signal.connect(start_game)
	game_ui.pick_card_signal.connect(pick_card)
	game_ui.pass_card_signal.connect(pass_card)
	game_ui.take_card_signal.connect(take_card)

func start_game():
	#Display the rules to the user for the round.
	if game_ui.has_method("on_update_label_text"):
		game_ui.on_update_label_text(rules_mgr.get_current_rule())
	start_round()
	

#when the game starts, deal out a hand to each player.
func start_round():
	#Deal the cards
	deal_cards_to_players()
	current_discard_card = deck.deal_card()
	set_discard_card(current_discard_card)


func deal_cards_to_players():
	for player in players:
		player.hand = deck.deal_hand(round_card_number[round_index])
		player_count += 1
		if player.is_player:
			player.add_card_to_game(true)


func set_discard_card(new_card : Card):
	if new_card == null:
		if discard_pile.size() <= 0:
			discard_card.texture = default_card
			current_discard_card = null
		else:
			discard_card.texture = load(discard_pile[discard_pile.size()-1].get_card_resource())
			current_discard_card = discard_pile[discard_pile.size()-1]

	else:
		discard_pile.append(new_card as Card)
		#Set the discard pile sprite to the last card in the discard_pile deck.
		discard_card.texture = load(new_card.get_card_resource())


func pick_card():
	#Card is taken off the top of the deck and put to the current players hand
	var drawn_card = deck.deal_card()
	send_player_card(drawn_card)		


func pass_card():
	print("Pass Card")
	#next_player()
	var material = discard_card.material as ShaderMaterial
	material.set_shader_parameter("apply_outline", true)
	print(material.get_shader_parameter("apply_outline"))
		

func take_card():
	var drawn_card = discard_pile.pop_back()	
	#Set the current discard card to null.
	set_discard_card(null)
	send_player_card(drawn_card)


#Send the player the current card.
func send_player_card(card :Card):
	pass
	#Send the card to the player.
	players[current_player].get_new_card(card)


func next_player():
	#Increment the current player.
	current_player += 1
	#If the current player is greater than the player count, reset the current player to 0.
	if current_player >= player_count:
		current_player = 0
	#If current player is not the user than hide buttons.
	if !players[current_player].is_player:
		game_ui.hide_buttons()
	else:
		game_ui.show_buttons()


#Print the current cards in the discard pile
func print_discard_pile():
	print("Discard Pile: " + str(discard_pile.size()) + " cards")
	for card in discard_pile:
		print(card)
		

