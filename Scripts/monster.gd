extends Area2D

@onready var monster_sprite = $monsterSprite2D
signal quest_complete
func _ready():
	monster_sprite.modulate = Color(0, 1, 0)  # Set monster to green at the start


func _on_heal_monster():
	emit_signal("quest_complete")
	monster_sprite.modulate = Color(1, 1, 1)  # Reset color to normal
