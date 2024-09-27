class_name Game extends RefCounted


static func from_disk(path: String) -> Game:
	# Load Metadata
	var meta_path := path.path_join("title.ini")
	if not FileAccess.file_exists(meta_path):
		printerr("Missing ",meta_path)
		return null
	
	var config := ConfigFile.new()
	config.load(meta_path)
	
	var game := from_config(config)
	game.id = StringName(path.get_file())
	game.directory = path
	
	# Load cover
	for ext in [ "png", "webp", "jpg", "jpeg", ]:
		game.cover_texture = try_load_image(path.path_join("cover."+ext))
		if game.cover_texture: break
	
	if not game.cover_texture:
		printerr("No cover image found for \"",game.title,"\" (",game.id,")")
	
	# Load images
	var images_dir := path.path_join("images")
	for image_filename in DirAccess.get_files_at(images_dir):
		var image_path := images_dir.path_join(image_filename)
		var image := try_load_image(image_path)
		if not image:
			printerr("Failed to load image ", image_path)
			continue
		game.image_textures.append(image)
	
	# Load about
	var about_path := path.path_join("about.txt")
	if FileAccess.file_exists(about_path):
		game.about = FileAccess.get_file_as_string(about_path).strip_edges()
	else:
		game.about = "No description provided!\nPlease create a 'about.txt' file in the game folder."
	
	# Load credits
	var credits_path := path.path_join("credits.txt")
	if FileAccess.file_exists(credits_path):
		game.credits.assign(FileAccess.get_file_as_string(credits_path).strip_edges().split("\n"))
		if game.shuffle_credits:
			game.credits.shuffle()
	
	# Load help
	var help_path := path.path_join("help.txt")
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


static func from_config(config: ConfigFile) -> Game:
	var game := Game.new()
	
	game.title = config.get_value("game", "title", "Untitled Game")
	game.exec = config.get_value("game", "exec", "")
	game.args.assign(config.get_value("game", "args", []))
	
	game.play_music = config.get_value("music", "enable", false)
	
	game.show_cursor = config.get_value("input", "use_mouse", false)
	
	game.shuffle_credits = config.get_value("credits", "shuffle", Config.shuffle_credits)
	
	return game


var id := &""
var directory := ""

var title := ""
var about := ""
var credits: Array[String] = []
var help := ""

var shuffle_credits := false
var play_music := false
var show_cursor := false

var cover_texture: Texture2D
var image_textures: Array[Texture2D] = []

var exec := ""
var args: Array[String] = []
