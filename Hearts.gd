extends Control

onready var player = get_parent().get_parent().get_node("Player")

func take_out_one_life():
	if get_child_count() <= 0:
		player.die()
	else:
		remove_child(get_child(get_child_count()-1))
		player.take_damage()
