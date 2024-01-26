extends Node
@onready var game_controller := $"../GameController"
@onready var game_ui := $"../UIController"


#Draw card from the deck
func draw_card(player):
	print("Player decided to draw from deck.")
	#Card is taken off the top of the deck and put to the current players hand
	var drawn_card = game_controller.deck.deal_card()
	game_controller.send_player_card(drawn_card, player)
	game_controller.current_round_controller.set_current_player_phase(playerPhase.player_phase.DISCARDING)
	#Set the UI to not show the actions.
	game_ui.ask_player_to_pick_card(false, true)


#Take the card from the discard pile
func take_card(player):
	var drawn_card = GlobalController.discard_pile.pop_back()	
	#Set the current discard card to null.
	game_controller.set_discard_card(null, false)
	game_controller.send_player_card(drawn_card, player)
	game_controller.pickup_card_timer.stop()
	game_ui.toggle_pickup_timer_label(false)
	game_controller.current_round_controller.set_current_player_phase(playerPhase.player_phase.DISCARDING)


#Discard the card from the player's hand that is selected.
func discard_card():
	#Lock the discard area.
	game_ui.toggle_lock_discard_area(true)
	#Get the card from the discardArea and set it to the current discard card.
	var new_discard_card = game_ui.get_discard_card()
	game_controller.players[game_controller.current_round_controller.current_player].hand.remove_card(new_discard_card)
	if new_discard_card:
		game_controller.set_discard_card(new_discard_card, false)
		game_ui.toggle_lock_discard_area(false)
		game_ui.toggle_discard_area(false)
		#Remove card from MouseHolder
		if game_controller.mouse_holder.get_child_count() > 0:
			game_controller.mouse_holder.remove_card()
			
	game_controller.current_round_controller.next_player()
