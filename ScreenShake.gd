extends Camera2D

export var amplitude = 50
export var frequency = 50
export var time = 0.5

var shake_amount = 0
var is_shaking = false

func _process(delta):
	if is_shaking:
		offset = Vector2(rand_range(-shake_amount, shake_amount),rand_range(-shake_amount, shake_amount)) * delta

func shake(forever=false, new_frequency=frequency, new_time=time, new_amplitude=amplitude):
	shake_amount += new_frequency
	if shake_amount > new_amplitude:
		shake_amount = new_amplitude
	if not forever:
		$Timer.wait_time = new_time
		$Timer.start()
	is_shaking = true

func _on_Timer_timeout():
	is_shaking = false
	offset = Vector2.ZERO
	$Timer.stop()
