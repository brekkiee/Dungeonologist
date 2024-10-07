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

## Colour Variants ##
# Liquid
@onready var anim_liquid_red = preload("res://Assets/Sprites/Alchemy/brew_cauldron_liquid_0.png")
@onready var anim_liquid_blue = preload("res://Assets/Sprites/Alchemy/brew_cauldron_liquid_1.png")
@onready var anim_liquid_green = preload("res://Assets/Sprites/Alchemy/brew_cauldron_liquid_2.png")
@onready var anim_liquid_yellow = preload("res://Assets/Sprites/Alchemy/brew_cauldron_liquid_3.png")
@onready var anim_liquid_orange = preload("res://Assets/Sprites/Alchemy/brew_cauldron_liquid_4.png")
@onready var anim_liquid_violet = preload("res://Assets/Sprites/Alchemy/Brew_cauldron_liquid_5.png")
@onready var anim_liquid_indigo = preload("res://Assets/Sprites/Alchemy/brew_cauldron_liquid_6.png")

# For sound fx:
#@onready var sfx_correct = preload("")
#@onready var sfx_incorrect = preload("")

# Start animation for cauldron bubbling when ready
func _ready():
	add_child(color_timer)
	color_timer.one_shot = true
	color_timer.connect("timeout", Callable(self, "_on_timer_timeout"))
	ladle.connect("gui_input", Callable(self, "_on_ladle_gui_input"))
	
	liquid.texture = anim_liquid_red
	anim_splash.set_animation("brew_splash_red")
	anim_bubble.set_animation("brew_bubble_red")
	
	anim_bubble.play()
	
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
	if correct_recipe:
		liquid.texture = anim_liquid_blue
		anim_bubble.set_animation("brew_bubble_blue")
	else:
		liquid.texture = anim_liquid_green
		anim_bubble.set_animation("brew_bubble_green")
	#anim_bubble.visible = false
	# Start timer to reset color
	color_timer.start(3)

func _on_timer_timeout():
	liquid.texture = anim_liquid_red  # Reset to default color
	anim_bubble.set_animation("brew_bubble_red")
	anim_splash.visible = false
	#anim_bubble.visible = true
