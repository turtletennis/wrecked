extends RedFish
@export var instakill:bool = true

func handle_collision(collision:KinematicCollision3D):
	if (collision):
		var collider = collision.get_collider()
		if (collider is Player):
			var player = collider as Player
			player.push(velocity * pushing_power)