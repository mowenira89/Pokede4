class_name MainMenu extends NinePatchRect
@onready var pointer: Sprite2D = $MarginContainer/Pointer
@onready var options_container: VBoxContainer = $MarginContainer/VBoxContainer
@onready var inv_screen: InvScreen = $"../../InvScreen"
@onready var pkmn_menu: PokemonMenu = $"../../PKMNMenu"
@onready var crafting_menu: CraftingMenu = $"../../CraftingMenu"

var selected_option=0
var options = []

signal open_menu_selection

func _ready():
    fill_arrays()
    
func fill_arrays():
    options = options_container.get_children()
    
func change_pointer_pos(d:int):
    selected_option+=d
    if selected_option<0:
        selected_option=options.size()-1
    if selected_option==options.size():
        selected_option=0
    pointer.position.y=(selected_option+1)*28

func open_menu():
    open_menu_selection.emit(selected_option)
    match selected_option:
        1:
            pkmn_menu.visible=true
        2: 
            inv_screen.visible=true
        3:
            crafting_menu.open_menu()
        
        
