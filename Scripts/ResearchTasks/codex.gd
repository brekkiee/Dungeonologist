extends NinePatchRect

@onready var name_label = $VBoxContainerLHS/Name
@onready var sprite_node = $VBoxContainerLHS/CenterContainer/EntrySprite2D
@onready var diet_label = $VBoxContainerLHS/DetailsVBoxContainer/Diet
@onready var habitat_label = $VBoxContainerLHS/DetailsVBoxContainer/Habitat
@onready var facts_label = $VBoxContainerLHS/DetailsVBoxContainer/Facts

@onready var notes_label = $VBoxContainerRHS/NotesTitle
var research_question_labels = []
var research_answer_labels = []

@onready var prev_page_button = $PrevPageButton
@onready var next_page_button = $NextPageButton
@onready var close_button = $CloseButton
@onready var potions_tab = $PotionsTab
@onready var monsters_tab = $MonstersTab
@onready var plants_tab = $PlantsTab

@onready var cursor_pointer_texture = preload("res://Assets/Sprites/UI/Cursor_Default.png")

var entries = []
var current_index = 0
var codex_section = "monsters"  # Default section to load
var codex_alert = null

@onready var potions_alert = $PotionsAlert

func _ready():
	$MonstersTab.set_pressed_no_signal(true)
	codex_alert = GameManager.main_ui.codex_alert
	if codex_alert.visible == true:
		codex_alert.visible = false
		
	if not validate_nodes():
		return

	# Initialize research question and answer labels
	for i in range(3):
		var question_label_path = "VBoxContainerRHS/ResearchQuestion%d" % i
		var answer_label_path = "VBoxContainerRHS/CenterContainer%d/ResearchAnswer%d" % [i, i]

		var question_label = get_node_or_null(question_label_path)
		var answer_label = get_node_or_null(answer_label_path)

		if question_label and answer_label:
			research_question_labels.append(question_label)
			research_answer_labels.append(answer_label)
		else:
			push_error("Failed to find labels for index " + str(i))

	clear_content()
	load_section(codex_section)
	display_entry(0)

	if QuestManager.active_quest and QuestManager.active_quest.quest_name == "EpicQuest":
		potions_alert.visible = true
	
	# Connect button signals
	prev_page_button.connect("pressed", Callable(self, "_on_prev_page_button_pressed"))
	next_page_button.connect("pressed", Callable(self, "_on_next_page_button_pressed"))
	close_button.connect("pressed", Callable(self, "_on_close_button_pressed"))
	potions_tab.connect("pressed", Callable(self, "_on_potions_tab_pressed"))
	monsters_tab.connect("pressed", Callable(self, "_on_monsters_tab_pressed"))
	plants_tab.connect("pressed", Callable(self, "_on_plants_tab_pressed"))

	prev_page_button.connect("mouse_entered", Callable(self, "_on_mouse_entered"))
	prev_page_button.connect("mouse_exited", Callable(self, "_on_mouse_exited"))
	next_page_button.connect("mouse_entered", Callable(self, "_on_mouse_entered"))
	next_page_button.connect("mouse_exited", Callable(self, "_on_mouse_exited"))
	close_button.connect("mouse_entered", Callable(self, "_on_mouse_entered"))
	close_button.connect("mouse_exited", Callable(self, "_on_mouse_exited"))
	potions_tab.connect("mouse_entered", Callable(self, "_on_mouse_entered"))
	potions_tab.connect("mouse_exited", Callable(self, "_on_mouse_exited"))
	monsters_tab.connect("mouse_entered", Callable(self, "_on_mouse_entered"))
	monsters_tab.connect("mouse_exited", Callable(self, "_on_mouse_exited"))
	plants_tab.connect("mouse_entered", Callable(self, "_on_mouse_entered"))
	plants_tab.connect("mouse_exited", Callable(self, "_on_mouse_exited"))

# Load the JSON file based on the selected section
var tab_paths := {
	"monsters": "res://Quests/Codex/CodexContent/MonsterEntries.json",
	"potions": "res://Quests/Codex/CodexContent/PotionEntries.json",
	"plants": "res://Quests/Codex/CodexContent/PlantEntries.json"
}

func load_section(section: String):
	codex_section = section
	var json_path = tab_paths.get(section, "")
	if json_path != "":
		load_json(json_path)
		current_index = 0
		display_entry(current_index)
	else:
		push_error("Invalid section specified: " + section)

# Clear the content of the labels and sprite to ensure they are empty before loading the new content
func clear_content():
	name_label.text = ""
	sprite_node.texture = null
	diet_label.text = ""
	habitat_label.text = ""
	facts_label.text = ""
	notes_label.text = ""

	for question_label in research_question_labels:
		question_label.text = ""
	for answer_label in research_answer_labels:
		answer_label.text = ""
		answer_label.visible = false

# Validating the nodes to avoid null references
func validate_nodes() -> bool:
	if name_label == null:
		push_error("name_label node is missing!")
		return false
	if sprite_node == null:
		push_error("sprite_node node is missing!")
		return false
	if diet_label == null:
		push_error("diet_label node is missing!")
		return false
	if habitat_label == null:
		push_error("habitat_label node is missing!")
		return false
	if facts_label == null:
		push_error("facts_label node is missing!")
		return false
	if notes_label == null:
		push_error("notes label is missing!")
		return false
	return true

func load_json(json_path: String):
	var file = FileAccess.open(json_path, FileAccess.READ)
	var data = JSON.parse_string(file.get_as_text())

	if data == null:
		push_error("Failed to parse JSON")
		return

	entries = data

func display_entry(index: int):
	clear_content()
	if index < 0 or index >= entries.size():
		return

	var entry = entries[index]

	name_label.text = entry["name"]
	sprite_node.texture = load(entry["sprite"])
	diet_label.text = entry.get("diet", "")
	habitat_label.text = entry.get("habitat", "")
	facts_label.text = entry.get("facts", "")
	notes_label.text = entry.get("notes", "")

	var research_tasks = entry.get("research_tasks", [])
	for i in range(research_tasks.size()):
		var task_completed = false
		if PlayerData.research_tasks_completed.has(entry["name"]):
			task_completed = PlayerData.research_tasks_completed[entry["name"]][i]

		research_question_labels[i].text = research_tasks[i]["question"]
		research_answer_labels[i].text = research_tasks[i]["completion"]
		research_answer_labels[i].visible = task_completed
		if task_completed == true:
			QuestManager.on_research_completed()

func _on_prev_page_button_pressed():
	if current_index > 0:
		current_index -= 1
		display_entry(current_index)
		GameManager.play_sound("click")

func _on_next_page_button_pressed():
	if current_index < entries.size() - 1:
		current_index += 1
		display_entry(current_index)
		GameManager.play_sound("click")

func _on_close_button_pressed():
	GameManager.close_codex()

func _on_potions_tab_pressed():
	load_section("potions")
	GameManager.play_sound("click")
	potions_alert.visible = false

func _on_monsters_tab_pressed():
	load_section("monsters")
	GameManager.play_sound("click")

func _on_plants_tab_pressed():
	load_section("plants")
	GameManager.play_sound("click")

# Called when the mouse enters the area
func _on_mouse_entered():
	Input.set_custom_mouse_cursor(cursor_pointer_texture)

# Called when the mouse exits the area
func _on_mouse_exited():
	Input.set_custom_mouse_cursor(null)
