extends Node2D
class_name GameController

#Controllers
@onready var game_ui := $"../UIController"
@onready var player_controller := $"../PlayerController"
@onready var card_action_controller := $"../CardActionController"
#Round Controller
@onready var roundControllerScene = preload("res://Scenes/GameController/round_controller.tscn")
var current_round_controller

@onready var players = get_tree().get_nodes_in_group("Player")
@onready var player_phases : Array[playerPhase] = [playerPhase.new(), playerPhase.new(), playerPhase.new(), playerPhase.new()]
@onready var deck = Deck.new()

@onready var deck_area = get_tree().get_first_node_in_group("Deck Area") as Node2D
@onready var discard_card = get_tree().get_first_node_in_group("Discard Card") as Sprite2D
@export var default_card : Texture2D
@onready var mouse_holder = get_tree().get_first_node_in_group("mouse_holder")

#Pickup Settings
@onready var pickup_card_timer = $PickUpTimer
@export var pickup_card_time: float = 20.0


#Debugging labels
@onready var gamePhaseLabel = $"../../GamePhase"
@onready var playerPhaseLabel = $"../../PlayerPhase"

#Define a signal for the game controller to emit to update the rule text.
signal update_rule_text(text :String)

#Define a signal for the game controller to emit to request pickup or pass to players._add_constant_central_force
signal request_pickup_or_pass(card : Card)

# Called when the node enters the scene tree for the first time.
func _ready():
	game_ui.start_game_signal.connect(start_game)
	game_ui.card_action_signal.connect(player_card_action)
	pickup_card_timer.timeout.connect(_pickup_card_timeout)
	

#Process every frame
func _process(delta):
	gamePhaseLabel.text = GlobalController.game_phase.get_phase_label()
	if current_round_controller != null:
		playerPhaseLabel.text = player_phases[current_round_controller.current_player].get_phase_label()
	#Check if the timer is running and update the label.
	player_action_timer()


#Start the game
func start_game():
	GlobalController.game_phase.next_phase()
	call_deferred("_initialize_new_round")
	connect_players()


#Add a new round to the game
func _initialize_new_round():
	if current_round_controller != null:
		current_round_controller.queue_free()
	current_round_controller = roundControllerScene.instantiate()
	GlobalController.round_index += 1
	current_round_controller.current_round = GlobalController.round_index
	get_parent().add_child(current_round_controller)
	current_round_controller.start_round()
	current_round_controller.set_current_player_phase(playerPhase.player_phase.CHOOSING)


#Initialize the pickup sequence. Request all players to pickup or pass.
func initalizePickupSequence():
	#Ask the players to pick a card. Start the timer for # of seconds.
	for index in range(players.size()):
		#If the current player is in the list then skip.
		if index == current_round_controller.current_player:
			continue
		#If the player in the list is the user then ask the user to pick a card.
		elif players[index].is_player:
			print("Ask Player if they want to pick up the card. Show UI.")
			game_ui.ask_player_to_pick_card(true, false)
		#If the player in the list not the user then ask the AI to pick a card.
		else:
			players[index].request_pickup(GlobalController.current_discard_card)
			var player_action = players[index].pass_action
			if player_action == CardActions.Action.REQUEST:
				set_pass_request(index, true, player_action)
			else:
				set_pass_request(index, false, player_action)

	#Start the timer.
	pickup_card_timer.start(pickup_card_time)
	#Get all AI players to decide if they want to pickup the card or not.
	return true


#Set the discard card based on pickup or put down
func set_discard_card(new_card : Card, first_card : bool):
	if new_card == null && !first_card:
		if GlobalController.discard_pile.size() <= 0:
			discard_card.texture = default_card
			GlobalController.current_discard_card = null
		else:
			discard_card.texture = load(GlobalController.discard_pile[GlobalController.discard_pile.size()-1].get_card_resource())
			GlobalController.current_discard_card = GlobalController.discard_pile[GlobalController.discard_pile.size()-1]
	else:
		#If first card then pick from deck and set the next phase
		if first_card:
			GlobalController.current_discard_card = deck.deal_card()
			new_card = GlobalController.current_discard_card
			GlobalController.game_phase.next_phase()

		GlobalController.discard_pile.append(new_card as Card)
		#Set the discard pile sprite to the last card in the GlobalController.discard_pile deck.
		discard_card.texture = load(new_card.get_card_resource())

