extends KinematicBody

onready var cameraPivot := get_node("Spatial")
onready var tween = get_node("Spatial/Tween")
onready var playerModel = get_node("MeshInstance")
export var speed := 4.0
var velocity := Vector3.ZERO
var direction:= Vector3.ZERO
var gravity := 20.0
var cameraTargetRotation = Vector3.ZERO
var cameraTempRotation = Vector3.ZERO
var controlsActive = true
var t = 0
var u = 0
var interpolation = 0
var shaderMovement = 0

#func _ready():

func _physics_process(delta):
	
	# player moving direction
	var xDirection = (Input.get_action_strength("move_backward") - Input.get_action_strength("move_forward"))
	var zDirection = (Input.get_action_strength("move_left") - Input.get_action_strength("move_right"))
	
	direction.x = xDirection
	direction.z = zDirection
	direction.y = 0
	direction = direction.normalized()
	direction = Basis(Vector3.UP, cameraPivot.rotation.y) * direction
	velocity = direction * speed
	
	if controlsActive:
		velocity = move_and_slide(velocity, Vector3.UP)	
		
		
	# player looking direction	
	if velocity.length() > 0:
		var lookDirection = Vector2(direction.z, direction.x)
		playerModel.rotation.y = lookDirection.angle() - deg2rad(90)
	
	
	# cloth movement
	shaderMovement = speed / 12
	t += delta * 7
	u += delta * 7
	
	if velocity.length() == 0:
		t = 0
		interpolation = shaderMovement * (1-u)
		interpolation = max(interpolation, 0)
	else:
		u = 0
		interpolation = shaderMovement * t
		interpolation = min(interpolation, shaderMovement)

	playerModel.get_surface_material(0).set("shader_param/Movement", interpolation)
		
	# camera movement
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
