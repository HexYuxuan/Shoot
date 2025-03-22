extends CharacterBody2D
@export var move_speed:float = 50
@export var animator:AnimatedSprite2D
@export var bullet_scene:PackedScene
var is_game_over:bool = false
var is_hit:bool = false
var is_jump:bool = false
var life_value:int = 5
# Called when the node enters the scene tree for the first time.
func _process(delta: float) -> void:
	
	if is_game_over or velocity==Vector2.ZERO:
		$RunningSound.stop()
	elif not $RunningSound.playing:
		$RunningSound.play() 
	if Input.is_action_just_pressed("jump"):
		is_jump = true
		#print("jump")
	if Input.is_action_just_pressed("hit"):
		is_hit = true
		
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if not is_game_over:
		velocity = Input.get_vector("left","right","up","down")*move_speed
		if velocity==Vector2.ZERO and not is_hit and not is_jump:
		#为0则为待机动画
			animator.play("idle")
		elif is_hit:
		#不为0播放跑步动画
			animator.play("hit")
			position += Vector2(0.8,0)
			await get_tree().create_timer(0.6).timeout
			is_hit = false
		elif is_jump:
			animator.play("jump")
			position +=Vector2(0,-0.6)
			await get_tree().create_timer(0.2).timeout
			position +=Vector2(0,0.6)
			await get_tree().create_timer(0.2).timeout
			is_jump = false
		else :
			animator.play("run")
	move_and_slide()
 
#输掉游戏
func _Game_over():
	if not is_game_over:
		if is_hit:
			return
		print("Be hit")
		get_tree().current_scene.life_value -=1
		life_value = get_tree().current_scene.life_value
		if life_value == 0:
			is_game_over = true
			$GameOverSound.play()
			animator.play("game_over")
			$RestartTimer.start()
			get_tree().current_scene.show_game_over()
		else: 
			return

func _on_fire() -> void:
	#print("Fire!")
	if is_game_over:
		return
	$FireSound.play()
	var bullet_node = bullet_scene.instantiate()
	bullet_node.position = position+Vector2(6,6)
	get_tree().current_scene.add_child(bullet_node)


func _reload_scene() -> void:
	get_tree().reload_current_scene()
