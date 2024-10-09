# IngredientSlot.gd
extends TextureRect

@export var slot_texture: TextureRect

var item_data = null
var item_texture: Texture2D

func _ready():
	set_process_unhandled_input(true)

func _gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if InventoryManager.item_mouse_follow != null:
				
				# If there is an item in the slot return it to the inventory
				for i in InventoryManager.current_plant_inventory:
					if item_data != null:
						if i.data.Name == item_data.Name:
							print("Name: ", i.data.Name, "\nQuantity: ", i.data.Quantity)
							i.data.Quantity = i.data.Quantity + 1
							i.get_node("TextureRect/Label").text = str(i.data.Quantity)
							InventoryManager.return_item(i)
				
				
				# Dragging item onto the slot
				item_data = InventoryManager.item_mouse_follow.data
				item_texture = InventoryManager.item_mouse_follow.get_node("TextureRect").texture
				slot_texture.texture = item_texture
				
				# Signal to cauldron that item has been added
				get_parent().get_parent()._on_item_added_to_slot(self, item_data)

				# Remove item from inventory
				InventoryManager.item_used_click()
			elif item_data.Name != "":
				# Player clicks to return item to inventory
				get_parent().get_parent()._on_item_removed_from_slot(self, item_data)
				
				# Clear slot
				item_data = null
				item_texture = null
				slot_texture.texture = null
				
