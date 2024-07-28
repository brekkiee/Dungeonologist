extends Control

@onready var monster_book_button = $MonsterBook

func _ready():
	print("Running _ready")
	if monster_book_button:
		print("MonsterBook button found")
		monster_book_button.connect("pressed", Callable(self, "_on_monster_book_pressed"))
		print("Signal connected to _on_monster_book_pressed")
	else:
		print("MonsterBook button not found")

func _on_monster_book_pressed():
	print("Button pressed")
