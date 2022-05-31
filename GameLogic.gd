extends Spatial


var gameOver = false
export var godMode = false


# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("Enemy").connect("gameOver", self, "_on_Enemy_gameOver")
	get_node("Lasers").connect("gameOver", self, "_on_Lasers_gameOver")
	get_node("Lasers2").connect("gameOver", self, "_on_Lasers_gameOver")
	get_node("Surveillance_Camera").connect("gameOver", self, "_on_Surveillance_Camera_gameOver")
	
func _process(delta):
	if Input.is_action_just_pressed("action") and gameOver:
		get_tree().reload_current_scene()


func gameOver():
	if godMode == false:
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

func _on_Ghost_Trap_gameOver():
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


