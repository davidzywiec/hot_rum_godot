class_name Hand

var card_array = []

func _init(new_hand):
	card_array = new_hand

func add_card(new_card : Card):
	card_array.append(new_card)

func remove_card(card_to_remove : Card):
	for index in card_array.size():
		if card_array[index].number == card_to_remove.number and card_array[index].suit == card_to_remove.suit:
			card_array.remove_at(index)
			return

func print_hand():
	for card in card_array:
		print(str(card))
