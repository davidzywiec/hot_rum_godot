extends Node

@onready var parent = get_parent()

#This script will be used to execute AI actions. If player is not the current player than the AI Agent will do the action._add_constant_central_force

#TODO: Add error chance to the AI actions

func request_pickup_card(is_turn: bool, card: Card) -> CardActions.Action:
	#TODO: Add logic to determine when to pickup card.
	print("AI: Requesting pickup card")
	return CardActions.Action.PASS

func discard_card() -> int:
	#Always dicard the first card in hand
	#TODO: Add logic to determine which card to discard
	return 0