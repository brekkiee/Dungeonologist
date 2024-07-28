extends Area2D

@export var harvested_item_name: String

# Adds a new item to the inventory when the plant is clicked
# Item added is determined by the harvested_item_name variable
func _on_input_event(viewport, event, shape_idx):
	if InputMap.event_is_action(event, "left_click"):
		if event.pressed:
			InventroyManager.add_inventroy_item(harvested_item_name)
