class_name Game extends RefCounted


static func from_disk(path: String) -> Game:
	# Load Metadata
	var meta_path := str(path,"meta.json")
	if not FileAccess.file_exists(meta_path):
		printerr("Folder is missing ",meta_path.get_file())
		return null
	
	var metadata := FileAccess.get_file_as_string(meta_path)
	var dict: Dictionary = JSON.parse_string(metadata)
	var game := from_dict(dict)
	game.id = StringName(path.get_file())
	game.directory = path
	
	# Load cover
	for ext in [ "png", "webp", "jpg", "jpeg", ]:
		game.cover_texture = try_load_image(str(path,"cover.",ext))
		if game.cover_texture: break
	
	if not game.cover_texture:
		printerr("No cover image found for \"",game.title,"\" (",game.id,")")
	
	# Load screenshots
	var screenshots_dir := str(path,"screenshots/")
	for screenshot_filename in DirAccess.get_files_at(screenshots_dir):
		var screenshot_path := screenshots_dir + screenshot_filename
		var screenshot := try_load_image(screenshot_path)
		if not screenshot:
			printerr("Failed to load screenshot ", screenshot_path)
			continue
		game.screenshot_textures.append(screenshot)
	
	# Load about
	var about_path := str(path,"about.txt")
	if FileAccess.file_exists(about_path):
		game.about = FileAccess.get_file_as_string(about_path).strip_edges()
	else:
		game.about = "No description provided!\nPlease create a 'about.txt' file in the game folder."
	
	# Load credits
	var credits_path := str(path,"credits.txt")
	if FileAccess.file_exists(credits_path):
		game.credits.assign(FileAccess.get_file_as_string(credits_path).split("\n"))
	
	# Load help
	var help_path := str(path,"help.txt")
	if FileAccess.file_exists(help_path):
		game.help = FileAccess.get_file_as_string(help_path).strip_edges()
	else:
		game.help = "No instructions provided!\nPlease create a 'help.txt' file in the game folder."
	
	return game


static func try_load_image(path: String) -> Texture2D:
	if not FileAccess.file_exists(path):
		return null
	var image := Image.load_from_file(path)
	var texture := ImageTexture.create_from_image(image)
	return texture


static func from_dict(dict: Dictionary) -> Game:
	var game := Game.new()
	
	game.title = dict.get("title", "")
	game.date = dict.get("date", "")
	
	game.continue_playing_menu_music = dict.get("continue_playing_menu_music", false)
	
	game.executable = dict.get("executable", "")
	game.arguments.assign(dict.get("arguments", []))
	
	return game


var id := &""
var directory := ""

var title := ""
var date := ""
var about := ""
var credits: Array[String] = []
var help := ""

var continue_playing_menu_music := false

var cover_texture: Texture2D
var screenshot_textures: Array[Texture2D] = []

var executable := ""
var arguments: Array[String] = []
