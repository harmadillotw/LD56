extends Node2D

@onready var shrimp1: Sprite2D = $Sprite2D2
@onready var shrimp2: Sprite2D = $Sprite2D3
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	shrimp1.modulate = Color(1,0,0,1)
	shrimp2.modulate = Color(0,1,0,1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_new_button_pressed() -> void:
	Global.loadGame = false
	MasterAudioStreamPlayer.play_fx_click2()
	get_tree().change_scene_to_file("res://Scenes/TankScene.tscn")


func _on_load_button_pressed() -> void:
	Global.loadGame = true
	MasterAudioStreamPlayer.play_fx_click2()
	get_tree().change_scene_to_file("res://Scenes/TankScene.tscn")

func _on_options_button_pressed() -> void:
	MasterAudioStreamPlayer.play_fx_click2()
	get_tree().change_scene_to_file("res://Scenes/OptionScene.tscn")

func _on_credits_button_pressed() -> void:
	MasterAudioStreamPlayer.play_fx_click2()
	get_tree().change_scene_to_file("res://Scenes/CreditsScene.tscn")


func _on_exit_button_pressed() -> void:
	MasterAudioStreamPlayer.play_fx_click2()
	get_tree().quit()
