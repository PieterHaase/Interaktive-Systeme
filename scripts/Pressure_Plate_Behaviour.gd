extends Spatial

signal gameOver

var isActive = true

#func _ready():
#func _process(delta):


func _on_Area_body_entered(body):
	if isActive:
		get_node("MeshInstance").get_active_material(0).albedo_color = Color(0.5,0.3,0.3)
		get_node("OmniLight").visible = true
		emit_signal("gameOver")


#func _on_Area_body_exited(body):
	#get_node("MeshInstance").get_active_material(0).albedo_color = Color(0.4,0.4,0.4)
	#get_node("OmniLight").visible = false

func active(var state):
	isActive = state
	get_node("MeshInstance").get_active_material(0).albedo_color = Color(0.35,0.35,0.35)
