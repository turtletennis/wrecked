extends Fish
@export var instakill:bool = true

func handle_collision(collision:KinematicCollision3D):
	if (collision):
		var collider = collision.get_collider()
		if (collider is Player):
			var player = collider as Player
			player.push(velocity * pushing_power)

func on_player_hit():
	if(instakill):
		GameController.game_over.call_deferred("Poisoned to death by a puffer fish")
	else:
		super.on_player_hit()