class_name QuestBase
extends Node

var quest_name = ""
var quest_type = ""
var current_stage = 0
var max_stage = 2 # Default max stage for a quest

func start_quest():
	current_stage = 0
	update_quest_display()

func progress_quest(stage: int):
	if stage <= max_stage:
		current_stage = stage
		update_quest_display()
		if current_stage == max_stage:
			complete_quest()

func update_quest_display():
	if current_stage < max_stage:
		QuestManager.quest_display.update_quest(quest_name, "Stage " + str(current_stage) + " of the quest")
	else:
		QuestManager.quest_display.update_quest(quest_name, "Quest completed!")
	pass

func complete_quest():
	print(quest_name + " quest completed!")
	update_quest_display()
	# Call additional logic needed when the quest is completed
	QuestManager.complete_quest(quest_type)
	pass
	
# Method to update NPC sprite, can be called from any QuestBase derived quest script
func update_npc_sprite(texture_path: String):
	var npc = GameManager.npc
	if npc and npc.has_method("update_sprite"):
		npc.update_sprite(texture_path)
	else:
		print("NPC script or method not found.")
