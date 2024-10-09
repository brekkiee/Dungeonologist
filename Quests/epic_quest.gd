extends QuestBase

func _init():
	# Initialise quest-specific information
	info["Name"] = "EpicQuest"
	info["Type"] = "chat"
	info["NpcSprite"] = "res://Assets/Sprites/Characters/char_3_Colin.png"
	info["QuestDisplayName"] = "Epic Quest"
	info["QuestDescription"] = {
		1: "Talk to Colin",
		2: "Brew a potion for Colin",
		3: "Send Colin on an expedition",
		4: "Collect expedition rewards",
		5: "More quests to come!"
	}
	
	quest_name = info["Name"]
	quest_type = info["Type"]
	max_stage = 6
	
	start_quest()
