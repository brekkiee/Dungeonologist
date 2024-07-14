extends Control

@onready var page_scene = preload("res://Scenes/page.tscn")
@onready var left_page = $AspectRatioContainer/PanelContainer/TextureRect/HBoxContainer/MarginContainer/LeftPage
@onready var right_page = $AspectRatioContainer/PanelContainer/TextureRect/HBoxContainer/MarginContainer2/RightPage

var left_page_index = 0
var right_page_index = left_page_index + 1

# Called when the node enters the scene tree for the first time.
func _ready():
	left_page.display_title_page()
	right_page.display_page(1)

# display the previous page
func _on_prev_button_pressed():
	if left_page_index == 0: # already on title page
		return
		
	if left_page_index == 2: # on page 2
		left_page_index = 0
		left_page.display_title_page()
		right_page.display_page(left_page_index + 1)
		
	if left_page_index >= 4:
		left_page_index -= 2
		left_page.display_page(left_page_index)
		right_page.display_page(left_page_index + 1)

# display the next page
func _on_next_button_pressed():
	if left_page_index + 1 >= left_page.page_text.size() + 1:  # end of book, don't turn page
		return
		
	if left_page_index >= 2:
		left_page_index += 2
		left_page.display_page(left_page_index)
		right_page.display_page(left_page_index + 1)
		
	if left_page_index == 0: # on title page
		left_page_index = 2
		left_page.display_page(left_page_index)
		right_page.display_page(left_page_index + 1)
