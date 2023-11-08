class_name GamePhase
 # @brief The GamePhase class is an abstract class that represents a phase of the game.

# There are 4 phases in the game to the player.
# 1. Player is waiting for their turn
# 2. Player is choosing to pick up a card from the deck or pick up the top card from the discard pile
# 3.	
#	A. Player is choosing to place cards down on the table
# 	B. Player is choosing to discard a card from their hand 
# 4. Player has no cards left. Game Over OR player has ended their turn by discarding.

enum game_phase
{	Next,
	Waiting,
	Choosing,
	Placing,
	Discarding
};
var game_phase_labels = ["Next", "Waiting", "Choosing", "Placing", "Discarding"]

var current_phase : game_phase = game_phase.Waiting 
#Get the current phase of the game
func get_phase():
	return current_phase

#Get the label of the current phase of the game
func get_phase_label():
	return game_phase_labels[current_phase]

#Override the phase of the game
func set_phase(new_phase : game_phase):
	current_phase = new_phase

#Go to the next phase of the game
func next_phase():
	match current_phase:
		game_phase.Waiting:
			current_phase = game_phase.Choosing
		game_phase.Choosing:
			current_phase = game_phase.Placing
		game_phase.Placing:
			current_phase = game_phase.Discarding
		game_phase.Discarding:
			current_phase = game_phase.Waiting
		_:
			print("Error: Invalid game phase")
			current_phase = game_phase.Waiting
