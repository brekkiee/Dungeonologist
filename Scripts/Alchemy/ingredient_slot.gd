# IngredientSlot.gd
extends TextureRect

@export var slot_texture: TextureRect

var item_name = ""
var item_texture: Texture2D

func _ready():
	set_process_unhandled_input(true)

func _gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if InventoryManager.item_mouse_follow != null:
				# Dragging item onto the slot
				item_name = InventoryManager.item_mouse_follow.ItemName
				item_texture = InventoryManager.item_mouse_follow.get_node("TextureRect").texture
				slot_texture.texture = item_texture

				# Signal to cauldron that item has been added
				get_parent().get_parent()._on_item_added_to_slot(self, item_name)

				# Remove item from inventory
				InventoryManager.item_used_click()
			elif item_name != "":
				# Player clicks to return item to inventory
				get_parent().get_parent()._on_item_removed_from_slot(self, item_name)

				# Clear slot
				item_name = ""
				item_texture = null
				slot_texture.texture = null