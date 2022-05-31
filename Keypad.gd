extends Spatial

var isActive = true
var playerIsNear = false
var deactivationProgress : float = 0
export var deactivationTime = 3

signal deactivateTraps

onready var sprite3D = get_node("ProgressBar/Sprite3D")
onready var progressBar = get_node("ProgressBar/Viewport/ProgressBar")
onready var display = get_node("MeshInstance/Display")
onready var promptLabel = get_parent().get_node("CanvasLayer/Prompt")

func _ready():
	display.get_active_material(0).emission = Color(1, 0, 0)

func _physics_process(delta):
	#if Input.is_action_just_pressed("action") and playerIsNear and isActive:
	#	sprite3D.visible = true
	
	if playerIsNear and isActive:
		sprite3D.visible = true
		promptLabel.text = "[SPACE] - Deactivate Traps"
		
	if Input.is_action_pressed("action") and playerIsNear and isActive:
		deactivationProgress += 1
		progressBar.visible = true
		progressBar.value = deactivationProgress / (60 * deactivationTime) * 100
		#print(progressBar.value)
		if deactivationProgress == 60 * deactivationTime:
			deactivationProgress = 0
			isActive = false
			sprite3D.visible = false
			display.get_active_material(0).emission = Color(0, 0, 0)
			display.get_active_material(0).albedo_color = Color(0.2, 0.2, 0.2)
			emit_signal("deactivateTraps")
			promptLabel.text = ""
			print("deactivated")
			
	if Input.is_action_just_released("action"):
		#sprite3D.visible = false
		deactivationProgress = 0
		progressBar.value = 0
		progressBar.visible = false

func _on_KeyPadArea_area_entered(area):
	playerIsNear = true

func _on_KeyPadArea_area_exited(area):
	playerIsNear = false
	sprite3D.visible = false
	deactivationProgress = 0
	progressBar.value = 0
	promptLabel.text = ""
