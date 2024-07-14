extends Control

@onready var codex_scene = preload("res://Scenes/codex.tscn")
@onready var exam_table_scene = $AspectRatioContainer/HBoxContainer/Room/ExaminationTable

var book
var book_open = false
signal quest_complete_npc

func _on_monster_book_pressed():
	print("Button pressed")
	if not book_open:
		print("Opening book")
		book_open = true
		book = book_scene.instantiate()
		print("Book instantiated")
		call_deferred("add_child", book)
		print("Book added to scene tree")
	elif book_open:
		print("Closing book")
		book.queue_free()
		book_open = false

#func _ready():
#	# Spawning a monster TODO: Add button
#	exam_table_scene.spawn_monster()


func _on_monster_quest_complete():
	emit_signal("quest_complete_npc")
