class_name Config extends RefCounted


const CONFIG_PATH := 'user://config.json'


static var games_path := "user://games/"


static func _static_init() -> void:
	if not FileAccess.file_exists(CONFIG_PATH):
		print("No config file found! Using default settings.")
		return
	
	var dict: Dictionary = JSON.parse_string(FileAccess.get_file_as_string(CONFIG_PATH))
	games_path = dict.get("games_path", games_path)
