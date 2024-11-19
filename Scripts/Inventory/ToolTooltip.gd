extends Control


func Config(tool):
	get_node("M/V/ToolName").text = tool.tool_name
	get_node("M/V/ToolUse").text = tool.tool_use
