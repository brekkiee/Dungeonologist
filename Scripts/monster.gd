extends Area2D

@onready var monster_sprite = $monsterSprite2D

func _ready():
	monster_sprite.modulate = Color(0, 1, 0)  # Set monster to green at the start

func heal_monster():
	monster_sprite.modulate = Color(1, 1, 1)  # Reset color to normal
