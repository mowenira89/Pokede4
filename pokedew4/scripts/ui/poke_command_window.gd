class_name PokeCommandWindow extends Panel

@onready var move1: Label = $MarginContainer/VBoxContainer/HBoxContainer/Label2
@onready var move2: Label = $MarginContainer/VBoxContainer/HBoxContainer2/Label2
@onready var move3: Label = $MarginContainer/VBoxContainer/HBoxContainer3/Label2
@onready var move4: Label = $MarginContainer/VBoxContainer/HBoxContainer4/Label2
@onready var texture_rect: TextureRect = $TextureRect


var mon:Fieldmon

var names = []
@onready var labels = [move1,move2,move3,move4]
var moves = []


func set_mon(f:Fieldmon):
    moves.resize(4)
    reset_text()
    mon=f
    for x in f.mon.current_moves:
            names.append(x._name)
            moves.append(x)
    for x in range(0,names.size()-1):
        labels[x].text=names[x] 
    
func reset_text():
    names=[]
    moves=[]
    move1.text=""
    move2.text=""
    move3.text=""
    move4.text=""
    
func close():
    visible=false
    reset_text()
    mon=null
    
func _input(event: InputEvent) -> void:
    if visible:
        if event.is_action_pressed("g"):
            if moves[0]!=null:
                moves[0].use(mon,mon,moves[0])
        elif event.is_action_pressed("h"):
            if moves[1]!=null:
                moves[1].use(mon,mon,moves[0])
        elif event.is_action_pressed("j"):
            if moves[2]!=null:
                moves[2].use(mon,mon,moves[0])
        elif event.is_action_pressed("k"):
            if moves[3]!=null:
                moves[3].use(mon,mon,moves[0])
                
