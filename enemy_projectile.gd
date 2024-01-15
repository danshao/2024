extends RigidBody2D

var speed = 350

# Called when the node enters the scene tree for the first time.
func _ready():
	get_parent().add_to_group("enemy")
	gravity_scale = 0

func _physics_process(delta):
	var velocity = Vector2(0, 1)
	var collision_info = move_and_collide(velocity.normalized() * delta * speed)
