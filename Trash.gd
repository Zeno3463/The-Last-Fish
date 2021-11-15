extends KinematicBody2D

class_name Trash

export(Array, StreamTexture) var trash_sprites
export(Array, StreamTexture) var big_trash_sprites
export var speed = 50
export var movement_is_random = false
export var patrol_direction = Vector2.ZERO
onready var vel = patrol_direction

func _ready():
	randomize()
	if randi() % 2 == 0:
		$Sprite.texture = trash_sprites[rand_range(0, len(trash_sprites))]
		$Area2D/CollisionShape2D.shape = RectangleShape2D.new()
		$Area2D/CollisionShape2D.shape.set("extents", Vector2(2, 4))
	else:
		$Sprite.texture = big_trash_sprites[rand_range(0, len(big_trash_sprites))]
	$AnimationPlayer.playback_speed = rand_range(0, 0.5)
	if movement_is_random:
		vel = Vector2(rand_range(-1, 1), rand_range(-1, 1))

func _physics_process(_delta):
	if is_on_wall():
		if movement_is_random:
			vel.x = rand_range(-1, 1)
			vel.y = rand_range(-1, 1)
		else:
			vel *= -1
		var particle_effect = preload("res://CPUParticles2D.tscn").instance()
		particle_effect.one_shot = true
		particle_effect.global_position = global_position
		get_parent().add_child(particle_effect)

	move_and_slide(vel * speed) # warning-ignore:return_value_discarded

func _on_Area2D_body_entered(body):
	if body is Player and not body.is_hurt:
		body.die()
