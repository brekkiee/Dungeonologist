extends Node

var current_scene = null

func _ready():
	# Store current scenee name in variable
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)
	QuestManager.addQuest.call_deferred("TutorialQuest")

func change_scene(scene_name):
	if scene_name != current_scene.name:
		if scene_name == "Home":
			call_deferred("_deferred_goto_scene", "res://Scenes/home.tscn")
		elif scene_name == "AlchemyLab":
			call_deferred("_deferred_goto_scene", "res://Scenes/alchemy_lab.tscn")
		elif scene_name == "MonsterEnclosure":
			call_deferred("_deferred_goto_scene", "res://Scenes/monster_enclosure.tscn")

func _deferred_goto_scene(path):
	print("Loading Scene: " + path)
	# safely remove current scene safely
	current_scene.free()
	# Load new scene
	var s = ResourceLoader.load(path)
	# Instance new scene
	current_scene = s.instantiate()
	# Add new scene to active scene
	get_tree().get_root().add_child(current_scene)
	# now compatible with the SceneTree.change_scene() API
	get_tree().set_current_scene(current_scene)

func tool_click(clickedItem, toolname):
	if QuestManager.ActiveQuests.has("TutorialQuest"):
		# check if clicked item is splinter
		if clickedItem.name == "splinter": 
			play_sound() #  plays success sound
			# check which tool made the click
			if toolname == "MagnifyingGlass":
				if QuestManager.ActiveQuests["TutorialQuest"]["CurrentStage"] < 2:
					QuestManager.advanceQuest("TutorialQuest") # advance quest 
			elif toolname == "Tweezers":
				get_node("/root/Home/monster")._on_heal_monster()
				QuestManager.completeQuest("TutorialQuest")
				clickedItem.get_node("Sprite2D").visible = false
	return true

func play_sound():
	var audio_stream = get_node("/root/Home/MainMusic")
	if audio_stream:
		# assign sound to play here or in inspector
		audio_stream.stream = load("res://Sounds/ToolSuccessSound.wav")
		audio_stream.play()
