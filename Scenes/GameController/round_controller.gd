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
	game_ui.set_current_player(current_player)	
	
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

#Set the current player phase
func set_current_player_phase(phase : playerPhase.player_phase):
	if phase == playerPhase.player_phase.DISCARDING  && game_controller.players[current_player].is_player:
		print("Player is discarding.")
		game_ui.toggle_discard_area(true)
	elif phase == playerPhase.player_phase.DISCARDING:
		print("AI is discarding.")
		var ai_agent = game_controller.players[current_player].ai_agent
		if ai_agent.has_method("set_discard_card"):
			game_ui.discard_area.current_card = ai_agent.set_discard_card()			
		if ai_agent.has_method("emit_card_action"):
			ai_agent.emit_card_action(playerPhase.player_phase.DISCARDING)	
	
	game_controller.player_phases[current_player].set_phase(phase)
	#Call UI player to pick up card.
	game_ui.ask_player_to_pick_card(game_controller.players[current_player].is_player)

func next_player():
	#Increment the current player.
	current_player += 1
	#If the current player is greater than the player count, reset the current player to 0.
	if current_player >= player_count:
		current_player = 0
	#If current player is not the user than hide buttons.
	if !game_controller.players[current_player].is_player:
		game_ui.hide_buttons()
	else:
		game_ui.show_buttons()
	#Set the current player phase to the next phase.
	set_current_player_phase(playerPhase.player_phase.CHOOSING)
	game_ui.set_current_player(current_player)
	#If current player is not the user than use the AI to pick a card from the deck.
	if !game_controller.players[current_player].is_player:
		print("AI is picking a card")
		var ai_agent = game_controller.players[current_player].ai_agent
		if ai_agent.has_method("emit_card_action"):
			ai_agent.emit_card_action(playerPhase.player_phase.CHOOSING)





	