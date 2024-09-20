extends Control

# Item name assigned when instantiated/spawned
var ItemName: String
var ItemQuantity: int
var ItemType: String

@onready var item_tooltip_template = preload("res://Scenes/UI/InvItemTooltip.tscn")
var tooltip = null
# Follow mouse position
func follow_mouse():
	self.set_global_position(get_global_mouse_position())

# Called when inventory item button is clicked (item selected for use)
func _on_button_pressed():
	InventoryManager.icon_clicked(self, ItemName)

func on_mouse_entered():
	tooltip = item_tooltip_template.instantiate()
	tooltip.Config(self)
	add_child(tooltip)
	

func on_mouse_exited():
	tooltip.queue_free()

func hide_tooltip():
	print("Hiding Tooltup")
	tooltip.queue_free()
