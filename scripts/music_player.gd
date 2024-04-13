class_name MusicPlayer extends AudioStreamPlayer


@export var fade_in_speed := 1.0
@export var fade_out_speed := 1.0


var song_paths: Array[String] = []

var muted := false
var volume := 0.0


func _ready() -> void:
	for file_name in DirAccess.get_files_at(Config.music_path):
		if not(
			file_name.ends_with(".mp3") or
			file_name.ends_with(".ogg")
		): continue
		
		song_paths.append(Config.music_path.path_join(file_name))
	
	finished.connect(play_song)
	play_song()


func _process(delta: float) -> void:
	var speed := fade_out_speed if muted else fade_in_speed
	var target_volume := 0.0 if muted else 1.0
	volume = move_toward(volume, target_volume, speed * delta)
	volume_db = linear_to_db(volume * Config.music_volume)


func play_song() -> void:
	if song_paths.size() <= 0: return
	
	for iteration in 100:
		var song_path := song_paths.pick_random()
		if not FileAccess.file_exists(song_path):
			printerr("Song no longer exists ", song_path)
			continue
		
		var song: AudioStream
		if song_path.ends_with(".mp3"):
			song = AudioStreamMP3.new()
			song.data = FileAccess.get_file_as_bytes(song_path)
		elif song_path.ends_with(".ogg"):
			song = AudioStreamOggVorbis.new()
			song.load_from_file(song_path)
		
		if not song:
			printerr("Unsupported song format ", song_path)
			continue
		
		stream = song
		play()
		return
	
	printerr("Failed to play a song too many times. Giving up.")
