extends Node

var inventory_panel_parent: Control
# Number of items allowed in one row ( Array Control)
var max_items_in_row = 15
# Stores all plants in the inventory
var current_plant_inventory = []
# Stores all potions in the inventory
var current_potion_inventory = []
# Scene template for each inventory item
var item_template = preload("res://Scenes/UI/InventoryItem.tscn")
# Tracks item following the mouse
var item_mouse_follow = null
var plant_item_origin: Dictionary = {}
var potion_item_origin: Dictionary = {}
#item currently in hand
var held_item = null
# Dictionary of all possible items and their icons
var all_Items_list: Dictionary = {
	"snackle_item": preload("res://Assets/Sprites/InventoryIcons/snackle_item.png"),
	"snepper_item": preload("res://Assets/Sprites/InventoryIcons/snepper_item.png"),
	"peepermint_item": preload("res://Assets/Sprites/InventoryIcons/peepermint_item.png"),
	"elfroot_item": preload("res://Assets/Sprites/InventoryIcons/elfroot_item.png"),
	"sunflower_item": preload("res://Assets/Sprites/InventoryIcons/sunflower_item.png"),
	"berry_item": preload("res://Assets/Sprites/InventoryIcons/berry_item.png"),
	"mushroom_item": preload("res://Assets/Sprites/InventoryIcons/mushroom_item.png"),
	"minor_health_potion_item": preload("res://Assets/Sprites/InventoryIcons/minor_health_potion_item.png") as Texture, 
	"minor_mana_potion_item": preload("res://Assets/Sprites/InventoryIcons/minor_mana_potion_item.png"),
	"common_slime_item": preload("res://Assets/Sprites/InventoryIcons/common_slime_item.png")
}
# Tracks items in cauldron inventory
var current_cauldron_inventory = []
# Dictionary of all possible cauldron recipes
var cauldron_recipies: Dictionary = {
	0: { "items_required": ["snackle_item", "snepper_item", "peepermint_item"],
		"result": "minor_health_potion_item"},
	1: { "items_required": ["snepper_item", "peepermint_item"],
		"result": "minor_mana_potion_item"}
}



# Sort items required for each cauldron recipe alphabetically
func _ready():
	for i in cauldron_recipies.size():
		cauldron_recipies[i].items_required.sort()

# Add item to current inventory
func add_plant_inventory_item(itemName):
	# check if max item is reached
	if current_plant_inventory.size() >= max_items_in_row:
		return false
		
	# Check if Item is Stackable
	for item in current_plant_inventory:
		if item.ItemName == itemName:
			# Increase Item Quantity by One
			item.ItemQuantity = item.ItemQuantity + 1
			item.get_node("TextureRect/Label").text = str(item.ItemQuantity)
			return true

	var newitem = item_template.instantiate()
	newitem.ItemName = itemName
	newitem.ItemQuantity = 1
	newitem.ItemType = "Plant"
	# Assign item's texture based on the all_items_list
	newitem.get_node("TextureRect").texture = all_Items_list[itemName]
	newitem.get_node("TextureRect/Label").text = str(newitem.ItemQuantity)
	#add item to the plants array
	current_plant_inventory.append(newitem)
	var temp = {newitem: newitem.global_position}
	plant_item_origin.merge(temp)
	# Add item to inventory panel
	inventory_panel_parent.get_node("PlantInventory").call_deferred("add_child", newitem)
	
	QuestManager.on_plant_harvested()
	return true

