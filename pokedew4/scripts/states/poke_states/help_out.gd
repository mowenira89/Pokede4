class_name HelpOutPokeState extends PokeState

@onready var pokemon: Fieldmon = $"../.."
@onready var work_area: Area2D = $"../../WorkArea"
@onready var work_timer: Timer = $"../../WorkTimer"
@onready var work_area_collider: CollisionShape2D = $"../../WorkArea/CollisionShape2D"

var nearby_machines = []
var nearby_fieldmon = []
var nearby_stockpiles=[]

func enter():
    nearby_machines=[]
    work_area_collider.disabled=true
    work_area.body_entered.connect(_body_entered)
    work_area.body_exited.connect(_body_exited)
    work_area_collider.disabled=false
    work_timer.timeout.connect(work_timeout)
    
func exit():
    work_area.body_entered.disconnect(_body_entered)
    work_area.body_exited.disconnect(_body_exited)
    work_timer.timeout.disconnect(work_timeout)

func _body_entered(body):
    if body is Machine:
        if body not in nearby_machines:
            nearby_machines.append(body)
    elif body is Fieldmon:
        if body not in nearby_fieldmon:
            nearby_fieldmon.append(body)
    elif body is Stockpile:
        if body not in nearby_stockpiles:
            nearby_stockpiles.append(body)
func _body_exited(body):
    if body in nearby_machines:
        nearby_machines.erase(body)
    elif body in nearby_fieldmon:
        nearby_fieldmon.erase(body)
        
func work_timeout():
    for x in nearby_machines:
        if x.has_method("fuel_by_pokefire"):
            if pokemon.available_fire>0:
                if x.fuel_by_pokefire():
                    pokemon.available_fire-=1
                    pokemon.change_energy(-1)
                    
        if x.has_method('turn'):
            x.turn(pokemon)
    
    for x in nearby_stockpiles:
        pass        
