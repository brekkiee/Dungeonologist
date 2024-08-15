extends Node2D

# Array to store tool nodes
@export var tool_nodes: Array[Node2D] = []

# Current tool following the cursor
var current_tool: Node2D = null
# Index of the current tool in the tool_nodes array
var current_tool_index = -1
# Original positions of tools in the toolbox
var original_tool_positions: Array[Vector2] = []

func _ready():
	# Store initial positions of tools
	for item in tool_nodes:
		original_tool_positions.append(item.position)

func put_down_tool():
	# Reset tool to original position
	current_tool.position = original_tool_positions[current_tool_index]
	current_tool_index = -1
	current_tool = null
	# Make mouse visible
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _process(delta):
	if current_tool != null:
		# Set tool position to mouse position
		current_tool.position = get_global_mouse_position()
		
		# Return the tool to the toolbox only on right click
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
			put_down_tool()

func toolbox_click(tool_node):
	for i in tool_nodes.size():
		# Select and follow clicked tool
		if tool_node == tool_nodes[i] and current_tool == null:
			current_tool = tool_nodes[i]
			current_tool.set_hover(false)
			current_tool_index = i
			# Hide mouse cursor
			Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

