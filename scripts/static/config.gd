class_name Config extends RefCounted


static var config := ConfigFile.new()

# SETTINGS
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
		config_path = "user://democade.ini"
	else:
		print("Standalone Mode")
		config_path = app_dir.path_join("democade.ini")
	
	print("Loading config at ",config_path)
	
	if not FileAccess.file_exists(config_path):
		print("No config file found! Using default settings.")
		return
	
	config.load(config_path)
	
	games_path = PathUtil.relative_path(config.get_value("games", "path", games_path), app_dir)
	music_path = PathUtil.relative_path(config.get_value("music", "path", music_path), app_dir)
	
	shuffle_games = config.get_value("games", "shuffle", shuffle_games)
	shuffle_credits = config.get_value("credits", "shuffle", shuffle_credits)
	music_volume = config.get_value("music", "volume", music_volume)


static func merge_configs(base: ConfigFile, override: ConfigFile) -> ConfigFile:
	var out := ConfigFile.new()
	
	# clone base
	for section in base.get_sections():
		for key in base.get_section_keys(section):
			var value := base.get_value(section, key)
			out.set_value(section, key, value)
	
	apply_config(out, override)
	
	return out


static func apply_config(config: ConfigFile, override: ConfigFile) -> void:
	for section in override.get_sections():
		for key in override.get_section_keys(section):
			var value := override.get_value(section, key)
			config.set_value(section, key, value)
