extends Node2D
class_name GameController

@onready var game_phase = GamePhase.new()
@onready var players = get_tree().get_nodes_in_group("Player")
@onready var deck = Deck.new()
@onready var game_ui := $"../UIController"
@onready var deck_area = get_tree().get_first_node_in_group("Deck Area") as Node2D
@onready var discard_card = get_tree().get_first_node_in_group("Discard Card") as Sprite2D
@export var default_card : Texture2D

#Pickup Settings
@onready var pickup_card_timer = $PickUpTimer
@export var pickup_card_time: float = 20.0
var player_pickup_request : Array = [false, false, false, false]
var players_picked_up = 0

#Round Controller
@onready var roundControllerScene = preload("res://Scenes/GameController/round_controller.tscn")
var current_round_controller

#Debugging labels
@onready var gamePhaseLabel = $"../../GamePhase"
@onready var playerPhaseLabel = $"../../PlayerPhase"

#Discard pile variables
var discard_pile : Array = []
var current_discard_card : Card

#Player variables
var current_player : int = 1
var player_count = 0
var round_index = -1
var round_card_number = [7,8,9,10,11,11,12,13]


#Define a signal for the game controller to emit to update the rule text.
signal update_rule_text(text :String)

#Define a signal for the game controller to emit to request pickup or pass to players._add_constant_central_force
signal request_pickup_or_pass(card : Card)

# Called when the node enters the scene tree for the first time.
func _ready():
	game_ui.start_game_signal.connect(start_game)
	game_ui.card_action_signal.connect(player_card_action)
	pickup_card_timer.timeout.connect(_pickup_card_timeout)
	game_ui.player_index = current_player
	call_deferred("set_player_names")



#Process every frame
func _process(delta):
	gamePhaseLabel.text = game_phase.get_phase_label()
	if pickup_card_timer.time_left <= 0.0:
		game_ui.toggle_pickup_timer_label(false)
	elif players_picked_up == players.size():
		print("All players sent action")
		pickup_card_timer.stop()
	else:
		game_ui.toggle_pickup_timer_label(true)
		game_ui.update_pickup_timer_label(pickup_card_timer.time_left)


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
	#Call UI player to pick up card.
	game_ui.ask_player_to_pick_card(players[current_round_controller.current_player].is_player)
	initalizePickupSequence()


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

#Player Card Action
func player_card_action(action : CardActions.Action, player: int):
	#If the current player decides to pickup the card than take the card from the discard pile.
	if player == current_round_controller.current_player:
		print("Player is current player")
		match action:
			CardActions.Action.TAKE:
				var drawn_card = discard_pile.pop_back()	
				#Set the current discard card to null.
				set_discard_card(null, false)
				send_player_card(drawn_card)
			CardActions.Action.DRAW:
				initalizePickupSequence()
			_:
				print("Invalid Selection made by player.")
	#If the current player is not the user than check if the player is an AI or a player.
	else:
		print("Player is NOT current player")
		match action:
			CardActions.Action.REQUEST:
				print("Player " + str(player+1) + " requested to pickup the card")
				player_pickup_request[player] = true
				players_picked_up += 1
			CardActions.Action.PASS:
				print("Player " + str(player+1) + " passed on the card")
				player_pickup_request[player] = false
				players_picked_up += 1
			_:
				print("Invalid Selection made by player.")
	
	#Update the game ui with the players action.
	game_ui.update_player_action(player, CardActions.get_action_string(action))



#Initialize the pickup sequence. Request all players to pickup or pass.
func initalizePickupSequence():
	#Ask the players to pick a card. Start the timer for # of seconds.
	for index in range(players.size()):
		#If the current player is in the list then skip.
		if index == current_player:
			continue
		#If the player in the list is the user then ask the user to pick a card.
		elif players[index].is_player:
			player_pickup_request[index] = game_ui.ask_player_to_pick_card(false)
		#If the player in the list not the user then ask the AI to pick a card.
		else:
			players[index].request_pickup(current_discard_card)
			var player_action = players[index].pass_action
			player_pickup_request[index] = player_action
			game_ui.update_player_action(index, CardActions.get_action_string(player_action))
			players_picked_up += 1

	#Start the timer.
	pickup_card_timer.start(pickup_card_time)
	#Get all AI players to decide if they want to pickup the card or not.
	return true



#Draw card from the deck
func draw_card():
	print("Player decided to draw from deck.")
	#Card is taken off the top of the deck and put to the current players hand
	var drawn_card = deck.deal_card()
	send_player_card(drawn_card)
		
	
#Pass on the card
func pass_card():
	#next_player()
	var material = discard_card.material as ShaderMaterial
	material.set_shader_parameter("apply_outline", true)


#Take the card from the discard pile
func take_card():
	var drawn_card = discard_pile.pop_back()	
	#Set the current discard card to null.
	set_discard_card(null, false)
	send_player_card(drawn_card)


#Discard the card from the player's hand that is selected.
func try_discard():
	print("Discard card")


#Send the player the current card.
func send_player_card(card :Card):
	pass
	#Send the card to the player.
	players[current_player].get_new_card(card)


#Get the next player in the list.
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
	

#When the timer is up, decide the next move. 
func _pickup_card_timeout():
	#If all players pass than the current player can draw a card from the deck.
	#If a player requests to pickup the card, than decide who has first priority. Than the current player can draw a card from the deck.
	print("Time is up!")

#Set player names
func set_player_names():
	for index in range(players.size()):
		if players[index].is_player:
			players[index].name = " [ME] " + players[index].name 
		else:
			players[index].name = " [BOT] " + players[index].name 
		game_ui.set_player_names(index, players[index].name)
