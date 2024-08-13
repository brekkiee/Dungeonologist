extends Node

@onready var quest_display_scene = preload("res://Quests/quest_display.tscn")

var quest_display

# Dictionary to store all quests for the level/monster
var Quests: Dictionary = {
	"TutorialQuest" :{
		"Script": "res://Quests/TutorialQuest/tutorialquest.gd",
		"QuestType": "monster",
	},
}

var active_monster_quest: Node = null
var ActiveOtherQuests = []
var CompletedQuests = []

func _ready():
	# Instantiate and add quest display to the scene tree
	quest_display = quest_display_scene.instantiate()
	get_tree().root.add_child.call_deferred(quest_display)

# Add quest to active quests
func addQuest(quest_id: String):
	#var questNodeParent = get_node("/root/Header/QuestsScriptsNode")
	if Quests[quest_id].QuestType == "monster":
		if active_monster_quest == null:
			# Load and instantiate the quest script
			var quest_script = load(Quests[quest_id].Script)
			active_monster_quest = quest_script.new()
	else:
		# Handle other types of quests here
		pass

# Called from dialogue manager when current conversation is finished
# Calls chat_finished method in active monster quest if it exists
func chat_finished():
	if active_monster_quest != null:
		if active_monster_quest.has_method("chat_finished"):
			active_monster_quest.chat_finished()

# Removes active monster quest and associated monster
# Only used when the quest is completed and monster is no longer required
func delete_monster_quest():
	CompletedQuests.append(active_monster_quest.info.Name)
	active_monster_quest.queue_free.call_deferred()
	active_monster_quest = null
	GameManager.spawned_monster.queue_free.call_deferred()
	GameManager.spawned_monster = null
