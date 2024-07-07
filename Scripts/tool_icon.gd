extends Node2D

var mouse_over: bool = false
var mouse_over_area: Area2D = null
@onready var tool_box = get_parent()

func _on_mouse_entered():
	mouse_over = true

func _process(delta):
	# Call toolbox_click() if mouse clicks on tool
	if mouse_over and Input.is_action_just_pressed("left_click"):
		tool_box.toolbox_click(self)

func _on_mouse_exited():
	mouse_over = false

func _on_area_entered(area):
	mouse_over_area = area

func _on_area_exited(area):
	# Clear the area if mouse exits same area
	if mouse_over_area == area:
		area = null