func add_potion_inventory_item(itemName):
	# check if max item is reached
	if current_potion_inventory.size() >= max_items_in_row:
		return false
	
	# Check if Item is Stackable
	for item in current_plant_inventory:
		if item.ItemName == itemName:
			# Increase Item Quantity by One
			item.ItemQuantity = item.ItemQuantity + 1
			item.get_node("TextureRect/Label").text = str(item.ItemQuantity)
			return true
	
	var newitem = item_template.instantiate()
	newitem.ItemName = itemName
	newitem.ItemQuantity = 1
	newitem.ItemType = "Potion"
	# Assign item's texture based on the all_items_list

	newitem.get_node("TextureRect").texture = all_Items_list[itemName]	
	#add item to the potions array
	current_potion_inventory.append(newitem)
	# Add item to inventory panel
	var temp = {newitem: newitem.global_position}
	potion_item_origin.merge(temp)
	inventory_panel_parent.get_node("PotionInventory").call_deferred("add_child", newitem)
	QuestManager.on_potion_brewed()
	return true

# Handle icon click to start following mouse
func icon_clicked(icon, item_name: String):
		icon.get_node("Button").visible = false
		held_item = item_name
		print("Item Click Initated on : ", item_name)
		if current_plant_inventory.has(icon):
			var temp = {icon: icon.global_position}
			plant_item_origin.merge(temp, true)
		if current_potion_inventory.has(icon):
			var temp = {icon: icon.global_position}
			potion_item_origin.merge(temp, true)
		item_mouse_follow = icon

# Check the item held for name and texture
func check_item_held():
	var item = all_Items_list[held_item]
	print("Checking held item : ", item)
	
	var item_name_and_texture = {
		"Item": item,
		"HeldItem": held_item
	}
	
	return item_name_and_texture

# Return Item to original Position
func return_item(item):
	print("Returning ", item.ItemName ," to Origin Position")
	item.get_node("Button").visible = true
	if current_plant_inventory.has(item):
		item.global_position = plant_item_origin.get(item)
	elif current_potion_inventory.has(item):
		item.global_position = potion_item_origin.get(item)
		

# Handle item used by cauldron
func item_used_click():
	if item_mouse_follow != null:
		print(item_mouse_follow.ItemName + " has been used")
		if current_plant_inventory.has(item_mouse_follow):
			# Check if the item needs to be removed
			if item_mouse_follow.ItemQuantity == 1:
				current_plant_inventory.erase(item_mouse_follow)
				item_mouse_follow.queue_free()
			else:
				# Update Back and Front end quantity
				item_mouse_follow.ItemQuantity = item_mouse_follow.ItemQuantity - 1
				item_mouse_follow.get_node("TextureRect/Label").text = str(item_mouse_follow.ItemQuantity)
				item_mouse_follow.hide_tooltip()
				return_item(item_mouse_follow)
		elif current_potion_inventory.has(item_mouse_follow):
			# Check if the item needs to be removed
			if item_mouse_follow.ItemQuantity == 1:
				current_potion_inventory.erase(item_mouse_follow)
				item_mouse_follow.queue_free()
			else:
				# Update Back and Front end quantity
				item_mouse_follow.ItemQuantity = item_mouse_follow.ItemQuantity - 1
				item_mouse_follow.get_node("TextureRect/Label").text = str(item_mouse_follow.ItemQuantity)
				item_mouse_follow.hide_tooltip()
				return_item(item_mouse_follow)
				
		item_mouse_follow = null
		

# Reset item position if not used after 0.1 seconds
func item_not_used_click():
	await get_tree().create_timer(0.1).timeout
	if item_mouse_follow != null:
		#update_item_positions()
		item_mouse_follow.hide_tooltip()
		return_item(item_mouse_follow)
		item_mouse_follow = null
		print("Nothing pressed with item.")


func remove_item(item_name):
		if current_plant_inventory.has(item_name):
			current_plant_inventory.erase(item_name)
		elif current_potion_inventory.has(item_name):
			current_potion_inventory.erase(item_name)
		print(item_name, " removed.")

# Execute every frame to make the item follow the mouse
func _process(delta):
	if item_mouse_follow != null:
		# Set tool position to mouse position
		item_mouse_follow.follow_mouse()
		if Input.is_action_just_pressed("left_click"):
			item_mouse_follow.get_node("Button").visible = true
			item_not_used_click()
