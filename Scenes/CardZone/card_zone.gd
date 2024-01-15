extends Node2D

@onready var card_scene_prefab = "res://Scenes/Card/card.tscn"
@onready var play_zones : Array = get_tree().get_nodes_in_group("play_zone")

func _ready():
	var num = 1
	for x in play_zones:
		x.get_node("Zone_Label").text = "Set " + str(num)
		num+=1
		
