extends CharacterBody2D

const SPEED : float = 150.0
const MAX_JUMP_VELOCITY : float = -500.0
const DEFAULT_JUMP_VELOCITY : float = -250.0

var jumpStrength : float = DEFAULT_JUMP_VELOCITY
var isJumping : bool = false

func _physics_process(delta: float) -> void:
	gravity(delta)
	jump(delta)
	inputHandling()
	move_and_slide()

func gravity(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

func inputHandling() -> void:
	var direction := Input.get_axis("move_left", "move_right")
	if (direction && !isJumping):
		velocity.x = direction * SPEED
		if (direction < 0):
			$Sprite2D.flip_h = true
		else:
			$Sprite2D.flip_h = false
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

func jump(delta: float) -> void:
	if(is_on_floor()):
		if(Input.is_action_pressed("jump") && jumpStrength > MAX_JUMP_VELOCITY):
			jumpStrength -= 10.0
			isJumping = true
		elif(Input.is_action_just_released("jump")):
			velocity.y = jumpStrength
			jumpStrength = DEFAULT_JUMP_VELOCITY
			isJumping = false

func die() -> void:
	print("died")
