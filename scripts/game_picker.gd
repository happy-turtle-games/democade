class_name GamePicker extends Control


const GAME_BUTTON_SCENE: PackedScene = preload('res://scenes/game_button.tscn')


@export var spacing := 0.0


@onready var title: Label = %"Title"
@onready var about: RichTextLabel = %"About"
@onready var background: FadingBG = %"Background"
@onready var credits: Marquee = %"Credits"


var index := 0
var selected_button: GameButton

var button_offset := 10.0


func _ready() -> void:
	for game in GameDB.games:
		var game_button: GameButton = GAME_BUTTON_SCENE.instantiate()
		game_button.game = game
		# game_button.size.x = 0.0
		game_button.size.y = size.y
		add_child(game_button)
		game_button.position.x = button_offset
		button_offset += game_button.size.x
		button_offset += spacing
	
	if GameDB.games.size() > 0:
		update_selected()


func _process(delta: float) -> void:
	if not App.current.active: return
	
	if Input.is_action_just_pressed(&'menu_ok'):
		App.current.launch_game(GameDB.games[index])
		return
	
	if Input.is_action_just_pressed(&"menu_left"):
		%"SFX Nav Left".play()
		index -= 1
		update_selected()
	
	if Input.is_action_just_pressed(&"menu_right"):
		%"SFX Nav Right".play()
		index += 1
		update_selected()
	
	var target_position := selected_button.position.x
	target_position -= size.x / 2.0
	target_position += selected_button.size.x / 2.0
	position.x = lerp(position.x, -target_position, Math.smooth(10.0, delta))


func update_selected() -> void:
	if is_instance_valid(selected_button):
		selected_button.set_selected(false)
	index = wrapi(index, 0, GameDB.games.size())
	selected_button = get_child(index)
	selected_button.set_selected(true)
	
	var game := selected_button.game
	title.text = game.title
	about.text = game.about
	credits.lines[0] = "     ".join(game.credits) + "     /     "
	credits.lines[1] = credits.lines[0]
	credits._rebuild()
	
	switch_bg()


func switch_bg() -> void:
	var game := selected_button.game
	if game.screenshot_textures.size() <= 0: return
	background.switch(game.screenshot_textures.pick_random())
