class_name GameDB extends RefCounted


const GAME_DIR := "user://games/"


static var games: Array[Game] = []


static func _static_init() -> void:
	print("Loading games...")
	
	for dir_name in DirAccess.get_directories_at(GAME_DIR):
		var dir := str(GAME_DIR,dir_name,"/")
		
		# Load Metadata
		var meta_path := str(dir,"game.json")
		if not FileAccess.file_exists(meta_path):
			printerr("Folder is missing ",meta_path.get_file())
			return
		
		var metadata := FileAccess.get_file_as_string(meta_path)
		var dict: Dictionary = JSON.parse_string(metadata)
		var game := Game.from_dict(dict)
		var id := StringName(GAME_DIR.get_file())
		game.id = id
		game.directory = dir
		
		# Load Cover
		for ext in [ "png", "webp", "jpg", "jpeg", ]:
			game.cover_texture = try_load_image(str(dir,"cover.",ext))
			if game.cover_texture: break
		
		if not game.cover_texture:
			printerr("No cover image found for \"",game.name,"\" (",game.id,")")
		
		var screenshots_dir := str(dir,"screenshots/")
		for screenshot_filename in DirAccess.get_files_at(screenshots_dir):
			var screenshot_path := screenshots_dir + screenshot_filename
			var screenshot := try_load_image(screenshot_path)
			if not screenshot:
				printerr("Failed to load screenshot ", screenshot_path)
				continue
			game.screenshot_textures.append(screenshot)
		
		games.append(game)
	
	print(games.size()," games found")


static func try_load_image(path: String) -> Texture2D:
	if not FileAccess.file_exists(path):
		return null
	var image := Image.load_from_file(path)
	var texture := ImageTexture.create_from_image(image)
	return texture
