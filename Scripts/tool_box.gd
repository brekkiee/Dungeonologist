extends Node2D

# Array to store tool nodes
@export var tool_nodes: Array[Node2D] = []

# Track if tool is selected
var follow_mouse: bool = false
# Current tool follow curser
var current_tool: Node2D = null
# Index of current tool in tool_nodes array
var current_tool_index = -1
# Original position of tools in the toolbox
var original_tool_positions: Array[Vector2] = []

func _ready():
	# Store initial positions of tools
	for item in tool_nodes:
		original_tool_positions.append(item.position)

func put_down_tool():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	follow_mouse = false
	# Reset tool to orig. position
	current_tool.position = original_tool_positions[current_tool_index]
	current_tool_index = -1
	current_tool.mouse_over_area = null
	current_tool = null

func _process(delta):
	if follow_mouse:
		# Set tool position to mouse postion
		current_tool.position = get_global_mouse_position()
		if Input.is_action_just_pressed("left_click"):
			if current_tool.mouse_over_area != null:
				GameManager.tool_click(current_tool.mouse_over_area, current_tool.name)
			put_down_tool.call_deferred()

func toolbox_click(tool_node):
	for i in tool_nodes.size():
		# Select and follow clicked tool
		if tool_node == tool_nodes[i] and current_tool != tool_nodes[i]:
			current_tool = tool_nodes[i]
			current_tool_index = i
			# Hide mouse curser
			Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
			follow_mouse = true
