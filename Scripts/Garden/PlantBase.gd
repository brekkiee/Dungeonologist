class_name PlantBase
extends Area2D

@onready var plant_animation = $PlantAnimSprite2D

var growth_speed: float = 1
var harvested_item_name: String = ""

func _ready():
	plant_animation.speed_scale = growth_speed
	#plant_animation.connect("animation_finished", Callable(self, "_on_growth_animation_finished"))

# Called when the growth animation finishes
func _on_growth_animation_finished():
	if plant_animation.animation == "growth":
		# Stop on the last frame of the animation
		plant_animation.stop()
		plant_animation.frame = plant_animation.sprite_frames.get_frame_count("growth") - 1

# Adds a new item to the inventory when the plant is clicked
# Item added is determined by the harvested_item_name variable
func _on_input_event(viewport, event, shape_idx):
	if InputMap.event_is_action(event, "left_click"):
		if event.pressed:
			if InventoryManager.add_plant_inventory_item(harvested_item_name):
				#This executes if it sucessfully added plants to Inventory 
				#since there is space available
				plant_animation.frame = 0
				plant_animation.play("growth")
				pass
			else:
				#This executes if the inventory is full and can't have more plants
				print("Inventory is full, can't add new plants")
				pass
