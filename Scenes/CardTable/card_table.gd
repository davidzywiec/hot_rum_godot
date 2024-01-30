extends Node2D

@onready var back_btn : Button = $BackBtn
@onready var sceneManager = get_tree().get_first_node_in_group("SceneManager")

# Called when the node enters the scene tree for the first time.
func _ready():
	back_btn.pressed.connect(go_back)


func go_back():
	sceneManager.move_to_prior_scene(true)
