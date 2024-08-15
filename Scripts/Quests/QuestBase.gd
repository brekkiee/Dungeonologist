class_name QuestBase
extends Node

var quest_name = ""
var quest_type = ""
var current_stage = 0
var max_stage = 2 # Default max stage for a quest

var is_completed = false
var info: Dictionary

func _init():
	info  = {
	"Name": "",
	"Type": "",
	"NpcSprite": "",
	"QuestDisplayName": "",
	"QuestDescription": {
		1: "",
		2: ""
	}
}

func start_quest():
	print("Starting quest with info: ", info)
	current_stage = 0
	is_completed = false
	update_quest_display()
	update_npc_sprite(info.NpcSprite)

func progress_quest(stage: int):
	if stage <= max_stage:
		current_stage = stage
		update_quest_display()
		if current_stage == max_stage:
			complete_quest()

func update_quest_display():
	print("Updating quest display with current stages: ", current_stage)
	var display_text = ""
	if current_stage < max_stage:
		display_text = info.QuestDescription.get(current_stage + 1, "Default Stage Description")
	else:
		display_text = info.QuestDescription.get(max_stage, "Default Completion Description")

	QuestManager.quest_display.update_quest(info.QuestDisplayName, display_text)
	print("quest script params Name: ", info.QuestDisplayName)
	print("quest script params Description: ", display_text)

func complete_quest():
	if is_completed:
		return # Prevent re-completion of the quest
	
	print(quest_name + " quest completed!")
	is_completed = true
	update_quest_display()
	# Call additional logic needed when the quest is completed
	QuestManager.complete_quest(quest_type)
	
# Method to update NPC sprite, can be called from any QuestBase derived quest script
func update_npc_sprite(texture_path: String):
	var npc = GameManager.npc
	if npc and npc.has_method("update_sprite"):
		npc.update_sprite(texture_path)
	else:
		print("NPC script or method not found.")
