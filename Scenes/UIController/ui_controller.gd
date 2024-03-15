extends Control

@onready var long_rule_label : Label = $RulePanelContainer/MarginContainer2/HBoxContainer/LongRuleText
@onready var deal_cards: Button = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer2/VBoxContainer/ButtonContainer/DealCards
@onready var draw_button: Button = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer2/VBoxContainer/ButtonContainer/DrawCard
@onready var req_button: Button = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer2/VBoxContainer/ButtonContainer/RequestCard
@onready var pass_button: Button = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer2/VBoxContainer/ButtonContainer/PassCard
@onready var take_button: Button = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer2/VBoxContainer/ButtonContainer/TakeCard
@onready var btn_container: VBoxContainer = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer2/VBoxContainer/ButtonContainer
var discard_button : Button
@onready var panel_container: PanelContainer = $MarginContainer/PanelContainer
@onready var card_table_button : Button = $CardTableButton
@onready var meld_area_button : Button = $MeldAreaButton
#Pickup Rules
@onready var pu_non_turn_rule : Label = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer2/VBoxContainer/PickupCardOutOfTurn
@onready var pu_turn_rule : Label = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer2/VBoxContainer/PickupCardOnTurn

#PickupTimer Label
@onready var pickup_timer_label : Label = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer2/VBoxContainer/PickupCountDown

#Player Labels
@onready var player_area : Array = get_tree().get_nodes_in_group("UIPlayerArea")

#Discard Area Button
@onready var discard_area : Sprite2D = get_tree().get_first_node_in_group("discard_area_sprite")

@export var current_player_color : Color = Color.GREEN
@onready var cardTableScene : PackedScene = preload("res://Scenes/CardTable/card_table.tscn")
var card_table_node : Node2D

@onready var meldDropOffScene : PackedScene = preload("res://Scenes/Meld/meld_drop_off.tscn")
var meld_drop_off : Node2D

@onready var sceneManager = get_tree().get_first_node_in_group("SceneManager")

var player_index : int = 0

signal start_game_signal
signal card_action_signal(action : CardActions.Action, player_index : int)

func _ready():
	deal_cards.pressed.connect(start_game)
	draw_button.pressed.connect(draw_card)
	pass_button.pressed.connect(pass_card)
	take_button.pressed.connect(take_card)
	req_button.pressed.connect(request_card)
	card_table_button.pressed.connect(move_to_card_table)
	discard_button = discard_area.get_node("ConfirmDiscard")
	if discard_button:
		discard_button.pressed.connect(discard_card)
	if meld_area_button:
		meld_area_button.pressed.connect(move_to_meld_area)
	


# Called when the node enters the scene tree for the first time.
func on_update_label_text(label_text):
	# Replace 'label' with the actual node path of your label
	if label_text == null:
		return
	long_rule_label.text = label_text


func start_game():
	emit_signal("start_game_signal")
	deal_cards.disabled = true
	deal_cards.visible = false
	

func draw_card():
	emit_signal("card_action_signal", CardActions.Action.DRAW, player_index)
	take_button.visible = false
	draw_button.visible = false
	hide_pickup_rules()


func pass_card():
	emit_signal("card_action_signal", CardActions.Action.PASS, player_index)
	hide_pickup_rules()


func take_card():
	emit_signal("card_action_signal", CardActions.Action.TAKE, player_index)
	take_button.visible = false
	draw_button.visible = false
	hide_pickup_rules()


func request_card():
	emit_signal("card_action_signal", CardActions.Action.REQUEST, player_index)
	pass_button.visible = false
	req_button.visible = false
	hide_pickup_rules()


func discard_card():
	emit_signal("card_action_signal", CardActions.Action.DISCARD, player_index)
	discard_button.get_parent().reset_card()
 


func ask_player_to_pick_card(toggle: bool,player_turn : bool):
	panel_container.visible = toggle
	if player_turn:
		pu_turn_rule.visible = toggle
		pu_non_turn_rule.visible = false
		draw_button.visible = toggle
		take_button.visible = toggle
		pass_button.visible = false
		req_button.visible = false

	else:
		pu_turn_rule.visible = false
		pu_non_turn_rule.visible = toggle
		pass_button.visible = toggle
		req_button.visible = toggle
		draw_button.visible = false
		take_button.visible = false


func hide_pickup_rules():
	pu_turn_rule.visible = false
	pu_non_turn_rule.visible = false
	panel_container.visible = false


func update_pickup_timer_label(time_left : float):
	pickup_timer_label.text = str(time_left).pad_decimals(1).pad_zeros(1)


func toggle_pickup_timer_label(toggle : bool):
	pickup_timer_label.visible = toggle



func update_player_action(player_index : int, action_name : String):
	player_area[player_index].get_node("ActionLabel").text = action_name
	player_area[player_index].get_node("ActionLabel").visible = true
	


func clear_player_action():
	for node in player_area:
		node.get_node("ActionLabel").text = ""
		node.get_node("ActionLabel").visible = false


func set_player_names(index : int, name : String):
	if index < player_area.size():
		player_area[index].get_node("PlayerName").text = name


func toggle_discard_area(toggle : bool):
	discard_area.visible = toggle
	if discard_area.has_method("toggle_active"):
		discard_area.toggle_active(toggle)


func toggle_lock_discard_area(toggle: bool):
	discard_button.disabled = toggle
	if discard_area.has_method("toggle_lock"):
		discard_area.toggle_lock(toggle)


func get_discard_card() -> Card:
	if discard_area.has_method("get_card"):
		return discard_area.get_card()
	return null


func set_current_player(current_player_index: int):
	var index = 0
	for node in player_area:
		if index == current_player_index:
			node.get_node("PlayerName").add_theme_color_override("font_color", current_player_color)
		else:
			node.get_node("PlayerName").add_theme_color_override("font_color", Color.WHITE)
		index += 1

func move_to_card_table():
	if !card_table_node:
		card_table_node = cardTableScene.instantiate()
		
	sceneManager.move_to_next_level(card_table_node, false)

func move_to_meld_area():
	print("Move to meld area")
	if !meld_drop_off:
		meld_drop_off = meldDropOffScene.instantiate()
	else:
		meld_drop_off.refresh_cards()
		
	sceneManager.move_to_next_level(meld_drop_off, false)
