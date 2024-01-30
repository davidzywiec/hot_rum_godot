extends Sprite2D

var card : Card

func set_card(new_card: Card):
	card = new_card
	self.texture = load(card.get_card_resource())

func get_card():
	return card
