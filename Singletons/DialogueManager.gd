extends Node

@onready var chat_box_scene = preload("res://Quests/Dialogue/chatbox.tscn")
var chat_lines: Array = []
var current_line_index = 0
var chat_box
var chat_box_pos: Vector2 = Vector2(350, 400)
var is_chat_active = false
var can_advance_line = false


#func _process(delta):
#	print("line index: ",current_line_index, " chat_line size: ", chat_lines.size())
# Start new chat at given position with provided lines
func start_chat(emotions: Dictionary, lines: Array):
	if is_chat_active:
		return # Exit if chat is already active
		
	current_line_index = 0
	chat_lines = lines
	_show_chat_box()
	
	is_chat_active = true

# set up new chat box scene
func _show_chat_box():
	print("showing new chatbox")
	chat_box = chat_box_scene.instantiate()
	var scene_spawn_point = get_node("/root/Header/UI")
	# get signal from chat box when ready for new line
	chat_box.finished.connect(_on_chat_box_finished)
	#parent_node.add_child(chat_box)
	#get_tree().root.add_child(chat_box)
	scene_spawn_point.add_child(chat_box)
	
	#display first line of text
	var current_line = chat_lines[current_line_index]
	
	#grab text from array and assign to correct variables
	
	var speaker_name = current_line.get("name", "")
	var dialogue_text = current_line.get("text", "")
	
	# Set chat box position and display first line of text
	chat_box.global_position = chat_box_pos
	chat_box.display_text(speaker_name, dialogue_text)
	can_advance_line = false

# Enable advancing to next line when chat box finishes current line
func _on_chat_box_finished():
	print("chatbox finished")
	can_advance_line = true

# handle input for advancing chat lines
#it dhfunc _unhandled_input(event):
	#if event.is_action_pressed("advance_text"):
	#	print("dialogue manager input event")
	#	advanceText()

func advanceText():
	
		if (
		is_chat_active &&
		can_advance_line
		):
			
			chat_box.queue_free()
			current_line_index += 1
			print( "size: ", chat_lines.size()," current line index: ",current_line_index)
		# End chat if all lines are shown
			if current_line_index >= (chat_lines.size()):
				is_chat_active = false 
				print("chat is no longer active ")
				current_line_index = 0 # reset line index
				return
			_show_chat_box()
		else:
			print("is chat active: ",is_chat_active, "can advance line: ", can_advance_line)
