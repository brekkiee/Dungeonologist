extends CharacterBody2D

@onready var monster_animation = $MonsterAnimSprite2D
@onready var emote_sprite = $EmoteSprite2D
@onready var hunger_meter = 5
@onready var happiness_meter = 5
@onready var hunger_timer = Timer.new()
@onready var happiness_timer = Timer.new()
@onready var pause_timer = Timer.new()
@export var emote_happy: Texture2D
@export var emote_sad: Texture2D
@export var emote_neutral: Texture2D
@export var emote_sick: Texture2D
@export var emote_angry: Texture2D
@export var emote_plead: Texture2D
@export var emote_cringe: Texture2D
@export var emote_poop: Texture2D
@export var emote_shock: Texture2D
@export var emote_question: Texture2D

var movement_speed = 1.0
var movement_direction = Vector2.ZERO

signal quest_complete

func _ready():
	# Add timers to enclosure scene
	add_child(hunger_timer)
	add_child(happiness_timer)
	add_child(pause_timer)
	
	# Load monster emotes
	_load_emotes()
	
	# Set timer properties
	hunger_timer.wait_time = 5.0 # Need to adjust as necessary
	hunger_timer.one_shot = false
	hunger_timer.connect("timeout", Callable(self, "_on_hunger_timer_timeout"))
	
	happiness_timer.wait_time = 5.0 # Need to adjust as necessary
	happiness_timer.one_shot = false
	happiness_timer.connect("timeout", Callable(self, "_on_happiness_timer_timeout"))
	
	pause_timer.wait_time = randf_range(0.5, 4.0) # Need to adjust as necessary
	pause_timer.one_shot = true
	pause_timer.connect("timeout", Callable(self, "random_move"))
	
	# Start the timers
	hunger_timer.start()
	happiness_timer.start()
	
	# Update the monster visuals when spawned
	update_monster()
	random_move()

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
	

# Called to update monster movement, hunger, happiness
func update_monster():
	if hunger_meter == 0 or happiness_meter == 0:
		#monster_animation.modulate = Color(1,0,0) # Sad monster
		emote_sprite.texture = emote_sad
	elif hunger_meter <= 2 or happiness_meter <= 2:
		emote_sprite.texture = emote_neutral
	else:
		#monster_animation.modulate = Color(1,1,1) # Happy healthy monstaah
		emote_sprite.texture = emote_happy
	

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
	
func inspect_monster():
	# Set the emote to visible
	print("Inspected monster using magnifying glass")
	update_monster()
	
# Random movement within the enclosure
func random_move():
	movement_direction = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)).normalized()
	velocity = movement_direction * movement_speed
	var move_duration = randf_range(0.5, 5.0)
	
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
		print("toolbox: ", toolbox)
		var current_tool = toolbox.current_tool
		print("current_tool: ", current_tool)
		
		if current_tool and current_tool.tool_name == "PettingHand":
			pet_monster()
		elif current_tool and current_tool.tool_name == "MagnifyingGlass":
			inspect_monster()
		elif InventoryManager.item_mouse_follow != null:
			# If item from inventory selected and dragged to monster, click to feed monster
			feed_monster()
			InventoryManager.item_used_click() # Remove the item from the inventory
