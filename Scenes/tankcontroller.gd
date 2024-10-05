extends Node2D

const MAX_PH = 14.0
const MAX_SAL = 10.0
var ph = 7.0
var salinity = 5.0
var light = 10.0
var ph_change = 0.01
var salinity_change = 0.01
@onready var magContainer: SubViewportContainer = $SubViewportContainer
@onready var phLevel: Label = $PHLevelLabel
@onready var salLevel: Label = $SALLevelLabel
@onready var creatureNode2D: Node2D = $CreaturesNode2D
var creatureScene = preload("res://Scenes/creature/Creature.tscn")
var rng = RandomNumberGenerator.new()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	magContainer.visible = false
	for n in 100:
		var instance = creatureScene.instantiate()
		var startx = rng.randf_range(400.0,1000.0)
		var starty = rng.randf_range(150.0,500.0)
		var startLocation = Vector2(startx,starty)
		#var startLocation = Vector2(400,150)
		instance.position = startLocation
		instance.health = 100
		instance.velocity = Vector2(0,0)
		print("X ", instance.position.x, " Y ", instance.position.y)
		print("X ", instance.global_position.x, " Y ", instance.global_position.y)
		creatureNode2D.add_child(instance)
		print("X ", instance.position.x, " Y " , instance.position.y)
		print("X ", instance.global_position.x, " Y ", instance.global_position.y)
		#instance.position = startLocation
		#instance.global_position = startLocation

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Maginfy"):
		magContainer.visible = !magContainer.visible
	phLevel.text = "PH: " + str(ph)
	salLevel.text = "Salinity: " + str(salinity)


func _on_button_pressed() -> void:
	ph += 0.2
	if ph > MAX_PH:
		ph = MAX_PH

func _on_ph_minus_button_pressed() -> void:
	ph -= 0.2
	if ph < 0.0:
		ph = 0.0

func _on_sal_plus_button_pressed() -> void:
	salinity += 0.2
	if salinity > MAX_SAL:
		salinity = MAX_SAL


func _on_sal_minus_button_pressed() -> void:
	salinity -= 0.2
	if salinity < 0.0:
		salinity = 0.0


func _on_mag_button_pressed() -> void:
	
	magContainer.visible = !magContainer.visible
	

	
		
		
