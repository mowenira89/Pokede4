class_name CraftingMenu extends Control

@onready var icon: TextureRect = $ColorRect/MarginContainer/VBoxContainer/TextureRect
@onready var name_label: Label = $ColorRect/MarginContainer/VBoxContainer/NameLabel
@onready var level_label: Label = $ColorRect/MarginContainer/VBoxContainer/HBoxContainer/LevelLabel
@onready var exp_label: Label = $ColorRect/MarginContainer/VBoxContainer/HBoxContainer/ExpLabel
@onready var ingredient_display: VBoxContainer = $ColorRect/MarginContainer/VBoxContainer/IngredientDisplay
@onready var craft_label: Label = $ColorRect/MarginContainer/VBoxContainer/Label
@onready var grid: GridContainer = $ColorRect/MarginContainer/ScrollContainer/VBoxContainer/Grid


const entry = preload("res://scenes/ui/craftable_entry.tscn")

enum modes{BASIC,WORKSHOP,FORGE,TAILOR,ADVANCED}
@export var mode:modes

var selected_index:int=0

var currently_crafting:bool=false

func open_menu():
    visible=true
    selected_index=0
    set_grid()
    set_cursor()
    
func close_menu():
    visible=false
    Signals.release_menu.emit()

func set_grid():
    var categories = []
    match mode:
        modes.BASIC: categories = [modes.BASIC]
        modes.WORKSHOP: categories = [modes.BASIC,modes.WORKSHOP]
        modes.FORGE: categories = [modes.BASIC,modes.WORKSHOP,modes.FORGE]
        modes.TAILOR: categories = [modes.BASIC,modes.WORKSHOP,modes.TAILOR]
        modes.ADVANCED: categories = [modes.BASIC,modes.WORKSHOP,modes.TAILOR,modes.ADVANCED]

    for x in Refs.known_crafts:
        if x.cat in categories:
            set_entry(x)
                
                
func set_entry(x:CraftableData):
    var e = entry.instantiate()
    grid.add_child(e)
    e.set_data(x)
    
func set_cursor():
    var children = grid.get_children()
    for x in children:
        x.unselect()
    children[selected_index].select()
    set_side_panel()
        
func set_side_panel():
    var craftable:CraftableData = grid.get_children()[selected_index].recipe
    name_label.text = craftable.item.data.item_name
    level_label.text="lvl "+str(craftable.craft_level)
    exp_label.text = str(craftable.exp)+" exp"        
            
func move_cursor(d:int):
    selected_index=clamp(selected_index+d,0,grid.get_children().size()-1)
    set_cursor()
    
func _unhandled_input(event: InputEvent) -> void:
    if visible:
        if event.is_action_pressed("right"):
            move_cursor(1)
        if event.is_action_pressed("left"):
            move_cursor(-1)    
        if event.is_action_pressed("up"):
            move_cursor(-6)
        if event.is_action_pressed("down"):
            move_cursor(6)
        if event.is_action_pressed("c"):
            pass
        if event.is_action_pressed('cancel'):
            close_menu()        
