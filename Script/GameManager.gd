extends Node2D
@export var slime_scene:PackedScene
@export var spawn_timer:Timer
var score:int = 0
@export var score_lable:Label
@export var game_over_lable:Label
var life_value:int = 5
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	spawn_timer.wait_time -= 0.2*delta
	spawn_timer.wait_time = clamp(spawn_timer.wait_time,1,3)
	score_lable.text = "Score:" + str(score)

func _create_slime() -> void:
	var slime_node = slime_scene.instantiate()
	slime_node.position = Vector2(260,randf_range(50,115))
	get_tree().current_scene.add_child(slime_node)

func show_game_over():
	game_over_lable.visible = true
	
