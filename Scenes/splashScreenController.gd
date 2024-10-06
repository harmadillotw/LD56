extends Node2D

const pre_main_menu = preload("res://Scenes/MainMenuScene.tscn")

@onready var shrimp1: Sprite2D = $Sprite2D2
@onready var shrimp2: Sprite2D = $Sprite2D3
@onready var shrimp3: Sprite2D = $Sprite2D4

var user_prefs: UserPreference


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	shrimp1.modulate = Color(1,0,0,1)
	shrimp2.modulate = Color(0,1,0,1)
	shrimp3.modulate = Color(0,0,1,1)

	user_prefs = UserPreferences.load_or_create()
	Global.fxVolume = user_prefs.fx_volume
	Global.musicVolume = user_prefs.music_volume
	MasterAudioStreamPlayer.set_volume(Global.musicVolume)
	MasterAudioStreamPlayer.play_music_game()
	await get_tree().create_timer(4.0).timeout
	get_tree().change_scene_to_packed(pre_main_menu)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
