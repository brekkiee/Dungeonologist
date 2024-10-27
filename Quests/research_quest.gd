extends QuestBase

func _init():
	# Initialise quest-specific information
	info["Name"] = "ResearchQuest"
	info["Type"] = "chat"
	info["NpcSprite"] = "res://Assets/Sprites/Characters/char_1_Guntheidon.png"
	info["QuestDisplayName"] = "Research Quest"
	info["QuestDescription"] = {
		1: "Complete research task: Common Slime",
		2: "Complete research task",
		3: "Talk to Elspeth"
	}
	
	quest_name = info["Name"]
	quest_type = info["Type"]
	max_stage = 4
	
	start_quest()
