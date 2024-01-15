extends RigidBody2D

const bulletPath = preload('res://enemy_projectile.tscn')
var enemy_in_hitbox: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	mass = 1
	gravity_scale = 0.03
	$BulletTimer.wait_time = randf_range(1, 2)
	$BulletTimer.start()
	$AnimatedSprite2D_Explosion.visible = false
	get_parent().add_to_group("enemy")

func _process(delta):
	pass

func _on_bullet_timer_timeout():
	shoot()

func shoot():
	var bullet = bulletPath.instantiate()
	get_parent().add_child(bullet)
	bullet.position = $Marker2D.global_position

func _on_body_entered(body):
	print("Enemy hit")
	
	$BulletTimer.stop()
	enemy_in_hitbox = true
	
	$AnimatedSprite2D.visible = false
	$AnimatedSprite2D_Explosion.visible = true
	$AnimatedSprite2D_Explosion.play()
	
	# Must be deferred as we can't change physics properties on a physics callback.
	$CollisionShape2D.set_deferred("disabled", true)

func _on_animated_sprite_2d_explosion_animation_finished():
	if enemy_in_hitbox:
		queue_free()
