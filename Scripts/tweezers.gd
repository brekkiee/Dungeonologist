extends Node2D

@export var picked_up: bool = false
@export var target_color: Color = Color(0, 1, 0)  # Green color
@export var normal_color: Color = Color(1, 1, 1)  # Default color (white)
@export var sprite: Sprite2D
@export var splinter_path: NodePath  # Path to the splinter node

func _on_mouse_entered():
	picked_up = true

func _process(delta):
	if picked_up and Input.is_mouse_button_pressed(1):
		global_position = get_global_mouse_position()
	if Input.is_mouse_button_pressed(0):
		picked_up = false

func _on_mouse_exited():
	picked_up = false
