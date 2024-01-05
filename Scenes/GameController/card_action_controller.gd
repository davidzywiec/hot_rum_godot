extends Node
@onready var game_controller := $"../GameController"
@onready var game_ui := $"../UIController"


#Draw card from the deck
func draw_card():
	print("Player decided to draw from deck.")
	#Card is taken off the top of the deck and put to the current players hand
	var drawn_card = game_controller.deck.deal_card()
	game_controller.send_player_card(drawn_card)
	game_controller.current_round_controller.set_current_player_phase(playerPhase.player_phase.DISCARDING)
	#Set the UI to not show the actions.
	game_ui.hide_buttons()


#Take the card from the discard pile
func take_card():
	var drawn_card = game_controller.discard_pile.pop_back()	
	#Set the current discard card to null.
	game_controller.set_discard_card(null, false)
	game_controller.send_player_card(drawn_card)
	game_controller.pickup_card_timer.stop()
	game_ui.toggle_pickup_timer_label(false)
	game_controller.current_round_controller.set_current_player_phase(playerPhase.player_phase.DISCARDING)


#Discard the card from the player's hand that is selected.
func discard_card():
	#Lock the discard area.
	game_ui.toggle_lock_discard_area(true)
	#Get the card from the discardArea and set it to the current discard card.
	var new_discard_card = game_ui.get_discard_card()
	if new_discard_card:
		game_controller.set_discard_card(new_discard_card, false)
		game_ui.toggle_lock_discard_area(false)
		game_ui.toggle_discard_area(false)
	game_controller.current_round_controller.next_player()
