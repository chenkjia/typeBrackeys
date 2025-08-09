extends Node

var score = 0
var active_slimes = []

@onready var score_label: Label = %ScoreLabel

func _ready():
	# 确保游戏管理器可以接收输入
	set_process_input(true)

func add_point():
	score +=1
	score_label.text = "Score:" + str(score)
	print(score)

func register_slime(slime):
	active_slimes.append(slime)

func unregister_slime(slime):
	active_slimes.erase(slime)

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		var key_char = event.as_text_keycode().to_lower()
		if key_char.length() == 1:
			# 将输入传递给所有活跃的slime
			for slime in active_slimes:
				if slime and is_instance_valid(slime):
					slime.handle_input(key_char)
	
