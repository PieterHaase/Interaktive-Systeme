extends Spatial

export var viewAngle := 80
export var viewDistance := 7
export var movementAngle := 160
var viewConeVector1 : Vector3
var viewConeVector2 : Vector3
var viewConeColor := Color.green
var startDirection
var lastDirection

var playerIsInViewAngle = false
var playerIsVisible = false
var isActive = true

onready var tween = get_node("Tween")
onready var lightCone = get_node("SpotLight")

signal gameOver
	
func _ready():
	#lightCone.light_color = Color.green
	var viewAngleRad = viewAngle * PI / 180
	
	viewConeVector1.x = sin(viewAngleRad/2)
	viewConeVector1.z = -cos(viewAngleRad/2)
	viewConeVector1 *= viewDistance
	
	viewConeVector2.x = -sin(viewAngleRad/2)
	viewConeVector2.z = -cos(viewAngleRad/2)
	viewConeVector2 *= viewDistance
	lastDirection = rotation_degrees
	startDirection = rotation_degrees
	
	
func _physics_process(delta):
	
	lightCone.light_color = Color.green
	
#	if rotation_degrees.y > 180:
#			rotation_degrees.y -= 360
#	if rotation_degrees.y < -180:
#			rotation_degrees.y += 360
#	#print(rotation_degrees)
	
	# draw view cone
	get_node("LineDrawer").clear()
	get_node("LineDrawer")._drawLine(Vector3(0,0,0), viewConeVector1, viewConeColor)
	get_node("LineDrawer")._drawLine(Vector3(0,0,0), viewConeVector2, viewConeColor)
	get_node("LineDrawer")._drawLine(Vector3(0,0,0), Vector3.FORWARD * 3, Color.white)
	
	var playerPosition = to_local(get_node("../Player").transform.origin)
	var playerDistance = playerPosition.length()
	
	var enemyPlayerAngle = acos(playerPosition.dot(Vector3.FORWARD) / (playerPosition.length() * Vector3.FORWARD.length()))
	enemyPlayerAngle = enemyPlayerAngle * 180 / PI
	var signedEnemyPlayerAngle = enemyPlayerAngle
	if Vector3.UP.dot(playerPosition.cross(Vector3.FORWARD)) < 0:
		signedEnemyPlayerAngle = -enemyPlayerAngle
	var targetRotation = rotation_degrees.y - signedEnemyPlayerAngle
	
	if enemyPlayerAngle < viewAngle / 2 and transform.origin.distance_to(playerPosition) > 2 and isActive:
		playerIsInViewAngle = true
		viewConeColor = Color.yellow
		# raycast
		var space_state = get_world().direct_space_state
		var result = space_state.intersect_ray(transform.origin, to_global(playerPosition))
		# draw line to player
		get_node("LineDrawer")._drawLine(Vector3(0,0,0), playerPosition, Color.white)
		if result:
			if result.collider == get_node("../Player") and playerDistance < viewDistance:
				viewConeColor = Color.red
				lightCone.light_color = Color.red
				playerIsVisible = true
				if (rotation_degrees.y - (rotation_degrees.y - enemyPlayerAngle)) > 2:
					if abs(targetRotation) > startDirection.y + (movementAngle / 2):
						targetRotation = startDirection.y
					if targetRotation < startDirection.y - (movementAngle / 2):
						targetRotation = startDirection.y
					
					tween.interpolate_property(self, "rotation_degrees",
					rotation_degrees, Vector3(0,targetRotation, 0), 0.3,
					Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
					tween.start()
				emit_signal("gameOver")
				#look_at(get_node("../Player").global_transform.origin, Vector3.UP)
			else:
				if playerIsVisible:
					tween.interpolate_property(self, "rotation_degrees",
					rotation_degrees, lastDirection, 0.3,
					Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
					tween.start()
					playerIsVisible = false
				
	else:
		viewConeColor = Color.green
		playerIsInViewAngle = false
		
	if !tween.is_active() and !playerIsInViewAngle:
		lastDirection = rotation_degrees
		if lastDirection.y > 180:
			lastDirection.y -= 360
		if rotation_degrees.y > 180:
			rotation_degrees.y -= 360
		#print(rotation_degrees)

func active(state):
	isActive = state
	if state == false:
		get_node("SpotLight").visible = false
