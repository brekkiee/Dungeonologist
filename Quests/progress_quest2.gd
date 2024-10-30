extends QuestBase

func _init():
	# Initialise quest-specific information
	info["Name"] = "ProgressQuest2"
	info["Type"] = "chat"
	info["NpcSprite"] = "res://Assets/Sprites/Characters/char_4_Elspeth.png"
	info["QuestDisplayName"] = "Progress Quest"
	info["QuestDescription"] = {
		1: "Complete any research task",
	}
	
	quest_name = info["Name"]
	quest_type = info["Type"]
	max_stage = 2
	
	start_quest()
