extends Node

var current_level : Node2D
var prior_levels : Array[Node2D] = []

func set_current_level(level : Node2D):
	current_level = level


func move_to_next_level(level : Node2D, destroy : bool):
	prior_levels.append(current_level)
	current_level = level
	add_child(current_level)
	
	#Destroy the scene if required else just remove and store in memory
	if destroy:
		var prior_level = prior_levels.pop_back()
		prior_level.queue_free()
	else:
		remove_child(prior_levels.back())
		
func move_to_prior_scene(destroy : bool):
	var prior_level = current_level 
	current_level = prior_levels.pop_back()
	prior_levels.append(prior_level)
	add_child(current_level)
	
	if destroy:
		prior_level = prior_levels.pop_back()
		prior_level.queue_free()
	else:
		remove_child(prior_levels.back())

