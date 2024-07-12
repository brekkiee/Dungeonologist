extends Node

# references
@onready var inventory_slot_scene = preload("res://Scenes/inventory_slot.tscn")

var inventory = []

signal inventoryUpdated

func _ready():
	inventory.resize(30) # set default size to 30

# adds an item to the inventory, returns true if successful
func addItem(item):
	# iterate over inventory slots
	for i in range(inventory.size()):
		# check if item already exists in inventory
		if inventory[i] != null and inventory[i]["name"] == item["name"]:
			inventory[i]["quantity"] += item["quantity"] # update quantity
			inventoryUpdated.emit()
			print("+" + str(item["quantity"]) + item["name"])
			return true
		# if identical item doesn't exist in inventory, check for an empty slot
		elif inventory[i] == null:
			inventory[i] = item # add item to empty inventory slot
			inventoryUpdated.emit()
			print("Adding " + item["name"] + " to inventory")
			return true
	print("Couldn't add item to inventory :(")
	return false # if no inventory slots available 

# removes an item from the inventory
func removeItem(item):
		# iterate over inventory slots
	for i in range(inventory.size()):
		# check if item already exists in inventory
		if inventory[i] != null and inventory[i]["name"] == item["name"]:
			inventory[i]["quantity"] -= 1 # update quantity
			# if none of the item exist in the inventory, set slot to empty
			if inventory[i]["quantity"] <= 0:
				inventory[i] = null
				
			inventoryUpdated.emit()
			return true
	return false

#increases inventory size dynamically
func increaseInventorySize():
	inventoryUpdated.emit()

func dropItem(item_data, drop_pos):
	var item_scene = load(item_data["scene_path"])
	var item_instance = item_scene.instantiate()
	# pass all the item data to the new item
	item_instance.set_item_data(item_data)
	
	# set position and add item instance to the scene tree
	item_instance.global_position = drop_pos
	get_tree().current_scene.add_child(item_instance)
	# make item draggable so the player can drop it into the scene
	item_instance.item_is_draggable = true
