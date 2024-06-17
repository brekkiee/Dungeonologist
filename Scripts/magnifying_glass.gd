extends Area2D

@export var picked_up: bool

func _on_mouse_entered():
		if not picked_up:
			picked_up = true
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if picked_up and Input.is_mouse_button_pressed(1):
		global_position = get_global_mouse_position()
	if Input.is_mouse_button_pressed(0):
		picked_up = false

func _on_mouse_exited():
	if not Input.is_mouse_button_pressed(1):
		picked_up = false
