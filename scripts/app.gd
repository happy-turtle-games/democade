class_name App extends Control


static var current: App


@export var time_to_start_quit := 0.2
@export var time_to_quit := 1.0


@onready var launcher: Launcher = %"Launcher"
@onready var help: Control = %"Help"
@onready var help_title: Label = %"Help Title"
@onready var help_text: RichTextLabel = %"Help Text"
@onready var help_prompt: CanvasItem = %"Help Prompt"
@onready var quit_bar: ProgressBar = %"Quit Bar"
@onready var overlay_label: Label = %"Overlay Label"
@onready var music_player: MusicPlayer = %"Music Player"


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
	set_active(true)
	close_help()
	overlay_label.hide()



func _input(event: InputEvent) -> void:
	if active: return
	
	if event.is_action_pressed(&"menu_home"):
		if not is_help_open:
			%"SFX Open".play()
			open_help()
			help_prompt.hide()
			quit_bar.show()
			is_opening_help = true
		return
	
	if event.is_action_released(&"menu_home"):
		if is_help_open and quit_timer < time_to_start_quit:
			if is_opening_help:
				is_opening_help = false
				return
			close_help()
			%"SFX Close".play()
		return


func _process(delta: float) -> void:
	is_game_running = OS.is_process_running(game_pid)
	
	if not active:
		_process_inactive(delta)


func _process_inactive(delta: float) -> void:
	if not is_game_running or not is_instance_valid(game):
		set_active(true)
		close_help()
		return
	
	if not game.show_cursor:
		if OS.has_feature("standalone"):
			Input.warp_mouse(Vector2.ONE * 999999)
	
	game_uptime += delta
	var minutes := int(game_uptime / 60)
	var seconds := int(game_uptime) % 60
	overlay_label.text = str(game.title," ",str(minutes).pad_zeros(2),":",str(seconds).pad_zeros(2))
	
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
	%"SFX Start".play()
	overlay_label.show()
	game_uptime = 0.0
	self.game = game
	
	var exec := PathUtil.relative_path(game.exec, ProjectSettings.globalize_path(game.directory))
	
	print("Launching ",exec," "," ".join(game.args))
	game_pid = OS.create_process(exec, game.args)
	set_active(false)
	
	help_title.text = "How to play %s" % game.title
	help_text.text = game.help
	help_prompt.show()
	quit_bar.hide()
	open_help()


func stop_game() -> void:
	%"SFX Quit".play()
	print("Stopping game ",overlay_label.text)
	overlay_label.hide()
	set_active(true)
	close_help()
	if OS.is_process_running(game_pid):
		OS.kill(game_pid)
	
	game = null


func set_active(active: bool) -> void:
	if self.active == active: return
	self.active = active
	launcher.visible = active
	launcher.process_mode = Node.PROCESS_MODE_INHERIT if active else Node.PROCESS_MODE_DISABLED
	music_player.muted = not active and not game.play_music


func open_help() -> void:
	is_help_open = true
	help.show()
	help.process_mode = Node.PROCESS_MODE_INHERIT


func close_help() -> void:
	is_help_open = false
	help.hide()
	help.process_mode = Node.PROCESS_MODE_DISABLED
