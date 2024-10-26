extends QuestBase

func _init():
	# Initialise quest-specific information
	info["Name"] = "ProgressQuest"
	info["Type"] = "chat"
	info["NpcSprite"] = "res://Assets/Sprites/Characters/char_4_Elspeth.png"
	info["QuestDisplayName"] = "Progress Quest"
	info["QuestDescription"] = {
		1: "Talk to Elspeth",
		2: "Complete any research task",
		3: "Talk to Elspeth"
	}
	
	quest_name = info["Name"]
	quest_type = info["Type"]
	max_stage = 4
	
	start_quest()
