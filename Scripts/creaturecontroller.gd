extends CharacterBody2D

signal breedSignal
signal dieSignal
@export var speed = 10
@export var minPh = 5.0
@export var maxPh = 9.0
@export var minSal = 5.0
@export var maxSal = 6.0
@export var health = 100.0
var localPh
var phStep
var localSal
var localSaturation = 1.0
var localAlpa = 1.0

var breedTimer = 300
var HLDiv = 5.0
@onready var color_sprite: Sprite2D = $Sprite2D
@onready var healthLabel: Label = $HealthLabel
var tank : Node2D
var rng = RandomNumberGenerator.new()
var lastBreed = 1
func _ready() -> void:
	color_sprite.modulate = Color(1,0,0,1)
	color_sprite.modulate.s = 1.0
	color_sprite.modulate.a = 1.0
	velocity = Vector2(0,0)
	breedTimer = rng.randf_range(300.0,500.0)
	#print("C X ", position.x, " Y " , position.y)
	#tank = get_tree().get_root().find_child("Tank")
	tank = find_parent("Tank")
func _physics_process(delta: float) -> void:
	lastBreed += 1
	breed()
	var direction = Vector2(
		randi_range(-1,1),
		randi_range(-1,1)
	)
	velocity = direction * speed
	var improveHealth = true
	# Update for PH
	if tank.ph > maxPh:
		localPh = ((tank.ph - maxPh)/(14.0 - maxPh))
		#localPh = get_parent().ph - maxPh
		localSaturation = 1.0 - localPh
		health -= localPh/HLDiv
		improveHealth = false
	if tank.ph < minPh:
		localPh = ((minPh - tank.ph)/(minPh))
		#localPh = get_parent().ph - maxPh
		localSaturation = 1.0 - localPh
		health -= localPh/HLDiv
		improveHealth = false
	#print("PH ", get_parent().ph, " ", localSaturation)
	#print("SAL ", color_sprite.modulate.s)
	# Update for Salinity
	if tank.salinity > maxSal:
		localSal = ((tank.salinity - maxSal)/(10.0 - maxSal))
		#localPh = get_parent().ph - maxPh
		localAlpa = 1.0 - localSal
		health -= localSal/HLDiv
		improveHealth = false
	if tank.salinity < minSal:
		localSal = ((minSal - tank.salinity)/(minSal))
		#localPh = get_parent().ph - maxPh
		localAlpa = 1.0 - localSal
		health -= localSal/HLDiv
		improveHealth = false
	if improveHealth:
		health += 0.05
	if health > 100:
		health = 100
	if health < 0:
		dieSignal.emit(self)
	move_and_slide()
	color_sprite.modulate.s = localSaturation
	color_sprite.modulate.a = localAlpa
	#print("S ", localSaturation, " A", localAlpa)
	
	healthLabel.text = str(health)

func breed() -> void:
	var doBreed = rng.randf_range(0.0,100.0)
	var adjustment = 100 - health
	doBreed = doBreed - adjustment
	if doBreed > 30.0 && lastBreed > breedTimer:
		lastBreed=0
		print("breed")
		breedSignal.emit()
		
func save():
	var save_dict = {"filename" : get_scene_file_path(),
		"parent" : get_parent().get_path(),
		"pos_x" : position.x, # Vector2 is not supported by JSON
		"pos_y" : position.y,
		"health" : health,
		"speed" : speed,
		"minPh" : minPh,
		"maxPh" : maxPh,
		"minSal" : minSal,
		"maxSal" : maxSal
		}
	return save_dict
