extends Panel

@export var monster_scene: PackedScene = preload("res://Scenes/monster.tscn")
@onready var spawn_point: Node2D = $MonsterSpawnPoint

func spawn_monster():
	if monster_scene:
		var monster = monster_scene.instantiate()
		monster.position = spawn_point.global_position
		get_tree().root.call_deferred("add_child", monster)
	else:
		print("Monster scene not set")
