class_name MonsterBase
extends CharacterBody2D

@export var species: MonsterSpecies

# Meters
@export_group("Meters Variables")
@export_range(0, 5) var hunger_meter = 5
@onready var hunger_rate = species.hunger_rate
@export_range(0, 5 ) var happiness_meter = 5
@onready var unhappy_rate = species.unhappy_rate
# Movement variables
@onready var movement_speed = species.movement_speed
@onready var min_move_time = species.min_move_time
@onready var max_move_time = species.max_move_time
var movement_direction = Vector2.ZERO
# Idle variables
@onready var min_idle_time = species.min_idle_time
@onready var max_idle_time = species.max_idle_time
# Emote textures
@onready var emote_time = 3.0
@onready var emote_happy: Texture2D
@onready var emote_sad: Texture2D
@onready var emote_neutral: Texture2D
@onready var emote_sick: Texture2D
@onready var emote_angry: Texture2D
@onready var emote_plead: Texture2D
@onready var emote_cringe: Texture2D
@onready var emote_poop: Texture2D
@onready var emote_shock: Texture2D
@onready var emote_question: Texture2D
# Animations & sprites variables
@onready var monster_animation = $MonsterAnimSprite2D
@onready var hunger_meter_animation = $HungerAnimSprite2D
@onready var happiness_meter_animation = $HappyAnimSprite2D
@onready var emote_sprite = $EmoteSprite2D
# Timers
@onready var hunger_timer = Timer.new()
@onready var happiness_timer = Timer.new()
@onready var pause_timer = Timer.new()
@onready var visibility_timer = Timer.new()
@onready var emote_timer = Timer.new()
# Item drop variables
@onready var item_id: int = species.item_type
@onready var drop_rate: int = species.drop_rate
# Item drop variables
var items_dropped: Dictionary = {}  # Stores items ready to be collected
var item_ready_to_collect: bool = false
var foods_fed = []
var all_food_items = ["dawn_grass", "thimbleweed"]
#TODO: Add these food items in all_food_items:
#"inkberry", "sweetroot", "blood_cap", "sentient_moss", "rotten_fruit", "dwarven_nettle", "gelatinous_blob"

signal quest_complete

# Called when the node enters the scene tree for the first time.
func _ready():
	# Add timers to enclosure scene
	add_child(hunger_timer)
	add_child(happiness_timer)
	add_child(pause_timer)
	add_child(visibility_timer)
	add_child(emote_timer)
	# Load monster emotes
	_load_emotes()
	# Set timer properties
	_set_timer_properties()
	# Start the meter timers
	hunger_timer.start()
	happiness_timer.start()
	# Initially hide the meters
	_hide_meters()
	# Update the monster movement when spawned
	update_monster()
	random_move()
	add_to_group("monsters")
	# Connect DayNightCycle signal
	DayNightCycle.connect("day_started", Callable(self, "_on_day_started"))

func _on_day_started(day_count):
	attempt_item_drop()
# Load all the monster emote textures
func _load_emotes():
	emote_happy = load("res://Assets/Sprites/Emotes/emote_0_Happy.png")
	emote_sad = load("res://Assets/Sprites/Emotes/emote_2_Sad.png")
	emote_neutral = load("res://Assets/Sprites/Emotes/emote_1_Neutral.png")
	emote_sick = load("res://Assets/Sprites/Emotes/emote_3_Sick.png")
	emote_angry = load("res://Assets/Sprites/Emotes/emote_4_Angry.png")
	emote_plead = load("res://Assets/Sprites/Emotes/emote_5_Plead.png")
	emote_cringe = load("res://Assets/Sprites/Emotes/emote_6_Cringe.png")
	emote_poop = load("res://Assets/Sprites/Emotes/emote_7_Poop.png")
	emote_shock = load("res://Assets/Sprites/Emotes/emote_8_Shock.png")
	emote_question = load("res://Assets/Sprites/Emotes/emote_9_Question.png")
	_hide_emote()
# Called to update monster movement, hunger, happiness
func update_monster():
	if not item_ready_to_collect:
		if hunger_meter == 0 or happiness_meter == 0:
			#monster_animation.modulate = Color(1,0,0) # Sad monster
			emote_sprite.texture = emote_sad
			_show_emote()
		elif hunger_meter <= 2 or happiness_meter <= 2:
			emote_sprite.texture = emote_neutral
			_show_emote()
		else:
			#monster_animation.modulate = Color(1,1,1) # Happy healthy monstaah
			emote_sprite.texture = emote_happy
	
	# Play the relevant hunger animation
	match hunger_meter:
		5:
			hunger_meter_animation.play("hunger_5")
		4:
			hunger_meter_animation.play("hunger_4")
		3:
			hunger_meter_animation.play("hunger_3")
		2:
			hunger_meter_animation.play("hunger_2")
		1:
			hunger_meter_animation.play("hunger_1")
		0:
			hunger_meter_animation.play("hunger_0")
	
	# Play the relevant happiness animation
	match happiness_meter:
		5:
			happiness_meter_animation.play("happy_5")
		4:
			happiness_meter_animation.play("happy_4")
		3:
			happiness_meter_animation.play("happy_3")
		2:
			happiness_meter_animation.play("happy_2")
		1:
			happiness_meter_animation.play("happy_1")
		0:
			happiness_meter_animation.play("happy_0")
