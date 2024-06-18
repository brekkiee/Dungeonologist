extends Control

@onready var book_scene = preload("res://Scenes/book.tscn")

var book
var book_open = false

func _on_monster_book_pressed():
	if not book_open:
		book_open = true
		book = book_scene.instantiate()
		get_tree().root.add_child(book)
	elif book_open:
		book.queue_free()
		book_open = false
