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
			return true
		# if identical item doesn't exist in inventory, check for an empty slot
		elif inventory[i] == null:
			inventory[i] = item # add item to empty inventory slot
			inventoryUpdated.emit()
			return true
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
