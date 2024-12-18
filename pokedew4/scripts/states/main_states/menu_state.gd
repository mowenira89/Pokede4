class_name MenuState extends State
@onready var normal: NormalState = $"../Normal"

@onready var menu: MainMenu = $"../../CanvasLayer/VBoxContainer/Menu"

var on_submenu:bool=false

func enter():
    menu.visible=true
    Signals.release_menu.connect(func():on_submenu=false)


func exit():
    menu.visible=false
    Signals.release_menu.disconnect(func():on_submenu=true)


func handle_input(event):
    if !on_submenu:
        if event.is_action_pressed('cancel'):
            Signals.switch_state.emit('normal')
            return normal
        if event.is_action_pressed('up'):
            menu.change_pointer_pos(-1)
        if event.is_action_pressed('down'):
            menu.change_pointer_pos(1)
        if event.is_action_pressed('accept'):
            menu.open_menu()
            on_submenu=true
