extends Control

@onready var long_rule_label : Label = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer2/VBoxContainer/LongRuleText
@onready var start_button: Button = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer2/VBoxContainer/StartButton
@onready var card_area : GridContainer = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer2/CardArea
signal start_game_signal

func _ready():
	start_button.pressed.connect(start_game)

# Called when the node enters the scene tree for the first time.
func on_update_label_text(label_text):
	# Replace 'label' with the actual node path of your label
	if label_text == null:
		return
	long_rule_label.text = label_text

func start_game():
	emit_signal("start_game_signal")
	
func add_cards_to_hand(card_array : Array):
	for card in card_array:
		var new_texrect = TextureRect.new() 
		new_texrect.texture = load(card.get_card_resource())
		card_area.add_child(new_texrect)
