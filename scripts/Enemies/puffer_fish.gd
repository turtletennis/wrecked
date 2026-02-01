extends Fish
@export var instakill:bool = true

func state_machine_tick(delta: float) -> void:
	if state == State.WANDERING:
		if (position.distance_squared_to(targetNodes[nextTarget].position) <= 0.01): # 0.1^2
			nextTarget += 1
			if nextTarget > (targetNodes.size() - 1):
				nextTarget = 0
		var target = targetNodes[nextTarget].position
		go_towards_target(target, wanderingSpeed, delta)
		if check_for_player_nearby(playerDetectionRadius):
			print_stack()
			change_state(State.CHASING)
	elif state == State.CHASING:
		go_towards_target(player.position, playerChaseSpeed, delta)
		if !check_for_player_nearby(playerIgnoreRadius):
			change_state(State.WANDERING)
	else:
		push_error("Enemy state unimplemented! State: ", State.keys()[state])

func on_player_hit():
	if(instakill):
		GameController.game_over.call_deferred()
	else:
		super.on_player_hit()