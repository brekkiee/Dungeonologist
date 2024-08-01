extends Control

# Item name assigned when instantiated/spawned
var ItemName: String

# Follow mouse position
func follow_mouse():
	self.set_global_position(get_global_mouse_position())

# Called when inventory item button is clicked (item selected for use)
func _on_button_pressed():
	InventoryManager.icon_clicked(self)
