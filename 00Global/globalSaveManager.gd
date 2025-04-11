extends Node

const SAVEPATH = "user://"

signal GameLoaded
signal GameSaved

#key value pair variable, we like storing save data in JSON so its human readable
#if anyones poking around in here, you didnt see shit
var currentSave : Dictionary = {
	scenePath = "", #this is gonna store the path to the scene the player is in when they save
	player = {
		level = 1,
		xp = 0,
		hp = 1,
		maxHP = 1,
		attack = 1,
		defense = 1,
		body = 1, 
		skillTreePoints = 0,
		posX = 0,
		posY = 0
	},
	items = [], #any item we want to save
	persistence = [], #any persistent var we want to save
	quests = [
		 # What each item looks like: { title = "not found", isComplete = false, completedSteps = [''] }
		
	], #any quests and quest data we want to save
}

#we need to be able to save the game, load the game, and gather the mess of JSON data we save

func saveGame() -> void:
	#before we save, we wanna update all our data TO save
	#lets make sure to keep all this in other functions to save confusion stupido
	updatePlayerData()
	updateScenePath()
	updateItemData()
	updateQuestData()
	
	var file := FileAccess.open( SAVEPATH + "save.sav", FileAccess.WRITE ) #gonna try and open a file, we gotta give it a path which includes the filename
	var saveJSON = JSON.stringify( currentSave ) #converts the savedata into a format we can actually store
	file.store_line( saveJSON )
	GameSaved.emit()
	pass

func getSaveFile() -> FileAccess:
	return FileAccess.open( SAVEPATH + "save.sav", FileAccess.READ )


func loadGame() -> void:
	#we want this function to open the file we saved, get the data outta it, and update the current savefile, and update the player
	var file := getSaveFile()
	var json := JSON.new()
	json.parse( file.get_line() ) #gonna get the first line and populate the new empty json
	#now lets convert silly json back into a file we can use lel
	var saveDict : Dictionary = json.get_data() as Dictionary #take our data and convert to dictionary
	currentSave = saveDict
	#lets make the player updates we need to, using the global level and player managers
	LevelManager.loadNewLevel( currentSave.scenePath, "", Vector2.ZERO ) #we position the player in another func, keep as vector2 zero for now
	
	await LevelManager.LevelLoadStarted
	#while the screen is black and we cant see anything, we update the player because game magic
	PlayerManager.setPlayerPosition( Vector2( currentSave.player.posX, currentSave.player.posY ) )
	PlayerManager.setPlayerHealth( currentSave.player.hp, currentSave.player.maxHP )
	var p : Player = PlayerManager.player
	p.level = currentSave.player.level
	p.xp = currentSave.player.xp
	p.attackStat = currentSave.player.attack
	p.defenceStat = currentSave.player.defense
	p.bodyStat = currentSave.player.body
	p.skillTreePoints = currentSave.player.skillTreePoints
	
	PlayerManager.INVENTORYDATA.parseSaveData( currentSave.items )
	QuestManager.currentQuests = currentSave.quests #both dictionaries, both in same format!!
	
	
	await LevelManager.LevelLoaded
	#screen is white, game is loaded. lets emit for anyone listening
	GameLoaded.emit()


#lets make some more funcs so we dont bloat poor saveGame
func updatePlayerData() -> void:
	var p : Player = PlayerManager.player
	currentSave.player.hp = p.hp
	currentSave.player.maxHP = p.maxHP
	currentSave.player.posX = p.global_position.x
	currentSave.player.posY = p.global_position.y
	currentSave.player.level = p.level
	currentSave.player.xp = p.xp
	currentSave.player.attack = p.attackStat
	currentSave.player.defense = p.defenceStat
	currentSave.player.body = p.bodyStat
	currentSave.skillTreePoints = p.skillTreePoints

func updateScenePath() -> void:
	var p : String = ""
	#we want to find the current level in the scene tree, get its path, and save that
	for c in get_tree().root.get_children():
		if c is Level: #the way we have it configured, only one level is active at once
			p = c.scene_file_path
	currentSave.scenePath = p

func updateItemData() -> void:
	currentSave.items = PlayerManager.INVENTORYDATA.getSaveData()

func updateQuestData() -> void:
	currentSave.quests = QuestManager.currentQuests

func addPersistentValue( value : String ) -> void:
	if checkPersistentValue( value ) == false: #make sure we dont add any more than one
		currentSave.persistence.append( value )

func removePersistentValue( value : String ) -> void:
	var p = currentSave.persistence as Array
	p.erase( value )

func checkPersistentValue( value : String ) -> bool: #check is NOT load, load is from disk, check is codey
	var p = currentSave.persistence as Array
	return p.has( value )
