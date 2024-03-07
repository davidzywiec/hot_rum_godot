extends Node2D

@onready var card_scene_prefab = "res://Scenes/Card/card.tscn"
@onready var mouse_holder : Node2D = $MouseHolder

func _ready():
	pass

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		if mouse_holder.has_card:
			remove_card_from_mouse_holder()
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
			print(node)

	return overlapping_sprites

func _sort_sprites_by_zindex(a, b):
	return b.order > a.order


#Add the card to the mouseholder
func add_card_to_mouse_holder(card_node):
	self.remove_child(card_node)
	mouse_holder.add_child(card_node)
	card_node.set_position(Vector2.ZERO)
	mouse_holder.has_card = true

func remove_card_from_mouse_holder():
	var current_child = mouse_holder.get_child(0)
	var new_pos = mouse_holder.position
	mouse_holder.remove_child(current_child)
	self.add_child(current_child)
	current_child.position = new_pos
	mouse_holder.has_card = false
	