# Set timers and connect them
func _set_timer_properties():
	hunger_timer.wait_time = hunger_rate # Need to adjust as necessary
	hunger_timer.one_shot = false
	hunger_timer.connect("timeout", Callable(self, "_on_hunger_timer_timeout"))
	
	happiness_timer.wait_time = unhappy_rate # Need to adjust as necessary
	happiness_timer.one_shot = false
	happiness_timer.connect("timeout", Callable(self, "_on_happiness_timer_timeout"))
	
	pause_timer.wait_time = randf_range(min_idle_time, max_idle_time) # Need to adjust as necessary
	pause_timer.one_shot = true
	pause_timer.connect("timeout", Callable(self, "random_move"))
	
	visibility_timer.wait_time = 5.0
	visibility_timer.one_shot = true
	visibility_timer.connect("timeout", Callable(self, "_hide_meters"))
	
	emote_timer.wait_time = emote_time
	emote_timer.one_shot = true
	emote_timer.connect("timeout", Callable(self, "_hide_emote"))

func _on_hunger_timer_timeout():
	if hunger_meter > 0:
		hunger_meter -= 1
	update_monster()
 
func _on_happiness_timer_timeout():
	if happiness_meter > 0:
		happiness_meter -= 1
	update_monster()

func feed_monster():
	var food_item = InventoryManager.held_item
	if food_item in species.diet:
		hunger_meter = 5
		_show_emote()
		update_monster()
		QuestManager.on_monster_fed()
		if species.name == "common_slime":
			if food_item not in foods_fed:
				foods_fed.append(food_item)
				check_common_slime_research_task()
		InventoryManager.item_used_click()
	else:
		print("This monster dosen't eat that")
		#TODO: Provide player feedback

func pet_monster():
	happiness_meter = 5
	_show_emote()
	update_monster()

func inspect_monster():
	print("Inspected monster using magnifying glass")
	_show_meters()
	update_monster()
# Show monster emote
func _show_emote():
	emote_sprite.visible = true
	if not item_ready_to_collect:
		emote_timer.start()
# Hide monster emote
func _hide_emote():
	emote_sprite.visible = false
# Show hunger and happiness meters
func _show_meters():
	hunger_meter_animation.visible = true
	happiness_meter_animation.visible = true
	visibility_timer.start()
# Hide hunger and happiness meters
func _hide_meters():
	hunger_meter_animation.visible = false
	happiness_meter_animation.visible = false
# Random movement within the enclosure
func random_move():
	movement_direction = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)).normalized()
	velocity = movement_direction * movement_speed
	var move_duration = randf_range(min_move_time, max_move_time)
	
	# Move the monster for the duration, then stop
	monster_animation.play("walk")	
	var move_timer = Timer.new()
	move_timer.wait_time = move_duration
	move_timer.one_shot = true
	move_timer.connect("timeout", Callable(self, "_stop_moving"))
	add_child(move_timer)
	move_timer.start()
	
	# Start moving the monster
	set_process(true)
func _physics_process(delta):
	if velocity != Vector2.ZERO:
	# Move the monster and get collision information
		var collision = move_and_collide(movement_direction * velocity)

		# Reverse direction on collision with walls
		if collision:
			# Reverse direction on collision
			movement_direction = -movement_direction
func _stop_moving():
	movement_direction = Vector2.ZERO
	monster_animation.play("idle")
	set_process(false)
	
	# Start the pause timer before the next move
	pause_timer.start()
# Handle input event when click on the monster
func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		var toolbox = get_node("/root/Header/UI/MainUI/ToolBox")
		var current_tool = toolbox.current_tool
		
		if item_ready_to_collect:
			collect_item()
		elif current_tool and current_tool.tool_name == "PettingHand":
			pet_monster()
		elif current_tool and current_tool.tool_name == "MagnifyingGlass":
			inspect_monster()
		elif InventoryManager.item_mouse_follow != null:
			# If item from inventory selected and dragged to monster, click to feed monster
			feed_monster()

func attempt_item_drop():
	if hunger_meter < 2 or happiness_meter < 2:
		#TODO: Monsters don't drop items if not fully fed and happy
		return
	
	var drop_table = species.drop_table
	if drop_table == null:
		print("drop_table not set for this species")
		return  # No drops available for this species

	for item_drop in drop_table.drops:
		var random_value = randf()
		if random_value <= item_drop.drop_rate:
			var quantity = randi_range(item_drop.min_quantity, item_drop.max_quantity)
			# Store the item in items_dropped dictionary
			items_dropped[item_drop.item_name] = quantity
			item_ready_to_collect = true
			emote_sprite.texture = emote_question
			_show_emote()
			break  # Only one item drop per day

func hide_item_drop_emote():
	emote_sprite.visible = false

func collect_item():
	for item_name in items_dropped.keys():
		var quantity = items_dropped[item_name]
		# Add item to inventory
		InventoryManager.add_potion_inventory_item(item_name)
		print("Collected ", quantity, " x ", item_name)
	# Reset item drop variables
	items_dropped.clear()
	item_ready_to_collect = false
	hide_item_drop_emote()
# TODO: Change the magnifying glass to show meters on hover
# instead of on click

func check_common_slime_research_task():
	if foods_fed.size() == all_food_items.size():
		PlayerData.research_tasks_completed["Common Slime"][0] = true
		PlayerData.save_data()
		print("Research task 'Common Slime' completed")
