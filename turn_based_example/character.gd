extends CharacterBody2D

class_name character

@onready var turn_queue: turn_queue
@onready var animation_player = $AnimationPlayer
@onready var combat_menu = $CanvasLayer/combat_menu
@onready var show_data_label = $show_data_label

enum CHAR_STATE {
	WAIT,
	IN_MOVE,
	IN_ACTION,
	IN_ATTACK
}

const _state_strings = {
	CHAR_STATE.WAIT: "WAIT",
	CHAR_STATE.IN_MOVE: "IN_MOVE",
	CHAR_STATE.IN_ACTION: "IN_ACTION",
	CHAR_STATE.IN_ATTACK: "IN_ATTACK"
}

@export var stamina: int
@export var speed: int

var _state: CHAR_STATE = CHAR_STATE.WAIT
var cur_stamina: int

func _ready():
	initialize()

func _physics_process(delta):
	if turn_queue.active_char == self:
		animation_player.play("active")
	else:
		animation_player.stop()
	var s = "%s - %s - %s speed - %s stamina left" % [self.name, _state_strings[_state], self.speed, self.cur_stamina]
	show_data_label.text = s

#--------------Turn Queue + Actions

func initialize():
	turn_queue = get_parent()


func play_turn():
	if _state == CHAR_STATE.WAIT and turn_queue.active_char == self:
		set_stamina(self.stamina)
		set_state(CHAR_STATE.IN_ACTION)
	elif _state == CHAR_STATE.WAIT:
		combat_menu.hide()
	match _state:
		CHAR_STATE.IN_ACTION:
			show_possible_actions()
		CHAR_STATE.IN_ATTACK:
			#do something
			#set_state(CHAR_STATE.IN_ACTION)
			pass

func show_possible_actions():
	combat_menu.show()


func set_state(new_state: CHAR_STATE) -> void:
	if new_state == _state:
		return
	_state = new_state


func combat_actions(action:String) -> void:
	#if _state == CHAR_STATE.WAIT:
#		combat_menu.hide()
	match action:
		"attack_1":
			if check_stamina(-4):
				set_state(CHAR_STATE.IN_ATTACK)
				print("attack1 with %s stamina" % stamina)
				change_stamina(-4)
				check_turn_end()
			else:
				check_turn_end()
		"attack_2":
			if check_stamina(-1):
				set_state(CHAR_STATE.IN_ATTACK)
				print("attack2 with %s stamina" % stamina)
				change_stamina(-1)
				check_turn_end()
			else:
				check_turn_end()
		"turn_end":
			_turn_end()

#--------------Stamina Helper Functions

func check_stamina(stamina: int) -> bool:
	var new_cur_stamina = (cur_stamina + stamina)
	if new_cur_stamina < 0:
		print("Not enough stamina left, you have: %s, you need: %s" % [cur_stamina, -stamina])
		return false
	else:
		return true

func set_stamina(stamina: int) -> void:
	cur_stamina = stamina

func change_stamina(stamina: int) -> void:
	var new_cur_stamina = (cur_stamina + stamina)
	cur_stamina = new_cur_stamina


#--------------Turn End

func check_turn_end() -> void:
	if cur_stamina == 0 and _state != CHAR_STATE.WAIT:
		_turn_end()
	else:
		play_turn()

func _turn_end() -> void:
		set_state(CHAR_STATE.WAIT)
		set_stamina(0)
		turn_queue.play_turn()


#--------------Buttons

func _on_turn_end_button_pressed():
	combat_actions("turn_end")


func _on_attack_1_pressed():
	combat_actions("attack_1")


func _on_attack_2_pressed():
	combat_actions("attack_2")
