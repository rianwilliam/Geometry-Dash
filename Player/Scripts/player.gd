extends CharacterBody2D
class_name Player

const SPEED: int = 300
const GRAVITY: float = 100.0
const JUMP_HEIGHT: float = -3200.0

func _physics_process(delta: float) -> void:
	var direction: Vector2 = Vector2.RIGHT
	velocity = direction * SPEED
	
	if not is_on_floor():
		velocity.y += GRAVITY
	
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = move_toward(velocity.y, velocity.y - JUMP_HEIGHT, 10)
	
	move_and_slide()
