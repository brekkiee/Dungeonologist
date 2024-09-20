extends Node2D

@onready var anim_splash = $BrewLiquid/Splash
@onready var anim_bubble = $BrewLiquid/Bubble
@onready var liquid = $BrewLiquid/Liquid
@onready var slot1 = $IngredientSlots/Slot1
@onready var slot2 = $IngredientSlots/Slot2
@onready var icon1 = $IngredientSlots/Slot1/Icon1
@onready var icon2 = $IngredientSlots/Slot2/Icon2
@onready var ladle = $Ladle
@onready var color_timer = Timer.new()

# For sound fx:
#@onready var sfx_correct = preload("")
#@onready var sfx_incorrect = preload("")

# Start animation for cauldron bubbling when ready
func _ready():
	add_child(color_timer)
	color_timer.one_shot = true
	color_timer.connect("timeout", Callable(self, "_on_timer_timeout"))
	anim_bubble.play()
	ladle.connect("gui_input", Callable(self, "_on_ladle_gui_input"))
	
func stir_mixture():
	if slot1.item_name != "" and slot2.item_name != "":
		mix_ingredients()
	else:
		# Give player feedback that ingredients are missing
		print("Need at least 2 ingredients to mix")
		
func mix_ingredients():
	var ingredients = [slot1.item_name, slot2.item_name]
	ingredients.sort()
	var recipe_found = false
	
	anim_splash.visible = true
	anim_splash.play()
	
	for recipe in InventoryManager.cauldron_recipies.values():
		recipe.items_required.sort()
		if recipe.items_required == ingredients:
			recipe_found = true
			print("Correct recipe called")
			_show_potion_mixture(true)
		
			# Add potion to inventory
			InventoryManager.add_potion_inventory_item(recipe.result)
			break
		
	if not recipe_found:
		_show_potion_mixture(false)
		
	_clear_slots()
	
func _clear_slots():
	# Clear the slots
	slot1.item_name = ""
	icon1.texture = null
	slot2.item_name = ""
	icon2.texture = null
	
func _on_item_added_to_slot(slot, item_name):
	# TODO: Additional logic here
	pass

func _on_item_removed_from_slot(slot, item_name):
	InventoryManager.add_plant_inventory_item(item_name)

func _show_potion_mixture(correct_recipe: bool):
	print("correct_recipe: ", correct_recipe)
	await  get_tree().create_timer(1.0).timeout
	liquid.modulate = Color(0, 1, 0) if correct_recipe else Color(1, 1, 0)
	anim_bubble.visible = false
	# Start timer to reset color
	color_timer.start(1)

func _on_timer_timeout():
	liquid.modulate = Color(1, 1, 1)  # Reset to default color
	anim_splash.visible = false
	anim_bubble.visible = true
