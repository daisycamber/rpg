extends Node
# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var camera = Vector2(0,0)
var cameraChunk = Vector2(0,0)
var worldSize = 16 * 4
var tileSize = OS.get_window_size().x/16
var tiles


func random(mi,mx):
	return randi()%(mx-mi) + mi
func randomPos():
	return Vector2(randi()%worldSize-1,randi()%worldSize-1)
func randomNeighbor(p): # random neighbor for position
	var pos = p + Vector2(randi()%2,randi()%3)
	pos.x = pos.x - 1
	pos.y = pos.y - 1
	if(pos.x > 63): pos.x = 63;
	if(pos.y > 63): pos.y = 63;
	if(pos.x < 0): pos.x = 0;
	if(pos.y < 0): pos.y = 0;
	return pos

func generateTiles():
	tiles = Array()
	for x in worldSize:
		tiles.append(Array())
		for y in worldSize:
			var tile = get_node("tile").duplicate()
			add_child(tile)
			tiles[x].append(tile)
	pass
func generateWorld():
	randomize()
	for x in worldSize:
		for y in worldSize:
			tiles[x][y].texture(57,tileSize);
			
	for x in worldSize/2:
		var pos = randomPos()
		tiles[pos.x][pos.y].texture(random(41,52),tileSize)
		for x in worldSize:
			pos = randomNeighbor(pos)
			print()
			tiles[pos.x][pos.y].texture(random(41,52),tileSize)
	for x in worldSize/8:
		var pos = randomPos()
		tiles[pos.x][pos.y].texture(random(27,28),tileSize)
		for x in worldSize:
			pos = randomNeighbor(pos)
			tiles[pos.x][pos.y].texture(random(27,28),tileSize)
	pass

func draw(camera):
	for x in worldSize:
		for y in worldSize:
			tiles[x][y].position.x = tileSize * x + camera.x
			tiles[x][y].position.y = tileSize * y + camera.y

var player
func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	#camera.x = tileSize * (worldSize/2)
	#camera.y = tileSize * (worldSize/2)
	generateTiles()
	generateWorld()
	player = get_node("player").duplicate()
	player.texture(0,tileSize)
	add_child(player)
	pass

var cameraSpeed = 100
func _process(delta):
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	if Input.is_action_pressed("w") and camera.y < 0:
		camera.y = camera.y + delta * cameraSpeed
	if Input.is_action_pressed("d") and camera.x > worldSize * tileSize * -1 + OS.get_window_size().x:
		camera.x = camera.x - delta * cameraSpeed
	if Input.is_action_pressed("s") and camera.y > worldSize * tileSize * -1 + OS.get_window_size().y:
		camera.y = camera.y - delta * cameraSpeed
	if Input.is_action_pressed("a") and camera.x < 0:
		camera.x = camera.x + delta * cameraSpeed
	draw(camera)
	pass
