class_name GamePicker extends Control


const GAME_BUTTON_SCENE: PackedScene = preload('res://scenes/game_button.tscn')


var index := 0
var selected_button: GameButton


func _ready() -> void:
	for game in GameDB.games:
		var game_button: GameButton = GAME_BUTTON_SCENE.instantiate()
		game_button.game = game
		add_child(game_button)
	
	update_selected()


func _process(delta: float) -> void:
	if not App.current.active: return
	
	if Input.is_action_just_pressed(&'menu_ok'):
		App.current.launch_game(GameDB.games[index])
		return
	
	if Input.is_action_just_pressed(&"menu_left"):
		index -= 1
		update_selected()
	
	if Input.is_action_just_pressed(&"menu_right"):
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
