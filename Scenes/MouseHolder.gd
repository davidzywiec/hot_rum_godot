extends Node2D

var has_card = false
var card : Card = null


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position = get_global_mouse_position()

func add_card(param_card : Card) -> bool:
	#Exit out if the mouse holder already has a card
	if has_card:
		return false
	#Continue here if no card is in the card slot
	has_card = true
	card = param_card
	var new_card : Sprite2D = card.sprite_card_scene.instantiate()
	new_card.texture = load(card.get_card_resource())
	new_card.set_position(Vector2.ZERO)
	new_card.set_card(card)
	add_child(new_card)
	return true

func get_card():
	return card

func remove_card():
	has_card = false
	card = null
	if get_child_count() > 0:
		remove_child(get_child(0))
