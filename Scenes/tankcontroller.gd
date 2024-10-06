extends Node2D

const MAX_PH = 14.0
const MAX_SAL = 10.0
# Products
var redShrimp = 0
var blueShrimp = 0
var greenShrimp = 0
var pH65Buffer = 0
var pH72Buffer = 0
var pH83Buffer = 0
var naturalSalt = 0
var declorinator = 0
var pHTestKit = 0
var salinityTestKit = 0



var ph = 4.0
var salinity = 1.0
var light = 10.0
var ph_change = 0.01
var salinity_change = 0.01
var creatureArray = []
var creatureCount = 0



@onready var magContainer: SubViewportContainer = $SubViewportContainer
#@onready var phLevel: Label = $PHLevelLabel
#@onready var salLevel: Label = $SALLevelLabel
@onready var cashLabel: Label = $MoneyLabel
@onready var creatureNode2D: Node2D = $CreaturesNode2D
@onready var pauseNode: Node2D = $PauseMenuNode
@onready var shopNode: Node2D = $Shop
@onready var saveButton: Button = $PauseMenuNode/SaveButton
@onready var loadButton: Button = $PauseMenuNode/LoadButton
@onready var itemsContainer: HBoxContainer = $ItemsHBoxContainer
@onready var phLevelDisplay: AnimatedSprite2D = $PHAnimatedSprite2D
@onready var salLevelDisplay: AnimatedSprite2D = $SalAnimatedSprite2D


var creatureScene = preload("res://Scenes/creature/Creature.tscn")
var itemContainerScene = preload("res://Scenes/itemContainer.tscn")
var rng = RandomNumberGenerator.new()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.cash = 300
	magContainer.visible = false
	saveButton.visible = false
	loadButton.visible = false
	shopNode.visible = false
	pauseNode.unpauseSignal.connect(_on_unpause)
	shopNode.exitShopSignal.connect(_on_exit_shop)
	shopNode.buyItemSignal.connect(_on_buy_shop_item)
	populateItems()
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
	#phLevel.text = "PH: " + str(ph)
	#salLevel.text = "Salinity: " + str(salinity)
	cashLabel.text = "Cash: " + str(Global.cash)

func _input(_event): 
	if Input.is_action_just_pressed("Pause"):
		get_viewport().set_input_as_handled()
		if !get_tree().paused:
			get_tree().paused = !get_tree().paused
			saveButton.visible = !saveButton.visible
			loadButton.visible = !loadButton.visible
			
func populateItems():
	addItem(Global.ITEM_SET.RED_SHRIMP,3)
	addItem(Global.ITEM_SET.BLUE_SHRIMP,0)
	addItem(Global.ITEM_SET.GREEN_SHRIMP,0)
	addItem(Global.ITEM_SET.PH_65_BUFFER,0)
	addItem(Global.ITEM_SET.PH_72_BUFFER,0)
	addItem(Global.ITEM_SET.PH_85_BUFFER,10)
	addItem(Global.ITEM_SET.NATURAL_SALT, 1)
	addItem(Global.ITEM_SET.DECHLORINATOR,1)
	addItem(Global.ITEM_SET.PH_TEST_KIT,5)
	addItem(Global.ITEM_SET.SALINITY_TEST_KIT, 5)
	pass
func addItem(type, count):
	var instance = itemContainerScene.instantiate()
	instance.type = type
	instance.count =count
	instance.useItemSignal.connect(_on_use_item)
	Global.items_dict[type] = instance
	itemsContainer.add_child(instance)
	
func _on_use_item(type : Global.ITEM_SET):
	match type:
		Global.ITEM_SET.RED_SHRIMP:
			for n in 10:
				add_creature(1,Global.ITEM_SET.RED_SHRIMP)
		Global.ITEM_SET.BLUE_SHRIMP:
			for n in 10:
				add_creature(1,Global.ITEM_SET.BLUE_SHRIMP)
		Global.ITEM_SET.GREEN_SHRIMP:
			for n in 10:
				add_creature(1,Global.ITEM_SET.GREEN_SHRIMP)
		Global.ITEM_SET.PH_65_BUFFER:
			descreasePh()
		Global.ITEM_SET.PH_72_BUFFER:
			descreasePh()
		Global.ITEM_SET.PH_85_BUFFER:
			increasePh()
		Global.ITEM_SET.NATURAL_SALT:
			increaseSalt()
		Global.ITEM_SET.DECHLORINATOR:
			decreaseSalt()
		Global.ITEM_SET.PH_TEST_KIT:
			do_ph_test()
		Global.ITEM_SET.SALINITY_TEST_KIT:
			do_salinity_test()
			
func do_ph_test():
	#phLevel.text = "PH: " + str(ph)
	phLevelDisplay.play()
	await phLevelDisplay.animation_finished
	phLevelDisplay.get_node("Label").text = str(ph)
func do_salinity_test():
	#salLevel.text = "Salinity: " + str(salinity)
	salLevelDisplay.play()
	await salLevelDisplay.animation_finished
	salLevelDisplay.get_node("Label").text = str(salinity)
func _on_breed(type):
	print("do breed")
	if creatureCount < Global.max_creature_count:
		add_creature(0,type)
func _on_die(creature):
	var cindex = creatureArray.find(creature)
	if cindex < creatureCount:
		var toDelete = creatureArray.pop_at(cindex)
		toDelete.queue_free()
		creatureCount -= 1
func _on_unpause():
	saveButton.visible = !saveButton.visible
	loadButton.visible = !loadButton.visible
