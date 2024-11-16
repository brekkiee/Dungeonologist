class_name PlantBase
extends Area2D

@onready var plant_animation = $PlantAnimSprite2D
@onready var mouse_control: Control = $Control

var growth_speed: float = 1.0  # Adjusted for 10 minutes growth
var harvested_item_data: ItemData = null

var is_fully_grown = false  # Variable to track if the plant is fully grown

# Load custom cursor textures
@onready var cursor_cutters_texture = preload("res://Assets/Sprites/UI/Cursor_Cut_0.png")

func _ready():
	plant_animation.speed_scale = growth_speed
	# Connect the animation_finished signal
	plant_animation.connect("animation_finished", Callable(self, "_on_growth_animation_finished"))
	# Connect the frame_changed signal
	plant_animation.connect("frame_changed", Callable(self, "_on_frame_changed"))
	is_fully_grown = false
	# Connect mouse enter and exit signals
	if not is_connected("mouse_entered", Callable(self, "_on_mouse_entered")):
		connect("mouse_entered", Callable(self, "_on_mouse_entered"))
	if not is_connected("mouse_exited", Callable(self, "_on_mouse_exited")):
		connect("mouse_exited", Callable(self, "_on_mouse_exited"))
	if not is_connected("input_event", Callable(self, "_on_input_event")):
		connect("input_event", Callable(self, "_on_input_event"))
	
	DayNightCycle.connect("day_started", Callable(self, "_on_day_started"))
	plant_animation.play("growth")  # Start the growth animation when ready

# Called when the growth animation finishes
func _on_growth_animation_finished():
	if plant_animation.animation == "growth":
		# Stop on the last frame of the animation
		plant_animation.stop()
		plant_animation.frame = plant_animation.sprite_frames.get_frame_count("growth") - 1
		# Do not set is_fully_grown here; it's handled in _on_frame_changed()

# Function called whenever the animation frame changes
func _on_frame_changed():
	if plant_animation.animation == "growth":
		var last_frame = plant_animation.sprite_frames.get_frame_count("growth") - 1
		if plant_animation.frame == last_frame:
			# Plant is fully grown
			is_fully_grown = true  # Set is_fully_grown to true here
		else:
			if plant_animation.is_playing():
				# Plant is still growing
				is_fully_grown = false  # Ensure the flag is false during growth
			else:
				# Animation is stopped, do not change is_fully_grown
				pass

# Called when mouse enters area
func _on_mouse_entered():
	if is_fully_grown:
		Input.set_custom_mouse_cursor(cursor_cutters_texture)

# Called when mouse exits area
func _on_mouse_exited():
	Input.set_custom_mouse_cursor(null)
	mouse_control.mouse_default_cursor_shape = Control.CURSOR_ARROW

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
					Input.set_custom_mouse_cursor(null)  # Reset cursor
					QuestManager.on_plant_harvested()
					is_fully_grown = false  # Reset growth state
				else:
					# Inventory is full
					print("Inventory is full, can't add new plants")
			else:
				# Plant is not fully grown, cannot harvest
				print("Plant is not fully grown yet.")

# Called when a new day starts
func _on_day_started(day_count):
	# Skip growth to fully grown if a new day starts
	is_fully_grown = true
	plant_animation.stop()
	plant_animation.frame = plant_animation.sprite_frames.get_frame_count("growth") - 1
	update_cursor_state()

func update_cursor_state():
	if is_fully_grown:
		Input.set_custom_mouse_cursor(cursor_cutters_texture)
	else:
		Input.set_custom_mouse_cursor(null)
