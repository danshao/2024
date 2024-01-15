extends Node

@export var mob_scene: PackedScene
var score

# Called when the node enters the scene tree for the first time.
func _ready():
	new_game()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	#print(get_tree().get_nodes_in_group("enemy"))

func _on_mob_timer_timeout():
	$MobTimer.wait_time = randf_range(1, 2)
	# Create a new instance of the Mob scene.
	var mob = mob_scene.instantiate()

	# Choose a random location on Path2D.
	var mob_spawn_location = get_node("MobPath/MobSpawnLocation")
	mob_spawn_location.progress_ratio = randf()

	# Set the mob's direction perpendicular to the path direction.
	#var direction = mob_spawn_location.rotation + PI / 4

	# Set the mob's position to a random location.
	mob.position = mob_spawn_location.position
	
	# Add some randomness to the direction.
	#direction += randf_range(-PI / 4, PI / 4)
	#mob.rotation = direction

	# Choose the velocity for the mob.
	#var velocity = Vector2.DOWN
	#mob.linear_velocity = velocity

	# Spawn the mob by adding it to the Main scene.
	add_child(mob)

func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	
func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()

func _on_score_timer_timeout():
	score += 1
	
func _on_start_timer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()
