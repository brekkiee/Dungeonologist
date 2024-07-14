extends PanelContainer

@onready var title_label = $MarginContainer/VBoxContainer/Title
@onready var title2_label = $MarginContainer/VBoxContainer/Title2
@onready var pic = $MarginContainer/VBoxContainer/Pic
@onready var text_label = $MarginContainer/VBoxContainer/Text
@onready var research_tasks_label = $MarginContainer/VBoxContainer/ResearchTasks
@onready var task1_label = $MarginContainer/VBoxContainer/Task1
@onready var task2_label = $MarginContainer/VBoxContainer/Task2

var title = ""
var title2 = ""
var text
var research_tasks
var task1 
var task2 

var task1_complete = false
var task2_complete = false

# list of monster pics for each page
var page_pic: Array[Texture2D] = [
	load("res://Assets/chatbox.png"),
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

# list of research tasks (1)
const page_task1: Array[String] = [
	"0",
	"Feed every food type to a single slime.",
	"Catch a Deep Dungeon Sharp Tooth.",
]

# list of research tasks (2)
const page_task2: Array[String] = [
	"0",
	"Find all slime colour variations.",
	"Discover the Deep Dungeon Sharptooth's favourite food.",
]

# display the correct content for each page based on the index provided
func display_page(index: int):
	if index >= page_text.size():
		display_blank()
	else:
		pic.texture = page_pic[index]
		title_label.text = page_title[index]
		title2_label.text = page_title2[index]
		text_label.text = page_text[index]
		research_tasks_label.text = "Research Tasks:"
		if task1_complete:
			task1_label.text = "COMPLETE" # change later to fun fact
		else:
			task1_label.text = page_task1[index]
		if task2_complete:
			task2_label.text = "COMPLETE" # change later to fun fact
		else:
			task2_label.text = page_task2[index]

# display the title page
func display_title_page():
	pic.texture = null
	title_label.text = "Dungeon Field Guide"
	title2_label.text = "Index"
	text_label.text = "1. Common Slime
	2. Deep Dungeon Sharptooth"
	research_tasks_label.text = ""
	task1_label.text = ""
	task2_label.text = ""

func display_blank():
	pic.texture = null
	title_label.text = ""
	title2_label.text = ""
	text_label.text = ""
	research_tasks_label.text = ""
	task1_label.text = ""
	task2_label.text = ""
