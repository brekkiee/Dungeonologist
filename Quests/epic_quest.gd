extends QuestBase

func _init():
	# Initialise quest-specific information
	info["Name"] = "EpicQuest"
	info["Type"] = "chat"
	info["NpcSprite"] = "res://Assets/Sprites/Characters/char_3_Colin.png"
	info["QuestDisplayName"] = "Epic Quest"
	info["QuestDescription"] = {
		1: "Brew a potion for Colin",
		2: "Send Colin on an expedition",
		3: "Collect expedition rewards"
	}
	
	quest_name = info["Name"]
	quest_type = info["Type"]
	max_stage = 3
	
	start_quest()
