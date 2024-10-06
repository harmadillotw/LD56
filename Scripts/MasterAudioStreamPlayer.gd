extends AudioStreamPlayer

const game_music = preload("res://Audio/track1s.wav")
const game_music2 = preload("res://Audio/track2s.wav")

var timeTrack = 0
var track
var rng = RandomNumberGenerator.new()

func _process(delta: float) -> void:
	timeTrack += 1
	if timeTrack > 18000:
		change_track()
	elif timeTrack > 14400:
		var chance = rng.randf_range(0.0,100.0)
		if chance < 20.0:
			change_track()
	elif timeTrack > 10800:
		var chance = rng.randf_range(0.0,100.0)
		if chance < 15.0:
			change_track()
	elif timeTrack > 7200:
		var chance = rng.randf_range(0.0,100.0)
		if chance < 10.0:
			change_track()
	elif timeTrack > 3600:
		var chance = rng.randf_range(0.0,100.0)
		if chance < 5.0:
			change_track()
		
func change_track():
	timeTrack = 0
	if track == 1:
		track = 2
		play_music_track2()
	else:
		track = 1
		play_music_track1()
		
func _play_music(music: AudioStream, volume = 0.0):
	if stream == music:
		return

	stream = music
	volume_db = volume
	play()
	
func play_music_game():
	_play_music(game_music,Global.musicVolume)
	track = 1	
	
func play_music_track1():
	_play_music(game_music,Global.musicVolume)
	track = 1
		
func play_music_track2():
	_play_music(game_music2,Global.musicVolume)
	track = 2
			
func set_volume(newVol: float):
	volume_db = newVol	
	
func play_fx(fx: AudioStream):
	var fx_player = AudioStreamPlayer.new()
	fx_player.stream = fx
	fx_player.volume_db = Global.fxVolume
	fx_player.name = "FX_PLAYER"
	add_child(fx_player)
	fx_player.play()
	await fx_player.finished
	fx_player.queue_free()
	
func play_fx_click():
	var click = load("res://Audio/click.wav")
	play_fx(click)
func play_fx_click2():
	var click = load("res://Audio/click2.wav")
	play_fx(click)
