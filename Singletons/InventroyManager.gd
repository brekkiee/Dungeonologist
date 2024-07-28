extends Node

var invetory_panel_parent: Control
# Stores all items in the inventory
var current_inventory = []
# Scene template for each inventory item
var item_template = preload("res://Scenes/InventoryItem.tscn")
# Tracks item following the mouse
var item_mouse_follow = null

# Dictionary of all possible items and their icons
var all_Items_list: Dictionary = {
	"plant1_item": preload("res://Assets/InventoryIcons/plant1_icon.png"),
	"plant2_item": preload("res://Assets/InventoryIcons/plant2_icon.png"),
	"plant3_item": preload("res://Assets/InventoryIcons/plant3_icon.png"),
	"potion1": preload("res://Assets/InventoryIcons/potion1_icon.png") 
}
# Tracks items in cauldron inventory
var current_cauldron_inventory = []
# Dictionary of all possible cauldron recipes
var cauldron_recipies: Dictionary = {
	0: { "items_required": ["plant1_item", "plant2_item", "plant3_item"],
		"result": "potion1"}
}

# Parameters for item position and distance in inventory
var intial_item_spawn_point = Vector2(21, 15)
var item_distance_horizontal = 40 # In pixels
var item_distance_vertical = 40
var max_items_in_row = 5

# Sort items required for each cauldron recipe alphabetically
func _ready():
	for i in cauldron_recipies.size():
		cauldron_recipies[i].items_required.sort()

# Calculate position of new item based on inventory index
func get_new_item_offset(inventory_index):
	var column_num = inventory_index % max_items_in_row
	var row_num = floor(inventory_index / max_items_in_row)
	var finalVectorX = (item_distance_vertical * column_num) + intial_item_spawn_point.x
	var finalVectorY = (item_distance_horizontal * row_num) + intial_item_spawn_point.y
	return intial_item_spawn_point + Vector2(finalVectorX, finalVectorY)

# Add item to current inventory
func add_inventroy_item(itemName):
	var newitem = item_template.instantiate()
	newitem.position = get_new_item_offset(current_inventory.size())
	newitem.ItemName = itemName
	# Assign item's texture
	newitem.get_node("TextureRect").texture = all_Items_list[itemName]
	# Add item to inventory
	current_inventory.append(newitem)
	# Add item to inventory panel
	invetory_panel_parent.call_deferred("add_child", newitem)

# Handle icon click to start following mouse
func icon_clicked(Icon):
	if item_mouse_follow == null:
		Icon.get_node("Button").visible = false
		item_mouse_follow = Icon

# Update item positions if inventory changes
func update_item_positions():
	for i in current_inventory.size():
		current_inventory[i].position = get_new_item_offset(i)

# Handle item used by cauldron
func item_used_click():
	if item_mouse_follow != null:
		print(item_mouse_follow.ItemName + " is used")
		current_inventory.erase(item_mouse_follow)

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
