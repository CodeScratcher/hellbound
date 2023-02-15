extends CharacterBody2D

var hurtbox = preload("res://Components/hurtbox.tscn")
@onready var root_node = get_node("/root/pickups")

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

var hp = 100
var invuln = 10
var blink_delta = 0

var right = true

func jump(delta):
	if Input.is_action_just_pressed("jump") and coyote_time < 5 and not used_jump:
		can_jump = true
		variable_time = 0
	if not Input.is_action_pressed("jump") or variable_time > 5:
		can_jump = false
	if Input.is_action_just_released("jump"):
		used_jump = true
	if Input.is_action_pressed("jump") and can_jump:
		velocity.y += JUMP_VELOCITY

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
		velocity.x += direction * ACCEL
	else:
		velocity.x = move_toward(velocity.x, 0, DECEL)
	velocity.x = clamp(velocity.x, -MAX_SPEED, MAX_SPEED)
	
	if Input.is_action_pressed("left"):
		right = false
	
	if Input.is_action_pressed("right"):
		print("right")
		right = true
	
	if right and not get_node_or_null("hurtbox"):
		$Sprite2D.flip_h = false
	elif not get_node_or_null("hurtbox"):
		$Sprite2D.flip_h = true
	
	move_and_slide()
	
	if Input.is_action_just_pressed("attack") and root_node.scythe:
		var instance = hurtbox.instantiate()
		instance.scale.x = 1 if right else -1
		add_child(instance)
		
	if hp <= 0:
		get_tree().reload_current_scene()
	
	invuln += delta

func _process(delta):
	if invuln < 1:
		if blink_delta >= 0.1:
			if modulate.r == 1:
				modulate.r = 5
				modulate.g = 5
				modulate.b = 5
			else:
				modulate.r = 1
				modulate.g = 1
				modulate.b = 1
			blink_delta = 0
	else:
		modulate.r = 1
		modulate.g = 1 
		modulate.b = 1
	blink_delta += delta
