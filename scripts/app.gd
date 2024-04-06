class_name App extends Control


static var current: App


var game_pid := -1
var is_game_running := false
var active = true


func _enter_tree() -> void:
	App.current = self


func _ready() -> void:
	for game in GameDB.games:
		print(game.name)
	
	set_active(true)


func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		print("About to quit, killing process")
		stop_game(game_pid)


func _process(delta: float) -> void:
	is_game_running = OS.is_process_running(game_pid)
	if not active and not is_game_running:
		set_active(true)
	
	if not active:
		if Input.is_action_just_pressed(&"menu_home"):
			stop_game(game_pid)
		if Input.is_action_just_pressed(&"menu_ok"):
			print("Ok pressed")


func launch_game(game: Game) -> void:
	var exe_path := ProjectSettings.globalize_path(game.directory + game.executable)
	print("Launching ",exe_path," "," ".join(game.arguments))
	game_pid = OS.create_process(exe_path, game.arguments)
	set_active(false)


func stop_game(pid: int) -> void:
	print("Trying to stop game")
	if not OS.is_process_running(pid): return
	OS.kill(pid)
	set_active(true)


func set_active(active: bool) -> void:
	if self.active == active: return
	self.active = active
	# Engine.max_fps = 0 if active else 5
