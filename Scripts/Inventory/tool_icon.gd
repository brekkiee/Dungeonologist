extends Node2D

@onready var tool_box = get_parent()
@onready var sprite = $Sprite2D
@export var normal_sprite: Texture2D
@export var hover_sprite: Texture2D
@export var tool_name: String = ""

# Inform the toolbox that the tool is clicked
# Simplified click detection to use a single function
func _on_input_event(viewport, event, shape_idx):
	if InputMap.event_is_action(event, "left_click") and not event.pressed:
		tool_box.toolbox_click(self)

func set_hover(is_hover):
	if is_hover and tool_box.current_tool != self:
		sprite.texture = hover_sprite
	else:
		sprite.texture = normal_sprite

func _on_mouse_entered():
	set_hover(true)

func _on_mouse_exited():
	set_hover(false)

# Checks if this tool is current active tool
func is_active_tool():
	return tool_box.current_tool == self
