extends Sprite

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var worldSize = 16
var tileSize = OS.get_window_size().x/worldSize
var id

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func texture(i,size):
	var texture = load("res://assets/land/unit/medievalUnit_17.png")
	set_texture(texture);
	id = i
	self.visible = true;
	var iss = self.texture.get_size() #image size
	var th = size #target height
	var tw = size #target width
	var scale = Vector2((iss.x/(iss.x/tw))/64, (iss.y/(iss.y/th))/64)
	set_scale(scale)
	position.x = OS.get_window_size().x/2
	position.y = OS.get_window_size().y/2
	pass


#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
