extends Node2D

export var spawn_frequency = 1

var poison_gas = preload("res://Poisonous Gas.tscn")

func _ready():
	$Timer.wait_time = spawn_frequency
	$Timer.start()

func _on_Timer_timeout():
	var poison_gas_instance = poison_gas.instance()
	poison_gas_instance.scale = Vector2.ONE * rand_range(0.5, 1)
	poison_gas_instance.global_position.y = global_position.y
	poison_gas_instance.global_position.x = rand_range($Position2D.global_position.x, $Position2D2.global_position.x)
	get_parent().add_child(poison_gas_instance)
	$Timer.start()
