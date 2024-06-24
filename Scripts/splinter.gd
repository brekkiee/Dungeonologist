extends Area2D
@export var Tweezer : Node2D
@onready var sprite : Sprite2D =  $Sprite2D
signal healmonster

func _on_area_entered(area):
	if area == Tweezer:
		sprite.visible = false
		emit_signal("healmonster")

