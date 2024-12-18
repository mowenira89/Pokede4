class_name Fieldmon extends CharacterBody2D

var mon:Pokemon
@onready var sprite: Sprite2D = $Sprite2D
var following:bool=true
@onready var state_machine:FieldmonStateMachine=$StateMachine
@onready var move_buffs: MoveBuffManager = $MoveBuffs
@onready var production: Production = $Production
@onready var farm: FarmingState = $StateMachine/Farm
@onready var mining: MiningPokeState = $StateMachine/Mining

@onready var hp: ProgressBar = $VBoxContainer/HP
@onready var energy: ProgressBar = $VBoxContainer/Energy
@onready var happiness: ProgressBar = $VBoxContainer/Happiness
@onready var work_timer: Timer = $WorkTimer

var transporting_item:Item
var available_fire=0
var available_water=0
var available_electric=0
var available_ice=0
var available_psi=0

var total_fire=0
var total_water=0
var total_electric=0
var total_ice=0
var total_psi=0

var number_of_mining_moves=0
var mining_bonus=0

var depester_bonus=0

var assigned_station:Station

func _ready():
    Signals.new_follower.connect(new_follower)
    work_timer.timeout.connect(ten_minutes)
    
func take_assignment(s:Station):
    if assigned_station!=null:
        assigned_station.remove_pokemon(self)
    assigned_station=s
    assigned_station.assign_pokemon(self) 
    Signals.send_notice.emit(mon.nickname+" assigned to new station.")   
    if s is MiningStation:
        state_machine.change_state(mining)
        

func new_follower(p:Pokemon):
    if p != mon:
        following=false    

func set_mon(m:Pokemon):
    mon=m
    sprite.texture=mon.image
    production.mon=mon
    hp.max_value=mon.get_stat(Entity.stats.HP)
    energy.max_value=mon.get_stat(Entity.stats.Energy)
    happiness.max_value=255
    set_moves()
    

func _physics_process(delta: float) -> void:
    if following:
        if global_position.distance_to(Refs.player.global_position)>100:
            velocity = global_position.direction_to(Refs.player.global_position) * (100+mon.get_stat(Entity.stats.Speed))
            move_and_slide()

func _process(delta: float) -> void:
    hp.value = mon.hp
    energy.value=mon.energy
    happiness.value=mon.happiness

func apply_passive_buff(id:String):
    move_buffs.apply(id)

func accept_assignment():
    pass

func set_moves():
    for x in mon.current_moves:
        if x is Move:
            total_fire+=x.fire
            total_water+=x.water
            total_electric+=x.electric
            total_ice+=x.ice
            total_psi+=x.psi
            if x.depester: depester_bonus+=1
            if x.mining_value>0:
                mining_bonus+=x.mining_value
                number_of_mining_moves+=1
    set_mining_bonus()
    reset_available_elements()
    
func set_mining_bonus():
    if number_of_mining_moves>0:
        mining_bonus=(mining_bonus/number_of_mining_moves)+number_of_mining_moves
    #insert logic for buffs
    
func reset_available_elements():
    available_fire=total_fire
    available_water=total_water
    available_electric=total_electric
    available_ice=total_ice
    available_psi=total_psi

func ten_minutes():
    reset_available_elements()
