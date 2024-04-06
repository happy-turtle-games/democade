class_name FadingBG extends Control


@export var fade_speed := 1.0


var flip := false
var fade := 0.0


func _process(delta: float) -> void:
	if not App.current.active: return
	
	material.get_shader_parameter
	fade = move_toward(fade, 1.0 if flip else 0.0, fade_speed * delta)
	material.set_shader_parameter(&"fade", fade)


func switch(texture: Texture2D) -> void:
	flip = !flip
	material.set_shader_parameter(&"texture_b" if flip else &"texture_a", texture)
