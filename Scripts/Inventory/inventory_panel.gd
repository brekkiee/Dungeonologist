extends Control

var holding = false
var min_x_value: float = -924
var max_x_value: float = 0
var initial_difference: float

@onready var Cursor_Default_Texture = preload("res://Assets/Sprites/UI/Cursor_Default.png")
@onready var drawer_handle = get_node("DrawerHandle")

# Called when node enters scene tree for the first time
func _ready():
	# Set inventory panel parent in InventoryManager
	InventoryManager.inventory_panel_parent = self
	# Connect mouse enter and exit signals for sliding drawer
	if drawer_handle:
		drawer_handle.connect("mouse_entered", Callable(self, "_on_mouse_entered"))
	if drawer_handle:
		drawer_handle.connect("mouse_exited", Callable(self, "_on_mouse_exited"))
	print("drawer_handle: ", drawer_handle)

func _process(delta):
	if holding:
		# gets the new position based on the current mouse position and
		# the distance between the mouse and the sliding drawer
		var new_x_pos = get_global_mouse_position().x - initial_difference
		# makes sure that the new value is not outside the range of the 
		# minimum and maximum allowed range
		new_x_pos = clamp(new_x_pos, min_x_value, max_x_value)
		# sets the position
		position = Vector2(new_x_pos, position.y)

func _on_texture_rect_gui_input(event):
	if InputMap.event_is_action(event, "left_click"):
		#event.pressed is true when the mouse starts holding down
		if event.pressed:
			# setting the initial difference to be the distance between the mouse
			# and the sliding drawer, this is done so that all future movement
			# is relative
			initial_difference = get_global_mouse_position().x - position.x
			holding = true
		#event.pressed is false when the mouse lets go of left click
		else:
			holding = false
			if position.x == max_x_value:
				InventoryManager.alert.visible = false

# Called when the mouse enters the area
func _on_mouse_entered():
	Input.set_custom_mouse_cursor(Cursor_Default_Texture)  # Set custom default cursor

# Called when the mouse exits the area
func _on_mouse_exited():
	Input.set_custom_mouse_cursor(null)  # Reset to default cursor
