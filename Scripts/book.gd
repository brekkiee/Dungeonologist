extends PanelContainer

@onready var title_label = $MarginContainer/VBoxContainer/Title
@onready var title2_label = $MarginContainer/VBoxContainer/Title2
@onready var pic = $MarginContainer/VBoxContainer/Pic
@onready var text_label = $MarginContainer/VBoxContainer/Text

var title = ""
var title2 = ""
var text
var page_index = 0

func _ready():
	_display_title_page()

# list of monster pics for each page
var page_pic: Array[Texture2D] = [
	load("res://Assets/UI/chatbox.png"),
	load("res://Assets/Sprites/slime.png"),
	load("res://Assets/Sprites/octo.png"),
]

# list of page titles
const page_title: Array[String] = [
	"0",
	"Common Slime",
	"Deep Dungeon Sharptooth",
]

# list of page subtitles 
const page_title2: Array[String] = [
	"0",
	"Slimus Commonus",
	"Sharpus Deepus",
]

# list of main body text for each page
const page_text: Array[String] = [
	"0",
	"The common slime can be found in dungeons across the continent. 
	They prefer wet environments and can even be found living underwater. 
	They don't appear to need oxygen to breathe. ",
	"The Deep Dungeon Sharptooth is said to lurk in the deepest levels of the dungeon.
	There has only been three sightings... at least by those who have lived to report it.",
]

# display the correct content for each page based on the index provided
func _display_page(index: int):
	pic.texture = page_pic[index]
	title_label.text = page_title[index]
	title2_label.text = page_title2[index]
	text_label.text = page_text[index]

# display the title page
func _display_title_page():
	pic.texture = null
	title_label.text = "Dungeon Field Guide"
	title2_label.text = "Index"
	text_label.text = "1. Common Slime
	2. Deep Dungeon Sharptooth"

# display the previous page
func _on_prev_page_button_pressed():
	if page_index == 0: # already on title page
		return
		
	if page_index == 1: # on page 1
		page_index = 0
		_display_title_page()
		
	if page_index >= 2:
		page_index -= 1
		_display_page(page_index)

# display the next page
func _on_next_page_button_pressed():
	if page_index >= page_text.size() - 1: # end of book, don't turn page
		return
		
	if page_index >= 1:
		page_index += 1
		_display_page(page_index)
		
	if page_index == 0: # on title page
		page_index = 1
		_display_page(page_index)
