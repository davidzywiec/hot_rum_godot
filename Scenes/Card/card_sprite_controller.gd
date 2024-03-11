extends Sprite2D

var card : Card
@export var create_fake_card = false
@export var fake_card_number = 2
@export var fake_card_suit = Card.Suit.diamonds
@export var order = 1
var in_meld = false

func _ready():
	if create_fake_card:
		set_card(Card.new(fake_card_number, fake_card_suit))

func set_card(new_card: Card):
	card = new_card
	self.texture = load(card.get_card_resource())

func get_card():
	return card

func select_card():
	if get_parent().has_method("add_card_to_mouse_holder"):
		get_parent().add_card_to_mouse_holder(self)
