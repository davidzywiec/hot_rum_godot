extends Area2D

@onready var cancel_btn : Button = $CancelBtn
@onready var valid_lbl : RichTextLabel = $ValidLbl

@export var meld_offset : Vector2 = Vector2(50,0)
var current_offset : Vector2 = Vector2.ZERO 
@onready var starting_pos : Vector2 = $StartingPos.position
var cards = []
@export var meld_type = GlobalController.MELD_TYPE.SET

func _ready():
	cancel_btn.pressed.connect(cancel_meld)

func entered_meld_card(_area : Area2D):
	if !get_parent():
		print("No Parent found on card")
		return
	var entered_card = get_parent().remove_card_from_mouse_holder(true)
	if entered_card and entered_card.in_meld == false:
		self.add_child(entered_card,0)
		entered_card.set_position(starting_pos + current_offset)
		current_offset += meld_offset
		entered_card.in_meld = true
		entered_card.remove_from_group("selectable_card")
		cards.append(entered_card)
	
	if self.get_child_count() > 0:
		cancel_btn.visible = true

	if GlobalController.check_for_meld(cards, meld_type):
		print("Valid " + GlobalController.meld_type_string[meld_type])
		valid_lbl.visible = true
	else:
		print("Invalid " + GlobalController.meld_type_string[meld_type])
		valid_lbl.visible = false


func cancel_meld():
	#Loop through the cards and reset them to the position on the a
	for card in cards:
		self.remove_child(card)
		card.set_position(Vector2.ZERO)
		card.add_to_group("selectable_card")
		get_parent().set_initial_card(card)
	cards.clear()
	#Reset offset on meld
	current_offset = Vector2.ZERO
	#Reset the visibility on cancel
	cancel_btn.visible = false
	valid_lbl.visible = false
	#Reset Current Offset
	get_parent().reset_offsets()

func get_meld():
	for card in cards:
		print(card.card)