extends Control

var popup = null;


# Called when the node enters the scene tree for the first time.
func _ready():
	popup = get_node("BagPopUp");
	popup.DungeonName = "NULL"
	popup.DungeonFloor = "Floor 0";
	popup.AdventurerName = "Colin"
	popup.update();
	popup.visible = false
	pass
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# Called When expo button is pressed
func on_button_pressed_expo1():
	print("Expedition 1 Button Pressed");
	
	popup.DungeonName = "expo";
	popup.DungeonFloor = "1";
	popup.AdventurerName = "Colin"
	
	popup.visible = true;
	pass
