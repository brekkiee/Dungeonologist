extends Node2D

@export var picked_up: bool = false
@export var target_color: Color = Color(0, 1, 0)  # Green color
@export var normal_color: Color = Color(1, 1, 1)  # Default color (white)
@onready var sprite: Sprite2D = $Sprite2D
@export var splinter_path: NodePath  # Path to the splinter node

func _on_mouse_entered():
	picked_up = true

func _process(delta):
	if picked_up and Input.is_mouse_button_pressed(1):
		global_position = get_global_mouse_position()
	if Input.is_mouse_button_pressed(0):
		picked_up = false

#	var splinter = get_node(splinter_path)
#	if splinter:
#		var collision_shape = splinter.get_node("CollisionShape2D")
#		if collision_shape:
#			var shape = collision_shape.shape
#			var splinter_rect = Rect2(collision_shape.global_position - shape.extents, shape.extents * 2)
#			if splinter_rect.has_point(global_position):
#				sprite.modulate = target_color  # Change color to green
#			else:
#				sprite.modulate = normal_color  # Change color back to normal

func _on_mouse_exited():
	picked_up = false

#func _input(event):
#	if event is InputEventMouseButton and event.pressed and picked_up:
##		var splinter = get_node(splinter_path)
#		if splinter and splinter.visible:
#			var collision_shape = splinter.get_node("CollisionShape2D")
#			if collision_shape:
#				var shape = collision_shape.shape
#				var splinter_rect = Rect2(collision_shape.global_position - shape.extents, shape.extents * 2)
#				if splinter_rect.has_point(mouse_position):
#					var monster = get_tree().get_root().get_node("Home/monster")
#					if monster and monster.has_method("heal_monster"):
#						monster.heal_monster()
