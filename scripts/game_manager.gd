extends Node

var score = 0
var active_slimes = []
var slime_scene = preload("res://scenes/slime.tscn")
var game_node

func _ready():
	set_process_input(true)
	spawn_slime_at_position(Vector2(399, 21))
	spawn_slime_at_position(Vector2(194, 6))

func add_point():
	score += 1
	%ScoreLabel.text = "Score: " + str(score)

func register_slime(slime):
	active_slimes.append(slime)

func unregister_slime(slime):
	active_slimes.erase(slime)

func _input(event):
	if event is InputEventKey and event.pressed:
		var character = char(event.unicode)
		for slime in active_slimes:
			slime.handle_input(character)

func spawn_slime_at_position(pos):
	game_node = $"../Slimes"
	var slime = slime_scene.instantiate()
	slime.global_position = pos
	game_node.add_child(slime)
	active_slimes.append(slime)

func schedule_respawn(pos):
	get_tree().create_timer(2.0).timeout.connect(_respawn_slime.bind(pos))

func _respawn_slime(pos):
	spawn_slime_at_position(pos)
	
