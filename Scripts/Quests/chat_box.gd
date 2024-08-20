extends Control

@export var chat: RichTextLabel
@export var character_name: RichTextLabel
@onready var npc_texture = $NPCTexture
@onready var timer = $Timer
@export var scroll_container: ScrollContainer

const MAX_WIDTH = 800

var textToDisplay = ""
var letter_index = 0

# timing customisation for text display
@export var letter_time = 0.03
@export var space_time = 0.06
@export var punct_time = 0.2

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
	
	# fEnable word wrap if width exceeds max
	if size.x > MAX_WIDTH:
		chat.autowrap_mode = TextServer.AUTOWRAP_WORD
		custom_minimum_size.y = size.y
		
	chat.text = ""
	letter_index = 0
	_display_character()
	
# displays each character with appropriate timing
func _display_character():
	chat.text += textToDisplay[letter_index]
	letter_index += 1
	
	# Scroll to the bottom as new text is added
	call_deferred("_scroll_to_bottom()")
	
	if letter_index >= textToDisplay.length():
		finished.emit()
		return
	
	# set timer for character type
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

func _scroll_to_bottom():
	if scroll_container:
		scroll_container.scroll_vertical = scroll_container.get_v_scrollbar().max_value
