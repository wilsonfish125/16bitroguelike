@tool
@icon( "res://NPC/Icons/chat_bubble.svg" )
class_name DialogueItem extends Node #acts as a base class for all unique dialogue options


@export var npcInfo : NPCResource



func _ready() -> void:
	if Engine.is_editor_hint():
		return
	checkNPCData()

func checkNPCData() -> void: #looks for parent npc node to get its data e.g. portrait data
	if npcInfo == null:
		var p = self
		var _checking : bool = true
		while _checking == true:
			p = p.get_parent()
			if p:
				if p is NPC and p.npcResource:
					npcInfo = p.npcResource
					_checking = false
			else:
				_checking = false
	pass
