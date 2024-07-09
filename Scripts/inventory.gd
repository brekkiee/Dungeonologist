extends HSplitContainer

@onready var grid_container = $ScrollContainer/GridContainer

func _ready():
	InventoryManager.inventoryUpdated.connect(_on_inventory_updated)
	_on_inventory_updated()

func _on_inventory_updated(): 
	# clear existing slots
	clear_grid_container()
	
	# add new slots for each inventory slot
	for item in InventoryManager.inventory:
		var slot = InventoryManager.inventory_slot_scene.instantiate()
		grid_container.add_child(slot)
		# set item for filled slot
		if item != null:
			slot.set_item(item)
		else:
			slot.set_empty()

# clears all grid container slots
func clear_grid_container():
	while grid_container.get_child_count() > 0:
		var child = grid_container.get_child(0)
		grid_container.remove_child(child)
		child.queue_free()
