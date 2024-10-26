extends Control

@export var chat: RichTextLabel
@export var character_name: RichTextLabel
@onready var npc_texture = $NPCTexture
@onready var timer = $Timer
@export var scroll_container: ScrollContainer

const MAX_WIDTH = 800

var textToDisplay = ""
var letter_index = 0
var is_fast_forward = false

# Timing customization for text display (reduced for faster display)
@export var letter_time = 0.01
@export var space_time = 0.02
@export var punct_time = 0.03

signal finished

func display_text(speaker_name: String, text_to_display: String, emotion_texture_path: String):
	textToDisplay = text_to_display
	chat.text = ""
	character_name.text = speaker_name
	custom_minimum_size.x = min(size.x, MAX_WIDTH)
	
	# Load and set the NPC texture based on emotion
	var texture = load(emotion_texture_path)
	if texture:
		npc_texture.texture = texture
		npc_texture.queue_redraw()
	else:
		print("Failed to load texture from path: ", emotion_texture_path)
	
	# Enable word wrap if width exceeds max
	if size.x > MAX_WIDTH:
		chat.autowrap_mode = TextServer.AUTOWRAP_WORD
		custom_minimum_size.y = size.y
		
	chat.text = ""
	letter_index = 0
	is_fast_forward = false
	_display_character()
	
# Displays each character with appropriate timing
func _display_character():
	if is_fast_forward:
		chat.text = textToDisplay
		# Defer emitting 'finished' to avoid immediate state change
		call_deferred("_emit_finished")
		return
	
	chat.text += textToDisplay[letter_index]
	letter_index += 1
	
	if letter_index >= textToDisplay.length():
		# Defer emitting 'finished' to avoid immediate state change
		call_deferred("_emit_finished")
		return
	
	# Set timer for character type
	match textToDisplay[letter_index]:
		"!", ".", ",", "?": # punctuation
			timer.start(punct_time)
		" ": # spaces
			timer.start(space_time)
		_: # Other characters
			timer.start(letter_time)
	
# Timer signals when to display next character
func _on_timer_timeout():
	_display_character()

# Finish displaying the text instantly
func finish_text():
	is_fast_forward = true
	_display_character()

func _emit_finished():
	finished.emit()
