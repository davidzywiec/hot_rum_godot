extends Node2D

@onready var placement_area : CollisionShape2D = $PlayingArea2D/PlayerAreaShape2D

var grid_size : Vector2 = Vector2(4, 3)  # Adjust the grid size as needed
var sprite_size = Vector2(50, 50)  # Adjust the sprite size as needed
@onready var sample_texture : Texture2D = load("res://Card Assets/1C.png")

func _ready():
	#Set Sprite Size
	sprite_size = sample_texture.get_size()
		
	# Get the screen dimensions
	var screen_size : Vector2 = get_viewport_rect().size

	# Set the placement area's size and position with a 10-pixel margin on top and bottom
	
	var new_shape : RectangleShape2D = RectangleShape2D.new()
	var new_size = Vector2(screen_size.x-25, (screen_size.y * 0.5) - 20)
	new_shape.set_size(new_size)
	placement_area.shape = new_shape
	# Calculate the position to center the node
	var center_position : Vector2 = Vector2((screen_size.x / 2), screen_size.y - (new_shape.size.y * 0.5)-25)

	# Set the position of your node to the center of the screen
	position = center_position
	grid_size = new_size
	var new_polygon = Polygon2D.new()
	new_polygon.set_polygon([
		Vector2(0, 0),
		Vector2(new_size.x, 0),
		Vector2(new_size.x, new_size.y),
		Vector2(0, new_size.y)
	])
	new_polygon.color = Color.INDIAN_RED
	add_child(new_polygon)
	# Optionally, you can set a background color or other properties for the placement area
	#placement_area.modulate = Color(0.8, 0.8, 0.8)  # Light gray color
