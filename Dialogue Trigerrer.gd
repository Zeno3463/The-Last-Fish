extends Area2D

export(String, MULTILINE) var text
export var display_cutscene = false
export var end_cutscene = false
export var is_end = false
export(Array, String, MULTILINE) var credit_text
onready var dialogue = GlobalVariables.get_node("Dialogue And Timer")

func _ready():
	GlobalVariables.is_starting_wave = false
	self.connect("body_entered", self, "on_Area2D_body_entered") # warning-ignore:return_value_discarded
	
func on_Area2D_body_entered(body):
	if body is Player and not self.name in GlobalVariables.triggered_dialouge:
		dialogue.display_dialogue(text)
		if not display_cutscene:
			GlobalVariables.triggered_dialouge.append(self.name)
			GlobalVariables.check_point = global_position
		elif display_cutscene:
			GlobalVariables.is_starting_wave = true
			GlobalVariables.get_node("Theme").stream = preload("res://poisonous wave music.mp3")
			GlobalVariables.get_node("Theme").play()
			body.get_node("Camera2D").shake(true)
			yield(get_tree().create_timer(2), "timeout")
			body.can_move = false
			body.is_hurt = true
			get_parent().get_parent().get_node("cutscene/Camera2D").current = true
			get_parent().get_parent().get_node("cutscene/Camera2D").shake(true)
			get_parent().get_parent().get_node("cutscene/AnimationPlayer").play("cutscene")
			yield(get_parent().get_parent().get_node("cutscene/AnimationPlayer"), "animation_finished")
			yield(get_tree().create_timer(2), "timeout")
			var poisonous_wave = preload("res://Poisonous Wave.tscn").instance()
			poisonous_wave.global_position = Vector2(2477, -238)
			get_parent().get_parent().get_node("cutscene").add_child(poisonous_wave)
			body.get_node("Camera2D").current = true
			body.is_hurt = false
			body.can_move = true
		if end_cutscene:
			GlobalVariables.get_node("Tween").interpolate_property(GlobalVariables.get_node("Theme"),"volume_db",0,-80,5,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
			GlobalVariables.is_starting_wave = false
			body.get_node("Camera2D").is_shaking = false
			GlobalVariables.get_node("Tween").start()
			yield(GlobalVariables.get_node("Tween"), "tween_completed")
			GlobalVariables.get_node("Tween").stop_all()
			GlobalVariables.get_node("Theme").stop()
			GlobalVariables.get_node("Theme").volume_db = 0
		if is_end:
			GlobalVariables.get_node("Theme").volume_db = 0
			GlobalVariables.get_node("Theme").stream = preload("res://end music.mp3")
			GlobalVariables.get_node("Theme").play()
			yield(get_tree().create_timer(5), "timeout")
			GlobalVariables.get_node("CanvasLayer/Dialogue And Timer").set_process(false)
			get_parent().get_parent().get_node("CanvasLayer/Scene Transition/AnimationPlayer").play_backwards("fade out")
			yield(get_parent().get_parent().get_node("CanvasLayer/Scene Transition/AnimationPlayer"), "animation_finished")
			body.can_move = false
			body.is_hurt = true
			for t in credit_text:
				get_parent().get_parent().get_node("CanvasLayer/Credit Scene/RichTextLabel").bbcode_text = t
				get_parent().get_parent().get_node("CanvasLayer/Credit Scene/AnimationPlayer").play("text fade in")
				yield(get_parent().get_parent().get_node("CanvasLayer/Credit Scene/AnimationPlayer"), "animation_finished")
				yield(get_tree().create_timer(3), "timeout")
				get_parent().get_parent().get_node("CanvasLayer/Credit Scene/AnimationPlayer").play_backwards("text fade in")
				yield(get_tree().create_timer(3), "timeout")
			GlobalVariables.get_node("Tween").interpolate_property(GlobalVariables.get_node("Theme"),"volume_db",0,-80,5,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
			GlobalVariables.get_node("Tween").start()
