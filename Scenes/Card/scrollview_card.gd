extends TextureRect

var original_scale
var rect_scale
var rect
var is_highlighted = false
var card : Card

func _ready():
	original_scale = scale
	rect = get_rect()


func _input(event):
	if event is InputEventMouseMotion:
		if rect.has_point(get_local_mouse_position()):
			rect_scale = original_scale * 1.1  # Increase the scale by 10%
			scale = rect_scale
		else:
			rect_scale = original_scale  # Reset the scale
			scale = rect_scale

	if event is InputEventMouseButton:
		if  event.button_index == MOUSE_BUTTON_LEFT and event.double_click:
			if rect.has_point(get_local_mouse_position()):
				print("Double click selected: " + str(self.get_index()))
				get_parent().move_child(self,2)
			
		elif event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if rect.has_point(get_local_mouse_position()):
				is_highlighted = false if is_highlighted else true
				if is_highlighted:
					modulate = Color(0.7, 1, 1, 1)
					add_to_group("selected")
				else:
					modulate = Color(1, 1, 1, 1)
					remove_from_group("selected")