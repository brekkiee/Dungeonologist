class_name PlantBase
extends Area2D

@onready var plant_animation = $PlantAnimSprite2D
@onready var mouse_control: Control = $Control

var growth_speed: float = 1
var harvested_item_data: ItemData = null

var is_fully_grown = false  # Variable to track if the plant is fully grown

func _ready():
	plant_animation.speed_scale = growth_speed
	# Connect the animation_finished signal
	plant_animation.connect("animation_finished", Callable(self, "_on_growth_animation_finished"))
	# Connect the frame_changed signal
	plant_animation.connect("frame_changed", Callable(self, "_on_frame_changed"))
	is_fully_grown = false

# Called when the growth animation finishes
func _on_growth_animation_finished():
	if plant_animation.animation == "growth":
		# Stop on the last frame of the animation
		plant_animation.stop()
		plant_animation.frame = plant_animation.sprite_frames.get_frame_count("growth") - 1
		# Set cursor to pointing hand
		mouse_control.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		# Do not set is_fully_grown here; it's handled in _on_frame_changed()

# Function called whenever the animation frame changes
func _on_frame_changed():
	if plant_animation.animation == "growth":
		var last_frame = plant_animation.sprite_frames.get_frame_count("growth") - 1
		if plant_animation.frame == last_frame:
			# Plant is fully grown
			mouse_control.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
			is_fully_grown = true  # Set is_fully_grown to true here
		else:
			if plant_animation.is_playing():
				# Plant is still growing
				mouse_control.mouse_default_cursor_shape = Control.CURSOR_ARROW
				is_fully_grown = false  # Ensure the flag is false during growth
			else:
				# Animation is stopped, do not change is_fully_grown
				pass

# Adds a new item to the inventory when the plant is clicked
# Item added is determined by the harvested_item_data variable
func _on_input_event(viewport, event, shape_idx):
	if InputMap.event_is_action(event, "left_click"):
		if event.pressed:
			if is_fully_grown:
				if InventoryManager.add_plant_inventory_item(harvested_item_data):
					# Successfully added plant to inventory
					plant_animation.frame = 0
					plant_animation.play("growth")
					mouse_control.mouse_default_cursor_shape = Control.CURSOR_ARROW  # Reset cursor
					QuestManager.on_plant_harvested()
					is_fully_grown = false  # Reset growth state
				else:
					# Inventory is full
					print("Inventory is full, can't add new plants")
			else:
				# Plant is not fully grown, cannot harvest
				print("Plant is not fully grown yet.")
