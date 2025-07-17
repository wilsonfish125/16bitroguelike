class_name MapGenerator extends Node

const XDIST := 50
const YDIST := 40
const PLACEMENTRANDOMNESS := 6 # Randomly moves rooms on grid
const FLOORS := 15
const MAPWIDTH := 7
const PATHS := 6 # Max number of paths for whole map
const MONSTERROOMWEIGHT := 10.0
const SHOPROOMWEIGHT := 3
const CAMPFIREROOMWEIGHT := 4.5

var randomRoomTypeWeights = {
	Room.Type.MONSTER: 0.0,
	Room.Type.CAMPFIRE: 0.0,
	Room.Type.SHOP: 0.0
}

var randomRoomTypeTotalWeight := 0
var mapData : Array[Array] # SENG1110 Reference
# 15 different 7-long arrays forms a 15x7 matrix

func generateMap() -> Array[Array]:
	mapData = _generateInitialGrid()
	var startingPoints := _getRandomStartingPoints()
	
	for j in startingPoints:
		var currentJ := j # Possible future J indicies change, therefore save a reference
		for i in FLOORS - 1:
			currentJ = _setupConnection(i, currentJ)
	
	_setupBossRoom()
	_setupRandomRoomWeights()
	_setupRoomTypes()
	
	return mapData

func _generateInitialGrid() -> Array[Array]:
	var result : Array[Array] = []
	
	for i in FLOORS:
		var adjacentRooms : Array[Room] = []
		
		for j in MAPWIDTH:
			var currentRoom := Room.new()
			var offset := Vector2(randf(), randf()) * PLACEMENTRANDOMNESS
			currentRoom.position = Vector2(j * XDIST, i * -YDIST) + offset
			currentRoom.row = i
			currentRoom.column = j
			currentRoom.nextRooms = [] # Store all other rooms we can go to FROM THIS ROOM
			
			# Boss room has non random y
			if i == FLOORS - 1:
				currentRoom.position.y = (i + 1) * -YDIST
			
			adjacentRooms.append(currentRoom)
		
		result.append(adjacentRooms)
	
	return result

func _getRandomStartingPoints() -> Array[int]:
	var yCoordinates : Array[int]
	var uniquePoints := 0
	
	while uniquePoints < 2:
		uniquePoints = 0
		yCoordinates = []
		
		for i in PATHS:
			var startingPoint := randi_range(0, MAPWIDTH -1)
			if not yCoordinates.has(startingPoint):
				uniquePoints += 1
			
			yCoordinates.append(startingPoint)
		
	return yCoordinates

func _setupConnection(i: int, j: int) -> int:
	var nextRoom : Room
	var currentRoom := mapData[i][j] as Room
	
	while not nextRoom or _wouldCrossExistingPath(i, j, nextRoom):
		#Dont want to cross existing paths or go off the map
		var randomJ := clampi(randi_range(j - 1, j + 1), 0, MAPWIDTH - 1)
		nextRoom = mapData[i + 1][randomJ]
	
	currentRoom.nextRooms.append(nextRoom)
	
	return nextRoom.column

func _wouldCrossExistingPath(i: int, j:int, room: Room ) -> bool:
	var leftNeighbour : Room
	var rightNeighbour : Room
	
	# If j = 0, no left neighbour
	if j > 0:
		leftNeighbour = mapData[i][j - 1]
	#If J == MAPWIDTH - 1, no right neighbour
	if j < MAPWIDTH - 1:
		rightNeighbour = mapData[i][j + 1]
	
	# Cant cross in right dir if right neighbour goes to left
	if rightNeighbour and room.column > j:
		for nextRoom : Room in rightNeighbour.nextRooms:
			if nextRoom.column < room.column:
				return true # WE CROSSED A PATH!!
	
	# Cant cross in left dir if left neighbour goes to right
	if leftNeighbour and room.column < j:
		for nextRoom : Room in leftNeighbour.nextRooms:
			if nextRoom.column > room.column:
				return true
	
	return false

