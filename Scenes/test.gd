extends Sprite2D


var is_highlighted = false


# Called when the node enters the scene tree for the first time.
func _ready():
	var sprite = self  # Replace with your sprite node path
	var material = sprite.material
	if material is ShaderMaterial:
		print("Shader is applied. Shader code: ", material.shader.code)
	else:
		print("Shader is not applied.")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		var size = self.texture.get_size()
		var rect = Rect2(global_position - size / 2, size)
		print(rect)
		print(event.global_position)
		if rect.has_point(event.global_position):
			set_shader_param(!is_highlighted)
			is_highlighted = !is_highlighted


func set_shader_param(new_bool : bool):
	print(new_bool)
	var sprite = self  # Replace with your sprite node path
	var material = sprite.material
	material.set_shader_parameter("apply_outline", new_bool)
	print(material.get_shader_parameter("apply_outline"))