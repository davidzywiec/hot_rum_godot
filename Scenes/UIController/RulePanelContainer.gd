extends PanelContainer

@onready var showButton : Button = $MarginContainer2/HBoxContainer/Button
@onready var long_text : Label = $MarginContainer2/HBoxContainer/LongRuleText

func _ready():
	showButton.pressed.connect(toggle_button)

func toggle_button():
	if long_text.visible:
		showButton.text = "<"
	else:
		showButton.text = ">"
	long_text.visible = !long_text.visible
