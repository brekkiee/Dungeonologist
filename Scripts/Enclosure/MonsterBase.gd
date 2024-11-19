class_name MonsterBase
extends CharacterBody2D

@export var species: MonsterSpecies
@export var monster_id: int = 0

@onready var mouse_control: Control = $Control

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
@onready var emote_time = 2.0
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
var emote_override = false

# Timers
@onready var hunger_timer = Timer.new()
@onready var happiness_timer = Timer.new()
@onready var pause_timer = Timer.new()
@onready var visibility_timer = Timer.new()
@onready var emote_timer = Timer.new()
@onready var emote_override_timer = Timer.new()

# Item drop variables
@onready var item_id: int = species.item_type
@onready var drop_rate: int = species.drop_rate

@onready var cursor_pointer_texture = preload("res://Assets/Sprites/UI/Cursor_Default.png")

var items_dropped: Dictionary = {}  # Stores items ready to be collected
var item_ready_to_collect: bool = false
var foods_fed = []
var all_food_items = [
	"DawnGrass", "Thimbleweed", "Inkberry",
	"Sweetroot", "BloodCap", "SentientMoss",
	"DwarvenNettle", "MeatChicken", "MeatBurger", "MeatSteak", "MeatFish", "MeatOrgan"
]

signal quest_complete

func _ready():
	# Add timers to enclosure scene
	add_child(hunger_timer)
	add_child(happiness_timer)
	add_child(pause_timer)
	add_child(visibility_timer)
	add_child(emote_timer)
	add_child(emote_override_timer)
	
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
	
	# Connect mouse signals
	connect("mouse_entered", Callable(self, "_on_mouse_entered"))
	connect("mouse_exited", Callable(self, "_on_mouse_exited"))

# Mouse enter event to set cursor for collecting items
func _on_mouse_entered():
	if item_ready_to_collect:
		Input.set_custom_mouse_cursor(cursor_pointer_texture)

# Mouse exit event to reset cursor
func _on_mouse_exited():
	Input.set_custom_mouse_cursor(null)
	mouse_control.mouse_default_cursor_shape = Control.CURSOR_ARROW

# Day started event to handle daily activities
func _on_day_started(day_count):
	attempt_item_drop()
	if hunger_meter > 0:
		hunger_meter -= 1
	if happiness_meter > 0:
		happiness_meter -= 1
	update_monster()

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

# Update monster visuals and emotes based on hunger and happiness
func update_monster():
	if not item_ready_to_collect and not emote_override:
		if happiness_meter == 0:
			emote_sprite.texture = emote_sad
		elif hunger_meter == 0:
			emote_sprite.texture = emote_plead
		elif hunger_meter <= 2 or happiness_meter <= 2:
			emote_sprite.texture = emote_neutral
		else:
			emote_sprite.texture = emote_happy
		_show_emote()
	_play_meter_animations()

# Play hunger and happiness meter animations based on meter values
func _play_meter_animations():
	hunger_meter_animation.play("hunger_%d" % hunger_meter)
	happiness_meter_animation.play("happy_%d" % happiness_meter)

# Set timers and connect them
func _set_timer_properties():
	_configure_timer(hunger_timer, hunger_rate, false, "_on_hunger_timer_timeout")
	_configure_timer(happiness_timer, unhappy_rate, false, "_on_happiness_timer_timeout")
	_configure_timer(pause_timer, randf_range(min_idle_time, max_idle_time), true, "random_move")
	_configure_timer(visibility_timer, 5.0, true, "_hide_meters")
	_configure_timer(emote_timer, emote_time, true, "_hide_emote")
	_configure_timer(emote_override_timer, emote_time, true, "_on_emote_override_timeout")

# Generalized function to configure timers
func _configure_timer(timer: Timer, wait_time: float, one_shot: bool, callback: String):
	timer.wait_time = wait_time
	timer.one_shot = one_shot
	timer.connect("timeout", Callable(self, callback))

# Handle hunger timer timeout
func _on_hunger_timer_timeout():
	if hunger_meter > 0:
		hunger_meter -= 1
	update_monster()

# Handle happiness timer timeout
func _on_happiness_timer_timeout():
	if happiness_meter > 0:
		happiness_meter -= 1
	update_monster()

func _on_emote_override_timeout():
	emote_override = false
	update_monster()

# Feed the monster if the food matches its diet
func feed_monster():
	var food_item = InventoryManager.held_item
	if food_item in species.diet:
		hunger_meter = 5
		emote_override = true
		emote_sprite.texture = emote_happy
		_show_emote()
		emote_override_timer.start()
		update_monster()
		QuestManager.on_monster_fed()
		if species.name == "common_slime" and food_item not in foods_fed:
			foods_fed.append(food_item)
			check_common_slime_research_task()
		InventoryManager.item_used_click()
		GameManager.play_sound("chew0")
	else:
		print("This monster doesn't eat that")
		emote_sprite.texture = emote_sick
		GameManager.play_sound("monster_sad0")
		InventoryManager.item_mouse_follow.hide_tooltip()
	_show_emote()
	
# Pet the monster to increase its happiness
func pet_monster():
	happiness_meter = 5
	emote_override = true
	emote_sprite.texture = emote_happy
	_show_emote()
	emote_override_timer.start()
	update_monster()
	GameManager.play_sound("monster_happy1")

# Inspect the monster to show meters
func inspect_monster():
	_show_meters()
	update_monster()
	GameManager.play_sound("click")

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
	monster_animation.play("walk")
	_start_move_timer(move_duration)
	set_process(true)

# Start a timer to control movement duration
func _start_move_timer(duration: float):
	var move_timer = Timer.new()
	move_timer.wait_time = duration
	move_timer.one_shot = true
	move_timer.connect("timeout", Callable(self, "_stop_moving"))
	add_child(move_timer)
	move_timer.start()

# Handle monster movement
func _physics_process(delta):
	if velocity != Vector2.ZERO:
		var collision = move_and_collide(movement_direction * velocity)
		if collision:
			movement_direction = -movement_direction

# Stop monster movement and start idle timer
func _stop_moving():
	movement_direction = Vector2.ZERO
	monster_animation.play("idle")
	set_process(false)
	pause_timer.start()

# Handle input events for the monster
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
			feed_monster()

# Attempt to drop an item based on hunger and happiness
func attempt_item_drop():
	if hunger_meter < 2 or happiness_meter < 2:
		return
	var drop_table = species.drop_table
	if drop_table == null:
		print("drop_table not set for this species")
		return
	for item_data in drop_table.drops:
		if randf() <= item_data.drop_rate:
			var quantity = randi_range(item_data.min_quantity, item_data.max_quantity)
			items_dropped[item_data] = quantity
			item_ready_to_collect = true
			emote_sprite.texture = emote_question
			_show_emote()
			GameManager.play_sound("click")
			break

# Collect dropped items
func collect_item():
	for item_data in items_dropped.keys():
		for i in range(items_dropped[item_data]):
			InventoryManager.add_plant_inventory_item(item_data)
		print("Collected ", items_dropped[item_data], " x ", item_data.Name)
	GameManager.play_sound("monster_happy0")
	items_dropped.clear()
	item_ready_to_collect = false
	emote_sprite.texture = null
	_hide_emote()
	Input.set_custom_mouse_cursor(null)
	mouse_control.mouse_default_cursor_shape = Control.CURSOR_ARROW

# Check if common slime research task is completed
func check_common_slime_research_task():
	if foods_fed.size() == all_food_items.size():
		PlayerData.research_tasks_completed["Common Slime"][0] = true
		PlayerData.save_data()
		print("Research task 'Common Slime' completed")
