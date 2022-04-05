extends KinematicBody

export var viewAngle := 80
export var viewDistance := 9
export var timeBetweenTurns := 5
var viewConeVector1 : Vector3
var viewConeVector2 : Vector3
var viewConeColor := Color.green
var lastDirection

var playerIsInViewAngle = false
var playerIsVisible = false

onready var tween = get_node("Tween")
onready var timer = get_node("Timer")
onready var lightCone = get_node("SpotLight2")
	
func _ready():
	lightCone.light_color = Color.green
	var viewAngleRad = viewAngle * PI / 180
	
	viewConeVector1.x = sin(viewAngleRad/2)
	viewConeVector1.z = -cos(viewAngleRad/2)
	viewConeVector1 *= viewDistance
	
	viewConeVector2.x = -sin(viewAngleRad/2)
	viewConeVector2.z = -cos(viewAngleRad/2)
	viewConeVector2 *= viewDistance
	lastDirection = rotation_degrees
	
	timer.set_wait_time(timeBetweenTurns)
	timer.start()
	
	
func _physics_process(delta):
	
	if rotation_degrees.y > 180:
			rotation_degrees.y -= 360
	if rotation_degrees.y < -180:
			rotation_degrees.y += 360
	
	drawViewCone()
	
	var playerPosition = to_local(get_node("../Player").transform.origin)
	var playerDistance = playerPosition.length()
	
	var enemyPlayerAngle = acos(playerPosition.dot(Vector3.FORWARD) / (playerPosition.length() * Vector3.FORWARD.length()))
	enemyPlayerAngle = enemyPlayerAngle * 180 / PI
	var signedEnemyPlayerAngle = enemyPlayerAngle
	if Vector3.UP.dot(playerPosition.cross(Vector3.FORWARD)) < 0:
		signedEnemyPlayerAngle = -enemyPlayerAngle
	
	if enemyPlayerAngle < viewAngle / 2:
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
				playerIsVisible = true
				lightCone.light_color = Color.red
				if (rotation_degrees.y - (rotation_degrees.y - enemyPlayerAngle)) > 2:
					tween.interpolate_property(self, "rotation_degrees",
					rotation_degrees, Vector3(0,rotation_degrees.y - signedEnemyPlayerAngle, 0), 0.1,
					Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
					tween.start()
				#look_at(get_node("../Player").global_transform.origin, Vector3.UP)
			else:
				if playerIsVisible:
					var tweenTime = 0.3
					if abs(rotation_degrees.y - lastDirection.y) > 90:
						tweenTime = 1
					tween.interpolate_property(self, "rotation_degrees",
					rotation_degrees, lastDirection, tweenTime,
					Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
					tween.start()
					playerIsVisible = false
					lightCone.light_color = Color.green
				
	else:
		viewConeColor = Color.green
		playerIsInViewAngle = false
		
	if !tween.is_active() and !playerIsVisible:
		lastDirection = rotation_degrees
		if lastDirection.y > 180:
			lastDirection.y -= 360
		if lastDirection.y < -180:
			lastDirection.y += 360
		
	
func drawViewCone():
	get_node("LineDrawer").clear()
	get_node("LineDrawer")._drawLine(Vector3(0,0,0), viewConeVector1, viewConeColor)
	get_node("LineDrawer")._drawLine(Vector3(0,0,0), viewConeVector2, viewConeColor)
	get_node("LineDrawer")._drawLine(Vector3(0,0,0), Vector3.FORWARD * 3, Color.white)

func turn(angle):
	lastDirection = rotation_degrees + Vector3(0, angle, 0)
	if lastDirection.y > 180:
		lastDirection.y -= 360
	if lastDirection.y < -180:
		lastDirection.y += 360
	tween.interpolate_property(self, "rotation_degrees",
	rotation_degrees, rotation_degrees + Vector3(0, angle, 0), 1,
	Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	tween.start()

func _on_Timer_timeout():
	if !playerIsVisible:
		turn(180)
	timer.start()
