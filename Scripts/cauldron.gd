extends Node2D

# Start animation for cauldron bubbling when ready
func _ready():
	var _animated_sprite = get_node("CauldronAnimation2d")
	_animated_sprite.play()

# Handle input event signal from cauldron node in garden scene
func _on_input_event(viewport, event, shape_idx):
	if InputMap.event_is_action(event, "left_click"):
		if event.pressed and InventroyManager.item_mouse_follow != null:
			# Add item to cauldron's inventory
			InventroyManager.current_cauldron_inventory.append(InventroyManager.item_mouse_follow.ItemName)
			# Notify InventoryManager item is used
			InventroyManager.item_used_click()

# Handle input event signal from ladle node in garden scene
func _on_ladle_input_event(viewport, event, shape_idx):
	if InputMap.event_is_action(event, "left_click"):
		if event.pressed:
			# Sort items in cauldron inventory before comparing to recipes
			var sorted_cauldron_items = InventroyManager.current_cauldron_inventory.duplicate()
			sorted_cauldron_items.sort()
			# Check if current items match any recipe
			for i in InventroyManager.cauldron_recipies.size():
				if InventroyManager.cauldron_recipies[i].items_required == sorted_cauldron_items:
					print("valid recipe created, item added.")
					# Add resulting product from recipe
					InventroyManager.add_inventroy_item(InventroyManager.cauldron_recipies[i].result)
				else:
					print("invalid recipe, item in cauldron deleted.")
			# Clear cauldron inventory
			InventroyManager.current_cauldron_inventory = []
