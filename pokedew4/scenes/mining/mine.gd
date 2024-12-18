class_name Mine extends Node2D

@export var use_mine_area:Area2D
@export var build_mine_area:Area2D
@export var mining:Mining

var in_range:bool=false
var active:bool=false

func _ready():
    use_mine_area.body_entered.connect(body_entered)
    use_mine_area.body_exited.connect(body_exited)
    
    
func body_entered(body: Node2D) -> void:
    if body.is_in_group("Player"):
        Signals.set_instruction.emit("Press F to mine")
        in_range=true

func body_exited(body: Node2D) -> void:
    if body.is_in_group("Player"):
        Signals.close_instruction.emit()
        in_range=false
        
func _input(event):
    if in_range:
        if !active and event.is_action_pressed("f"):
            mining.player=Refs.player.data
            mining.start()
            active=true
        elif event.is_action_pressed('cancel'):
            mining.exit()
            active=false
            get_viewport().set_input_as_handled()
        elif active and event.is_action_pressed('f'):
            mining.on_pressed(Refs.player.data,InvManager.inventory.items)
