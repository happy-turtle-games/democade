class_name GameDB extends RefCounted


static var games: Array[Game] = []


static func _static_init() -> void:
	print("Loading games...")
	
	for dir_name in DirAccess.get_directories_at(Config.games_path):
		var dir := str(Config.games_path,dir_name,"/")
		var game := Game.from_disk(dir)
		if not game: continue
		games.append(game)
	
	print(games.size()," games found")
