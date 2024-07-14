extends Panel

# Called when node enters scene tree for the first time
func _ready():
	# Set inventory panel parent in InventoryManager
	InventroyManager.invetory_panel_parent = self
