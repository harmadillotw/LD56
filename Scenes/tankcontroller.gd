extends Node2D

const MAX_PH = 14.0
const MAX_SAL = 10.0
var ph = 7.0
var salinity = 5.0
var light = 10.0
var ph_change = 0.01
var salinity_change = 0.01
var creatureArray = []
var creatureCount = 0
var cash = 100
@onready var magContainer: SubViewportContainer = $SubViewportContainer
@onready var phLevel: Label = $PHLevelLabel
@onready var salLevel: Label = $SALLevelLabel
@onready var cashLabel: Label = $MoneyLabel
@onready var creatureNode2D: Node2D = $CreaturesNode2D
@onready var pauseNode: Node2D = $PauseMenuNode
@onready var saveButton: Button = $PauseMenuNode/SaveButton
@onready var loadButton: Button = $PauseMenuNode/LoadButton


var creatureScene = preload("res://Scenes/creature/Creature.tscn")
var rng = RandomNumberGenerator.new()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	magContainer.visible = false
	saveButton.visible = false
	loadButton.visible = false
	pauseNode.unpauseSignal.connect(_on_unpause)
		#instance.position = startLocation
		#instance.global_position = startLocation

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if Input.is_action_just_pressed("Maginfy"):
		magContainer.visible = !magContainer.visible
	#if Input.is_action_just_pressed("Pause"):
	#	if !get_tree().paused:
	#		get_tree().paused = !get_tree().paused
	#		saveButton.visible = !saveButton.visible
	#		loadButton.visible = !loadButton.visible
	phLevel.text = "PH: " + str(ph)
	salLevel.text = "Salinity: " + str(salinity)
	cashLabel.text = "Cash: " + str(cash)

func _input(_event): 
	if Input.is_action_just_pressed("Pause"):
		get_viewport().set_input_as_handled()
		if !get_tree().paused:
			get_tree().paused = !get_tree().paused
			saveButton.visible = !saveButton.visible
			loadButton.visible = !loadButton.visible
func _on_breed():
	print("do breed")
	add_creature(0)

func _on_unpause():
	saveButton.visible = !saveButton.visible
	loadButton.visible = !loadButton.visible
	
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
	

func add_creature(cost) -> void:
	if cost > 0 && cash <= 0:
		return
	var instance = creatureScene.instantiate()
	var startx = rng.randf_range(400.0,1000.0)
	var starty = rng.randf_range(150.0,500.0)
	var startLocation = Vector2(startx,starty)
	#var startLocation = Vector2(400,150)
	instance.position = startLocation
	instance.health = 100
	instance.velocity = Vector2(0,0)
	instance.breedSignal.connect(_on_breed)
	creatureArray.append(instance)
	creatureCount += 1
	cash -= cost
	print("Creature Count ", creatureCount)
	creatureNode2D.add_child(instance)
	

func _on_add_button_pressed() -> void:
	add_creature(1)

func _on_add_5_button_pressed() -> void:
	for n in 5:
		add_creature(1)

func _on_add_10_button_pressed() -> void:
	for n in 10:
		add_creature(1)

func sell_creature(repeat: bool) -> void:
	var cpos = rng.randi_range(0,creatureArray.size())
	var cNode = creatureArray.pop_at(cpos)
		#var cNode = creatureDit.get(cpos)
	if cNode !=null:
		creatureCount -= 1
		cash += 1
		print("Creature Count ", creatureCount)
		cNode.queue_free()
	else:
		if repeat:
			print("Creature(1) is null")
			sell_creature(false)
		else:
			print("Creature(2) is null")	
	#creature.erase(cpos)
func _on_sell_10_button_2_pressed() -> void:
	for n in 10:
		sell_creature(true)


func _on_sell_5_button_2_pressed() -> void:
	for n in 5:
		sell_creature(true)


func _on_sell_button_2_pressed() -> void:
	sell_creature(true)


func _on_save_button_pressed() -> void:
	save_game()
	
func save_game():
	var save_file = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for node in save_nodes:
		# Check the node is an instanced scene so it can be instanced again during load.
		if node.scene_file_path.is_empty():
			print("persistent node '%s' is not an instanced scene, skipped" % node.name)
			continue

		# Check the node has a save function.
		if !node.has_method("save"):
			print("persistent node '%s' is missing a save() function, skipped" % node.name)
			continue

		# Call the node's save function.
		var node_data = node.call("save")

		# JSON provides a static method to serialized JSON string.
		var json_string = JSON.stringify(node_data)

		# Store the save dictionary as a new line in the save file.
		save_file.store_line(json_string)


func _on_load_button_pressed() -> void:
	load_game()
	
func load_game():
	while creatureArray.size() > 0:
		var cNode = creatureArray.pop_at(0)
		cNode.queue_free()
	if not FileAccess.file_exists("user://savegame.save"):
		return # Error! We don't have a save to load.

	# We need to revert the game state so we're not cloning objects
	# during loading. This will vary wildly depending on the needs of a
	# project, so take care with this step.
	# For our example, we will accomplish this by deleting saveable objects.
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for i in save_nodes:
		i.queue_free()

	# Load the file line by line and process that dictionary to restore
	# the object it represents.
	var save_file = FileAccess.open("user://savegame.save", FileAccess.READ)
	while save_file.get_position() < save_file.get_length():
		var json_string = save_file.get_line()

		# Creates the helper class to interact with JSON.
		var json = JSON.new()

		# Check if there is any error while parsing the JSON string, skip in case of failure.
		var parse_result = json.parse(json_string)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			continue

		# Get the data from the JSON object.
		var node_data = json.data

		# Firstly, we need to create the object and add it to the tree and set its position.
		var new_object = load(node_data["filename"]).instantiate()
		get_node(node_data["parent"]).add_child(new_object)
		new_object.position = Vector2(node_data["pos_x"], node_data["pos_y"])
		
		# appliy needed variable
		new_object.health = node_data["health"]
		new_object.speed = node_data["speed"]
		new_object.minPh = node_data["minPh"]
		new_object.maxPh = node_data["maxPh"]
		new_object.minSal = node_data["minSal"]
		new_object.maxSal = node_data["maxSal"]
		# reconnect signals
		new_object.breedSignal.connect(_on_breed)
		# Now we set the remaining variables.
		for i in node_data.keys():
			if i == "filename" or i == "parent" or i == "pos_x" or i == "pos_y":
				continue
			new_object.set(i, node_data[i])
