extends Node2D

@onready var tool_box = get_parent()

# Inform the toolbox that the tool is clicked
# Simplified click detection to use a single function
func _on_input_event(viewport, event, shape_idx):
	if InputMap.event_is_action(event, "left_click") and not event.pressed:
		tool_box.toolbox_click(self)
