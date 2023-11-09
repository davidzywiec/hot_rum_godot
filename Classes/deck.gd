class_name Deck

#Always use 2 decks
var number_of_decks : int = 2
var cards : Array = []


#Create a deck with 4 suits by 13 numbers cards (52 cards) multiplied by the number of decks
func _init():
	#Create Deck
	for i in range(number_of_decks):
		for j in range(4):
			for x in range(13):
				var card = Card.new(x+1,j)
				cards.append(card)
	#Shuffle deck after creation
	shuffle_deck()


#Shuffle the deck
func shuffle_deck():
	randomize()
	cards.shuffle()

func print_deck():
	for c in cards:
		print(c.to_string())

func deal_hand(card_cnt: int)->Hand:
	var new_hand = []
	for x in range(card_cnt):
		new_hand.append(cards.pop_front())
	return Hand.new(new_hand)
