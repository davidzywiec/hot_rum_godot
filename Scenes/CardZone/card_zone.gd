extends Node2D

@onready var card_scene_prefab = "res://Scenes/Card/card.tscn"
@onready var play_zones : Array = get_tree().get_nodes_in_group("play_zone")

func _ready():
	var num = 1
	for x in play_zones:
		x.get_node("Zone_Label").text = "Set " + str(num)
		num+=1

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		var overlapping_sprites : Array = get_overlapping_sprites(event.global_position)

		if not overlapping_sprites.is_empty():
			var topmost_sprite = overlapping_sprites[-1]
			if topmost_sprite.has_method("select_card"):
				topmost_sprite.select_card()

func get_overlapping_sprites(event_position) -> Array:
	var overlapping_sprites = []
	# Get all nodes under the cursor position
	var overlapping_nodes = get_tree().get_nodes_in_group("selectable_card")
	for node in overlapping_nodes:
		#print("Sprite Rect: Position =", node.position, "Size =", node.texture.get_size())
		if node.get_rect().has_point(node.to_local(event_position)):
			overlapping_sprites.append(node)

	# Sort the list by z-index (topmost first)
	#overlapping_sprites.sort_custom(_sort_sprites_by_zindex)

	return overlapping_sprites

func _sort_sprites_by_zindex(a, b):
	return abs(a.global_position.x) - abs(b.global_position.x)
