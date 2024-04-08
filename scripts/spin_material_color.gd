extends CanvasItem


@export var uniform_name := &"color"
@export var speed := 1.0
@export var saturation := 1.0
@export var lightness := 1.0


var hue := 0.0


func _process(delta: float) -> void:
	hue += delta * speed
	if hue > 1.0:
		hue -= 1.0
	
	var color := Color.from_ok_hsl(hue, saturation, lightness)
	material.set_shader_parameter(uniform_name, color)
