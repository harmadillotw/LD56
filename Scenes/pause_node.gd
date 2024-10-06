extends Node2D

signal unpauseSignal

@onready var saveButton: Button = $Panel/VBoxContainer/SaveButton
@onready var loadButton: Button = $Panel/VBoxContainer/LoadButton
@onready var pauseNode: Node2D = $PauseMenuNode
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
		


func _on_resume_button_pressed() -> void:
	pass
	#get_tree().paused = !get_tree().paused
	#unpauseSignal.emit()
	
func _input(_event): 
	if Input.is_action_just_pressed("Pause"):
		get_viewport().set_input_as_handled()
		if get_tree().paused:
			get_tree().paused = !get_tree().paused
			#saveButton.visible = !saveButton.visible
			#loadButton.visible = !loadButton.visible
			visible = !visible
