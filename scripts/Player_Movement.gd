extends KinematicBody


export var speed := 7.0
var velocity := Vector3.ZERO
var gravity := 20.0

func _ready():
	print("Script started!")

func _physics_process(delta):
	
	var xDirection = (Input.get_action_strength("move_backward") - Input.get_action_strength("move_forward"))
	var zDirection = (Input.get_action_strength("move_left") - Input.get_action_strength("move_right"))
	
	velocity.x = xDirection
	velocity.z = zDirection
	velocity.y = 0
	velocity = velocity.normalized() * speed
	
	velocity = move_and_slide(velocity, Vector3.UP)	
