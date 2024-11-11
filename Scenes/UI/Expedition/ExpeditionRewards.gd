extends Control

var expo_title: String
var expo_rewards: Array[RewardResource]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	get_node("BG/MC/VB/Title").text = expo_title
	get_node("BG/MC/VB/Content").text = ""
	for r in expo_rewards:
		if r.isItem:
			get_node("BG/MC/VB/Content").text = str(get_node("BG/MC/VB/Content").text, r.quantity ,"x ",r.item_data.Name, "\n")
		else:
			get_node("BG/MC/VB/Content").text = str(get_node("BG/MC/VB/Content").text, "1x ",r.monster_name.name, "\n")

func show_rewards():
	self.visible = true

func _on_button_pressed():
	self.visible = false
	pass # Replace with function body.
