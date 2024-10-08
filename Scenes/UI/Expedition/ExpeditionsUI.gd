extends Control

var popup = null;
var rewardUI = null

# Called when the node enters the scene tree for the first time.
func _ready():
	popup = get_node("BagPopUp");
	popup.DungeonName = "NULL"
	popup.DungeonFloor = "Floor 0";
	popup.AdventurerName = "Colin"
	popup.update();
	popup.visible = false
	
	rewardUI = get_node("ExpeditionRewards")
	rewardUI.visible = false
	ExpeditionManager.expeditionUI = self
	pass
	

func show_rewards(rewards):
	rewardUI.visible = true
	rewardUI.expo_title = str(popup.DungeonName," " ,popup.DungeonFloor)
	rewardUI.expo_rewards = rewards

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# Called When expo button is pressed
func on_button_pressed_expo1():
	print("Expedition 1 Button Pressed");
	
	popup.DungeonName = "expo";
	popup.DungeonFloor = "1";
	popup.AdventurerName = "Colin"
	popup.update()
	popup.visible = true;
	pass
