extends ImmediateGeometry

#func _ready():
	
	

#func _process(delta):	
	
	
func _drawLine(start, end, color):	
	begin(Mesh.PRIMITIVE_LINES)
	set_color(color)
	add_vertex(start)
	set_color(color)
	add_vertex(end)
	end()

func _clear():
	clear()
