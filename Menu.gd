extends Control

func _ready():
	if OS.get_name() == "Windows": OS.window_fullscreen = true
	GlobalVariables.get_node("Dialogue And Timer").set_process(false)
	
func _on_Button_button_down():
	$CanvasLayer/AudioStreamPlayer.play()
	get_node("CanvasLayer/Scene Transition/AnimationPlayer").play_backwards("fade out")
	yield(get_node("CanvasLayer/Scene Transition/AnimationPlayer"), "animation_finished")
	get_tree().change_scene("res://Scene 1.tscn") # warning-ignore:return_value_discarded
