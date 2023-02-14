extends CharacterBody2D


const ACCEL = 166.66
const DECEL = 166.66
const MAX_SPEED = 500.0
const JUMP_VELOCITY = -100.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var can_jump = false 
var used_jump = false
var coyote_time = 0
var variable_time = 0

func jump(delta):
	if Input.is_action_just_pressed("jump") and coyote_time < 5 and not used_jump:
		can_jump = true
		variable_time = 0
	if not Input.is_action_pressed("jump") or variable_time > 5:
		can_jump = false
	if Input.is_action_just_released("jump"):
		used_jump = true
	if Input.is_action_pressed("jump") and can_jump:
		velocity.y += JUMP_VELOCITY * (delta * 60)

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
		coyote_time += 1 
		variable_time += 1
	else:
		used_jump = false
		coyote_time = 0

	jump(delta)

	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x += direction * ACCEL * (delta * 60)
	else:
		velocity.x = move_toward(velocity.x, 0, DECEL)
	velocity.x = clamp(velocity.x, -MAX_SPEED, MAX_SPEED)

	move_and_slide()
