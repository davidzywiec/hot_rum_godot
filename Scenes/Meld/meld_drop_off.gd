extends Node2D

@onready var mouse_holder : Node2D = $MouseHolder


@onready var starting_pos : Vector2 = $ResetPos.position
@export var starting_offset : Vector2 = Vector2(50,0)
var current_offset : Vector2 = Vector2.ZERO 

@onready var organize_btn : Button = $OrganizeButton
@onready var cancel_btn : Button = $CancelButton
@onready var sceneManager = get_tree().get_first_node_in_group("SceneManager")
var cards = []

var meld_area_prefab : PackedScene = preload("res://Scenes/Meld/meld_card_area.tscn")

@export var meld_positions = []
var created_melds = false
var melds = []


func _ready():
	organize_btn.pressed.connect(organize_cards)
	cancel_btn.pressed.connect(cancel_drop_off)
	current_offset = starting_pos
	find_melds()
	refresh_cards()

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		if mouse_holder.has_card:
			remove_card_from_mouse_holder(false)
		else:
			var overlapping_sprites : Array = get_overlapping_sprites(event.position)
			overlapping_sprites.sort_custom(_sort_sprites_by_zindex)

			if not overlapping_sprites.is_empty():
				var topmost_sprite = overlapping_sprites.pop_back()
				add_card_to_mouse_holder(topmost_sprite)
				
			
func get_overlapping_sprites(event_position) -> Array:
	var overlapping_sprites = []
	# Get all nodes under the cursor position
	var overlapping_nodes = get_tree().get_nodes_in_group("selectable_card")
	for node in overlapping_nodes:
		#print("Sprite Rect: Position =", node.position, "Size =", node.texture.get_size())
		if node.get_rect().has_point(node.to_local(event_position)):
			overlapping_sprites.append(node)

	return overlapping_sprites

func _sort_sprites_by_zindex(a, b):
	return b.order > a.order


#Add the card to the mouseholder
func add_card_to_mouse_holder(card_node):
	if card_node.get_parent():
		var par = card_node.get_parent()
		par.remove_child(card_node)
	mouse_holder.add_child(card_node)
	card_node.set_position(Vector2.ZERO)
	mouse_holder.has_card = true
	

func remove_card_from_mouse_holder(forced : bool) -> Node2D:
	if mouse_holder.get_child_count() > 0:
		var current_child = mouse_holder.get_child(0)
		mouse_holder.remove_child(current_child)	

		if !forced:	
			var new_pos = mouse_holder.position
			self.add_child(current_child)
			current_child.position = new_pos

		mouse_holder.has_card = false
		return current_child
	return null
	
func set_initial_card(card : Sprite2D):
		card.in_meld = false
		if card.get_parent() != self:
			call_deferred("add_child",card,0)
		card.global_position = current_offset
		current_offset += starting_offset
		
func reset_offsets():
	current_offset = starting_pos
	starting_offset = Vector2(50,0)

#Send validation to global controller on all melds
func validate_all_melds():
	pass

#Reset the cards into a line
func organize_cards():
	reset_offsets()
	#Find all selectable cards and set them with set initial card logic
	for card in get_tree().get_nodes_in_group("selectable_card"):
		if !card.in_meld:
			set_initial_card(card)


func find_melds():
	#print(get_tree().get_nodes_in_group("meldArea"))
	for node in get_tree().get_nodes_in_group("meldArea"):
		melds.append(node)

func add_card_to_scene(card : Card):
	var card_sprite = card.sprite_card_scene.instantiate()
	card_sprite.set_card(card)
	set_initial_card(card_sprite)

func cancel_drop_off():
	sceneManager.move_to_prior_scene(false)

func refresh_cards():
	create_meld_areas()
	for card in DataController.player_hand.card_array:
		if card not in cards:
			add_card_to_scene(card)
			cards.append(card)

	for card in cards:
		if card not in DataController.player_hand.card_array:
			card.queue_free()
	
	


func create_meld_areas():
	var current_round = GlobalController.round_index
	var melds_in_round = GlobalController.round_place_conditions[current_round]
	var index = 0
	for meld in melds_in_round:
		var meld_instance = meld_area_prefab.instantiate()
		meld_instance.set_meld_type(meld)
		melds.append(meld_instance)
		add_child(meld_instance)
		meld_instance.global_position = meld_positions[index]
		index+= 1



	created_melds = true
			
