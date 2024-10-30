extends Area2D

signal stirred_mixture()

var is_following_mouse = false
var original_position = Vector2.ZERO

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
				print("Stiring Mixture Cast")
				# Stop following mouse
				is_following_mouse = false
				# Emit signal to stir the mixture
				emit_signal("stirred_mixture")
				# Return ladle to original position
				position = original_position

func _process(delta):
	if is_following_mouse:
		self.global_position = get_global_mouse_position()
