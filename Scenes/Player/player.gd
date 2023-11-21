extends Node

@export var is_player : bool = false
var hand : Hand = null
var card_scene : PackedScene = preload("res://Scenes/Card/card.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func add_to_ui():
	var ui = get_tree().get_first_node_in_group("UIController")
	if ui.has_method("add_cards_to_hand"):
			ui.add_cards_to_hand(hand.card_array)
