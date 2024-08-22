extends Control

@onready var main_window_scene = preload("res://Scenes/Windows/MainWindow.tscn")

	
func _on_start_button_pressed():
	GameManager.start_game()
	hide()

func _on_exit_button_pressed():
	# Quit the game
	get_tree().quit()
