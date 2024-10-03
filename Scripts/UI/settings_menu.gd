extends Control

signal menu_closed

@onready var time_mode_option_button = $SettingsMenuScreen/ButtonGridContainer/TimeOptionButton
@onready var close_button = $SettingsMenuScreen/ButtonGridContainer/CloseButton

func _ready():
	# Load saved preference or defualt to In-Game time
	var time_mode = PlayerData.get_time_mode()
	if time_mode == "Real-Time":
		time_mode_option_button.selected = 1
	else:
		time_mode_option_button.selected = 0
	
	time_mode_option_button.connect("item_selected", Callable(self, "_on_time_mode_option_button_item_selected"))
	close_button.connect("pressed", Callable(self, "_on_close_button_pressed"))

func _on_time_mode_option_button_item_selected(index):
	var selected_time_mode = time_mode_option_button.get_item_text(index)
	# Save the player's preference
	PlayerData.set_time_mode(selected_time_mode)
	# Update DayNightCycle
	DayNightCycle.update_time_mode(selected_time_mode)

func _on_close_button_pressed():
	emit_signal("menu_closed")
	queue_free()
