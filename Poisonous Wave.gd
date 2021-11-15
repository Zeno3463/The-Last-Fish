extends KinematicBody2D

export var speed = 30

func _physics_process(_delta):
	move_and_slide(Vector2.LEFT * speed) # warning-ignore:return_value_discarded

func _on_Area2D_body_entered(body):
	if body is Player:
		body.die()
