class_name Card

enum Suit {spades, hearts, diamonds, clubs};

var number : int
var suit : Suit

func _init(number : int, suit : Suit):
    self.number = number
    self.suit = suit

func _to_string():
    var suit_str : String
    match suit:
        Suit.spades:
            suit_str = "spades"
        Suit.hearts:
            suit_str = "hearts"
        Suit.diamonds:
            suit_str = "diamonds"
        Suit.clubs:
            suit_str = "clubs"
    return str(number) + " of " + suit_str