class_name FieldmonStateMachine extends Node

var states=[]
var prev_state:PokeState
var current_state:PokeState
var mon:Fieldmon
@onready var task_label: Label = $"../TaskLabel"
@onready var progress_bar: ProgressBar = $"../TaskLabel/ProgressBar"
@onready var work_timer: Timer = $"../WorkTimer"

func _ready():
    process_mode=Node.PROCESS_MODE_DISABLED
    mon=get_parent()
    initialize()
    
func initialize():	
    for c in get_children():
        if c is PokeState: states.append(c)
    if states.size()>0:
        for x in states:
            x.state_machine=self
            x.init()
        change_state(states[0])
        process_mode = Node.PROCESS_MODE_INHERIT

func _process(delta):
    if !work_timer.is_stopped():
        progress_bar.value=work_timer.time_left
    change_state(current_state.process(delta))
    
func _physics_process(delta):
    change_state(current_state.physics(delta))
    
func _unhandled_input(event):
    change_state(current_state.handle_input(event))
    
    
func change_state(new_state:PokeState):
    if new_state==null or new_state==current_state:return
    if current_state: current_state.exit()
    prev_state=current_state
    current_state=new_state
    current_state.enter()

func set_task_label(s:String):
    task_label.text=s
    task_label.visible=true
    progress_bar.max_value=mon.mon.get_stat(Entity.stats.WorkSpeed)
    
