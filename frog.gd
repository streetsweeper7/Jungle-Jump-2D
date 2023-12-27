extends CharacterBody2D


const SPEED = 60.0
const JUMP_VELOCITY = -400.0
var player_direction = 0
var x_diff = 0;
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var player
var previous_speed:Vector2

enum State {IDLE, CHASE, DEAD}
var current_state = State.IDLE
var no_of_bounces = 0

func _ready():
	current_state = State.IDLE
	player = Globals.player


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Get the input direction and handle the movement/deceleration.
	if (current_state == State.CHASE):
		# update the chase
		update_frog_chase(position.x, Globals.player.position.x)
		# check if the player is far from frog and stop the chase
		if (abs(x_diff) > ($PlayerDectection/CollisionShape2D).get_shape().get_rect().size.x):
			current_state = State.IDLE
			velocity.x = 0
		
	if (current_state == State.IDLE):
		$AnimatedSprite2D.play("idle")
	if (current_state == State.CHASE):
		$AnimatedSprite2D.play("jump")
	if (current_state == State.DEAD):
		pass
	
	if (current_state != State.DEAD):
		move_and_slide()



func _on_player_dectection_body_entered(body):
	
	if (body.name == "Player"):
		# A player has entered the frog's area
		print ("The body has been entered")
		print("And the x diff is: ", x_diff)
		
		update_frog_chase(position.x, body.position.x)
			
		current_state = State.CHASE

func update_frog_chase(frog_x, player_x):
	x_diff = frog_x - player_x
	if (x_diff > 0):
		# The player is on the left side
		velocity.x = -SPEED
		
		if ($AnimatedSprite2D.flip_h == true):
			$AnimatedSprite2D.flip_h = false	
	else:
		# The player is on the right side
		if ($AnimatedSprite2D.flip_h == false):
			$AnimatedSprite2D.flip_h = true
		velocity.x = SPEED


func _on_head_body_entered(body):

	if (body.name == "Player"):
		# This means the player has jumped on the frog's head
		current_state = State.DEAD
		$CollisionShape2D.set_deferred("disabled", true)
		#Bounce the player
		bounce_player()
		
		$AnimatedSprite2D.play("death")
		await $AnimatedSprite2D.animation_finished
		# Kill the frog after the animation finishes
		queue_free()
	
func bounce_player():
	# get the speed in the x
		
	# maintain the same x speed but invert the y speed
	print ("The speed of the player is: ", Vector2(player.get_prev_velocity().x, -player.get_prev_velocity().y))
	
	if (no_of_bounces == 0):
		player.update_velocity(Vector2((player.get_prev_velocity().x / abs(player.get_prev_velocity().x))*120, -player.get_prev_velocity().y))
		player.current_state = player.State.JUMP
		no_of_bounces += 1
	
