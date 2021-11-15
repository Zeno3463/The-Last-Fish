extends KinematicBody2D

export var speed = 100
export var horizontal_acceleration = 10
export var horizontal_speed_limit = 100

var vel = Vector2.ZERO
var moving_left = false

func _physics_process(_delta):
	vel.y = -speed
	
	if moving_left: vel.x -= horizontal_acceleration
	else: vel.x += horizontal_acceleration
	
	if vel.x < -horizontal_speed_limit: moving_left = false
	elif vel.x > horizontal_speed_limit: moving_left = true
	
	move_and_slide(vel) # warning-ignore:return_value_discarded

func _on_Area2D_body_entered(body):
	if body is Player and not body.is_hurt:
		body.die()
	if not body == self and not body is Trash:
		var particle_effect = preload("res://CPUParticles2D.tscn").instance()
		particle_effect.one_shot = true
		particle_effect.global_position = global_position
		get_parent().add_child(particle_effect)
		queue_free()
