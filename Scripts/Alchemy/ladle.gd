extends Area2D

signal stirred_mixture()

var is_following_mouse = false
var original_position = Vector2.ZERO

@onready var cursor_pointer_texture = preload("res://Assets/Sprites/UI/Cursor_Default.png")

func _ready():
	original_position = position
	# Enable monitoring to detect overlaps
	set_process_input(true)
	connect("mouse_entered", Callable(self, "_on_mouse_entered"))
	connect("mouse_exited", Callable(self, "_on_mouse_exited"))

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

func _on_mouse_entered():
	Input.set_custom_mouse_cursor(cursor_pointer_texture)

func _on_mouse_exited():
	Input.set_custom_mouse_cursor(null)
