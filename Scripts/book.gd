extends PanelContainer

@onready var title_label = $MarginContainer/VBoxContainer/Title
@onready var title2_label = $MarginContainer/VBoxContainer/Title2
@onready var pic_texture = $MarginContainer/VBoxContainer/Pic
@onready var text_label = $MarginContainer/VBoxContainer/Text

var title = ""
var title2 = ""
var pic = 0
var text
var page_index = 0

func _ready():
	_display_title_page()
	
const page_text: Array[String] = [
	"0",
	"1",
	"Common Slime",
	"Slimus Commonius",
	"The common slime can be found in dungeons across the continent. 
	They prefer wet environments and can even be found living underwater. 
	They don't appear to need oxygen to breathe. ",
	"2",
	"Deep Dungeon Sharptooth",
	"Sharpus Deepus",
	"The Deep Dungeon Sharptooth is said to lurk in the deepest levels of the dungeon.
	There has only been three sightings... at least by those who have lived to report it.",
]

func _display_page(index: int, text_to_display: Array):
	print(page_index)
	title_label.text = text_to_display[index + 1]
	title2_label.text = text_to_display[index + 2]
	text_label.text = text_to_display[index + 3]
	
func _display_title_page():
	print(page_index)
	title_label.text = "Dungeon Field Guide"
	title2_label.text = "Index"
	text_label.text = "1. Common Slime
	2. Deep Dungeon Sharptooth"
	
func _on_prev_page_button_pressed():
	if page_index == 0: # already on title page
		return
		
	if page_index == 1: # on page 1
		page_index = 0
		_display_title_page()
		
	if page_index >= 2:
		page_index -= 4
		_display_page(page_index, page_text)

func _on_next_page_button_pressed():
	if page_index >= page_text.size() - 4: # end of book, don't turn page
		return
		
	if page_index >= 1:
		page_index += 4
		_display_page(page_index, page_text)
		
	if page_index == 0: # on title page
		page_index = 1
		_display_page(page_index, page_text)
