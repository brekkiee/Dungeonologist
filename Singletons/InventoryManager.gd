extends Node

var inventory_panel_parent: Control
# Number of items allowed in one row ( Array Control)
var max_items_in_row = 15
# Stores all plants in the inventory
var current_plant_inventory = []
# Stores all potions in the inventory
var current_potion_inventory = []
# Scene template for each inventory item
var item_template = preload("res://Scenes/UI/Inventory/InventoryItem.tscn")
# Tracks item following the mouse
var item_mouse_follow = null
var plant_item_origin: Dictionary = {}
var potion_item_origin: Dictionary = {}
#item currently in hand
var held_item = null
# Dictionary of all possible items and their icons
# Tracks items in cauldron inventory
var current_cauldron_inventory = []
# Dictionary of all possible cauldron recipes
var cauldron_recipies: Dictionary = {
	0: { "items_required": ["Blood Cap", "Dawn Grass"],
		"result": preload("res://Items/minor_health_potion.tres")},
	1: { "items_required": ["Thimbleweed", "Slime Residue"],
		"result": preload("res://Items/minor_mana_potion.tres")},
	2: { "items_required": ["Blood Cap", "Shroom Spores"],
		"result": preload("res://Items/minor_stamina_potion.tres")}
}

var save_load_data: Dictionary = {
	"Blood Cap": preload("res://Items/blood_cap.tres"),
	"Dawn Grass": preload("res://Items/dawn_grass.tres"),
	"Dwarven Nettle": preload("res://Items/dwarven_nettle.tres"),
	"Gelatinous Blob": preload("res://Items/gelatinous_blob.tres"),
	"Gutweed": preload("res://Items/gutweed.tres"),
	"Imp Droppings": preload("res://Items/imp_droppings.tres"),
	"Inkberry": preload("res://Items/inkberry.tres"),
	"Lucky Coin": preload("res://Items/lucky_coin.tres"),
	"Minor Health Potion": preload("res://Items/minor_health_potion.tres"),
	"Minor Mana Potion": preload("res://Items/minor_mana_potion.tres"),
	"Minor Stamina Potion": preload("res://Items/minor_stamina_potion.tres"),
	"Rotten Fruit": preload("res://Items/rotten_fruit.tres"),
	"Sentient Moss": preload("res://Items/sentient_moss.tres"),
	"Shroom Spores": preload("res://Items/shroom_spores.tres"),
	"Slime Residue": preload("res://Items/slime_residue.tres"),
	"Sweetroot": preload("res://Items/sweetroot.tres"),
	"Thimbleweed": preload("res://Items/thimbleweed.tres"),
	"Meat Burger": preload("res://Items/thimbleweed.tres"),
	"Meat Chicken": preload("res://Items/thimbleweed.tres"),
	"Meat Fish": preload("res://Items/thimbleweed.tres"),
	"Meat Organ": preload("res://Items/thimbleweed.tres"),
	"Meat Steak": preload("res://Items/thimbleweed.tres"),
}

var alert = null


# Sort items required for each cauldron recipe alphabetically
func _ready():
	inventory_panel_parent = get_node("/root/MainWindow/UI/MainUI/InventoryPanelParent")
	for i in cauldron_recipies.size():
		cauldron_recipies[i].items_required.sort()

# Add item to current inventory
func add_plant_inventory_item(item_data):
	if inventory_panel_parent == null:
		print("Warning: inventory_panel_parent is not yet init. for add_plants")
		return false
		
	# check if max item is reached
	if current_plant_inventory.size() >= max_items_in_row:
		return false
		
	# Check if Item is Stackable
	for item in current_plant_inventory:
		if item.data.Name == item_data.Name:
			# Increase Item Quantity by One
			item.data.Quantity += 1
			item.get_node("TextureRect/Label").text = str(item.data.Quantity)
			return true

	var newitem = item_template.instantiate()
	newitem.data = item_data
	newitem.data.Quantity = 1

	newitem.get_node("TextureRect").texture = newitem.data.Sprite
	newitem.get_node("TextureRect/Label").text = str(newitem.data.Quantity)
	# Add item to the plants array
	current_plant_inventory.append(newitem)
	var temp = {newitem: newitem.global_position}
	plant_item_origin.merge(temp)
	# Add item to inventory panel
	inventory_panel_parent.get_node("PlantInventory").call_deferred("add_child", newitem)
	
	QuestManager.on_plant_harvested()
	return true

