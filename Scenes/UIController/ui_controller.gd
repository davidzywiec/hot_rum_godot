extends Control

@onready var long_rule_label : Label = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer2/VBoxContainer/LongRuleText
@onready var start_button: Button = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer2/VBoxContainer/ButtonContainer/StartButton
@onready var pick_button: Button = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer2/VBoxContainer/ButtonContainer/PickCard
@onready var pass_button: Button = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer2/VBoxContainer/ButtonContainer/PassCard
@onready var take_button: Button = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer2/VBoxContainer/ButtonContainer/TakeCard
@onready var discard_button: Button = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer2/VBoxContainer/ButtonContainer/DiscardCard
@onready var btn_container: VBoxContainer = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer2/VBoxContainer/ButtonContainer


signal start_game_signal
signal pick_card_signal
signal pass_card_signal
signal take_card_signal
signal discard_card_signal

func _ready():
	start_button.pressed.connect(start_game)
	pick_button.pressed.connect(pick_card)
	pass_button.pressed.connect(pass_card)
	take_button.pressed.connect(take_card)
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
	pick_button.visible = true
	take_button.visible = true


func pick_card():
	emit_signal("pick_card_signal")
	pick_button.visible = false


func pass_card():
	emit_signal("pass_card_signal")


func take_card():
	emit_signal("take_card_signal")
	take_button.visible = false
	

func discard_card():
	emit_signal("discard_card_signal")


func hide_buttons():
	btn_container.visible = false


func show_buttons():
	btn_container.visible = true

