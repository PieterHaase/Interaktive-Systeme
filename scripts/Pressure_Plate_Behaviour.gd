extends Spatial

signal gameOver

var isActive = true
var doorsOpen = false
var playerPosition
var playerDistance

onready var animationPlayer = get_node("AnimationPlayer")

func _ready():
	#get_node("root/Keypad").connect("deactivateTraps", self, _on_Keypad_deactivateTraps())
	get_node("LightCone/OmniLight").light_energy = 0
	get_node("LightCone/Light").get_active_material(0).set_shader_param("light_intensity", 0)
	
func _physics_process(delta):
	playerPosition = to_local(get_node("../Player").transform.origin)
	playerDistance = playerPosition.length()
	
	if isActive:
		if playerDistance < 5 and !doorsOpen:
			animationPlayer.play("door_open")
			doorsOpen = true
				
		if playerDistance > 5 and doorsOpen:
			animationPlayer.play_backwards("door_open")
			doorsOpen = false
		
		if playerDistance < 3:
			get_node("LightCone/OmniLight").light_energy = 3
			get_node("LightCone/Light").get_active_material(0).set_shader_param("light_intensity", 3)
		else:
			get_node("LightCone/OmniLight").light_energy = 0
			get_node("LightCone/Light").get_active_material(0).set_shader_param("light_intensity", 0)


func _on_Area_body_entered(body):
	if isActive and body is KinematicBody:
			emit_signal("gameOver")


#func _on_Area_body_exited(body):
	#get_node("MeshInstance").get_active_material(0).albedo_color = Color(0.4,0.4,0.4)
	#get_node("OmniLight").visible = false

func active(var state):
	isActive = state


func _on_Keypad_deactivateTraps():
	isActive = false
	get_node("ghost_trap").get_active_material(0).emission_enabled = false