func _setupBossRoom() -> void:
	var middle := floori(MAPWIDTH * 0.5)
	var bossRoom := mapData[FLOORS - 1][middle] as Room
	
	# Connect all rooms below boss room to boss room
	for j in MAPWIDTH:
		var currentRoom = mapData[FLOORS - 2][j] as Room
		if currentRoom.nextRooms:
			currentRoom.nextRooms = [] as Array[Room]
			currentRoom.nextRooms.append(bossRoom)
		
	bossRoom.type = Room.Type.BOSS

func _setupRandomRoomWeights() -> void:
	randomRoomTypeWeights[Room.Type.MONSTER] = MONSTERROOMWEIGHT
	randomRoomTypeWeights[Room.Type.CAMPFIRE] = MONSTERROOMWEIGHT + CAMPFIREROOMWEIGHT
	randomRoomTypeWeights[Room.Type.SHOP] = MONSTERROOMWEIGHT + CAMPFIREROOMWEIGHT + SHOPROOMWEIGHT
	
	randomRoomTypeTotalWeight = randomRoomTypeWeights[Room.Type.SHOP]

func _setupRoomTypes() -> void:
	#1st floor is always a battle
	for room : Room in mapData[0]:
		if room.nextRooms.size() > 0:
			room.type = Room.Type.MONSTER
	
	#9th Floor is always a treasure
	for room : Room in mapData[8]:
		if room.nextRooms.size() > 0:
			room.type = Room.Type.TREASURE
	
	#Last floor before boss is always a campfire
	for room : Room in mapData[13]:
		if room.nextRooms.size() > 0:
			room.type = Room.Type.CAMPFIRE
	
	# Rest of rooms
	for currentFloor in mapData:
		for room : Room in currentFloor:
			for nextRoom : Room in room.nextRooms:
				if nextRoom.type == Room.Type.NOT_ASSIGNED:
					_setRoomRandomly( nextRoom )

func _setRoomRandomly( roomToSet : Room ) -> void:
	# All rules we need to follow
	var campfireBelow4 := true
	var consecutiveCampfire := true
	var consecutiveShop := true
	var campfireOn13 := true
	
	var typeCandidate : Room.Type
	while campfireBelow4 or consecutiveCampfire or consecutiveShop or campfireOn13:
		typeCandidate = _getRandomRoomTypeByWeight()
		
		var isCampfire := typeCandidate == Room.Type.CAMPFIRE
		var hasCampfireParent := _roomHasParentOfType( roomToSet, Room.Type.CAMPFIRE )
		var isShop := typeCandidate == Room.Type.SHOP
		var hasShopParent := _roomHasParentOfType( roomToSet, Room.Type.SHOP )
		
		campfireBelow4 = isCampfire and roomToSet.row < 3
		consecutiveCampfire = isCampfire and hasCampfireParent
		consecutiveShop = isShop and hasShopParent
		campfireOn13 = isCampfire and roomToSet.row == 12
	
	roomToSet.type = typeCandidate

func _roomHasParentOfType(room : Room, type : Room.Type ) -> bool:
	var parents : Array[Room] = []
	# Left parent
	if room.column > 0 and room.row > 0:
		var parentCandidate := mapData[room.row - 1][room.column - 1] as Room
		if parentCandidate.nextRooms.has(room):
			parents.append(parentCandidate)
	# Parent Below
	if room.row > 0:
		var parentCandidate := mapData[room.row - 1][room.column] as Room
		if parentCandidate.nextRooms.has(room):
			parents.append(parentCandidate)
	# Right Parent
	if room.column < MAPWIDTH - 1 and room.row > 0:
		var parentCandidate := mapData[room.row - 1][room.column + 1] as Room
		if parentCandidate.nextRooms.has(room):
			parents.append(parentCandidate)
	
	for parent: Room in parents:
		if parent.type == type:
			return true # There is a match
	
	return false

func _getRandomRoomTypeByWeight() -> Room.Type:
	var roll := randf_range(0.0, randomRoomTypeTotalWeight)
	
	for type: Room.Type in randomRoomTypeWeights:
		if randomRoomTypeWeights[type] > roll:
			return type
	
	return Room.Type.MONSTER
