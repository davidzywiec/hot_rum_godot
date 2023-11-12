extends Node

var hand : Hand = null
var card_scene : PackedScene = preload("res://Scenes/Card/card.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func print_hand():
	for card in hand.card_array:
		var card_node = card_scene.instantiate() as Sprite2D
		card_node.texture = "res://Card Assets/1C.png"
		
