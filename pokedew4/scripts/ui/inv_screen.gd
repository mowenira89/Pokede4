class_name InvScreen extends Control

@onready var grid: GridContainer = $ColorRect/MarginContainer/HBoxContainer/MarginContainer2/MarginContainer/ColorRect/MarginContainer/GridContainer
@onready var slot_ref = preload("res://scenes/ui/inv_slot.tscn")
@onready var poke_panel_holder: VBoxContainer = $ColorRect/MarginContainer/HBoxContainer/MarginContainer/ScrollContainer/PokePanelHolder

@onready var texture_rect: TextureRect = $ColorRect/MarginContainer/HBoxContainer/MarginContainer/ItemData/TextureRect
@onready var label: Label = $ColorRect/MarginContainer/HBoxContainer/MarginContainer/ItemData/Label
@onready var desc: Label = $ColorRect/MarginContainer/HBoxContainer/MarginContainer/ItemData/Desc


@onready var item_data: VBoxContainer = $ColorRect/MarginContainer/HBoxContainer/MarginContainer/ItemData
@onready var side_panel_controller: SidePanelController = $ColorRect/MarginContainer/HBoxContainer/MarginContainer

signal unmenu

var panel = preload("res://scenes/ui/poke_panel.tscn")
@onready var inv = InvManager.inventory.items
var selected_index=0

var first_slot:int=0
var last_slot:int=79
var selected_for_movement

enum modes {NORMAL,BATTLE}
@export var mode:modes

enum substates {NORMAL,OPTIONS,POKESELECTION}
var substate:substates=substates.NORMAL
@export var message:Message

var can_move:bool=true



func _ready():
    set_grid()
    set_cursor(0)
    Signals.update_inventory.connect(set_grid)

func set_grid():
    for x in grid.get_children():
        x.queue_free()
    for x in inv:
        var slot = slot_ref.instantiate()
        grid.add_child(slot)
        if x!=null:
            slot.set_slot(inv, inv.find(x))

func set_cursor(i:int):
    if can_move:
        selected_index=clamp(i,first_slot,last_slot)
        var inv_slots=grid.get_children()
        for x in inv_slots:
            if x.index==selected_for_movement:
                pass
            else:
                x.unselect()
        grid.get_child(selected_index).be_hovered_over()
        set_item_data()

func set_for_movement():
    if selected_for_movement==null:
        selected_for_movement=selected_index
        grid.get_child(selected_index).select()
    else:
        InvManager.switch_items(InvManager.inventory,selected_index,InvManager.inventory,selected_for_movement)
        selected_for_movement=null
        set_grid()

func close_menu():
    set_grid()
    visible=false
    Signals.toggle_substate.disconnect(toggle_substate)
    Signals.release_menu.emit()
    unmenu.emit()
    
func show_options():
    grid.get_child(selected_index).show_options()
    can_move=false
    
func close_options():
    grid.get_child(selected_index).hide_options()
    can_move=true

func move_options(d:int):
    grid.get_child(selected_index).change_cursor_position(d)

func select_option():
    grid.get_child(selected_index).select_option()


#Logic for poke panels
func set_poke_screen():
    for x in Refs.pokemon_order:
        if x!=null:
            var pp = panel.instantiate()
            poke_panel_holder.add_child(pp)
            pp.make_panel(Refs.captured_pokemon[x])

func open_panels():
    item_data.visible=false    
    side_panel_controller.set_container()
    
func close_panels():
    side_panel_controller.close_panels()

func move_panel_selection(d:int):
    side_panel_controller.move_selected(d)
    
func select_mon():
    if side_panel_controller.selected_index!=null:
        var mon = side_panel_controller.get_mon()
        var slot = grid.get_child(selected_index)
        var item = slot.item
        if item!=null:
            var mode = slot.poke_panel_mode
            if mode==0:
                item.use(Refs.player,mon)
            if mode==1:
                pass

# Logic for item side panel
func set_item_data():
    var item = inv[selected_index]
    if item!=null:
        texture_rect.texture=item.data.image
        label.text = item.data.item_name
        desc.text = item.data.flavor_text

func hide_item_data():
    texture_rect.texture=null
    label.text=""
    desc.text=""

func connections():
    Signals.toggle_substate.connect(toggle_substate)
    visible=true

func toggle_substate(s:String):
    match s:
        'normal':substate=substates.NORMAL
        'options':substate=substates.OPTIONS
        'pokeselection':substate=substates.POKESELECTION


func _unhandled_input(event: InputEvent) -> void:
    if visible:
        if message.visible:
            if event.is_action_pressed('accept'):
                Signals.display_messages.emit()
            return
        if substate==substates.NORMAL:
            if event.is_action_pressed('right'):
                set_cursor(selected_index+1)
            if event.is_action_pressed('left'):
                set_cursor(selected_index-1)
            if event.is_action_pressed('down'):
                set_cursor(selected_index+10)
            if event.is_action_pressed('up'):
                set_cursor(selected_index-10)
            if event.is_action_pressed('cancel'):
                close_menu()
            if event.is_action_pressed('c'):
                set_for_movement() 
            if event.is_action_pressed('accept'):
                show_options()
                substate=substates.OPTIONS
        elif substate==substates.OPTIONS:
            if event.is_action_pressed("cancel"):
                close_options()
                substate=substates.NORMAL
            if event.is_action_pressed('up'):
                move_options(-1)
            if event.is_action_pressed('down'):
                move_options(1)
            if event.is_action_pressed('accept'):
                select_option()
        elif substate==substates.POKESELECTION:
            if event.is_action_pressed('down'):
                move_panel_selection(1)
            if event.is_action_pressed('up'):
                move_panel_selection(-1)
            if event.is_action_pressed('cancel'):
                close_panels()
                substate=substates.OPTIONS
            if event.is_action_pressed('accept'):
                select_mon()
        get_viewport().set_input_as_handled()