#Send the player the current card.
func send_player_card(card :Card, player_index: int):
	#Send the card to the player.
	players[player_index].get_new_card(card)


#When the timer is up, decide the next move. 
func _pickup_card_timeout():
	#If all players pass than the current player can draw a card from the deck.
	#If a player requests to pickup the card, than decide who has first priority. Than the current player can draw a card from the deck.
	if !GlobalController.player_pickup_request.has(true):
		for index in players.size()-1:
			if GlobalController.player_pickup_request[index] == false: 
				game_ui.update_player_action(index, CardActions.get_action_string(CardActions.Action.PASS))
		
		card_action_controller.draw_card(current_round_controller.current_player)
		
	else:
		var priority_player = get_first_priority_player()
		print("Priority Player: " + str(players[priority_player].name))
		card_action_controller.take_card(priority_player)
		card_action_controller.draw_card(priority_player)


func get_first_priority_player() -> int:
	var current_index = current_round_controller.current_player + 1 if current_round_controller.current_player + 1 < players.size()-1 else 0
	for index in range(players.size()):
		print("Current Index: " + str(current_index))
		if GlobalController.player_pickup_request[current_index]:
			print("Player found. Index: " + str(current_index))
			return current_index
		current_index += 1
		if current_index >= players.size():
			current_index = 0
	return -1

func set_pass_request(player : int, request : bool, player_action : CardActions.Action):
	GlobalController.player_pickup_request[player] = request
	GlobalController.players_picked_up += 1
	game_ui.update_player_action(player, CardActions.get_action_string(player_action))


func player_action_timer():
	if pickup_card_timer.time_left <= 0.0:
		game_ui.toggle_pickup_timer_label(false)
			
	elif GlobalController.players_picked_up == players.size()-1:
		print("All players sent action")
		pickup_card_timer.stop()
		_pickup_card_timeout()
	else:
		game_ui.toggle_pickup_timer_label(true)
		game_ui.update_pickup_timer_label(pickup_card_timer.time_left)

#Connect all the players in the groups signals to the game controller.
func connect_players():
	for index in range(players.size()):
		var ai_agent = players[index].ai_agent
		ai_agent.card_action_signal.connect(ai_player_action)

#AI Card Action
func ai_player_action(action : CardActions.Action, player: int):
	print("Received signal response: from AI: " + str(player))
	await get_tree().create_timer(2).timeout
	player_action(action, player)

#Player Card Action
func player_card_action(action : CardActions.Action, player: int):
	print("Received signal response: from player: " + str(player))
	#Always wait 2 seconds before doing action.
	player_action(action, player)

func player_action(action : CardActions.Action, player: int):
	#If the current player decides to pickup the card than take the card from the discard pile.
	if player == current_round_controller.current_player:
		match action:
			CardActions.Action.TAKE:
				print("Player " + str(player+1) + " current turn. Requested to Pick up")
				card_action_controller.take_card(player)				
			CardActions.Action.DRAW:
				print("Player " + str(player+1) + " current turn. Requested to Draw")
				initalizePickupSequence()
			CardActions.Action.DISCARD:
				print("Player " + str(player+1) + " current turn. Requested to Discard")
				card_action_controller.discard_card()

			_:
				print("Invalid Selection made by player.")
	#If the current player is not the user than check if the player is an AI or a player.
	else:
		print("Player is NOT current player")
		match action:
			CardActions.Action.REQUEST:
				print("Player " + str(player+1) + " requested to pickup the card")
				set_pass_request(player, true, action)
			CardActions.Action.PASS:
				print("Player " + str(player+1) + " passed on the card")
				set_pass_request(player, false, action)
			_:
				print("Invalid Selection made by player.")

#DEBUGGING FUNCTIONS BELOW
#Print the current cards in the discard pile
func print_discard_pile():
	print("Discard Pile: " + str(GlobalController.discard_pile.size()) + " cards")
	for card in GlobalController.discard_pile:
		print(card)
