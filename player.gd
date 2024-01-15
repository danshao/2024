extends Area2D

signal hit
const projectilePath = preload('res://player_projectile.tscn')

@export var speed = 300 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.
var player_in_hitbox: bool = false

var fire_rate : float = 5 #Fire rate 10 bullets per second
@onready var update_delta : float = 1 / fire_rate
var current_time : float = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	current_time += delta
	if player_in_hitbox: 
		return
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
		
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	
	if Input.is_action_pressed("ui_accept"):
		if (current_time < update_delta):
			return
		else:
			current_time = 0
			shoot()
	
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
	$AnimatedSprite2D_Explosion.visible = false

func shoot():
	var projectile = projectilePath.instantiate()
	get_parent().add_child(projectile)
	projectile.position = $Marker2D.global_position

func _on_body_entered(body):
	#if body.is_in_group('enemy'):
	$AnimatedSprite2D.visible = false
	$AnimatedSprite2D_Explosion.visible = true
	$AnimatedSprite2D_Explosion.play()
	hit.emit()
	player_in_hitbox = true
	# Must be deferred as we can't change physics properties on a physics callback.
	$CollisionShape2D.set_deferred("disabled", true)
	

func _on_animated_sprite_2d_explosion_animation_finished():
	$AnimatedSprite2D_Explosion.pause()
