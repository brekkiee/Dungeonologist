extends Control

@onready var monster_book_scene = preload("res://Quests/Codex/codex.tscn")
@onready var quest_book_scene = preload("res://Quests/Codex/QuestLog.tscn")
@onready var day_count_label = $DayCounterLabel
@onready var time_label = $TimeLabel

@onready var inventory_drawer = $InventoryPanel/SlidingDrawer
@onready var skip_day_button_alert = $SkipDayButton/Alert
@onready var inventory_alert = $InventoryPanel/SlidingDrawer/DrawerHandle/InvAlert

@onready var Cursor_Default_Texture = preload("res://Assets/Sprites/UI/Cursor_Default.png")
@onready var monster_book_button = get_node("MainScreen/ScreenBorders/BookShelf/MonsterBook")
@onready var guntheidon_orb_button = get_node("MainScreen/ScreenBorders/BookShelf/GuntheidonOrb")

var monster_book
var monster_book_open = false

var quest_book
var quest_book_open = false

var slime_hint_file = "res://Quests/Dialogue/DialogueText/GuntheidonHints/Slime_Hint.json"
var shrooman_hint_file = "res://Quests/Dialogue/DialogueText/GuntheidonHints/Shrooman_Hint.json"
var dinglebat_hint_file = "res://Quests/Dialogue/DialogueText/GuntheidonHints/Dinglebat_Hint.json"
var imp_hint_file = "res://Quests/Dialogue/DialogueText/GuntheidonHints/Imp_Hint.json"
var jelly_hint_file = "res://Quests/Dialogue/DialogueText/GuntheidonHints/Jelly_Hint.json"
var nekomata_hint_file = "res://Quests/Dialogue/DialogueText/GuntheidonHints/Nekomata_Hint.json"

var hint_files = {
	"Common Slime": slime_hint_file,
	"Forest Dinglebat": dinglebat_hint_file,
	"Common Shrooman": shrooman_hint_file,
	"Plains Imp": imp_hint_file,
	"Shallows Jelly": jelly_hint_file,
	"Nekomata": nekomata_hint_file,
}

var potions_alert = null
var guntheidon_hint_open = false
@onready var hint_alert = $MainScreen/ScreenBorders/BookShelf/GuntheidonOrb/HintOrbAlert
@onready var codex_alert = $MainScreen/ScreenBorders/BookShelf/MonsterBook/CodexAlert

func _ready():
	randomize()
	DayNightCycle.connect("day_started", Callable(self, "_on_day_started"))
	update_day_counter(DayNightCycle.day_count)
	DialogueManager.connect("chat_finished", Callable(self, "_on_guntheidon_chat_finished"))
	InventoryManager.alert = get_node("InventoryPanel/SlidingDrawer/DrawerHandle/InvAlert")
	inventory_alert.connect("visibility_changed", Callable(self, "_on_inventory_alert_visibility_changed"))
	
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

func _on_crystal_ball_pressed():
	print("Crystal ball pressed")
	if hint_alert.visible == true:
		hint_alert.visible = false
	if DialogueManager.is_chat_active:
		DialogueManager.advance_text()
	elif DialogueManager.chat_ended:
		DialogueManager.close_chat_box()
		guntheidon_hint_open = false
	else:
		print("Opening Guntheidon Hint")
		guntheidon_hint_open = true
		# Determine available hints based on incomplete research tasks
		var available_hints = []
		for research_task_name in hint_files.keys():
			var task_completed = PlayerData.research_tasks_completed[research_task_name][0]
			if not task_completed:
				available_hints.append(hint_files[research_task_name])
		if available_hints.size() > 0:
			# Choose a random hint file
			var random_index = randi() % available_hints.size()
			var selected_hint_file = available_hints[random_index]
			# Load the hint
			var hint_content = _load_guntheidon_hint(selected_hint_file)
			# Prepare texture mappings and dialogue lines
			var texture_mappings = {}
			var dialogue_array = []
			for entry in hint_content:
				if entry.has("texture"):
					texture_mappings[entry["emotion"]] = entry["texture"]
				else:
					dialogue_array.append(entry)
			# Start the dialogue
			DialogueManager.start_chat(texture_mappings, dialogue_array)
			GameManager.play_sound("click")
		else:
			print("No hints available.")
			guntheidon_hint_open = false

func _on_guntheidon_chat_finished():
	guntheidon_hint_open = false

func _load_guntheidon_hint(hint_file_path):
	var file = FileAccess.open(hint_file_path, FileAccess.READ)
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
	if skip_day_button_alert.visible == true:
		skip_day_button_alert.visible = false

func close_inventory_drawer():
	# Ensure the reference to the inventory drawer is valid before proceeding
	if inventory_drawer != null:
		# Check if drawer is open using its position or other conditions if is_open() isn't available
		if inventory_drawer.position.x > -924:  # Assuming min_x_value = -924 is closed state
			inventory_drawer.position.x = -924  # Set the position to the closed state
			print("Closing inventory drawer")
			GameManager.play_sound("drawer")  # Optionally, play a sound when closing
	else:
		print("Error: Inventory drawer reference is null")

func _on_inventory_alert_visibility_changed():
	if inventory_alert.visible == true:
		# Open the drawer slightly
		if inventory_drawer:
			inventory_drawer.open_slightly()
