extends TextureRect

@export var slot_texture: TextureRect

signal item_added_to_slot(slot, item_data)
signal item_removed_from_slot(slot, item_data)

var item_data = null
var item_texture: Texture2D

func _ready():
	set_process_unhandled_input(true)

func _gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if InventoryManager.item_mouse_follow != null:
				# Dragging item onto the slot
				item_data = InventoryManager.item_mouse_follow.data
				item_texture = InventoryManager.item_mouse_follow.get_node("TextureRect").texture
				slot_texture.texture = item_texture

				# Signal to cauldron that item has been added
				emit_signal("item_added_to_slot", self, item_data)

				# Remove item from inventory
				InventoryManager.item_used_click()
			elif item_data != null and item_data.Name != "":
				# Player clicks to return item to inventory
				emit_signal("item_removed_from_slot", self, item_data)

				# Clear slot
				item_data = null
				item_texture = null
				slot_texture.texture = null
