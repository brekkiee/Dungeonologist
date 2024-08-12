extends Control

@onready var book_scene = preload("res://Quests/Codex/codex.tscn")

var book
var book_open = false

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
