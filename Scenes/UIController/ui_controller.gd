extends Control

@onready var long_rule_label : Label = $PanelContainer/VBoxContainer/LongRuleText
@onready var start_button: Button = $PanelContainer/VBoxContainer/StartButton
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
	
