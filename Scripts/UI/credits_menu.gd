extends Control

signal menu_closed

@onready var close_button = $CreditsScreen/ButtonGridContainer/CloseButton

func _ready():
	close_button.connect("pressed", Callable(self, "_on_close_button_pressed"))

func _on_close_button_pressed():
	emit_signal("menu_closed")
	queue_free()
