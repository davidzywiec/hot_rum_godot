extends Node2D

@onready var game_phase = GamePhase.new()
@onready var players = get_tree().get_nodes_in_group("Player")
@onready var deck = Deck.new()
@onready var game_ui := $"../UIController"
@onready var deck_area = get_tree().get_first_node_in_group("Deck Area") as Node2D
@onready var discard_card = get_tree().get_first_node_in_group("Discard Card") as Sprite2D
@export var default_card : Texture2D

#Round Controller
@onready var roundControllerScene = preload("res://Scenes/GameController/round_controller.tscn")
var current_round_controller

#Debugging labels
@onready var gamePhaseLabel = $"../../GamePhase"
@onready var playerPhaseLabel = $"../../PlayerPhase"

var discard_pile : Array = []
var current_discard_card : Card

var current_player :int = 0
var player_count = 0
var round_index = -1
var round_card_number = [7,8,9,10,11,11,12,13]

#Define a signal for the game controller to emit to update the rule text.
signal update_rule_text(text :String)

# Called when the node enters the scene tree for the first time.
func _ready():
	game_ui.start_game_signal.connect(start_game)
	game_ui.pick_card_signal.connect(pick_card)
	game_ui.pass_card_signal.connect(pass_card)
	game_ui.take_card_signal.connect(take_card)
	game_ui.discard_card_signal.connect(try_discard)

	
func _process(delta):
	gamePhaseLabel.text = game_phase.get_phase_label()


#Start the game
func start_game():
	game_phase.next_phase()
	call_deferred("_initialize_new_round")


#Add a new round to the game
func _initialize_new_round():
	if current_round_controller != null:
		current_round_controller.queue_free()
	current_round_controller = roundControllerScene.instantiate()
	current_round_controller.current_round = round_index + 1
	get_parent().add_child(current_round_controller)
	current_round_controller.start_round()


#Set the discard card based on pickup or put down
func set_discard_card(new_card : Card, first_card : bool):

	if new_card == null && !first_card:
		if discard_pile.size() <= 0:
			discard_card.texture = default_card
			current_discard_card = null
		else:
			discard_card.texture = load(discard_pile[discard_pile.size()-1].get_card_resource())
			current_discard_card = discard_pile[discard_pile.size()-1]
	else:
		#If first card then pick from deck and set the next phase
		if first_card:
			current_discard_card = deck.deal_card()
			new_card = current_discard_card
			game_phase.next_phase()

		discard_pile.append(new_card as Card)
		#Set the discard pile sprite to the last card in the discard_pile deck.
		discard_card.texture = load(new_card.get_card_resource())

func pick_card():
	#Card is taken off the top of the deck and put to the current players hand
	var drawn_card = deck.deal_card()
	send_player_card(drawn_card)


func pass_card():
	#next_player()
	var material = discard_card.material as ShaderMaterial
	material.set_shader_parameter("apply_outline", true)
		

func take_card():
	var drawn_card = discard_pile.pop_back()	
	#Set the current discard card to null.
	set_discard_card(null, false)
	send_player_card(drawn_card)

func try_discard():
	print("Discard card")

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
	


