extends CharacterBody2D

var invuln = 0
var hp = 5
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for body in $effective_collision.get_overlapping_areas():
		if body.is_in_group("hurt") and invuln >= 0.5:
			invuln = 0
			hp -= 1
	for body in $effective_collision.get_overlapping_bodies():
		if body.is_in_group("player") and body.invuln >= 0.5:
			body.invuln = 0
			body.hp -= 1
	if hp <= 0:
		queue_free()
	invuln += delta