func _on_exit_shop():
	if get_tree().paused:
		get_tree().paused = !get_tree().paused
	shopNode.visible = false
func _on_buy_shop_item(type : Global.ITEM_SET):
	pass
	#Global.items_dict[type].count += 1
	
func increasePh() -> void:
	ph += 0.2
	if ph > MAX_PH:
		ph = MAX_PH
func descreasePh():
	ph -= 0.2
	if ph < 0.0:
		ph = 0.0
			

func increaseSalt() -> void:
	salinity += 0.2
	if salinity > MAX_SAL:
		salinity = MAX_SAL


func decreaseSalt() -> void:
	salinity -= 0.2
	if salinity < 0.0:
		salinity = 0.0


func _on_mag_button_pressed() -> void:
	
	magContainer.visible = !magContainer.visible
	

func add_creature(cost, type) -> void:
	if cost > 0 && Global.cash <= 0:
		return
	var instance = creatureScene.instantiate()
	var startx = rng.randf_range(400.0,1080.0)
	var starty = rng.randf_range(250.0,500.0)
	var startLocation = Vector2(startx,starty)
	#var startLocation = Vector2(400,150)
	instance.position = startLocation
	instance.health = 90 + rng.randf_range(0.0,10.0)
	instance.velocity = Vector2(0,0)
	match type:
		Global.ITEM_SET.RED_SHRIMP:
			instance.minPh = 5.0
			instance.maxPh = 9.0
			instance.minSal = 0.0
			instance.maxSal = 2.0
		Global.ITEM_SET.BLUE_SHRIMP:
			instance.minPh = 7.0
			instance.maxPh = 10.0
			instance.minSal = 0.0
			instance.maxSal = 4.0
		Global.ITEM_SET.GREEN_SHRIMP:
			instance.minPh = 9.0
			instance.maxPh = 12.0
			instance.minSal = 3.0
			instance.maxSal = 8.0
	instance.type = type
	instance.breedSignal.connect(_on_breed)
	instance.dieSignal.connect(_on_die)
	creatureArray.append(instance)
	creatureCount += 1
	Global.cash -= cost
	print("Creature Count ", creatureCount)
	creatureNode2D.add_child(instance)
	

func sell_creature(repeat: bool) -> void:
	var cpos = rng.randi_range(0,creatureArray.size())
	var cNode = creatureArray.pop_at(cpos)
		#var cNode = creatureDit.get(cpos)
	if cNode !=null:
		creatureCount -= 1
		Global.cash += 1
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
	var save_main_nodes = get_tree().get_nodes_in_group("Persist_Main")
	for node in save_main_nodes:
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

		if node_data.has("health"):
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
			new_object.dieSignal.connect(_on_die)
			# Now we set the remaining variables.
			for i in node_data.keys():
				if i == "filename" or i == "parent" or i == "pos_x" or i == "pos_y":
					continue
				new_object.set(i, node_data[i])
		else:	
			Global.cash = node_data["cash"]
			Global.items_dict[Global.ITEM_SET.RED_SHRIMP].count= node_data["items_red"]
			Global.items_dict[Global.ITEM_SET.GREEN_SHRIMP].count = node_data["items_green"]
			Global.items_dict[Global.ITEM_SET.BLUE_SHRIMP].count = node_data["items_blue"]
			Global.items_dict[Global.ITEM_SET.PH_65_BUFFER].count = node_data["items_65"]
			Global.items_dict[Global.ITEM_SET.PH_72_BUFFER].count = node_data["items_72"]
			Global.items_dict[Global.ITEM_SET.PH_85_BUFFER].count = node_data["items_85"]
			Global.items_dict[Global.ITEM_SET.NATURAL_SALT].count = node_data["items_salt"]
			Global.items_dict[Global.ITEM_SET.DECHLORINATOR].count = node_data["items_water"]
			Global.items_dict[Global.ITEM_SET.PH_TEST_KIT].count = node_data["items_ph_test"]
			Global.items_dict[Global.ITEM_SET.SALINITY_TEST_KIT].count = node_data["items_sal_test"]
			ph = node_data["ph"]
			salinity = node_data["salinity"]
			

func _on_shop_button_pressed() -> void:
	if !get_tree().paused:
		get_tree().paused = !get_tree().paused
	shopNode.visible = true
	
func save():
	var save_dict = {"filename" : get_scene_file_path(),
		"parent" : get_parent().get_path(),
		"pos_x" : position.x, # Vector2 is not supported by JSON
		"pos_y" : position.y,
		"items_red" : Global.items_dict[Global.ITEM_SET.RED_SHRIMP].count,
		"items_green" : Global.items_dict[Global.ITEM_SET.GREEN_SHRIMP].count,
		"items_blue" : Global.items_dict[Global.ITEM_SET.BLUE_SHRIMP].count,
		"items_65" : Global.items_dict[Global.ITEM_SET.PH_65_BUFFER].count,
		"items_72" : Global.items_dict[Global.ITEM_SET.PH_72_BUFFER].count,
		"items_85" : Global.items_dict[Global.ITEM_SET.PH_85_BUFFER].count,
		"items_salt" : Global.items_dict[Global.ITEM_SET.NATURAL_SALT].count,
		"items_water" : Global.items_dict[Global.ITEM_SET.DECHLORINATOR].count,
		"items_ph_test" : Global.items_dict[Global.ITEM_SET.PH_TEST_KIT].count,
		"items_sal_test" : Global.items_dict[Global.ITEM_SET.SALINITY_TEST_KIT].count,
		"ph" : ph,
		"salinity" : salinity,
		"cash"	: Global.cash,
		
		}
	return save_dict
