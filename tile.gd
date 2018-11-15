extends Sprite

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var worldSize = 16
var tileSize = OS.get_window_size().x/worldSize
var id

func texture(id,size):
	var texture = load(str("res://assets/land/tile/medievalTile_",id,".png"))
	set_texture(texture);
	id = id
	self.visible = true;
	var iss = self.texture.get_size() #image size
	var th = size #target height
	var tw = size #target width
	var scale = Vector2((iss.x/(iss.x/tw))/64, (iss.y/(iss.y/th))/64)
	set_scale(scale)

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	self.visible = false
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
