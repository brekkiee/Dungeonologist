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
	# Wait 0.1 seconds before resetting the item to the inventory
	await get_tree().create_timer(0.1).timeout
	# Make mouse visible
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	# Reset tool to original position
	current_tool.position = original_tool_positions[current_tool_index]
	current_tool_index = -1
	current_tool = null

func _process(delta):
	if current_tool != null:
		# Set tool position to mouse position
		current_tool.position = get_global_mouse_position()
		if Input.is_action_just_pressed("left_click"):
			# Put down tool without calling any function
			# Click detection is handled by clicked objects, e.g., tutorial_slime script
			put_down_tool()

func toolbox_click(tool_node):
	for i in tool_nodes.size():
		# Select and follow clicked tool
		if tool_node == tool_nodes[i] and current_tool != tool_nodes[i]:
			current_tool = tool_nodes[i]
			current_tool_index = i
			# Hide mouse cursor
			Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
