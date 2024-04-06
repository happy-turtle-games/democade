class_name App extends Control


static var current: App


@export var hold_time_to_quit := 1.0


@onready var menu: Control = %"Menu"
@onready var help: Control = %"Help"
@onready var help_title: Label = %"Help Title"
@onready var help_text: RichTextLabel = %"Help Text"


var game_pid := -1
var is_game_running := false
var active := true
var is_help_open := false

var quit_hold_timer := 0.0


func _enter_tree() -> void:
	App.current = self


func _ready() -> void:
	for game in GameDB.games:
		print(game.title)
	
	set_active(true)
	close_help()


func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		print("About to quit, killing process")
		stop_game()


func _process(delta: float) -> void:
	is_game_running = OS.is_process_running(game_pid)
	if not active and not is_game_running:
		set_active(true)
		close_help()
	
	if not active:
		if Input.is_action_just_pressed(&"menu_home"):
			if is_help_open:
				close_help()
			else:
				open_help()
		
		if Input.is_action_pressed(&'menu_home'):
			quit_hold_timer += delta
			if quit_hold_timer > hold_time_to_quit:
				quit_hold_timer = 0.0
				stop_game()
		else:
			quit_hold_timer = 0.0


func launch_game(game: Game) -> void:
	var exe_path := ProjectSettings.globalize_path(game.directory + game.executable)
	print("Launching ",exe_path," "," ".join(game.arguments))
	game_pid = OS.create_process(exe_path, game.arguments)
	set_active(false)
	
	help_title.text = "How to play %s" % game.title
	help_text.text = game.help
	open_help()


func stop_game() -> void:
	print("Stopping game")
	set_active(true)
	close_help()
	if OS.is_process_running(game_pid):
		OS.kill(game_pid)


func set_active(active: bool) -> void:
	if self.active == active: return
	self.active = active
	menu.visible = active
	# Engine.max_fps = 0 if active else 5


func open_help() -> void:
	help.show()
	is_help_open = true


func close_help() -> void:
	help.hide()
	is_help_open = false
