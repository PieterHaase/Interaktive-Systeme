extends Spatial

var isActive = true
var playerIsNear = false
var deactivationProgress : float = 0
export var deactivationTime = 3

onready var sprite3D = get_node("ProgressBar/Sprite3D")
onready var progressBar = get_node("ProgressBar/Viewport/ProgressBar")
onready var screen = get_node("MeshInstance/Screen")
onready var surveillanceCamera = get_parent().get_node( "Surveillance_Camera")
onready var promptLabel = get_parent().get_node("CanvasLayer/Prompt")

func _ready():
	screen.get_active_material(0).emission = Color(1, 1, 1)

func _physics_process(delta):
	#if Input.is_action_just_pressed("action") and playerIsNear and isActive:
	#	sprite3D.visible = true
	
	if playerIsNear and isActive:
		sprite3D.visible = true
		promptLabel.text = "[SPACE] - Deactivate Cameras"
		
	if Input.is_action_pressed("action") and playerIsNear and isActive:
		deactivationProgress += 1
		progressBar.visible = true
		progressBar.value = deactivationProgress / (60 * deactivationTime) * 100
		#print(progressBar.value)
		if deactivationProgress == 60 * deactivationTime:
			deactivationProgress = 0
			isActive = false
			sprite3D.visible = false
			screen.get_active_material(0).emission = Color(0, 0, 0)
			screen.get_active_material(0).albedo_color = Color(0.2, 0.2, 0.2)
			surveillanceCamera.active(false)
			promptLabel.text = ""
			#print("deactivated")
			
	if Input.is_action_just_released("action"):
		#sprite3D.visible = false
		deactivationProgress = 0
		progressBar.value = 0
		progressBar.visible = false

func _on_TerminalArea_area_entered(area):
	playerIsNear = true


func _on_TerminalArea_area_exited(area):
	playerIsNear = false
	sprite3D.visible = false
	deactivationProgress = 0
	progressBar.value = 0
	promptLabel.text = ""
