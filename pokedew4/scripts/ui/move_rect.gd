class_name MoveRect extends ColorRect

enum modes {battle,skill}
var mode:modes

var move:Move
@onready var move_rect: ColorRect = $"."
@onready var type_color: ColorRect = $TypeColor
@onready var move_name: Label = $TypeColor/MarginContainer/MoveName
@onready var power_label: Label = $MarginContainer/PowerLabel
@onready var desc_label: RichTextLabel = $MarginContainer/DescLabel


func _ready():
    Signals.change_stat_mode.connect(change_mode)


func set_rect(m:Move):
    move=m
    var type = m.type
    
    if mode==modes.battle:
        var power_string = str(move.power)
        var acc_string = str(move.acc)
        if power_string=="0":power_string="--"
        if acc_string == "0":acc_string="--"
        power_label.text = "Power: "+power_string+"  Acc: " + acc_string + "  Energy: " + str(move.energy)
        desc_label.text = move.description
    elif mode==modes.skill:
        var s = ""
        var perform = move.perform_value
        if perform>0:
            if move.perform_type==Move.perform_types.Bad:
                perform*=-1
            s="Perform: "+str(perform) +" "+ Move.perform_types.keys()[move.perform_type]
        if move.mining_value>0:   
            s += "\nMining: "+str(move.mining_value)
        power_label.text=s
        desc_label.text=move.description_passive    
    
    
    type_color.color = Entity.get_type_color(type)
    move_name.text=move._name
    match move.move_type:
        Move.types.PHYSICAL:
            color = "#eec67a"
        Move.types.SPECIAL:
            color = "#f9e4be"
        Move.types.STATUS:
            color = "#fefaf3"
            
    
func change_mode(s:String):
    match s:
        'battle':
            mode=modes.battle
            set_rect(move)
        'skill':
            mode=modes.skill
            set_rect(move)
