extends Node2D

var area_active = true
var cards : Array[Sprite2D]
@onready var area : Area2D = $Area2D
@onready var card_pos : Node2D = $CardPos
@export var meld_type : GlobalController.MELD_TYPE
var offset = Vector2(5,0)
var current_pos : Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	area.area_entered.connect(card_entered)
	area.area_exited.connect(card_exited)



#When a card is added
func card_entered(new_area : Area2D):
	if area_active && new_area.get_parent().has_method("get_card"):
		var card = new_area.get_parent().get_card()
		call_deferred("create_card",card)


		


func card_exited(area : Area2D):
	var latest_card = cards.pop_back()
	latest_card.queue_free()
	
func create_card(card : Card):
	var new_card : Sprite2D = Sprite2D.new()
	new_card.texture = load(card.get_card_resource())
	new_card.set_position(current_pos)
	cards.append(new_card)
	card_pos.add_child(new_card)
	current_pos += offset
	
	
func remove_card():
	pass
		
		
	
