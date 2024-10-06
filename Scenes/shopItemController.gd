extends Panel


signal buyItemButtonSignal

@export var type : Global.ITEM_SET
@export var count : int
@export var price : int
@export var labelText : String

@onready var textLabel: Label = $Label
@onready var countLabel: Label = $CountLabel
@onready var priceLabel: Label = $PriceLabel
@onready var buyButton: Button = $Button
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setText()
	priceLabel.text = "$" + str(price)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	countLabel.text = str(Global.items_dict[type].count)
	#countLabel.text = str(count)
func setText():
	match type:
		Global.ITEM_SET.RED_SHRIMP:
			labelText = "Red Shrimp"
			textLabel.text = labelText
		Global.ITEM_SET.BLUE_SHRIMP:
			labelText = "Blue Shrimp"
			textLabel.text = labelText
		Global.ITEM_SET.GREEN_SHRIMP:
			labelText = "Green Shrimp"
			textLabel.text = labelText
		Global.ITEM_SET.PH_65_BUFFER:
			labelText = "pH 6.5 Buffer"
			textLabel.text = labelText
		Global.ITEM_SET.PH_72_BUFFER:
			labelText = "pH 7.2 Buffer"
			textLabel.text = labelText
		Global.ITEM_SET.PH_85_BUFFER: 
			labelText = "pH 8.5 Buffer"
			textLabel.text = labelText
		Global.ITEM_SET.NATURAL_SALT: 
			labelText = "Natural Salt"
			textLabel.text = labelText
		Global.ITEM_SET.DECHLORINATOR:
			labelText = "Water"
			textLabel.text = labelText
		Global.ITEM_SET.PH_TEST_KIT:
			labelText = "pH Test Kit"
			textLabel.text = labelText
		Global.ITEM_SET.SALINITY_TEST_KIT:
			labelText = "Salinity Test Kit"
			textLabel.text = labelText


func _on_button_pressed() -> void:	
	if (Global.cash - price) > 0:
		Global.cash -= price
		count -= 1
		Global.items_dict[type].count += 1
	#buyItemButtonSignal.emit(type)
