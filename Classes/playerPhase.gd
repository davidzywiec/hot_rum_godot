class_name playerPhase

enum player_phase
{	Waiting,
	Choosing,
	Placing,
	Discarding
};
var player_phase_labels = ["Waiting", "Choosing", "Placing", "Discarding"]
var current_phase : player_phase = player_phase.Waiting 

func get_phase():
	return current_phase

#Get the label of the current phase of the game
func get_phase_label():
	return player_phase_labels[current_phase]

func set_phase(new_phase : player_phase):
	current_phase = new_phase
