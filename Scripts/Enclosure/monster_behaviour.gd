extends Area2D

@onready var monster_sprite = $monsterSprite2D
signal quest_complete


func _ready():
	# Update the monster visuals when spawned
#	update_monster()

#test
# Called to update the appearance of the monster
#func update_monster():
#	# Get the current stage of the quest from tutorialquest.gd
#	var quest_stage = QuestManager.active_monster_quest.CurrentStage
#	if quest_stage < 2:
#		monster_sprite.modulate = Color(0, 1, 0)  # Set monster to green at the start
#		$Splinter.visible = true
#	else:
#		monster_sprite.modulate = Color(1, 1, 1)  # Reset color to normal
#		$Splinter.visible = false

# Handle input event when something clicks on the splinter
#func _on_splinter_input_event(viewport, event, shape_idx):
#	if InputMap.event_is_action(event, "left_click"):
#		var tool_box = GameManager.current_scene.get_node("UI/ToolBox")
#		# Ensure the toolbox has a tool active before calling the function in tutorialquest.gd
#		if event.pressed and tool_box.current_tool != null:
#			QuestManager.active_monster_quest.tool_used(tool_box.current_tool.name)
