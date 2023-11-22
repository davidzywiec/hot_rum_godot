class_name Card

enum Suit {spades, hearts, diamonds, clubs};

var number : int
var suit : Suit


func _init(number : int, suit : Suit):
	self.number = number
	self.suit = suit

func _to_string():
	var suit_str : String
	var card_num : String
	match suit:
		Suit.spades:
			suit_str = "spades"
		Suit.hearts:
			suit_str = "hearts"
		Suit.diamonds:
			suit_str = "diamonds"
		Suit.clubs:
			suit_str = "clubs"
	
	match number:
		1:
			card_num = "Ace"
		11:
			card_num = "Jack"
		12: 
			card_num = "Queen"
		13:
			card_num = "King"
		_:
			card_num = str(number)
	return card_num + " of " + suit_str

func get_card_resource():
	var suit_str : String
	match suit:
		Suit.spades:
			suit_str = "S"
		Suit.hearts:
			suit_str = "H"
		Suit.diamonds:
			suit_str = "D"
		Suit.clubs:
			suit_str = "C"
	
	
			
	return "res://Card Assets/" + str(number) + suit_str + ".png"
