extends Node2D

@export var is_player : bool = false
var hand : Hand = null
var screen_size : Vector2 = Vector2.ZERO
var offset = 0
var player_phase = playerPhase.new()
var current_row = 0
var current_col = 0
var current_z_index :int = 1
var max_col = 20
@onready var cardbox = get_tree().get_first_node_in_group("CardBox")
@onready var ai_agent = $AIAgent
@onready var game_controller = get_tree().get_first_node_in_group("GameController")
var pass_action : CardActions.Action

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


func add_cards_to_cardbox_ui(card : Card):
	var textureRect : TextureRect = card.texrect_card_scene.instantiate()
	cardbox.add_child(textureRect)
	if textureRect.has_method("set_card"):
		textureRect.set_card(card)
	else:
		print("TextureRect has no method set_card")
	
func request_pickup(card : Card):
	if is_player:
		pass
	else:
		pass_action = ai_agent.request_pickup_card(false, card)


func pick_card(action: CardActions.Action):
	print("Pick Card action: ", CardActions.card_action_string[action])
	#pass_action = action
