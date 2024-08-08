extends Area2D

@onready var monster_sprite = $monsterSprite2D
@onready var hunger_meter = 5
@onready var happiness_meter = 5
@onready var hunger_timer = Timer.new()
@onready var happiness_timer = Timer.new()
var tween: Tween

signal quest_complete

func _ready():
	# Add timers to enclosure scene
	add_child(hunger_timer)
	add_child(happiness_timer)
	
	# Set timer properties
	hunger_timer.wait_time = 10.0 # Need to adjust as necessary
	hunger_timer.one_shot = false
	hunger_timer.connect("timeout", Callable(self, "_on_hunger_timer_timeout"))
	
	happiness_timer.wait_time = 10.0 # Need to adjust as necessary
	happiness_timer.one_shot = false
	happiness_timer.connect("timeout", Callable(self, "_on_hunger_timer_timeout"))
	
	# Start the timers
	hunger_timer.start()
	happiness_timer.start()
		
	# Update the monster visuals when spawned
	update_monster()
	random_move()

# Called to update monster movement, hunger, happiness
func update_monster():
	if hunger_meter == 0 or happiness_meter == 0:
		monster_sprite.modulate = Color(1,0,0) # Sad monster
	else:
		monster_sprite.modulate = Color(1,1,1) # Happy healthy monstaah

func _on_hunger_timer_timeout():
	if hunger_meter > 0:
		hunger_meter -= 1
	update_monster()

func _on_happiness_timer_timeout():
	if happiness_meter > 0:
		happiness_meter -= 1
	update_monster()
	
func feed_monster():
	hunger_meter = 5
	update_monster()
	
func pet_monster():
	happiness_meter = 5
	update_monster()
	
# Random movement within the enclosure
func random_move():
	tween = create_tween()
	
	var random_pos = Vector2(randi() % get_viewport().size.x, randi() % get_viewport().size.y)
	tween.tween_property(self, "position", random_pos, 2.0)
	await tween.finished
	random_move()
	
# Handle input event when click on the monster
func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			pet_monster() # For now, left click pets the monster
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			feed_monster() # For now, just right click to feed the monstaah
	
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
