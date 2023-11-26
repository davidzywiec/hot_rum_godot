class_name Hand

var card_array = []

func _init(new_hand):
	card_array = new_hand

func add_card(new_card : Card):
	card_array.append(new_card)
