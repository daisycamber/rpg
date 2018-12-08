extends Node
# class member variables go here, for example:
# var a = 2
# var b = "textvar"
# The camera in this game is based on a set number of chunks, details as follows
var worldSize = 3 # In chunks, size of world to display on the screen
var chunkSize = 16 # Number of tiles to put in a chunk
var worldMapChunkSize = 6 # Size of the world map in chunks + 1
var mapSize = worldMapChunkSize * chunkSize # Size of the map in tiles (for generation)
var tileSize = OS.get_window_size().x/chunkSize # Size of each tile
var worldMap
var camera = Vector2(0,0) # Position of the camera relative to the chunk
var cameraChunk = Vector2(1,1) # Chunk where the camera resides
var offset = Vector2(0,0)
var cameraSpeed = tileSize * 4

func random(mi,mx):
	randomize()
	return randi()%(mx-mi) + mi
func randomPos():
	randomize()
	return Vector2(randi()%(mapSize-1)+1,randi()%(mapSize-1)+1)
func randomNeighbor(p): # random neighbor for position
	var pos = p + Vector2(randi()%2,randi()%3)
	pos.x = pos.x - 1
	pos.y = pos.y - 1
	if(pos.x > mapSize-1): pos.x = mapSize-1;
	if(pos.y > mapSize-1): pos.y = mapSize-1;
	if(pos.x < 0): pos.x = 0;
	if(pos.y < 0): pos.y = 0;
	return pos
var sprites

func generateSprites():
	sprites = Array()
	for x in 10:
		var sprite = get_node("sprite").duplicate()
		add_child(sprite)
		sprite.texture("land/structure/medievalStructure_01", tileSize)
		sprite.setPos(Vector2(random(0,1200),random(0,1200)))
		sprites.append(sprite)
# Create the randomly generated tilemap
func generateMap():
	seed(120)
	worldMap = Array()
	# Fill the map with grass
	for x in mapSize:
		worldMap.append(Array())
		for y in mapSize:
			worldMap[x].append(57)
	# Add trees randomly
	# Generate forests
	for x in mapSize * 4:
		var pos = randomPos()
		worldMap[pos.x][pos.y] = random(41,52)
	# Generate water
	for x in mapSize/4:
		var pos = randomPos()
		worldMap[pos.x][pos.y] = random(27,28)
		for y in mapSize:
			pos = randomNeighbor(pos)
			worldMap[pos.x][pos.y] = random(27,28)
	pass

var currentChunk = Vector2()
var chunks
func generateChunks():
	chunks = Array()
	for x in worldSize:
		chunks.append(Array())
		for y in worldSize:
			var chunk = get_node("chunk").duplicate()
			add_child(chunk)
			chunk.visible = true
			chunk.position.x = x * chunkSize * tileSize
			chunk.position.y = y * chunkSize * tileSize
			chunks[x].append(chunk)
	pass

var player
var structure
func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	generateMap()
	generateChunks()
	generateSprites()
	
	player = get_node("player").duplicate()
	player.texture(0,tileSize)
	add_child(player)
	pass
	
func drawSprites():
	for sprite in sprites:
		var chunkP = cameraChunk
		if(chunkP.x == 2): chunkP.x = 0
		if(chunkP.y == 2): chunkP.y = 0
		if chunkP.y == 5: chunkP.y = 2
		if chunkP.x == 5: chunkP.x = 2
		var spos = sprite.getPos()# The sprites position in the world
		sprite.position.x = camera.x + (chunkP.x-1) * chunkSize * tileSize + spos.x
		sprite.position.y = camera.y + (chunkP.y-1) * chunkSize * tileSize + spos.y
		print(sprite.position)
	pass

func getChunk(loc):
	var chunk = Array()
	for x in chunkSize:
		chunk.append(Array())
		for y in chunkSize:
			chunk[x].append(worldMap[loc.x+x][loc.y+y])
	return chunk
	
func drawWorld():
	for x in range(3):
		for y in range(3):
			# Position the chunks according to the camera
			var pos = Vector2(camera.x + (x-1) * chunkSize * tileSize, camera.y + (y-1) * chunkSize * tileSize)
			# For the scrolling infinite world to work, this code checks if we have
			# reached the world bounds and finds the chunk we display appropriatley
			var chunkPos = Vector2(x + cameraChunk.x - 1, y + cameraChunk.y - 1)
			if(x + cameraChunk.x - 1 == worldMapChunkSize): chunkPos.x = 1 # 0
			if(x + cameraChunk.x - 1 == 0): chunkPos.x = (worldMapChunkSize-1)
			if(y + cameraChunk.y - 1 == worldMapChunkSize): chunkPos.y = 1 # 0
			if(y + cameraChunk.y - 1 == 0): chunkPos.y = (worldMapChunkSize-1)
			chunks[x][y].update(pos, getChunk(chunkPos))
	drawSprites()
	pass
func _process(delta):
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	if Input.is_action_pressed("w"):
		camera.y = camera.y + delta * cameraSpeed
	if Input.is_action_pressed("d"):
		camera.x = camera.x - delta * cameraSpeed
	if Input.is_action_pressed("s"):
		camera.y = camera.y - delta * cameraSpeed
	if Input.is_action_pressed("a"):
		camera.x = camera.x + delta * cameraSpeed
	# Scroll the world if we have reached the bounds to simulate a globe
	if(cameraChunk.x == 0): cameraChunk.x = worldMapChunkSize-1
	if(cameraChunk.x == worldMapChunkSize): cameraChunk.x = 1 # 1
	if(cameraChunk.y == 0): cameraChunk.y = worldMapChunkSize-1
	if(cameraChunk.y == worldMapChunkSize): cameraChunk.y = 1 # 1
	# Update camera position according to the chunk (camera manages chunks individually)
	if(camera.x > chunkSize * tileSize): 
		camera.x = 0
		cameraChunk.x = cameraChunk.x - 1
	if(camera.x < 0): 
		camera.x = chunkSize * tileSize
		cameraChunk.x = cameraChunk.x + 1
	if(camera.y > chunkSize * tileSize): 
		camera.y = 0
		cameraChunk.y = cameraChunk.y - 1
	if(camera.y < 0): 
		camera.y = chunkSize * tileSize
		cameraChunk.y = cameraChunk.y + 1
	print(cameraChunk)
	drawWorld()
	pass