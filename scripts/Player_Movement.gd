extends KinematicBody

onready var cameraPivot := get_node("Spatial")
onready var tween = get_node("Spatial/Tween")
export var speed := 7.0
var velocity := Vector3.ZERO
var gravity := 20.0
var cameraTargetRotation = Vector3.ZERO
var cameraTempRotation = Vector3.ZERO
var controlsActive = true

#func _ready():

func _physics_process(delta):
	
	var xDirection = (Input.get_action_strength("move_backward") - Input.get_action_strength("move_forward"))
	var zDirection = (Input.get_action_strength("move_left") - Input.get_action_strength("move_right"))
	
	velocity.x = xDirection
	velocity.z = zDirection
	velocity.y = 0
	velocity = velocity.normalized() * speed
	
	velocity = Basis(Vector3.UP, cameraPivot.rotation.y) * velocity
	if controlsActive:
		velocity = move_and_slide(velocity, Vector3.UP)	

	if Input.is_action_just_pressed("camera_left") and controlsActive:
		cameraTargetRotation += Vector3(0, -90, 0)
		tween.interpolate_property(cameraPivot, "rotation_degrees",
		cameraPivot.rotation_degrees, cameraTempRotation + cameraTargetRotation, 0.4,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween.start()
		
		
	if Input.is_action_just_pressed("camera_right") and controlsActive:
		cameraTargetRotation += Vector3(0, +90, 0)
		tween.interpolate_property(cameraPivot, "rotation_degrees",
		cameraPivot.rotation_degrees, cameraTempRotation + cameraTargetRotation, 0.4,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween.start()
		
	if !tween.is_active():
		cameraTempRotation = cameraPivot.rotation_degrees
		cameraTargetRotation = Vector3.ZERO
		
func deactivateControls():
	controlsActive = false
