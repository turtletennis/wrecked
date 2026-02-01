extends Fish

class_name RedFish

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if targetNodes.size() < 1:
		push_error("Enemy target Node array is empty!")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if state == State.WANDERING:
		#print_debug(targetNodes.size(),nextTarget,name)
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
	else:
		push_error("Enemy state unimplemented! State: ", State.keys()[state])

func on_player_hit():
	player.push(velocity * pushing_power)
