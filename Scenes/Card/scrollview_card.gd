extends TextureRect

var original_scale
var rect_scale
var rect
var is_highlighted = false
var card : Card
var clickable = false
var pressed = true
@onready var timer : Timer = $Timer
var wait_time = 100000

func _ready():
	original_scale = scale
	rect = get_rect()
	self.mouse_entered.connect(_mouse_entered)
	self.mouse_exited.connect(_mouse_exited)
	timer.set_one_shot(false)
	timer.set_wait_time(wait_time)

func _mouse_entered():
	rect_scale = original_scale * 1.1  # Increase the scale by 10%
	scale = rect_scale
	clickable = true


func _mouse_exited():
	rect_scale = original_scale  # Reset the scale
	scale = rect_scale
	clickable = false

func _input(event):	
	if event is InputEventMouseButton && clickable:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			#Print pressed every second the mouse is held down
			timer.start()
			print("Start")
		elif event.button_index == MOUSE_BUTTON_LEFT and !event.pressed:
			#Print released when the mouse is released			
			print("Time elapsed: ", wait_time - timer.time_left)
			timer.stop()

			
		if event.button_index == MOUSE_BUTTON_LEFT and event.double_click:
			print("Double click selected: " + str(self.get_index()))
			get_parent().move_child(self,2)

		if event.button_index == MOUSE_BUTTON_LEFT and event.double_click:
				print("Double click selected: " + str(self.get_index()))
				get_parent().move_child(self,2)
			
		elif event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
				is_highlighted = false if is_highlighted else true
				if is_highlighted:
					modulate = Color(0.7, 1, 1, 1)
					add_to_group("selected")
				else:
					modulate = Color(1, 1, 1, 1)
					remove_from_group("selected")
