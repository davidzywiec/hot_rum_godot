class_name playerPhase

enum player_phase
{	Waiting,
	Choosing,
	Thinking,
	Placing,
	Discarding,
	RoundOver
};
var player_phase_labels = ["Waiting", "Choosing", "Thinking","Placing", "Discarding","Round Over"]
var current_phase : player_phase = player_phase.Waiting 

func get_phase():
	return current_phase

#Get the label of the current phase of the game
func get_phase_label():
	return player_phase_labels[current_phase]

func set_phase(new_phase : player_phase):
	current_phase = new_phase

func phase_to_string(enum_value : player_phase):
	return player_phase_labels[enum_value]
