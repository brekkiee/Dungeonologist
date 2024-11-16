extends Control

@onready var monster_book_scene = preload("res://Quests/Codex/codex.tscn")
@onready var quest_book_scene = preload("res://Quests/Codex/QuestLog.tscn")
@onready var day_count_label = $DayCounterLabel
@onready var time_label = $TimeLabel

@onready var Cursor_Default_Texture = preload("res://Assets/Sprites/UI/Cursor_Default.png")
@onready var monster_book_button = get_node("MainScreen/ScreenBorders/BookShelf/MonsterBook")
@onready var guntheidon_orb_button = get_node("MainScreen/ScreenBorders/BookShelf/GuntheidonOrb")

var monster_book
var monster_book_open = false

var quest_book
var quest_book_open = false

@onready var guntheidon_dialogue_file = "res://Quests/Dialogue/DialogueText/GuntheidonHints.json"
var guntheidon_hint_open = false

func _ready():
	DayNightCycle.connect("day_started", Callable(self, "_on_day_started"))
	update_day_counter(DayNightCycle.day_count)
	DialogueManager.connect("chat_finished", Callable(self, "_on_guntheidon_chat_finished"))
	InventoryManager.alert = get_node("InventoryPanel/SlidingDrawer/DrawerHandle/InvAlert")

	# Connect mouse enter and exit signals for MonsterBook and GuntheidonOrb
	if monster_book_button:
		monster_book_button.connect("mouse_entered", Callable(self, "_on_mouse_entered"))
		monster_book_button.connect("mouse_exited", Callable(self, "_on_mouse_exited"))
	if guntheidon_orb_button:
		guntheidon_orb_button.connect("mouse_entered", Callable(self, "_on_mouse_entered"))
		guntheidon_orb_button.connect("mouse_exited", Callable(self, "_on_mouse_exited"))

func _process(delta):
	update_time_label()

func update_time_label():
	var time_string = DayNightCycle.get_formatted_time()
	time_label.text = time_string

func _on_day_started(day_count):
	update_day_counter(day_count)

func update_day_counter(day_count):
	day_count_label.text = "Day: " + str(day_count)

func _on_monster_book_pressed():
	print("Button pressed")
	if not monster_book_open:
		print("Opening Codex")
		monster_book_open = true
		monster_book = monster_book_scene.instantiate()
		print("Codex instantiated")
		call_deferred("add_child", monster_book)    
		print("Codex added to scene tree")
	elif monster_book_open:
		print("Closing Codex")
		monster_book.queue_free()
		monster_book_open = false
	GameManager.play_sound("click")

func _on_quest_book_pressed():
	print("Quests button pressed")
	if not quest_book_open:
		print("Opening QuestLog")
		quest_book_open = true
		quest_book = quest_book_scene.instantiate()
		print("Codex instantiated")
		call_deferred("add_child", quest_book)    
		print("Codex added to scene tree")
	elif quest_book_open:
		print("Closing Codex")
		quest_book.queue_free()
		quest_book_open = false

func _on_crystal_ball_pressed():
	print("Crystal ball pressed")
	if not guntheidon_hint_open:
		print("Opening Guntheidon Hint")
		guntheidon_hint_open = true
		# Load Guntheidon's hints dialogue file
		var hints = _load_guntheidon_hints()
		# Prepare texture mappings
		var texture_mappings = {}
		for entry in hints:
			if entry.has("texture"):
				texture_mappings[entry["emotion"]] = entry["texture"]
		# Determine available hints
		var available_chat_nums = []
		var chat_num_to_hint = {}
		for entry in hints:
			if entry.has("chat_num"):
				var chat_num = entry["chat_num"]
				var research_task_name = _get_research_task_name_from_chat_num(chat_num)
				if research_task_name != "":
					var task_completed = PlayerData.research_tasks_completed[research_task_name][0]
					if not task_completed:
						if not chat_num_to_hint.has(chat_num):
							chat_num_to_hint[chat_num] = []
						chat_num_to_hint[chat_num].append(entry)
						if !available_chat_nums.has(chat_num):
							available_chat_nums.append(chat_num)
		if available_chat_nums.size() > 0:
			# Choose a random chat_num
			var random_chat_num = available_chat_nums[randi() % available_chat_nums.size()]
			# Get the dialogue lines for this chat_num
			var dialogue_array = chat_num_to_hint[random_chat_num]
			# Start the dialogue
			DialogueManager.start_chat(texture_mappings, dialogue_array)
			GameManager.play_sound("click")
		else:
			print("No hints available.")
			guntheidon_hint_open = false
	else:
		print("Closing Guntheidon Hint")
		# Close the hint dialogue
		DialogueManager.close_chat_box()
		guntheidon_hint_open = false

func _on_guntheidon_chat_finished():
	guntheidon_hint_open = false

func _load_guntheidon_hints():
	var file = FileAccess.open(guntheidon_dialogue_file, FileAccess.READ)
	var content = JSON.parse_string(file.get_as_text())
	return content

func _get_research_task_name_from_chat_num(chat_num):
	# Map chat_num to research task names
	match chat_num:
		"0":
			return "Common Slime"
		"1":
			return "Forest Dinglebat"
		"2":
			return "Common Shrooman"
		"3":
			return "Plains Imp"
		"4":
			return "Shallows Jelly"
		"5":
			return "Nekomata"
		_:
			return ""

# Called when the mouse enters the area
func _on_mouse_entered():
	Input.set_custom_mouse_cursor(Cursor_Default_Texture)  # Set custom default cursor

# Called when the mouse exits the area
func _on_mouse_exited():
	Input.set_custom_mouse_cursor(null)  # Reset to default cursor

func _on_skip_day_button_pressed():
	DayNightCycle.skip_to_next_day()
