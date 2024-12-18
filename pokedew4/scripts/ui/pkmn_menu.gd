class_name PokemonMenu extends ColorRect
@onready var grid: GridContainer = $MarginContainer/ColorRect/MarginContainer/HBoxContainer/GridContainer
@onready var stats_side: VBoxContainer = $MarginContainer/ColorRect/MarginContainer/HBoxContainer/StatsSide

@onready var stat_panel_icon: TextureRect = $MarginContainer/ColorRect/MarginContainer/HBoxContainer/StatsSide/StatPanelIcon
@onready var nickname: Label = $MarginContainer/ColorRect/MarginContainer/HBoxContainer/StatsSide/Nickname
@onready var hpbar: ProgressBar = $MarginContainer/ColorRect/MarginContainer/HBoxContainer/StatsSide/GridContainer/HPBAR
@onready var energybar: ProgressBar = $MarginContainer/ColorRect/MarginContainer/HBoxContainer/StatsSide/GridContainer/ENERGYBAR
@onready var happinessbar: ProgressBar = $MarginContainer/ColorRect/MarginContainer/HBoxContainer/StatsSide/GridContainer/HAPPINESSBAR
@onready var stat_screen: StatScreen = $StatScreen
@onready var nature: Label = $MarginContainer/ColorRect/MarginContainer/HBoxContainer/StatsSide/ButtonContainer/HBoxContainer/Nature
@onready var level: Label = $MarginContainer/ColorRect/MarginContainer/HBoxContainer/StatsSide/ButtonContainer/HBoxContainer/Level

var slot_ref = preload("res://scenes/ui/poke_slot.tscn")

signal unmenu 

enum modes {BATTLE,NORMAL}
enum substates {NORMAL,STATS,OPTIONS,STATOPTIONS}
var substate:substates=substates.NORMAL

@export var mode:modes
var forced:bool=false
var first_slot:int=0
var last_slot:int=79
var selected_pokemon:Pokemon
var selected_for_movement=null
var selected_index=0

var selected_for_stat_window

var top_menu

signal send_out_pokemon

func _ready():
    set_screen()
    hide_stats()
    set_cursor(selected_index)
    Signals.close_poke_options.connect(hide_stats)
    
func reset_screen():
    set_screen()
    hide_stats()
    selected_index=0
    set_cursor(0)
    
func set_screen():
    for x in grid.get_children():
        x.queue_free()
    for x in range(first_slot,last_slot+1):
        var slot = slot_ref.instantiate()
        grid.add_child(slot)
        slot.set_slot(x)
        slot.left_clicked.connect(show_stats)
        slot.options.show_stat_screen.connect(show_stat_screen)
        slot.options.pokemon_go.connect(pokemon_go)
        
func set_cursor(i:int):
    selected_index=clamp(i,first_slot,last_slot)
    var pokeslots=grid.get_children()
    for x in pokeslots:
        if x.index==selected_for_movement:
            pass
        else:
            x.deselect()
    var slot = grid.get_child(selected_index)
    slot.be_hovered_over()
    show_stats(slot)

func set_for_movement():
    if selected_for_movement==null:
        selected_for_movement=selected_index
        grid.get_child(selected_index).select()
    else:
        Refs.switch_pokemon_position(selected_index,selected_for_movement)
        selected_for_movement=null
        set_screen()
        

func hide_stats():
    stats_side.visible=false
    substate=substates.NORMAL

    
func show_stats(slot:PokeSlot):
    if slot.index>=Refs.pokemon_order.size():
        hide_stats()
        return
    var pokemon:Pokemon = Refs.get_pokemon_by_index(slot.index)
    selected_pokemon=pokemon
    
    if pokemon:
        
        stat_panel_icon.texture=pokemon.image                
        nickname.text = pokemon.nickname
        hpbar.max_value = pokemon.get_stat(Entity.stats.HP)
        hpbar.value = pokemon.hp
        energybar.max_value = pokemon.get_stat(Entity.stats.Energy)
        energybar.value = pokemon.energy
        happinessbar.max_value = 255
        happinessbar.value = pokemon.happiness
        nature.text = pokemon.get_nature_name(pokemon.nature)
        level.text = "lvl. " + str(pokemon.get_level())
        Signals.set_stats.emit(pokemon)
        stats_side.visible=true
    
    
    
