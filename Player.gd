extends KinematicBody2D

class_name Player

export var speed = 300
export var acceleration = 500
export var vel = Vector2.ZERO

var is_dead = false
var is_hurt = false
var can_move = true

func _ready():
	global_position = GlobalVariables.check_point

func _physics_process(delta):
	if not can_move: return
	if is_dead:
		vel.y += acceleration * delta
		vel = move_and_slide(vel)
		return
	
	var axis = Vector2.ZERO
	axis.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	axis.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	axis = axis.normalized()
	
	if axis == Vector2.ZERO:
		if vel.length() > acceleration * delta:
			vel -= vel.normalized() * acceleration * delta
		else:
			vel = Vector2.ZERO
	else:
		vel += acceleration * axis * delta
		vel = vel.clamped(speed)
		
	if Input.is_action_pressed("ui_right"):
		$AnimatedSprite.flip_h = true
	elif Input.is_action_pressed("ui_left"):
		$AnimatedSprite.flip_h = false
		
	vel = move_and_slide(vel)
	
func die():
	vel = Vector2.ZERO
	is_hurt = true
	is_dead = true
	GlobalVariables.get_node("Theme").stop()
	GlobalVariables.get_node("Theme").volume_db = 0
	$AudioStreamPlayer.play()
	$Camera2D.shake(GlobalVariables.is_starting_wave)
	GlobalVariables.is_starting_wave = false
	$Light2D.visible = false
	$AnimatedSprite.play("dead")
	yield(get_tree().create_timer(1), "timeout")
	get_parent().get_node("CanvasLayer/Scene Transition/AnimationPlayer").play_backwards("fade out")
	yield(get_parent().get_node("CanvasLayer/Scene Transition/AnimationPlayer"), "animation_finished")
	get_tree().reload_current_scene() # warning-ignore:return_value_discarded

