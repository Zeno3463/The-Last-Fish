extends Area2D

export(String, MULTILINE) var text
onready var dialogue = get_parent().get_parent().get_node("CanvasLayer/Dialogue And Timer")

func _ready():
	self.connect("body_entered", self, "on_Area2D_body_entered") # warning-ignore:return_value_discarded
	
func on_Area2D_body_entered(body):
	if body is Player:
		dialogue.display_dialogue(text)
