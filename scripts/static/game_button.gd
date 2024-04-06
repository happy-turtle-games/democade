class_name GameButton extends Control


@onready var cover: TextureRect = %"Cover"


var game: Game

var selected := false


func _ready() -> void:
	cover.texture = game.cover_texture
	set_selected(false)


func _process(delta: float) -> void:
	if not App.current.active: return
	
	var target_scale := 1.0 if selected else 0.8
	# scale = Vector2.ONE * move_toward(scale.x, target_scale, delta)
	scale = Vector2.ONE * lerpf(scale.x, target_scale, Math.smooth(10.0, delta))


func set_selected(selected: bool) -> void:
	self.selected = selected
