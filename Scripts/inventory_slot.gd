extends Control

# references
@onready var icon = $MarginContainer/ItemIcon
@onready var quantity_label = $QuantityLabel
@onready var details_panel = $Details
@onready var name_label = $Details/MarginContainer/VBoxContainer/NameLabel
@onready var type_label = $Details/MarginContainer/VBoxContainer/TypeLabel

# slot item
var item = null

func _ready():
	pass

func _process(delta):
	pass

# handle slot interaction
func _on_button_pressed():
	if item != null:
		print("Using " + item["name"])
		InventoryManager.removeItem(item)

# shows details panel on mouse hover
func _on_button_mouse_entered():
	if item != null:
		details_panel.visible = true

# hides details panel on hover exit
func _on_button_mouse_exited():
	details_panel.visible = false

# default empty slot
func set_empty():
	icon.texture = null
	quantity_label.text = ""

# populate slot with item dict values
func set_item(new_item):
	item = new_item
	icon.texture = item["texture"]
	quantity_label.text = str(item["quantity"])
	name_label.text = str(item["name"])
	type_label.text = str(item["type"])
