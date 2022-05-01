extends Spatial


var gameOver = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func _process(delta):
	if Input.is_action_just_pressed("action") and gameOver:
		get_tree().reload_current_scene()


func gameOver():
	gameOver = true
	get_node("Player").deactivateControls()
	get_node("CanvasLayer/GameOverText").visible = true
	get_node("CanvasLayer/ColorRect").visible = true

func _on_Enemy_gameOver():
	gameOver()


func _on_Surveillance_Camera_gameOver():
	gameOver()


func _on_Lasers_gameOver():
	gameOver()


func _on_Pressure_Plate_gameOver():
	gameOver()


func _on_Goal_victory():
	gameOver = true
	get_node("CanvasLayer/GameOverText").text = "Mission Accomplished"
	get_node("CanvasLayer/GameOverText").visible = true
	get_node("CanvasLayer/ColorRect").color = Color(0,0.4,1,.1)
	get_node("CanvasLayer/ColorRect").visible = true
	get_node("Player").deactivateControls()

func showPrompt(text):
	get_node("CanvasLayer/GameOverText").text = text
