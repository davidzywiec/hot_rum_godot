extends Sprite2D

var is_highlighted = true


# Called when the node enters the scene tree for the first time.
func _ready():
	var sprite = self  # Replace with your sprite node path
	var material = sprite.material


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if event is InputEventMouseButton and event.pressed:		
		if get_rect().has_point(to_local(event.position)):
			select_card()
	


func set_shader_param(new_bool : bool):
	var sprite = self  # Replace with your sprite node path
	var material = sprite.material
	material.set_shader_parameter("apply_outline", new_bool)


func select_card():
	set_shader_param(!is_highlighted)
	is_highlighted = !is_highlighted
	if is_highlighted:
		add_to_group("Selected Card")
	else:
		remove_from_group("Selected Card")
