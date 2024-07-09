extends Node

@onready var quest_display_scene = preload("res://Scenes/quest_display.tscn")
var quest_display

# Dictionary to store all quests for the level/monster
var quests: Dictionary = {
	"TutorialQuest" :{
		"QuestName": "Help Carlson",
		"CurrentStage": 0,
		"QuestDescription":{
			"1": "Diagnose Carlson",
			"2": "Treat Carlson"
		}
	},
}

var activeQuests: Dictionary = {}
var completedQuests: Array = []

func _ready():
	quest_display = quest_display_scene.instantiate()
	get_tree().root.add_child.call_deferred(quest_display)

# Add quest to active quests
func addQuest(quest_id: String):
	if quest_id in quests.keys():
		activeQuests[quest_id] = quests[quest_id]
		advanceQuest(quest_id)
	else:
		print(quest_id + ": quest not found.")

# update current stage of quest
func advanceQuest(quest_id: String):
	if not activeQuests.has(quest_id):
		print("Error: Quest ID " + quest_id + " not found in ActiveQuests")
		return
	# increment current stage by 1 and convert to string
	activeQuests[quest_id]["CurrentStage"] += 1
	var current_stage: String = str(activeQuests[quest_id]["CurrentStage"])
	
	if current_stage in activeQuests[quest_id]["QuestDescription"].keys():
		# get updated quest description for the new stage
		quest_display.update_quest(activeQuests[quest_id]["QuestName"], activeQuests[quest_id]["QuestDescription"][current_stage])
	else:
		completeQuest(quest_id)
	
# handle quest completion
func completeQuest(quest_id: String):
	if activeQuests.has(quest_id):
		completedQuests.append(quests[quest_id]["QuestName"])
		activeQuests.erase(quest_id)
		quest_display.complete_quest()
		print("quest completed")
