class_name NotificationUI extends Control

var notificationQueue : Array # Everytime we recieve a notif, it is added to the queue

@onready var panel_container: PanelContainer = $PanelContainer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var titleLabel : Label = $PanelContainer/VBoxContainer/Label
@onready var messageLabel : Label = $PanelContainer/VBoxContainer/Label2

func _ready() -> void:
	panel_container.visible = false
	animation_player.animation_finished.connect( notificationAnimationFinished )

func addNotificationToQueue( _title : String, _message : String ) -> void:
	notificationQueue.append( {
			title = _title,
			message = _message
	})
	if animation_player.is_playing():
		return
	displayNotification()

func displayNotification() -> void:
	var _n = notificationQueue.pop_front() # Removes and returns elements from an array
	if _n == null:
		return # No notifs to display
	titleLabel.text = _n.title
	messageLabel.text = _n.message
	animation_player.play( "showNotification" )

# This is a different method as we don't want to require an argument for displayNotification()
func notificationAnimationFinished( _a : String ) -> void:
	displayNotification()
