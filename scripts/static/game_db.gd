class_name GameDB extends RefCounted


static var games: Array[Game] = []


static func _static_init() -> void:
	print("Loading games...")
	
	for dirname in DirAccess.get_directories_at(Config.games_path):
		var path := Config.games_path.path_join(dirname)
		var game := Game.from_disk(path)
		if not game: continue
		games.append(game)
	
	print(games.size()," games found:")
	for game in GameDB.games:
		print(" - \"",game.title,"\" (",game.id,")")
	
	if Config.shuffle_games:
		games.shuffle()
