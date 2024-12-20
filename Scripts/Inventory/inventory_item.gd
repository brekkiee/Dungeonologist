extends Control

# Item name assigned when instantiated/spawned
var ItemName: String
var ItemQuantity: int
var ItemType: String

var data: ItemData

@onready var item_tooltip_template = preload("res://Scenes/UI/Inventory/InvItemTooltip.tscn")
@onready var cursor_pointer_texture = preload("res://Assets/Sprites/UI/Cursor_Default.png")
var tooltip = null
# Follow mouse position
func follow_mouse():
	self.set_global_position(get_global_mouse_position())

# Called when inventory item button is clicked (item selected for use)
func _on_button_pressed():
	InventoryManager.icon_clicked(self, data.Name)
	if tooltip:
		hide_tooltip()

func on_mouse_entered():
	tooltip = item_tooltip_template.instantiate()
	tooltip.Config(self)
	add_child(tooltip)
	Input.set_custom_mouse_cursor(cursor_pointer_texture)

func on_mouse_exited():
	if tooltip:
		hide_tooltip()
	Input.set_custom_mouse_cursor(null)

func hide_tooltip():
	print("Hiding Tooltip")
	if tooltip:
		tooltip.queue_free()
		tooltip = null

func _exit_tree():
	if tooltip:
		hide_tooltip()
