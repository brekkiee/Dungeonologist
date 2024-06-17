extends Node2D

const lines: Array[String] = [
	"Hi there.",
	"I'm a wizard!",
	"Poo poo~",
	"Pee pee!",
]

func _unhandled_input(event):
	if event.is_action_pressed("advance_text"):
		DialogueManager.start_chat(global_position, lines)
