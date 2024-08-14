extends Control

@export var quest_name: Label
@export var quest_text: Label


func _ready():
	print("quest_name: ", quest_name)
	print("quest_text: ", quest_text)

func update_quest(questName: String, text: String):
	print("Update quest called.")
	if quest_name == null or quest_text == null:
		print("Error: quest_name or quest_text is null!")
		return
	print("Updating quest_name.text and quest_text.text")
	quest_name.text = questName
	quest_text.text = text
	print("quest_name.text: ", quest_name.text, " quest_text.text: ", quest_text.text)

func complete_quest():
	if quest_name != null and quest_text != null:
		quest_name.text = ""
		quest_text.text = ""
	else:
		print("Error: quest_name or quest_text is null!")