func add_potion_inventory_item(item_data):
	if inventory_panel_parent == null:
		print("Warn: inventory_panel_parent not yet init. for add_potions")
		return false
		# check if max item is reached
	if current_potion_inventory.size() >= max_items_in_row:
		return false
		
	# Check if Item is Stackable
	for item in current_potion_inventory:
		if item.data.Name == item_data.Name:
			# Increase Item Quantity by One
			item.data.Quantity += 1
			item.get_node("TextureRect/Label").text = str(item.data.Quantity)
			return true

	var newitem = item_template.instantiate()
	newitem.data = item_data
	newitem.data.Quantity = 1
	
	newitem.get_node("TextureRect").texture = newitem.data.Sprite
	newitem.get_node("TextureRect/Label").text = str(newitem.data.Quantity)
	#add item to the potions array
	current_potion_inventory.append(newitem)
	var temp = {newitem: newitem.global_position}
	potion_item_origin.merge(temp)
	# Add item to inventory panel
	inventory_panel_parent.get_node("PotionInventory").call_deferred("add_child", newitem)

	QuestManager.on_potion_brewed()
	return true

# Handle icon click to start following mouse
func icon_clicked(icon, item_name: String):
		print(icon.data.Name)
		
		if item_mouse_follow != null:
			return_item(item_mouse_follow)
		
		icon.get_node("Button").visible = false
		held_item = item_name
		if current_plant_inventory.has(icon):
			var temp = {icon: icon.global_position}
			plant_item_origin.merge(temp, true)
		if current_potion_inventory.has(icon):
			var temp = {icon: icon.global_position}
			potion_item_origin.merge(temp, true)
			
		item_mouse_follow = icon

# Return Item to original Position
func return_item(item):
	print("Returning ", item.data.Name ," to Origin Position")
		
	item.hide_tooltip()
	if current_plant_inventory.has(item):
		item.global_position = plant_item_origin.get(item)
	elif current_potion_inventory.has(item):
		item.global_position = potion_item_origin.get(item)
	await get_tree().create_timer(0.1).timeout;
	item.get_node("Button").visible = true

# Handle item used by cauldron
func item_used_click():
	if item_mouse_follow != null:
		print(item_mouse_follow.data.Name + " has been used")
		if current_plant_inventory.has(item_mouse_follow):
			# Check if the item needs to be removed
			if item_mouse_follow.data.Quantity == 1:
				current_plant_inventory.erase(item_mouse_follow)
				item_mouse_follow.queue_free()
			else:
				# Update Back and Front end quantity
				item_mouse_follow.data.Quantity = item_mouse_follow.data.Quantity - 1
				item_mouse_follow.get_node("TextureRect/Label").text = str(item_mouse_follow.data.Quantity)
				item_mouse_follow.hide_tooltip()
				return_item(item_mouse_follow)
		elif current_potion_inventory.has(item_mouse_follow):
			# Check if the item needs to be removed
			if item_mouse_follow.data.Quantity == 1:
				current_potion_inventory.erase(item_mouse_follow)
				item_mouse_follow.queue_free()
			else:
				# Update Back and Front end quantity
				item_mouse_follow.data.Quantity = item_mouse_follow.data.Quantity - 1
				item_mouse_follow.get_node("TextureRect/Label").text = str(item_mouse_follow.data.Quantity)
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

func get_plant_inventory_data() -> Array:
	var plant_inventory = []
	for item in current_plant_inventory:
		plant_inventory.append({
			"ItemData": item.data.item_save()
		})
	return plant_inventory

func get_potion_inventory_data() -> Array:
	var potion_inventory = []
	for item in current_potion_inventory:
		potion_inventory.append({
			"ItemData": item.data.item_save(),
		})
	return potion_inventory

func load_inventory_data(inventory_data: Dictionary):
	# Clear current inventories
	clear_inventory()

	# Defer loading the inventory to ensure `inventory_panel_parent` is set
	call_deferred("_load_inventory_deferred", inventory_data)

func _load_inventory_deferred(inventory_data: Dictionary):
	# Load plant inventory
	for plant_data in inventory_data.get("plants", []):
		print(plant_data);
		for i in range(plant_data["ItemData"]["Quantity"]):
			add_plant_inventory_item(save_load_data[plant_data["ItemData"]["Name"]]);
		#for i in range(plant_data["ItemQuantity"]):
		#	add_plant_inventory_item(plant_data["ItemData"])

	# Load potion inventory
	for potion_data in inventory_data.get("potions", []):
		print(potion_data);
		for i in range(potion_data["ItemData"]["Quantity"]):
			add_potion_inventory_item(save_load_data[potion_data["ItemData"]["Name"]]);
		#for i in range(potion_data["ItemQuantity"]):
		#	add_potion_inventory_item(potion_data["ItemData"])

func clear_inventory():
	# Clear plant and potion inventories
	for item in current_plant_inventory:
		item.queue_free()
	for item in current_potion_inventory:
		item.queue_free()

	current_plant_inventory.clear()
	current_potion_inventory.clear()
