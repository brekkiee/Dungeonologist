extends Control

# Item name assigned when instantiated/spawned
var ItemName: String
var ItemQuantity: int

# Follow mouse position
func follow_mouse():
	self.set_global_position(get_global_mouse_position())

# Called when inventory item button is clicked (item selected for use)
func _on_button_pressed():
	InventoryManager.icon_clicked(self, ItemName)

# Highlight Items on Hover
func on_button_mouse_exited():
	self.get_node("TextureRect").material.set_shader_parameter("line_thickness", 0)
	# TODO:
	# Destroy / Clear Tool Tip

func on_button_mouse_entered():
	self.get_node("TextureRect").material.set_shader_parameter("line_thickness", 0.4)
	# TODO:
	# Create Tool Tip
	# Set Tool Tip data
	# Force Tool Tip to follow mouse
