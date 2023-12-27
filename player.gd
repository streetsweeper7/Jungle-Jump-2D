extends CharacterBody2D

var flipped = false
const SPEED = 200.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") * 5

# build a state machine
enum State {IDLE, JUMP, RUN, WALK, CROUCH, CLIMB}
var current_state = State.IDLE
var state_changed: bool = false

@onready var anim = get_node("AnimationPlayer")

func change_state(final_state):
	if (current_state != final_state):
		state_changed = true
		return true
	else:
		state_changed = false
	return false
	
	
func _ready():
	current_state = State.IDLE
	Globals.player = self


func _physics_process(delta):
	if (current_state == State.JUMP):
		state_changed = false
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		if (change_state(State.JUMP)):
			current_state = State.JUMP
		
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		if is_on_floor():
			if (change_state(State.RUN)):
				current_state = State.RUN
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if (velocity.x == 0 and is_on_floor() and velocity.y == 0):
		if(change_state(State.IDLE)):
			current_state = State.IDLE
	
	# Handle the animations
	if (current_state == State.JUMP and state_changed):
		if (velocity.y < 0):
			anim.play("Jump")
	if (current_state == State.JUMP and velocity.y > 0 and !state_changed):
		anim.play("Fall")
	if (current_state == State.RUN and state_changed):
		anim.play("Run")
	if (current_state == State.IDLE and state_changed and is_on_floor()):
		anim.play("Idle")
			
	# If the player is facing left flip the direction of the animation
	if (direction < 0 and !$AnimatedSprite2D.is_flipped_h()):
		$AnimatedSprite2D.set_flip_h(true)
	if (direction > 0 and $AnimatedSprite2D.is_flipped_h()):
		$AnimatedSprite2D.set_flip_h(false)
		
	move_and_slide()
