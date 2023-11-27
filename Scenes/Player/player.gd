extends Node2D

@export var is_player : bool = false
var hand : Hand = null
var card_scene : PackedScene = preload("res://Scenes/Card/card.tscn")
@onready var card_area : CollisionShape2D = $CardArea/PlayingArea2D/PlayerAreaShape2D
var screen_size : Vector2 = Vector2.ZERO
var offset = 0
var player_phase = playerPhase.new()
var current_row = 0
var current_col = 0
var max_row = 1
var max_col = 1

var gridSpacing = Vector2(68, 94)  # Adjust the spacing between sprites
var gridSize = Vector2(20, 4)       # Adjust the number of rows and columns

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

#Player receives a new car in hand
func get_new_card(new_card : Card):
	hand.add_card(new_card)
	if is_player:
		add_card_to_game(false)


#Player adds cards to the UI
func add_card_to_game(all_cards: bool):
	test_add_cards_to_grid()
	#Create an offset incrased for each card
	if all_cards:
		#For each card in the hand
		for card in hand.card_array:
			#Create an instance of the card
			#add_card_to_grid(card)
			pass
	else:
		#Create an instance of the card
		var card_sprite = card_scene.instantiate()
		card_sprite.texture = load(hand.card_array[hand.card_array.size()-1].get_card_resource())
		card_sprite.position = Vector2(0,0)
		card_sprite.position.x += offset
		offset -= card_sprite.texture.get_width()
		card_area.add_child(card_sprite)


#Move the card to the other slot 
func add_card_to_grid(card : Card):
	var card_sprite = card_scene.instantiate()
	card_sprite.texture = load(card.get_card_resource())
	card_sprite.position = Vector2(0,0)
	card_sprite.position.x += offset
	offset -= card_sprite.texture.get_width()
	var position = Vector2(current_col * card_sprite.texture.get_size().x, current_row * card_sprite.texture.get_size().y)
	print(position)
	card_area.add_child(card_sprite)

func test_add_cards_to_grid():
	var shape_width = Vector2(-778,-163)
	print(shape_width)
	for row in range(int(gridSize.y)):
		for col in range(int(gridSize.x)):
		# Create a new sprite
			var sprite = card_scene.instantiate()
			# Set the sprite's texture or other properties as needed
			# For example, you can set a default texture:
			# sprite.texture = preload("res://path/to/your/texture.png")
			# Calculate the position based on the grid spacing and current row/column
			var new_pos = Vector2((col * gridSpacing.x) + shape_width.x, (row * gridSpacing.y) + shape_width.y)
			# Set the sprite's position relative to the Area2D
			sprite.position = new_pos
			# Add the sprite as a child of the Area2D
			add_child(sprite)
