extends Area2D

@onready var cancel_btn : Button = $CancelBtn
@export var meld_offset : Vector2 = Vector2.ZERO
var current_offset : Vector2 = Vector2.ZERO 
@onready var starting_pos : Vector2 = $StartingPos.position

func entered_meld_card(_area : Area2D):
	if !get_parent():
		return
	var entered_card = get_parent().remove_card_from_mouse_holder(true)
	if entered_card and entered_card.in_meld == false:
		self.add_child(entered_card,0)
		entered_card.set_position(starting_pos + current_offset)
		current_offset += meld_offset
		entered_card.in_meld = true
		entered_card.remove_from_group("selectable_card")
	
	if self.get_child_count() > 0:
		cancel_btn.visible = true
