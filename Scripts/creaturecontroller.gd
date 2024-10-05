extends CharacterBody2D

@export var speed = 10
@export var minPh = 5.0
@export var maxPh = 9.0
@export var minSal = 5.0
@export var maxSal = 6.0
@export var health = 90.0
var localPh
var phStep
var localSal
var localSaturation = 1.0
var localAlpa = 1.0
@onready var color_sprite: Sprite2D = $Sprite2D
var tank : Node2D

func _ready() -> void:
	color_sprite.modulate = Color(1,0,0,1)
	color_sprite.modulate.s = 1.0
	color_sprite.modulate.a = 1.0
	velocity = Vector2(0,0)
	print("C X ", position.x, " Y " , position.y)
	#tank = get_tree().get_root().find_child("Tank")
	tank = find_parent("Tank")
func _physics_process(delta: float) -> void:

	var direction = Vector2(
		randi_range(-1,1),
		randi_range(-1,1)
	)
	velocity = direction * speed
	
	# Update for PH
	if tank.ph > maxPh:
		localPh = ((tank.ph - maxPh)/(14.0 - maxPh))
		#localPh = get_parent().ph - maxPh
		localSaturation = 1.0 - localPh
	if tank.ph < minPh:
		localPh = ((minPh - tank.ph)/(minPh))
		#localPh = get_parent().ph - maxPh
		localSaturation = 1.0 - localPh
	#print("PH ", get_parent().ph, " ", localSaturation)
	#print("SAL ", color_sprite.modulate.s)
	# Update for Salinity
	if tank.salinity > maxSal:
		localSal = ((tank.salinity - maxSal)/(10.0 - maxSal))
		#localPh = get_parent().ph - maxPh
		localAlpa = 1.0 - localSal
	if tank.salinity < minSal:
		localSal = ((minSal - tank.salinity)/(minSal))
		#localPh = get_parent().ph - maxPh
		localAlpa = 1.0 - localSal
	
	move_and_slide()
	color_sprite.modulate.s = localSaturation
	color_sprite.modulate.a = localAlpa
	#print("S ", localSaturation, " A", localAlpa)
