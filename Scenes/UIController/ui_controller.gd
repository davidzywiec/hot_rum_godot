extends Control

@onready var long_rule_label : RichTextLabel = $LongRuleText

# Called when the node enters the scene tree for the first time.
func on_update_label_text(label_text):
    # Replace 'label' with the actual node path of your label
    long_rule_label.text = label_text