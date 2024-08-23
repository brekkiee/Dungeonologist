extends NinePatchRect


@export var QuestName: RichTextLabel
@export var Stage: RichTextLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	load_json("res://Quests/Codex/CodexContent/QuestEntries.json")


func load_json(json_path: String):
	var file = FileAccess.open(json_path, FileAccess.READ)
	var data = JSON.parse_string(file.get_as_text())

	if data == null:
		push_error("Failed to parse JSON")
		return
		
		

