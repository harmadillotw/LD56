extends AudioStreamPlayer

const game_music = preload("res://Audio/track1s.wav")
const game_music2 = preload("res://Audio/track2s.wav")
func _play_music(music: AudioStream, volume = 0.0):
	if stream == music:
		return

	stream = music
	volume_db = volume
	play()
	
func play_music_game():
	_play_music(game_music,Global.musicVolume)

func play_music_track1():
	_play_music(game_music,Global.musicVolume)

func play_music_track2():
	_play_music(game_music2,Global.musicVolume)
	
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
