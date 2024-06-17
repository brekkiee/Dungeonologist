extends MarginContainer

@onready var label = $MarginContainer/Label
@onready var timer = $Timer

const MAX_WIDTH = 76

var text = ""
var letter_index = 0

# timing customisation
@export var letter_time = 0.03
@export var space_time = 0.06
@export var punct_time = 0.2

signal finished()

# updates text box text and size
func display_text(text_to_display: String):
	text = text_to_display
	label.text = text_to_display
	
	# update text box size
	custom_minimum_size.x = min(size.x, MAX_WIDTH)
	if size.x > MAX_WIDTH:
		label.autowrap_mode = TextServer.AUTOWRAP_WORD
		custom_minimum_size.y = size.y
		
	global_position.x -= size.x / 2
	global_position.y -= size.y + 24
	
	label.text = ""
	_display_character()
	
# displays each character and sets appropriate timer
func _display_character():
	label.text += text[letter_index]
	
	letter_index += 1
	if letter_index >= text.length():
		finished.emit()
		return 
	
	# set timer for character type
	match text[letter_index]:
		"!", ".", ",", "?": # punctuation
			timer.start(punct_time)
		" ": # spaces
			timer.start(space_time)
		_: # anything else
			timer.start(letter_time)
	
# timer tells script when to display next character
func _on_timer_timeout():
	_display_character()

