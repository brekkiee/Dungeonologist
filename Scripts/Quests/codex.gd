extends NinePatchRect

@onready var name_label = $VBoxContainerLHS/Name
@onready var sprite_node = $VBoxContainerLHS/CenterContainer/EntrySprite2D
@onready var diet_label = $VBoxContainerLHS/DetailsVBoxContainer/Diet
@onready var habitat_label = $VBoxContainerLHS/DetailsVBoxContainer/Habitat
@onready var facts_label = $VBoxContainerLHS/DetailsVBoxContainer/Facts

@onready var notes_label = $VBoxContainerRHS/NotesTitle
@onready var research_question0_label = $VBoxContainerRHS/ResearchQuestion0
@onready var research_question1_label = $VBoxContainerRHS/ResearchQuestion1
@onready var research_question2_label = $VBoxContainerRHS/ResearchQuestion2
@onready var research_answer0_label = $VBoxContainerRHS/CenterContainer0/ResearchAnswer0
@onready var research_answer1_label = $VBoxContainerRHS/CenterContainer1/ResearchAnswer1
@onready var research_answer2_label = $VBoxContainerRHS/CenterContainer2/ResearchAnswer2

@onready var prev_page_button = $PrevPageButton
@onready var next_page_button = $NextPageButton

var entries = []
var current_index = 0

func _ready():
	
	if not validate_nodes():
		return
	
	clear_content()
	load_json("res://Quests/Codex/CodexContent/MonsterEntries.json")
	display_entry(0)
	
# Clear the content of the labels and sprite to ensure they are empty before loading the new content
func clear_content():
	name_label.text = ""
	sprite_node.texture = null
	diet_label.text = ""
	habitat_label.text = ""
	facts_label.text = ""
	notes_label.text = ""
	research_question0_label.text = ""
	research_answer0_label.text = ""
	research_question1_label.text = ""
	research_answer1_label.text = ""
	research_question2_label.text = ""
	research_answer2_label.text = ""

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
	if research_question0_label == null:
		push_error("research_question0_label node is missing!")
		return false
	if research_answer0_label == null:
		push_error("research_answer0_label node is missing!")
		return false
	if research_question1_label == null:
		push_error("research_question1_label node is missing!")
		return false
	if research_answer1_label == null:
		push_error("research_answer1_label node is missing!")
		return false
	if research_question2_label == null:
		push_error("research_question2_label node is missing!")
		return false
	if research_answer2_label == null:
		push_error("research_answer2_label node is missing!")
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
		print("name_label.text = " + entry["name"])
		sprite_node.texture = load(entry["sprite"])
		print("sprite_label.text = " + entry["sprite"])	
		diet_label.text = "Diet: " + entry["diet"]
		print("diet_label.text = " + entry["diet"])	
		habitat_label.text = "Habitat: " + entry["habitat"]
		print("habitat_label.text = " + entry["habitat"])	
		facts_label.text = entry["facts"]
		print("facts_label.text = " + entry["facts"])	
		notes_label.text = entry["notes"]
	elif entry["type"] == "quest":
		name_label.text = entry["name"]
		print("name_label.text = " + entry["name"])
		sprite_node.texture = load(entry["sprite"])
		print("sprite_label.text = " + entry["sprite"])	
		diet_label.text = ""
		print("diet_label.text = " + entry["diet"])	
		habitat_label.text = ""
		print("habitat_label.text = " + entry["habitat"])	
		facts_label.text = entry["facts"]
		print("facts_label.text = " + entry["facts"])	
		notes_label.text = entry["notes"]
	
	var research_tasks = entry["research_tasks"]

	# Accessing the research tasks and assigning them to labels
	if research_tasks.size() > 0:
		research_question0_label.text = research_tasks[0]["question"]
		research_answer0_label.text = research_tasks[0]["completion"]
		research_answer0_label.visible = false
		print("research_question0_label.text = " + research_tasks[0]["question"])
		print("research_answer0_label.text = " + research_tasks[0]["completion"])

	if research_tasks.size() > 1:
		research_question1_label.text = research_tasks[1]["question"]
		research_answer1_label.text = research_tasks[1]["completion"]
		research_answer1_label.visible = false
		print("research_question1_label.text = " + research_tasks[1]["question"])
		print("research_answer1_label.text = " + research_tasks[1]["completion"])

	if research_tasks.size() > 2:
		research_question2_label.text = research_tasks[2]["question"]
		research_answer2_label.text = research_tasks[2]["completion"]
		research_answer2_label.visible = false
		print("research_question2_label.text = " + research_tasks[2]["question"])
		print("research_answer2_label.text = " + research_tasks[2]["completion"])

func _on_prev_page_button_pressed():
	if current_index > 0:
		current_index -= 1
		display_entry((current_index))

func _on_next_page_button_pressed():
	if current_index < entries.size() - 1:
		current_index += 1
		display_entry((current_index))
