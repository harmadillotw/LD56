extends Node2D

signal exitShopSignal
signal buyItemSignal
@onready var aquaticsContainer: HBoxContainer = $Panel/VBoxContainer/AquaticsHB
@onready var waterConContainer: HBoxContainer = $Panel/VBoxContainer/WaterConditioningHB
@onready var testsContainer: HBoxContainer = $Panel/VBoxContainer/TestsHB

var shop_items_dict = {}

var shopItemContainerScene = preload("res://Scenes/shopItemContainer.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	addItem(Global.ITEM_SET.RED_SHRIMP,aquaticsContainer)
	addItem(Global.ITEM_SET.BLUE_SHRIMP,aquaticsContainer)
	addItem(Global.ITEM_SET.GREEN_SHRIMP,aquaticsContainer)
	
	addItem(Global.ITEM_SET.PH_65_BUFFER,waterConContainer)
	addItem(Global.ITEM_SET.PH_72_BUFFER,waterConContainer)
	addItem(Global.ITEM_SET.PH_85_BUFFER,waterConContainer)
	addItem(Global.ITEM_SET.NATURAL_SALT,waterConContainer)
	addItem(Global.ITEM_SET.DECHLORINATOR,waterConContainer)

	addItem(Global.ITEM_SET.PH_TEST_KIT,testsContainer)
	addItem(Global.ITEM_SET.SALINITY_TEST_KIT,testsContainer)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func addItem(type, parentNode):
	var instance = shopItemContainerScene.instantiate()
	instance.type = type
	#instance.count =count
	instance.buyItemButtonSignal.connect(_on_buy_item)
	shop_items_dict[type] = instance
	parentNode.add_child(instance)

func _on_buy_item(type : Global.ITEM_SET):
	buyItemSignal.emit(type)
func _on_button_pressed() -> void:
		if get_tree().paused:
			get_tree().paused = !get_tree().paused
			exitShopSignal.emit()
