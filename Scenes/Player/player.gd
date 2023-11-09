extends Node

var hand : Hand = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func print_hand():
	print(self.name)
	for card in hand.card_array:
		print(card)
