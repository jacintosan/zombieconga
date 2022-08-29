extends Control

func _ready():
	for button in $Menu/CenterRow/Options.get_children():
		button.connect("pressed", self, "_on_Button_pressed", [button.scene_to_load])

func _on_Button_pressed(scene_to_load):
	SceneTransition.change_scene(scene_to_load)
