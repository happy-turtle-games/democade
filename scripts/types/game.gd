class_name Game extends RefCounted


static func from_dict(dict: Dictionary) -> Game:
	var game := Game.new()
	
	game.name = dict.get("name", "")
	game.date = dict.get("date", "")
	game.description = "\n".join(dict.get("description", []))
	game.credits.assign(dict.get("credits", []))
	
	game.continue_playing_menu_music = dict.get("continue_playing_menu_music", false)
	
	game.executable = dict.get("executable", "")
	game.arguments.assign(dict.get("arguments", []))
	
	return game


var id := &""
var directory := ""

var name := ""
var date := ""
var description := ""
var credits: Array[String] = []

var continue_playing_menu_music := false

var cover_texture: Texture2D
var screenshot_textures: Array[Texture2D] = []

var executable := ""
var arguments: Array[String] = []
