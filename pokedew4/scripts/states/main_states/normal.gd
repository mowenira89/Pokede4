class_name NormalState extends State

@onready var main_menu: State = $"../Menu"
@onready var hotbar: Hotbar = $"../../CanvasLayer/Hotbar"
@onready var message: Message = $"../../CanvasLayer/Message"
@onready var inv_screen: InvScreen = $"../../CanvasLayer/InvScreen"
@onready var command_window: Panel = $"../../CanvasLayer/CommandWindow"

var selected_fieldmon:Fieldmon

func init():
    pass
    
func enter():
    if Refs.player!=null:
        Refs.player.can_move=true
    message.activate()
    
func exit():
    Refs.player.can_move=false
    message.deactivate()
    
func process(delta)->State:
    return null
    
func physics(delta)->State:
    return null

func handle_input(event)->State:
    if message.visible:
        if event.is_action_pressed('accept') or event.is_action_pressed('cancel'):
            Signals.display_messages.emit()
    else:
        if event.is_action_pressed("cancel"):
            command_window.close()
            selected_fieldmon=null
            return main_menu
        if event.is_action_pressed("MWU"):
            Signals.change_hotbar.emit(-1)
        if event.is_action_pressed("MWD"):
            Signals.change_hotbar.emit(1)
        if event.is_action_pressed('q'):
            inv_screen.visible=true
            main_menu.on_submenu=true
            return main_menu
        if event.is_action_pressed('accept') or event.is_action_pressed('click'):
            var item=hotbar.get_children()[hotbar.selected_index].item
            var coord = Refs.player.get_cursor_position()
            
            if coord in Refs.current_level.obstructions:
                if Refs.current_level.obstructions[coord].has_method('interact'):                
                    Refs.current_level.obstructions[coord].interact()
            elif item!=null:        
                var player_position = Refs.player.get_player_pos()
                var cursor_position = Refs.player.get_cursor_position()
                if Refs.player.targetted_mon!=null:
                    item.use(Refs.player,Refs.player.targetted_mon)
                elif player_position==cursor_position:
                    item.use(Refs.player,Refs.player)
                else:
                    item.use(Refs.player,Refs.player.get_cursor_position())
        if event.is_action_pressed('c'):
            if command_window.visible:
                    var coord = Refs.player.get_cursor_position()
                    var co = Refs.current_level.obstructions
                    if coord in co and co[coord] is Station:
                            selected_fieldmon.take_assignment(co[coord])
            if Refs.player.targetted_mon!=null:
                selected_fieldmon=Refs.player.targetted_mon
                command_window.set_mon(selected_fieldmon)
                command_window.visible=true      
        if event.is_action_pressed('f'):
            if Refs.player.targetted_mon!=null:
                var fm = Refs.player.targetted_mon
                Signals.new_follower.emit(fm.mon)
                fm.following=!fm.following
                
                              
    return null