func close_menu():
    hide_stats()
    grid.get_child(selected_index).hide_options()
    visible=false
    if mode==modes.NORMAL:
        Signals.release_menu.emit()
    else:
        unmenu.emit()
    
    
func toggle_option_menu():
    if selected_for_movement!=null:
        Refs.switch_pokemon_position(selected_index,selected_for_movement)
        selected_for_movement=null
        set_screen()
        return
    var slot = grid.get_children()[selected_index]
    if !slot.options.visible:
        slot.show_options()
        substate=substates.OPTIONS
    else:
        slot.hide_options()
        substate=substates.NORMAL
        
func show_stat_screen():
    stat_screen.set_mon(selected_pokemon)
    stat_screen.visible=true
    substate=substates.STATS
    selected_for_stat_window=selected_index

func move_stat_screen_up():
    for x in range(selected_for_stat_window,-1,-1):
        if Refs.pokemon_order[x]!=null:
            selected_for_stat_window=x
            stat_screen.set_mon(Refs.captured_pokemon[Refs.pokemon_order[x]])


func move_stat_screen_down():
    for x in range(selected_for_stat_window,Refs.pokemon_order.size()):
        if Refs.pokemon_order[x]!=null:
            selected_for_stat_window=x
            stat_screen.set_mon(Refs.captured_pokemon[Refs.pokemon_order[x]])

func hide_stat_screen():
    stat_screen.visible=false
    Signals.toggle_substate.emit('options')

func pokemon_go():
    if mode==modes.BATTLE:
        
        send_out_pokemon.emit(selected_pokemon)
    elif mode==modes.NORMAL:
        selected_pokemon.pokemon_go()
        close_menu()
        Signals.switch_state.emit("normal")
        Signals.new_follower.emit(selected_pokemon)

func _unhandled_input(event: InputEvent) -> void:
    if visible:
        print(substate)
        match substate:
            substates.NORMAL:
                if event.is_action_pressed('right'):
                    set_cursor(selected_index+1)
                if event.is_action_pressed('left'):
                    set_cursor(selected_index-1)
                if event.is_action_pressed('down'):
                    set_cursor(selected_index+10)
                if event.is_action_pressed('up'):
                    set_cursor(selected_index-10)
                if event.is_action_pressed('cancel'):
                    if !forced:
                        close_menu()
                if event.is_action_pressed('c'):
                    set_for_movement()
                if event.is_action_pressed('accept'):
                    toggle_option_menu()
                            
            substates.OPTIONS:
                if event.is_action_pressed('down'):
                    Signals.select_poke_option.emit(1)
                if event.is_action_pressed('up'):
                    Signals.select_poke_option.emit(-1)
                if event.is_action_pressed('cancel'):
                    toggle_option_menu()
                if event.is_action_pressed('accept'):
                    Signals.choose_poke_option.emit()
            substates.STATS:
                if event.is_action_pressed('cancel'):
                    hide_stat_screen()  
                if event.is_action_pressed('right'):
                    Signals.change_stat_mode.emit("skill")
                if event.is_action_pressed('left'):
                    Signals.change_stat_mode.emit('battle')
                if event.is_action_pressed('down'):
                    move_stat_screen_down()
                if event.is_action_pressed('up'):
                    move_stat_screen_up() 
                if event.is_action_pressed('c'):
                    stat_screen.focus_buttons()
                    substate=substates.STATOPTIONS
            substates.STATOPTIONS:
                if event.is_action_pressed('cancel'):
                    substate=substates.STATS         
        get_viewport().set_input_as_handled()
    
