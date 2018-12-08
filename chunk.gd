extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
const CHUNKSIZE = 16
var TILESIZE = OS.get_window_size().x/CHUNKSIZE

var tiles

func update(pos,textures):
	position = pos
	for x in CHUNKSIZE:
		for y in CHUNKSIZE:
			tiles[x][y].texture(textures[x][y],TILESIZE)
	

func generate():
	tiles = Array()
	for x in CHUNKSIZE:
		tiles.append(Array())
		for y in CHUNKSIZE:
			var tile = get_node("tile").duplicate()
			add_child(tile)
			tile.texture(57,TILESIZE)
			tile.position.x = TILESIZE * x
			tile.position.y = TILESIZE * y
			tiles[x].append(tile)
	pass
var sprites
func _ready():
	generate()
	sprites = Array()
	#structure = get_node("structure").duplicate()
	#add_child(structure)
	#structure.texture(10,TILESIZE)
	pass
	

func addSprite(texture):
	var sprite = get_node("sprite").duplicate()
	add_child(sprite)
	sprite.texture(texture,TILESIZE)
	sprites.append(sprite)
	pass