extends Panel


@onready var pageNode1: Node2D = $PageNode1
@onready var pageNode2: Node2D = $PageNode2
@onready var pageNode3: Node2D = $PageNode3
#@onready var panel1: Panel = $PageNode3
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pageNode1.visible = true
	pageNode2.visible = false
	pageNode3.visible = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_1_pressed() -> void:
	pageNode1.visible = true
	pageNode2.visible = false
	pageNode3.visible = false # Replace with function body.


func _on_button_2_pressed() -> void:
	pageNode1.visible = false
	pageNode2.visible = true
	pageNode3.visible = false # Replace with function body.


func _on_button_3_pressed() -> void:
	pageNode1.visible = false
	pageNode2.visible = false
	pageNode3.visible = true # Replace with function body.
