extends Sprite2D

@onready var area = $Area2D
@onready var confirm_button = $ConfirmDiscard
var default_card = preload("res://Card Assets/discard_card.png")
var current_card : Card
var locked = false
var area_active = false

# Called when the node enters the scene tree for the first time.
func _ready():
	area.area_entered.connect(card_entered)
	area.area_exited.connect(card_exited)

func card_entered(area : Area2D):
	if locked == false && area_active:
		if area.get_parent().has_method("get_card"):
			current_card = area.get_parent().get_card()
			self.texture = load(current_card.get_card_resource())
		area.get_parent().visible = false
		confirm_button.visible = true


func card_exited(area : Area2D):
	if locked == false && area_active:
		self.texture = default_card
		current_card = null
		area.get_parent().visible = true
		confirm_button.visible = false

func toggle_lock(toggle: bool):
	locked = toggle

func toggle_active(toggle: bool):
	area_active = toggle

func get_card():
	return current_card
