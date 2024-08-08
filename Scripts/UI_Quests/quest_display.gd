extends Control

@onready var quest_name = $PanelContainer/VBoxContainer/QuestName
@onready var quest_text = $PanelContainer/VBoxContainer/QuestText


func update_quest(questName: String, text: String):
	quest_name.text = questName
	quest_text.text = text

func complete_quest():
	quest_name.text = ""
	quest_text.text = ""
