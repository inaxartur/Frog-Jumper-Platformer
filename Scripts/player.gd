extends CharacterBody2D

const SPEED : float = 150.0
const MAX_JUMP_VELOCITY : float = -400.0
const DEFAULT_JUMP_VELOCITY : float = -200.0
const JUMP_DIRECTION_STRENGTH : float = 0.4

@onready var FrogSprite : AnimatedSprite2D = $FrogSprite
@onready var GroundRayCast : RayCast2D = $ToGroundDistance
@onready var JumpBar : TextureProgressBar = $JumpStrengthBar
@onready var ShadowSprite : Sprite2D = $ShadowSprite

var jumpStrength : float = DEFAULT_JUMP_VELOCITY
var isJumping : bool = false
var isOnFloatingLog : bool = false

func _ready() -> void:
	JumpBar.max_value = abs(MAX_JUMP_VELOCITY)
	JumpBar.min_value = abs(DEFAULT_JUMP_VELOCITY)
	JumpBar.visible = false

func _physics_process(delta: float) -> void:
	
	if(Input.is_action_pressed("noclip_y_up")):
		global_position.y -= 25
	
	gravity(delta)
	inputHandling()
	jump(delta)
	player_on_floating_log()
	shadow()
	anims()
	move_and_slide()

func gravity(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
		if(JumpBar.visible == true):
			JumpBar.visible = false

func anims() -> void:
	if(isJumping):
		FrogSprite.play("ready_to_jump")
	elif(!is_on_floor()):
		FrogSprite.play("jumping")
	else:
		FrogSprite.play("default")

func shadow() -> void:
	var target : Node2D = GroundRayCast.get_collider()
	if(!is_on_floor()):
		if(target != null):
			ShadowSprite.visible = true
			ShadowSprite.global_position.y = target.global_position.y
		else:
			ShadowSprite.visible = false
	else:
		ShadowSprite.global_position.y = global_position.y

func inputHandling() -> void:
	var direction := Input.get_axis("move_left", "move_right")
	if (direction):
		if (direction < 0):
			FrogSprite.flip_h = true
		else:
			FrogSprite.flip_h = false
		

func jump(delta: float) -> void:
	if(is_on_floor()):
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if(Input.is_action_pressed("jump") && jumpStrength > MAX_JUMP_VELOCITY):
			jumpStrength -= 15.0
			isJumping = true
			JumpBar.visible = true
			JumpBar.value = abs(jumpStrength)
			if(global_position.x > 135):
				JumpBar.global_position.x = 155 - 49
			elif(global_position.x < -135):
				JumpBar.global_position.x = -155
			else:
				JumpBar.global_position.x = global_position.x - 25
		elif(Input.is_action_just_released("jump")):
			if(FrogSprite.flip_h == true):
				velocity.x = JUMP_DIRECTION_STRENGTH * jumpStrength
			else:
				velocity.x = -JUMP_DIRECTION_STRENGTH * jumpStrength
			velocity.y = jumpStrength
			jumpStrength = DEFAULT_JUMP_VELOCITY
			isJumping = false
			JumpBar.visible = false

func die() -> void:
	print("died")
	SignalBus.playerDied.emit()

func get_is_on_floor() -> bool:
	return is_on_floor()

func set_player_on_floating_log(isOnLog : bool) -> void:
	isOnFloatingLog = isOnLog

func player_on_floating_log() -> void:
	if(global_position.x > -130 && isOnFloatingLog):
		global_position.x -= 0.40
