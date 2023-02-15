extends CharacterBody2D

var invuln = 10
var hp = 50
var blink_delta = 0

var right = true

func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	velocity.x = 100.0 * (1 if right else -1)
	move_and_slide()
	if get_slide_collision_count() > 0: 
		right = !right
		
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for body in $effective_collision.get_overlapping_areas():
		if body.is_in_group("hurt") and invuln >= 0.5:
			invuln = 0
			hp -= 10
	for body in $effective_collision.get_overlapping_bodies():
		if body.is_in_group("player") and body.invuln >= 0.5:
			body.invuln = 0
			body.hp -= 10
	if hp <= 0:
		queue_free()
	invuln += delta
	
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
