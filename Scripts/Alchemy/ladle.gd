# Ladle.gd
extends Area2D

var is_following_mouse = false
var original_position = Vector2.ZERO
@export var cauldron_node: Node2D

func _ready():
	original_position = position
	# Enable monitoring to detect overlaps
	set_process_input(true)

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			if not is_following_mouse:
				# Start following mouse
				is_following_mouse = true
			else:
				# Stop following mouse
				is_following_mouse = false
				# Check if over cauldron
				#if cauldron_node.overlaps_point(get_global_mouse_position()):
				cauldron_node.stir_mixture()
				# Return ladle to original position
				position = original_position

func _process(delta):
	if is_following_mouse:
		self.set_global_position(get_global_mouse_position())
