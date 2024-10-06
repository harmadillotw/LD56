extends Node2D

signal exitShopSignal
signal buyItemSignal
@onready var aquaticsContainer: HBoxContainer = $Panel/VBoxContainer/AquaticsHB
@onready var waterConContainer: HBoxContainer = $Panel/VBoxContainer/WaterConditioningHB
@onready var testsContainer: HBoxContainer = $Panel/VBoxContainer/TestsHB
@onready var cashLabel: Label = $Panel/CashLabel
var shop_items_dict = {}

var shopItemContainerScene = preload("res://Scenes/shopItemContainer.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	addItem(Global.ITEM_SET.RED_SHRIMP,aquaticsContainer, 20)
	addItem(Global.ITEM_SET.BLUE_SHRIMP,aquaticsContainer, 40)
	addItem(Global.ITEM_SET.GREEN_SHRIMP,aquaticsContainer, 80)
	
	addItem(Global.ITEM_SET.PH_65_BUFFER,waterConContainer, 30)
	addItem(Global.ITEM_SET.PH_72_BUFFER,waterConContainer, 30)
	addItem(Global.ITEM_SET.PH_85_BUFFER,waterConContainer, 40)
	addItem(Global.ITEM_SET.NATURAL_SALT,waterConContainer, 40)
	addItem(Global.ITEM_SET.DECHLORINATOR,waterConContainer, 40)

	addItem(Global.ITEM_SET.PH_TEST_KIT,testsContainer, 30 )
	addItem(Global.ITEM_SET.SALINITY_TEST_KIT,testsContainer, 20)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	cashLabel.text = "Cash:" + str(Global.cash)

func addItem(type, parentNode, price):
	var instance = shopItemContainerScene.instantiate()
	instance.type = type
	instance.price = price
	#instance.count =count
	instance.buyItemButtonSignal.connect(_on_buy_item)
	shop_items_dict[type] = instance
	parentNode.add_child(instance)

func _on_buy_item(type : Global.ITEM_SET):
	cashLabel.text = "Cash:" + str(Global.cash)
	buyItemSignal.emit(type)
func _on_button_pressed() -> void:
		
		if get_tree().paused:
			get_tree().paused = !get_tree().paused
			exitShopSignal.emit()
