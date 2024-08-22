extends Node

var invetory_panel_parent: Control
# Stores all plants in the inventory
var current_plant_inventory = []
# Stores all potions in the inventory
var current_potion_inventory = []
# Scene template for each inventory item
var item_template = preload("res://Scenes/UI/InventoryItem.tscn")
# Tracks item following the mouse
var item_mouse_follow = null

# Dictionary of all possible items and their icons
var all_Items_list: Dictionary = {
	"snackle_item": preload("res://Assets/Sprites/InventoryIcons/snackle_item.png"),
	"snepper_item": preload("res://Assets/Sprites/InventoryIcons/snepper_item.png"),
	"peepermint_item": preload("res://Assets/Sprites/InventoryIcons/peepermint_item.png"),
	"elfroot_item": preload("res://Assets/Sprites/InventoryIcons/elfroot_item.png"),
	"sunflower_item": preload("res://Assets/Sprites/InventoryIcons/sunflower_item.png"),
	"berry_item": preload("res://Assets/Sprites/InventoryIcons/berry_item.png"),
	"mushroom_item": preload("res://Assets/Sprites/InventoryIcons/mushroom_item.png"),
	"minor_health_potion_item": preload("res://Assets/Sprites/InventoryIcons/minor_health_potion_item.png"), 
	"minor_mana_potion_item": preload("res://Assets/Sprites/InventoryIcons/minor_mana_potion_item.png") 
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

# Parameters for item position and distance in inventory
var intial_item_spawn_point = Vector2(260,20)  #21, 15)
var item_distance_horizontal = 50 # In pixels
var item_distance_vertical = 40
var max_items_in_row = 15

# Sort items required for each cauldron recipe alphabetically
func _ready():
	for i in cauldron_recipies.size():
		cauldron_recipies[i].items_required.sort()

# Calculate position of new item based on inventory index
func get_new_item_offset(inventory_index, row_num):
	var column_num = inventory_index % max_items_in_row
	#var row_num = floor(inventory_index / max_items_in_row)
	var finalVectorX = (item_distance_vertical * column_num) + intial_item_spawn_point.x
	var finalVectorY = (item_distance_horizontal * row_num) + intial_item_spawn_point.y
	return intial_item_spawn_point + Vector2(finalVectorX, finalVectorY)

# Add item to current inventory
func add_plant_inventory_item(itemName):
	# check if max item is reached
	if current_plant_inventory.size() >= max_items_in_row:
		return false
	
	var newitem = item_template.instantiate()
	newitem.ItemName = itemName
	# Assign item's texture based on the all_items_list
	newitem.get_node("TextureRect").texture = all_Items_list[itemName]
	# get the spawn potion based on the array size and the row index.
	newitem.position = get_new_item_offset(current_plant_inventory.size(), 0)	
	#add item to the plants array
	current_plant_inventory.append(newitem)
	# Add item to inventory panel
	invetory_panel_parent.call_deferred("add_child", newitem)
	QuestManager.on_plant_harvested()
	return true

func add_potion_inventory_item(itemName):
	# check if max item is reached
	if current_potion_inventory.size() >= max_items_in_row:
		return false
	
	var newitem = item_template.instantiate()
	newitem.ItemName = itemName
	# Assign item's texture based on the all_items_list
	newitem.get_node("TextureRect").texture = all_Items_list[itemName]	
	# get the spawn potion based on the array size and the row index.
	newitem.position = get_new_item_offset(current_potion_inventory.size(), 1)	
	#add item to the potions array
	current_potion_inventory.append(newitem)
	# Add item to inventory panel
	invetory_panel_parent.call_deferred("add_child", newitem)
	return true

# Handle icon click to start following mouse
func icon_clicked(Icon):
	if item_mouse_follow == null:
		Icon.get_node("Button").visible = false
		item_mouse_follow = Icon

# Update item positions if inventory changes
func update_item_positions():
	for i in current_plant_inventory.size():
		current_plant_inventory[i].position = get_new_item_offset(i, 0)
	for i in current_potion_inventory.size():
		current_potion_inventory[i].position = get_new_item_offset(i, 1)

# Handle item used by cauldron
func item_used_click():
	if item_mouse_follow != null:
		print(item_mouse_follow.ItemName + " is used")
		if current_plant_inventory.has(item_mouse_follow):
			current_plant_inventory.erase(item_mouse_follow)
		elif current_potion_inventory.has(item_mouse_follow):
			current_potion_inventory.erase(item_mouse_follow)

		item_mouse_follow.queue_free()
		item_mouse_follow = null
		update_item_positions()

# Reset item position if not used after 0.1 seconds
func item_not_used_click():
	await get_tree().create_timer(0.1).timeout
	if item_mouse_follow != null:
		update_item_positions()
		item_mouse_follow = null
		print("Nothing pressed with item.")

# Execute every frame to make the item follow the mouse
func _process(delta):
	if item_mouse_follow != null:
		# Set tool position to mouse position
		item_mouse_follow.follow_mouse()
		if Input.is_action_just_pressed("left_click"):
			item_mouse_follow.get_node("Button").visible = true
			item_not_used_click()
