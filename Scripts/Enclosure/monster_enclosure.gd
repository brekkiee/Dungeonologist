#extends Node2D
#
#@export var found_monster: Node2D  # The monster node to show
#
#func _input_event(viewport, event, shape_idx):
#	if event is InputEventMouseButton and event.pressed:
#		if InventoryManager.item_mouse_follow != null:
#			if InventoryManager.item_mouse_follow.ItemName == "common_slime":
#				print("Added ", InventoryManager.item_mouse_follow.ItemName, " to enclosure")
#				
#				# Make the monster visible
#				found_monster.visible = true
#				
#				# Remove the item from the inventory
#				InventoryManager.item_used_click()
#
