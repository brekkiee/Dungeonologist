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
@onready var ladle_alert = ladle.get_node("InvAlert")

var first_potion_mixed = true

## Colour Variants ##
@onready var anim_liquid_red = preload("res://Assets/Sprites/Alchemy/brew_cauldron_liquid_0.png")
@onready var anim_liquid_blue = preload("res://Assets/Sprites/Alchemy/brew_cauldron_liquid_1.png")
@onready var anim_liquid_green = preload("res://Assets/Sprites/Alchemy/brew_cauldron_liquid_2.png")

func _ready():
	add_child(color_timer)
	color_timer.one_shot = true
	color_timer.connect("timeout", Callable(self, "_on_timer_timeout"))

	slot1.connect("item_added_to_slot", Callable(self, "_on_item_added_to_slot"))
	slot1.connect("item_removed_from_slot", Callable(self, "_on_item_removed_from_slot"))
	slot2.connect("item_added_to_slot", Callable(self, "_on_item_added_to_slot"))
	slot2.connect("item_removed_from_slot", Callable(self, "_on_item_removed_from_slot"))

	$ClickableArea.input_pickable = true
	$ClickableArea.connect("input_event", Callable(self, "_on_Cauldron_input_event"))

	_set_liquid_color("red")
	anim_bubble.play()

func _on_Cauldron_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT and ladle.is_following_mouse == true:
		stir_mixture()

func stir_mixture():
	if slot1.item_data != null and slot2.item_data != null:
		mix_ingredients()
	else:
		print("Need at least 2 ingredients to mix")

func mix_ingredients():
	var ingredients = [slot1.item_data.Name, slot2.item_data.Name]
	ingredients.sort()
	var recipe_found = false

	anim_splash.visible = true
	anim_splash.play()

	for recipe in InventoryManager.cauldron_recipies.values():
		var required_items = recipe.items_required.duplicate()
		required_items.sort()
		if required_items == ingredients:
			recipe_found = true
			_show_potion_mixture(true)
			GameManager.play_sound("mission_completed")
			get_node("PotionSuccess").texture = recipe.result.Sprite
			await get_tree().create_timer(1).timeout
			get_node("PotionSuccess").texture = null
			InventoryManager.add_potion_inventory_item(recipe.result)
			if first_potion_mixed:
				first_potion_mixed = false
				GameManager.main_ui.inventory_alert.visible = true
			break

	if not recipe_found:
		_show_potion_mixture(false)

	_clear_slots()
	ladle_alert.visible = false

func _clear_slots():
	slot1.item_data = null
	icon1.texture = null
	slot2.item_data = null
	icon2.texture = null

func _on_item_added_to_slot(slot, item_data):
	if slot1.item_data != null and slot2.item_data != null:
		if GameManager.first_time_alchemy_lab == true:
			ladle_alert.visible = true
			GameManager.first_time_alchemy_lab = false
	pass

func _on_item_removed_from_slot(slot, item_data):
	InventoryManager.add_plant_inventory_item(item_data)

func _show_potion_mixture(correct_recipe: bool):
	await get_tree().create_timer(1.0).timeout
	if correct_recipe:
		_set_liquid_color("blue")
	else:
		_set_liquid_color("green")
	color_timer.start(3)

func _set_liquid_color(color: String):
	match color:
		"red":
			liquid.texture = anim_liquid_red
			anim_bubble.animation = "brew_bubble_red"
			anim_splash.animation = "brew_splash_red"
		"blue":
			liquid.texture = anim_liquid_blue
			anim_bubble.animation = "brew_bubble_blue"
		"green":
			liquid.texture = anim_liquid_green
			anim_bubble.animation = "brew_bubble_green"

func _on_timer_timeout():
	_set_liquid_color("red")
	anim_splash.visible = false
