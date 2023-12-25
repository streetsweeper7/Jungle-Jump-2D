extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var player_direction = 0
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _on_ready():
	$AnimatedSprite2D.play("idle")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Get the input direction and handle the movement/deceleration.
	
	#if player_direction:
		#velocity.x = direction * SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()


func _on_player_dectection_body_entered(body):
	print(body.name)
	#if ((position.x - body.position.x) > 0):
		
	
