extends TextureRect

var original_scale
var rect_scale
var rect
var is_highlighted = false
var card : Card
var clickable = false
var long_press = false
@onready var timer : Timer = $Timer
@onready var mouse_holder_node : Node2D = get_tree().get_first_node_in_group("mouse_holder")
var wait_time = 100000

func _ready():
	original_scale = scale
	rect = get_rect()
	self.mouse_entered.connect(_mouse_entered)
	self.mouse_exited.connect(_mouse_exited)
	timer.set_one_shot(false)
	timer.set_wait_time(wait_time)

func _process(delta):
#Process the mouse press if it goes longer than 0.5 seconds than it is a long press.
	if !timer.is_stopped():
		if wait_time - timer.time_left > 0.5:
			on_long_press()


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
			if move_card():
				timer.start()
				toggle_highlight()
			
		elif event.button_index == MOUSE_BUTTON_LEFT and !event.pressed:
			#Print released when the mouse is released			
			timer.stop()
			
		if event.button_index == MOUSE_BUTTON_LEFT and event.double_click:
			print("Double click selected: " + str(self.get_index()))
			get_parent().move_child(self,2)


#Long press function moves the card to the mouse holder node.
func on_long_press():
	#Stop the timer
	timer.stop()
	#Set the long press to true
	long_press = true
	#Remove all selected cards from the selected group
	for selected_card in get_tree().get_nodes_in_group("selected"):
		selected_card.toggle_highlight()
	#Add the card to the mouse holder node	
	if mouse_holder_node.has_method("add_card"):
		if mouse_holder_node.add_card(card):
			queue_free()

#Set the card texture and card variable
func set_card(new_card: Card):
	card = new_card
	texture = load(card.get_card_resource())


func move_card():
	#If the card holder has a card, than create a temp_card and set it to the card's index
	if mouse_holder_node.has_card:
		var textureRect : TextureRect = mouse_holder_node.card.texrect_card_scene.instantiate()
		get_parent().add_child(textureRect)
		var current_child_index = get_index()
		get_parent().move_child(textureRect, current_child_index)
		if textureRect.has_method("set_card"):
			textureRect.set_card(mouse_holder_node.card)
			mouse_holder_node.remove_card()
		else:
			print("TextureRect has no method set_card")
		return false
	return true

func toggle_highlight():
	is_highlighted = false if is_highlighted else true
	if is_highlighted:
		modulate = Color(0.7, 1, 1, 1)
		add_to_group("selected")
	else:
		modulate = Color(1, 1, 1, 1)
		remove_from_group("selected")
