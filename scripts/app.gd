class_name App extends Control


static var current: App


@export var time_to_start_quit := 0.2
@export var time_to_quit := 1.0


@onready var menu: Control = %"Menu"
@onready var help: Control = %"Help"
@onready var help_title: Label = %"Help Title"
@onready var help_text: RichTextLabel = %"Help Text"
@onready var help_prompt: CanvasItem = %"Help Prompt"
@onready var quit_bar: ProgressBar = %"Quit Bar"
@onready var overlay_label: Label = %"Overlay Label"


var game: Game
var game_pid := -1
var game_uptime := 0.0
var is_game_running := false
var active := true
var is_help_open := false
var is_opening_help := false

var quit_timer := 0.0


func _enter_tree() -> void:
	App.current = self


func _ready() -> void:
	for game in GameDB.games:
		print(game.title)
	
	set_active(true)
	close_help()
	overlay_label.hide()


func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		print("About to quit, killing process")
		stop_game()


func _process(delta: float) -> void:
	is_game_running = OS.is_process_running(game_pid)
	
	if not active:
		_process_inactive(delta)


func _process_inactive(delta: float) -> void:
	if not is_game_running:
		set_active(true)
		close_help()
		return
	
	game_uptime += delta
	var minutes := int(game_uptime / 60)
	var seconds := int(game_uptime) % 60
	overlay_label.text = str(game.title," ",str(minutes).pad_zeros(2),":",str(seconds).pad_zeros(2))
	
	# Help Menu close/quit
	if not is_help_open and Input.is_action_just_pressed(&"menu_home"):
			open_help()
			help_prompt.hide()
			quit_bar.show()
			is_opening_help = true
	elif (
		is_help_open and
		quit_timer < time_to_start_quit and
		Input.is_action_just_released(&"menu_home")
	):
		if is_opening_help:
			is_opening_help = false
		else:
			close_help()
	
	if Input.is_action_pressed(&'menu_home') and is_help_open:
		quit_timer += delta
		if quit_timer > time_to_quit + time_to_start_quit:
			quit_timer = 0.0
			stop_game()
	else:
		quit_timer = 0.0
	
	if quit_timer > time_to_start_quit:
		quit_bar.value = (quit_timer - time_to_start_quit) / time_to_quit * quit_bar.max_value
	else:
		quit_bar.value = 0.0


func launch_game(game: Game) -> void:
	overlay_label.show()
	game_uptime = 0.0
	self.game = game
	
	var exec_path := game.exec\
		.replace("./", ProjectSettings.globalize_path(game.directory))
	
	print("Launching ",exec_path," "," ".join(game.args))
	game_pid = OS.create_process(exec_path, game.args)
	set_active(false)
	
	help_title.text = "How to play %s" % game.title
	help_text.text = game.help
	help_prompt.show()
	quit_bar.hide()
	open_help()


func stop_game() -> void:
	print("Stopping game ",overlay_label.text)
	overlay_label.hide()
	set_active(true)
	close_help()
	if OS.is_process_running(game_pid):
		OS.kill(game_pid)


func set_active(active: bool) -> void:
	if self.active == active: return
	self.active = active
	menu.visible = active


func open_help() -> void:
	help.show()
	is_help_open = true


func close_help() -> void:
	help.hide()
	is_help_open = false
