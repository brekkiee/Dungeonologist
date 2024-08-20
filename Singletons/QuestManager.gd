extends Node

@onready var quest_display_scene = preload("res://Quests/quest_display.tscn")

var quest_display: Control
var active_quests = {
	"chat": null,
	"garden": null,
	"alchemy": null,
	"monster": null,
	"expedition": null	
}
var completed_quests = []

# Dictionary to store all quests for game
var quests_data: Dictionary = {
	"TutorialQuest" :{
		"script": "res://Quests/TutorialQuest/tutorialquest.gd",
		"type": "chat",
	},
	"HarvestQuest" :{
		"script": "res://Quests/harvestquest.gd",
		"type": "garden",
	},
	"PotionQuest" :{
		"script": "",
		"type": "alchemy",
	},
	"FeedQuest" :{
		"script": "",
		"type": "monster",
	},
	"ExpeditionQuest" :{
		"script": "",
		"type": "expedition",
	}
}

func _ready():
	# Instantiate and add quest display to the scene tree
	quest_display = quest_display_scene.instantiate()
	get_tree().root.add_child.call_deferred(quest_display)

# Add quest to active quests
func add_quest(quest_id: String):
	var quest_data = quests_data.get(quest_id, null)
	if quest_data == null:
		print("Quest ID not found: ", quest_id)
		return
	
	var quest_type = quest_data["type"]
	if active_quests[quest_type] == null:
		var quest_script = load(quest_data["script"])
		if quest_script:
			var quest_instance = quest_script.new()
			active_quests[quest_type] = quest_instance
			quest_instance.start_quest()
			print("Added new quest: ", quest_id, " of type: ", quest_type)
			update_quest_display(quest_id)
		else:
			print("Failed to load quest script: ", quest_data["script"])
	else:
		print("A quest of type ", quest_type, " is already active.")

	# NPC can update only when there is a quest active
	if quest_type == "chat" and GameManager.npc:
		GameManager.npc.update_npc_sprite_based_on_active_quest()

# Method to update the quest display based on active quest
func update_quest_display(quest_id: String) -> void:
	var quest = active_quests[quests_data[quest_id]["type"]]
	if quest:
		var quest_name = quest.info["QuestDisplayName"]
		var quest_description = quest.info["QuestDescription"][1]
		quest_display.update_quest(quest_name, quest_description)
	else:
		print("Quest data not found for quest ID: ", quest_id)

# Progress a specific quest
func progress_quest(quest_type: String, stage: int):
	if active_quests[quest_type] != null:
		active_quests[quest_type].progress_quest(stage)

# Complete a specific quest
func complete_quest(quest_type: String):
	if active_quests.has(quest_type) and active_quests[quest_type] != null:
		# Only call the quest's complete_quest method once
		if completed_quests.has(quest_type):
			print("Warning: Attempted to complete a quest that is already completed: ", quest_type)
		else:
			active_quests[quest_type].complete_quest()
			completed_quests.append(quest_type)
	else:
		print("Warning: Attempted to complete a quest that is no longer active or does not exist: ", quest_type)
