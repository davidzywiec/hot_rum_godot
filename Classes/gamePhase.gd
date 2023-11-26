class_name GamePhase
 # @brief The GamePhase class is an abstract class that represents a phase of the game.


enum game_phase
{	NewGame,
	NewRound,
	Playing,
	Tallying,
	Pause,
	GameOver
};
var game_phase_labels = ["New Round", "Playing Round", "Tallying Score", "Paused Game", "Game Over"]
var round_number = -1
var current_phase : game_phase = game_phase.NewGame 
#Get the current phase of the game
func get_phase():
	return current_phase

#Get the label of the current phase of the game
func get_phase_label():
	return game_phase_labels[current_phase]

#Override the phase of the game
func set_phase(new_phase : game_phase):
	current_phase = new_phase
	if new_phase == game_phase.NewRound:
		round_number+=1

#Go to the next phase of the game
func next_phase():
	match current_phase:
		game_phase.NewGame:
			set_phase(game_phase.NewRound)
		game_phase.NewRound:
			set_phase(game_phase.Playing)
		game_phase.Playing:
			set_phase(game_phase.Tallying)
		game_phase.Tallying:
			if round_number == 7:
				set_phase(game_phase.GameOver)
			else:
				set_phase(game_phase.NewRound)
		_:
			print("Error: Invalid game phase")
			set_phase(game_phase.Pause)
