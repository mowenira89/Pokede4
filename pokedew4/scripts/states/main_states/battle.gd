class_name BattleState extends State
@onready var message: Message = $"../../CanvasLayer/Message"

func enter():
    message.active=false
    
func exit():
    message.active=true
