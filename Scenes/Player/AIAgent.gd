extends Node

@onready var parent = get_parent()

#This script will be used to execute AI actions. If player is not the current player than the AI Agent will do the action._add_constant_central_force

#TODO: Add error chance to the AI actions

signal card_action_signal(action : CardActions.Action, player_index : int)

func request_pickup_card(is_turn: bool, card: Card) -> CardActions.Action:
	#TODO: Add logic to determine when to pickup card.
	return CardActions.Action.PASS

func set_discard_card() -> Card:
	#TODO: Implement logic
	return parent.hand.card_array[0]


func emit_card_action(player_phase : playerPhase.player_phase):
	print("Player " + str(parent.player_index) + "Emitting signal...")
	if player_phase != playerPhase.player_phase.DISCARDING:
		emit_signal("card_action_signal", CardActions.Action.DRAW, parent.player_index)
	else:
		emit_signal("card_action_signal", CardActions.Action.DISCARD, parent.player_index)
