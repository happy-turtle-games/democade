class_name GameButton extends TextureRect


@export var unselected_scale := 0.8


var game: Game

var selected := false


var scale_factor := unselected_scale


func _ready() -> void:
	texture = game.cover_texture
	set_selected(false)
	pivot_offset.x = size.x / 2.0
	pivot_offset.y = size.y


func _process(delta: float) -> void:
	if not App.current.active: return
	
	var target_scale := 1.0 if selected else unselected_scale
	scale_factor = lerpf(scale_factor, target_scale, Math.smooth(10.0, delta))
	scale = Vector2.ONE * scale_factor


func set_selected(selected: bool) -> void:
	self.selected = selected
