class_name MenuManager extends CanvasLayer

@onready var main_menu: MainMenu = $VBoxContainer/Menu
@onready var pkmn_menu: PokemonMenu = $PKMNMenu
@onready var inv_screen: InvScreen = $InvScreen

@onready var menu: MenuState = $"../StateMachine/Menu"

    
func open_menu(i:int):
    match i:
        0: print('pokedex')
        1: 
            pkmn_menu.visible=true
            pkmn_menu.connections()
            
        2:
            inv_screen.visible=true
            inv_screen.connections()
        
