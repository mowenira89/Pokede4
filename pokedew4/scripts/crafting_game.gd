class_name CraftingGame extends Panel

@onready var progress_bar: ProgressBar = $VBoxContainer/ProgressBar
@onready var label: Label = $VBoxContainer/Label
@onready var timer: Timer = $Timer

var potential_letters = []
var crafting:CraftableData

var current_letter

var craft_total:int=0
var current_craft_points:int=0
var game_on:bool=false

var craft_point_per:int=0

func start(c:CraftableData):
    crafting=c
    craft_point_per = Refs.player.data.get_stat(Entity.stats.Craft)
    print(craft_point_per)
    craft_point_per = ceil(craft_point_per/10)+1
    craft_total = c.craft_points
    var num_of_letters = c.craft_level
    match num_of_letters:
        1: 
            potential_letters = ['a','s','d']
        2:
            potential_letters = ['a','s','d','w']
        3:
            potential_letters = ['a','s','d','w','q']
        4:
            potential_letters = ['a','s','d','w','q','e']
    next_round()
    game_on=true
    visible=true
        
            
func next_round():
    current_letter = potential_letters.pick_random()
    label.text=current_letter.to_upper()
    timer.start(randf_range(.5,2))

func _on_timer_timeout() -> void:
    next_round()
    
func add_points(amount:int):
    if game_on:
        current_craft_points+=craft_point_per
        if current_craft_points>=craft_total:
            give_output()

func give_output():
    if InvManager.add(crafting.item):
        close()
        
func close():
    game_on=false
    visible=false
    
    
func _unhandled_input(event: InputEvent) -> void:
    
    if visible and game_on:
        if event.is_action_pressed(current_letter):
            print(craft_point_per)
            add_points(craft_point_per)
            next_round()
        elif event.is_action_pressed('cancel'):
            close()
