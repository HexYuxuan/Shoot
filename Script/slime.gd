extends Area2D
@export var slime_speed:float = -40
var slime_is_dead:bool = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if not slime_is_dead:
		position += Vector2(slime_speed,0)*delta
	if position.x < -276:
		queue_free()



func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D and not slime_is_dead:
		body._Game_over()


func _on_slime_dead(area: Area2D) -> void:
	if area.is_in_group("bullet"):
		get_tree().current_scene.score +=1
		#print("Slime dies")
		$SlimeDeadSound.play()
		slime_is_dead = true
		area.queue_free()
		$AnimatedSprite2D.play("slime_dead")
		await get_tree().create_timer(0.6).timeout
		queue_free()
