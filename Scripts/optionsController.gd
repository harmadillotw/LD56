extends Node2D

var user_prefs: UserPreferences
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_return_button_pressed() -> void:
	MasterAudioStreamPlayer.play_fx_click2()
	get_tree().change_scene_to_file("res://Scenes/MainMenuScene.tscn")


func _on_music_h_slider_value_changed(value: float) -> void:
	Global.musicVolume = value
	
	MasterAudioStreamPlayer.set_volume(value)
	if user_prefs:
		user_prefs.music_volume = value
		user_prefs.save()


func _on_fxh_slider_value_changed(value: float) -> void:
	Global.fxVolume = value
	
	if user_prefs:
		user_prefs.fx_volume = value
		user_prefs.save()
