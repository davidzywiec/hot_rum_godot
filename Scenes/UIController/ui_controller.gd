extends Control

@onready var long_rule_label : Label = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer2/VBoxContainer/LongRuleText
@onready var start_button: Button = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer2/VBoxContainer/ButtonContainer/StartButton
@onready var draw_button: Button = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer2/VBoxContainer/ButtonContainer/DrawCard
@onready var req_button: Button = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer2/VBoxContainer/ButtonContainer/RequestCard
@onready var pass_button: Button = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer2/VBoxContainer/ButtonContainer/PassCard
@onready var take_button: Button = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer2/VBoxContainer/ButtonContainer/TakeCard
@onready var discard_button: Button = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer2/VBoxContainer/ButtonContainer/DiscardCard
@onready var btn_container: VBoxContainer = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer2/VBoxContainer/ButtonContainer

#Pickup Rules
@onready var pu_non_turn_rule : Label = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer2/VBoxContainer/PickupCardOutOfTurn
@onready var pu_turn_rule : Label = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer2/VBoxContainer/PickupCardOnTurn

#PickupTimer Label
@onready var pickup_timer_label : Label = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer2/VBoxContainer/PickupCountDown

#Player Labels
@onready var player_area : Array = get_tree().get_nodes_in_group("UIPlayerArea")


var player_index : int = 0

signal start_game_signal
signal card_action_signal(action : CardActions.Action)

func _ready():
	start_button.pressed.connect(start_game)
	draw_button.pressed.connect(draw_card)
	pass_button.pressed.connect(pass_card)
	take_button.pressed.connect(take_card)
	req_button.pressed.connect(request_card)
	discard_button.pressed.connect(discard_card)


# Called when the node enters the scene tree for the first time.
func on_update_label_text(label_text):
	# Replace 'label' with the actual node path of your label
	if label_text == null:
		return
	long_rule_label.text = label_text


func start_game():
	emit_signal("start_game_signal")
	start_button.disabled = true
	start_button.visible = false
	

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

func hide_buttons():
	btn_container.visible = false


func show_buttons():
	btn_container.visible = true


func ask_player_to_pick_card(player_turn : bool):
	if player_turn:
		pu_turn_rule.visible = true
		pu_non_turn_rule.visible = false
		draw_button.visible = true
		take_button.visible = true
	else:
		pu_turn_rule.visible = false
		pu_non_turn_rule.visible = true
		pass_button.visible = true
		req_button.visible = true

func hide_pickup_rules():
	pu_turn_rule.visible = false
	pu_non_turn_rule.visible = false

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

