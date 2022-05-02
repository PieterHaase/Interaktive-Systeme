extends Spatial

onready var timer = get_node("Timer")
export var beamLength = 4
export var interval_on = 3
export var interval_off = 1.5
var isOn = true

onready var laser1 = get_node("Laser")
onready var laser2 = get_node("Laser2")
onready var laser3 = get_node("Laser3")
onready var light = get_node("OmniLight")

signal gameOver

func _ready():
	timer.set_wait_time(interval_on)
	timer.start()


func _physics_process(delta):
	var playerPosition = to_local(get_node("../Player").transform.origin)
	var playerDistance = playerPosition.length()
	
	if playerDistance < beamLength:
		var space_state = get_world().direct_space_state
		var result = space_state.intersect_ray(transform.origin, to_global(Vector3(0,0, beamLength)))
		if result:
			if result.collider == get_node("../Player"):
				if isOn:
					emit_signal("gameOver")
	
func _on_Timer_timeout():
	if isOn:
		timer.set_wait_time(interval_off)	
	else:
		timer.set_wait_time(interval_on)
	isOn = !isOn
	laser1.visible = !laser1.visible
	laser2.visible = !laser2.visible
	laser3.visible = !laser3.visible
	light.visible = !light.visible
	
	timer.start()
