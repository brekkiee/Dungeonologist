extends TextureRect

@onready var alchemy_emote: TextureRect = $AlchemyEmote
@export var yes_texture_path = "res://Assets/Sprites/Alchemy/emote_10_Yes.png"
@export var no_texture_path = "res://Assets/Sprites/Alchemy/emote_10_no.png"

func _ready():
	print("AlchemyEmote _ready function called")
	if alchemy_emote.texture == null:
		print("alchemy_emote is still null after manual assignment!")
	else:
		print("alchemy_emote is correctly assigned after manual assignment")
	
func display_emote(correct_recipe: bool):
	var test_texture = load("res://Assets/Sprites/Alchemy/emote_10_Yes.png")
	
	if test_texture:
		alchemy_emote.texture = test_texture
	else:
		print("Failed to load the test texture")
	#var texture
	#if correct_recipe:
	#	texture = load(yes_texture_path)
	#	alchemy_emote.texture = texture
	#elif !correct_recipe:
	#	texture = load(no_texture_path)
	#	alchemy_emote.texture  = texture
	#else:
	#	alchemy_emote.texture = null
