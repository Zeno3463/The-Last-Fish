extends Control

var time = 0

func _process(delta):
	time += delta
	$Timer.text = str(stepify(time, 0.01))

func display_dialogue(text):
	$Label.text = ""
	for word in text:
		$Label.text += word
		var wait_time = 0.1
		if word in [".", "?", "!"]: wait_time = 1
		yield(get_tree().create_timer(wait_time), "timeout")
	$Label.text = ""
