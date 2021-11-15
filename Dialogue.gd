extends Control

var time = 0
var is_displaying = false

func _process(delta):
	time += delta
	$Timer.text = str(stepify(time, 0.01))

func display_dialogue(text):
	if not is_displaying:
		is_displaying = true
		$Label.text = ""
		for word in text:
			$Label.text += word
			var wait_time = 0.05
			if word in [".", "?", "!"]: wait_time = 0.5
			yield(get_tree().create_timer(wait_time), "timeout")
		yield(get_tree().create_timer(1), "timeout")
		$Label.text = ""
		is_displaying = false
