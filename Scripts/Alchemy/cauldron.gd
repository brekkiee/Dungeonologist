extends Node2D

@onready var alchemy_emote = $AlchemyEmote
@export var yes_texture = Texture2D
@export var no_texture = Texture2D
@onready var timer = Timer.new()

# Start animation for cauldron bubbling when ready
func _ready():
	add_child(timer)
	timer.one_shot = true
	timer.connect("timeout", Callable(self, "_on_timer_timeout"))
	
	
	#var _animated_sprite = get_node("CauldronAnimation2d")
	#_animated_sprite.play()
	pass

func display_emote(correct_recipe: bool):
	if correct_recipe:
		alchemy_emote.texture = yes_texture
	elif not correct_recipe:
		alchemy_emote.texture = no_texture
	else:
		alchemy_emote.texture = null
	
	# Start emote display timer
	timer.start(5)

# Called when the timer times out
func _on_timer_timeout():
	alchemy_emote.texture = null

# Handle input event signal from cauldron node in garden scene
func _on_input_event(viewport, event, shape_idx):
	if InputMap.event_is_action(event, "left_click"):
		if event.pressed and InventoryManager.item_mouse_follow != null:
			# Add item to cauldron's inventory
			InventoryManager.current_cauldron_inventory.append(InventoryManager.item_mouse_follow.ItemName)
			# Notify InventoryManager item is used
			InventoryManager.item_used_click()

# Handle input event signal from ladle node in garden scene
func _on_ladle_input_event(viewport, event, shape_idx):
	if InputMap.event_is_action(event, "left_click"):
		if event.pressed:
			# Sort items in cauldron inventory before comparing to recipes
			var sorted_cauldron_items = InventoryManager.current_cauldron_inventory.duplicate()
			sorted_cauldron_items.sort()
			
			var recipe_found = false
			
			# Check if current items match any recipe
			for i in InventoryManager.cauldron_recipies.size():
				if InventoryManager.cauldron_recipies[i].items_required == sorted_cauldron_items:
					# Add resulting product from recipe
					if InventoryManager.add_potion_inventory_item(InventoryManager.cauldron_recipies[i].result):
						# sucessfully added potions to Inventory since there is space available
						# clearing the cauldron's Inventory
						display_emote(true)
						print("valid recipe created, item added.")
						InventoryManager.current_cauldron_inventory = []
						recipe_found = true
						break
					else:
						#This executes if the inventory is full and can't have more potions
						print("Inventory is full, can't add new potions")
			if not recipe_found:
				display_emote(false)
				InventoryManager.current_cauldron_inventory = []
				print("invalid recipe, items in cauldron deleted.")
			# Clear cauldron inventory

