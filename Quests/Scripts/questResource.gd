class_name Quest extends Resource

# Designed to describe a quest and its rewards
# Does NOT keep track of quest rewards and completions

@export var title : String
@export_multiline var description : String

@export var steps : Array[ String ] # What are the steps to complete this quest?
@export var rewardXP : int
@export var rewardItems : Array[ QuestRewardItem ] = []
