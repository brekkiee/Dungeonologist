extends Control

@onready var quest_name = $PanelContainer/VBoxContainer/QuestName
@onready var quest_text = $PanelContainer/VBoxContainer/QuestText


func update_quest(name: String, text: String):
	quest_name.text = name
	quest_text.text = text

func complete_quest():
	quest_name.text = ""
	quest_text.text = ""
