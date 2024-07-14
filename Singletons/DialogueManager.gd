extends Node

@onready var chat_box_scene = preload("res://Scenes/chat_box.tscn")

var chat_lines = []
var current_line_index = 0
var chat_box
var chat_box_pos: Vector2
var is_chat_active = false
var can_advance_line = false

# Start new chat at given position with provided lines
func start_chat(position: Vector2, lines):
	if is_chat_active:
		# Add new lines to current chat if chat is active
		chat_lines += lines
		return # Exit if chat is already active

	chat_lines = lines
	chat_box_pos = position
	_show_chat_box()
	is_chat_active = true

# Set up and display chat box scene
func _show_chat_box():
	chat_box = chat_box_scene.instantiate()
	# Connect signal for when chat box is ready for next line
	chat_box.finished.connect(_on_chat_box_finished)
	get_node("/root/Header/UI/MainUI").add_child(chat_box)
	# Set chat box position and display first line of text
	chat_box.global_position = chat_box_pos
	chat_box.display_text(chat_lines[current_line_index])
	can_advance_line = false

# Enable advancing to next line when chat box finishes current line
func _on_chat_box_finished():
	can_advance_line = true

# Handle input for advancing chat lines
func _unhandled_input(event):
	if (
		event.is_action_pressed("advance_text") and
		is_chat_active and
		can_advance_line
	):
		chat_box.queue_free()
		current_line_index += 1

		# End chat if all lines are shown
		if current_line_index >= chat_lines.size():
			QuestManager.chat_finished()
			is_chat_active = false
			current_line_index = 0 # Reset line index
			return

		_show_chat_box()
