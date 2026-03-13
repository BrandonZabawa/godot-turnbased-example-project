extends Node2D

func _ready():
	var turn_queue = get_node("turn_queue")
	turn_queue.initalize()
