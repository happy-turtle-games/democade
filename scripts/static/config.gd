class_name Config extends RefCounted


static var games_path := "./games"
static var music_path := "./music"

static var shuffle_games := false
static var shuffle_credits := false
static var music_volume := 1.0


static func _static_init() -> void:
	prints(ProjectSettings.get_setting("application/config/name"), ProjectSettings.get_setting("application/config/version"))
	
	var app_dir := OS.get_executable_path().get_base_dir()
	
	var config_path := ""
	if OS.has_feature("editor"):
		print("Editor Mode")
		config_path = "user://config.json"
	else:
		print("Standalone Mode")
		config_path = app_dir.path_join("config.json")
	
	print("Loading config at ",config_path)
	
	if not FileAccess.file_exists(config_path):
		print("No config file found! Using default settings.")
		return
	
	var dict: Dictionary = JSON.parse_string(FileAccess.get_file_as_string(config_path))
	games_path = PathUtil.relative_path(dict.get("games_path", games_path), app_dir)
	music_path = PathUtil.relative_path(dict.get("music_path", music_path), app_dir)
	
	shuffle_games = dict.get("shuffle_games", shuffle_games)
	shuffle_credits = dict.get("shuffle_credits", shuffle_credits)
	music_volume = dict.get("music_volume", music_volume)
