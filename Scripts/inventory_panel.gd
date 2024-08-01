extends Control

var holding = false
var min_x_value: float = -845
var max_x_value: float = -200
var initial_difference: float

# Called when node enters scene tree for the first time
func _ready():
	# Set inventory panel parent in InventoryManager
	InventoryManager.invetory_panel_parent = self

func _process(delta):
	if holding:
		# gets the new position based on the current mouse position and
		# the distance between the mouse and the sliding drawer
		var new_x_pos = get_global_mouse_position().x - initial_difference
		# makes sure that the new value is not outside the range of the 
		# minimum and maximum allowed range
		new_x_pos = clamp(new_x_pos, min_x_value, max_x_value)
		# sets the positon
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
			print("Started dragging drawer.")
		#event.pressed is false when the mouse lets go of left click
		else:
			holding = false
			print("Ended dragging drawer.")
