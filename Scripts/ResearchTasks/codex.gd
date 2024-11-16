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

@onready var cursor_pointer_texture = preload("res://Assets/Sprites/UI/Cursor_Default.png")

var entries = []
var current_index = 0

func _ready():
	
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
	load_json("res://Quests/Codex/CodexContent/MonsterEntries.json")
	display_entry(0)
	
	prev_page_button.connect("mouse_entered", Callable(self, "_on_mouse_entered"))
	prev_page_button.connect("mouse_exited", Callable(self, "_on_mouse_exited"))
	next_page_button.connect("mouse_entered", Callable(self, "_on_mouse_entered"))
	next_page_button.connect("mouse_exited", Callable(self, "_on_mouse_exited"))
	close_button.connect("mouse_entered", Callable(self, "_on_mouse_entered"))
	close_button.connect("mouse_exited", Callable(self, "_on_mouse_exited"))
	
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
	var entry = entries[index]
	
	if entry["type"] == "monster":
		name_label.text = entry["name"]
		sprite_node.texture = load(entry["sprite"])
		diet_label.text = "Diet: " + entry["diet"]
		habitat_label.text = "Habitat: " + entry["habitat"]
		facts_label.text = entry["facts"]
		notes_label.text = entry["notes"]
	elif entry["type"] == "potion":
		name_label.text = entry["name"]
		sprite_node.texture = load(entry["sprite"])
		diet_label.text = entry["diet"]
		habitat_label.text = entry["habitat"]
		facts_label.text = entry["facts"]
		notes_label.text = entry["notes"]
	elif entry["type"] == "quest":
		name_label.text = entry["name"]
		sprite_node.texture = load(entry["sprite"])
		diet_label.text = ""
		habitat_label.text = ""
		facts_label.text = entry["facts"]
		notes_label.text = entry["notes"]
	
	var research_tasks = entry["research_tasks"]
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

func _on_button_pressed():
	research_answer_labels[0].visible = true

# Called when the mouse enters the area
func _on_mouse_entered():
	Input.set_custom_mouse_cursor(cursor_pointer_texture)  # Set custom pointer cursor

# Called when the mouse exits the area
func _on_mouse_exited():
	Input.set_custom_mouse_cursor(null)  # Reset to default cursor

func _on_close_button_pressed():
	GameManager.close_codex()
