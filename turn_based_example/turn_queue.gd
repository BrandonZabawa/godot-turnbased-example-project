extends Node2D

class_name turn_queue

var all_chars: Array
var active_char: character
var next_active_char: character
var counter: int = 0

func initalize():
	get_chars()
	play_turn()

func play_turn():
	if (next_active_char):
		active_char = next_active_char
	counter += 1 # Turn Counter
	active_char.play_turn()
	var new_index: int = (active_char.get_index() + 1) %  get_child_count() # sets the index to the next child or to 0 if there are no more childs
	next_active_char = get_child(new_index)

func get_chars() -> void:
	all_chars = get_children(false)
	all_chars.sort_custom(sort_chars)
	for char in all_chars:
		char.move_to_front() # puts this node to the first position of its parent
	active_char = get_child(0)

func sort_chars(a : character,b: character) -> bool:
	#add a custom speed calculation
	#eg a.speed * a.stamina > b.speed * b.stamina
	return a.speed > b.speed

func add_new_char(char: character) -> void:
	#currently not used, but you propably get the gist :D
	var new_char = char.new()
	add_char_to_queue(new_char)

func add_char_to_queue(char: character) -> void:
	#currently not used, but you propably get the gist :D
	add_child(char)

func remove_char_from_queue(char: character) -> void:
	#currently not used, but you propably get the gist :D
	char.queue_free()
