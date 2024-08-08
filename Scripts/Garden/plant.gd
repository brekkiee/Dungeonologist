extends Area2D

@export var harvested_item_name: String

# Adds a new item to the inventory when the plant is clicked
# Item added is determined by the harvested_item_name variable
func _on_input_event(viewport, event, shape_idx):
	if InputMap.event_is_action(event, "left_click"):
		if event.pressed:
			if InventoryManager.add_plant_inventory_item(harvested_item_name):
				#This executes if it sucessfully added plants to Inventory 
				#since there is space available
				pass
			else:
				#This executes if the inventory is full and can't have more plants
				print("Inventory is full, can't add new plants")
				pass
