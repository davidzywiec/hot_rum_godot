extends Node2D

@export var is_player : bool = false
var hand : Hand = null
var card_scene : PackedScene = preload("res://Scenes/Card/scrollview_card.tscn")
var screen_size : Vector2 = Vector2.ZERO
var offset = 0
var player_phase = playerPhase.new()
var current_row = 0
var current_col = 0
var current_z_index :int = 1
var max_col = 20
@onready var cardbox = get_tree().get_first_node_in_group("CardBox")

var gridSpacing = Vector2(5,5)  # Adjust the spacing between sprites
var gridSize = Vector2(20, 2)       # Adjust the number of rows and columns

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass

#Player receives a new car in hand
func get_new_card(new_card : Card):
	hand.add_card(new_card)
	if is_player:
		add_card_to_game(false)


#Player adds cards to the UI
func add_card_to_game(all_cards: bool):
	#Create an offset incrased for each card
	if all_cards:
		#For each card in the hand
		for card in hand.card_array:
			#Create an instance of the card
			#add_card_to_grid(card)
			add_cards_to_cardbox_ui(card)
	else:
		#Create an instance of the card
		var card = hand.card_array[hand.card_array.size()-1]
		#add_card_to_grid(card)
		add_cards_to_cardbox_ui(card)


#Move the card to the other slot 
func add_card_to_grid(card : Card):
	var sprite : Sprite2D = card_scene.instantiate()
	sprite.texture = load(card.get_card_resource())
	var sprite_width = sprite.texture.get_width()*sprite.scale.x
	var sprite_height = sprite.texture.get_height()*sprite.scale.y
	var new_pos = Vector2((current_col * sprite_width ) + (gridSpacing.x * current_col), (current_row * sprite_height) + (gridSpacing.y * current_row))
	sprite.global_position = new_pos
	add_child(sprite)
	if current_col+1 > max_col:
		current_row+=1
		current_col = 1
	else:
		current_col+=1
	

func test_add_cards_to_grid():
	for row in range(int(gridSize.y)):
		for col in range(int(gridSize.x)):
		# Create a new sprite
			var sprite = card_scene.instantiate()
			var sprite_width = sprite.texture.get_width()*sprite.scale.x
			var sprite_height = sprite.texture.get_height()*sprite.scale.y
			# Set the sprite's texture or other properties as needed
			# For example, you can set a default texture:
			# sprite.texture = preload("res://path/to/your/texture.png")
			# Calculate the position based on the grid spacing and current row/column
			var new_pos = Vector2((col * sprite_width ) + (gridSpacing.x * col), (row * sprite_height) + (gridSpacing.y * row))
			# Set the sprite's position relative to the Area2D
			sprite.position = new_pos
			print(new_pos)
			# Add the sprite as a child of the Area2D
			add_child(sprite)


func add_cards_to_cardbox_ui(card : Card):
	var textureRect : TextureRect = card_scene.instantiate()
	textureRect.texture = load(card.get_card_resource())
	cardbox.add_child(textureRect)
