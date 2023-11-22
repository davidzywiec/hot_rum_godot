extends Node

@export var is_player : bool = false
var hand : Hand = null
var card_scene : PackedScene = preload("res://Scenes/Card/card.tscn")
@onready var card_area = $CardArea
var offset = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func get_new_card(new_card : Card):
	hand.add_card(new_card)
	if is_player:
		add_card_to_game(false)


func add_card_to_game(all_cards: bool):
	#Create an offset incrased for each card
	if all_cards:
		#For each card in the hand
		for card in hand.card_array:
			#Create an instance of the card
			var card_sprite = card_scene.instantiate()
			card_sprite.texture = load(card.get_card_resource())
			card_sprite.position = Vector2(0,0)
			card_sprite.position.x += offset
			offset -= card_sprite.texture.get_width()
			card_area.add_child(card_sprite)
	else:
		#Create an instance of the card
		var card_sprite = card_scene.instantiate()
		card_sprite.texture = load(hand.card_array[hand.card_array.size()-1].get_card_resource())
		card_sprite.position = Vector2(0,0)
		card_sprite.position.x += offset
		offset -= card_sprite.texture.get_width()
		card_area.add_child(card_sprite)
