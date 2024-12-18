class_name PokeOptionsPanel extends ColorRect
@onready var holder: VBoxContainer = $MarginContainer/VBoxContainer
@onready var pointer: Sprite2D = $Sprite2D

var options=[]
var selected_option:int=0

signal show_stat_screen
signal pokemon_go

func _ready():
    for x in holder.get_children():
        options.append(x)
    Signals.close_poke_options.connect(disconnect_signal)

func connect_signal():
    Signals.select_poke_option.connect(change_pointer_pos)
    Signals.choose_poke_option.connect(select_option)

func disconnect_signal():
    visible=false
    Signals.select_poke_option.disconnect(change_pointer_pos)
    Signals.choose_poke_option.disconnect(select_option)

    
func change_pointer_pos(d:int):
    selected_option+=d
    if selected_option<0:
        selected_option=options.size()-1
    if selected_option==options.size():
        selected_option=0
    pointer.position.y=(selected_option+1)*45

func select_option():
    match selected_option:
        
        0:
            pokemon_go.emit()
        1:
            show_stat_screen.emit()
