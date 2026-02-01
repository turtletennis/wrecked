extends Fish

class_name YellowFish

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if targetNodes.size() < 1:
		push_error("Enemy target Node array is empty!")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if state == State.WANDERING:
		if (position.distance_squared_to(targetNodes[nextTarget].position) <= 0.01): # 0.1^2
			nextTarget += 1
			if nextTarget > (targetNodes.size() - 1):
				nextTarget = 0
		var target = targetNodes[nextTarget].position
		go_towards_target(target, wanderingSpeed, delta)
		if check_for_player_nearby(playerDetectionRadius):
			change_state(State.CHASING)
	elif state == State.CHASING:
		go_towards_target(player.position, playerChaseSpeed, delta)
		if !check_for_player_nearby(playerIgnoreRadius):
			change_state(State.WANDERING)
	elif state == State.ATTACKING:
		player.velocity.y += 0.1
	else:
		push_error("Enemy state unimplemented! State: ", State.keys()[state])

func on_player_hit():
	change_state(State.ATTACKING)
