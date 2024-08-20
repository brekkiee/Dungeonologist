extends Control

func _on_resume_button_pressed():
	GameManager.toggle_pause()

func _on_main_menu_button_pressed():
	# Unpause and go back to the Start Menu
	GameManager.toggle_pause()
	GameManager.change_scene("StartMenu")

func _on_exit_button_pressed():
	# Quit the game
	get_tree().quit()
