extends MarginContainer

onready var stat1 = get_node("HBoxContainer/VBoxContainer/Stat1")
onready var stat2 = get_node("HBoxContainer/VBoxContainer/Stat2")
var fps
var minFps = 200
var timer = 0

func _physics_process(delta):
	fps = Performance.get_monitor(Performance.TIME_FPS)
	minFps = min(fps, minFps)
	stat1.text = "fps: " + str(fps) + "  |  min: " + str(minFps)
	stat2.text = "mem: " + str(round(Performance.get_monitor(Performance.MEMORY_STATIC)/1024/1024)) + " mb"
	
	timer += 1
	
	if timer == 120:
		minFps = 200
		timer = 0
