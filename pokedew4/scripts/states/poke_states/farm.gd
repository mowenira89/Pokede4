class_name FarmingState extends PokeState
@onready var pokemon:Fieldmon = $"../.."
@onready var work_area: Area2D = $"../../WorkArea"
@onready var work_timer: Timer = $"../../WorkTimer"
@onready var task_label: Label = $"../../TaskLabel"
@onready var collision_shape_2d: CollisionShape2D = $"../../WorkArea/CollisionShape2D"

var station:Station

var nearby_crops:Array[Crop]=[]

func enter():
    collision_shape_2d.disabled=true
    work_area.body_entered.connect(on_body_entered)
    work_area.body_entered.connect(on_body_exited)
    collision_shape_2d.disabled=false
    work_timer.timeout.connect(on_work_timer_timeout)
    state_machine.set_task_label("Farming")
    start_work_timer()
    
    
func exit():
    work_area.body_entered.disconnect(on_body_entered)
    work_area.body_entered.disconnect(on_body_exited)
    work_timer.timeout.disconnect(on_work_timer_timeout)
    work_timer.stop()
    
func on_body_entered(body):
    if body.is_in_group("Crop") and body not in nearby_crops:
        nearby_crops.append(body)
        
func on_body_exited(body):
    if body in nearby_crops:
        nearby_crops.erase(body)

func on_work_timer_timeout():
    work_timer.stop()
    for x in nearby_crops:
        if x.pest!=null:
            var pest_speed = x.pest.get_stat(Entity.stats.Speed)
            var pest_level = x.pest.get_level()
            var mon_speed = pokemon.mon.get_stat(Entity.stats.Speed)
            var mon_level = pokemon.mon.get_level()
            var victory_rate = 30
            #add depested moves later
            for m in pokemon.mon.current_moves:
                if m.depester: victory_rate+=10
            if Pokemon.types.Flying in pokemon.mon.type: victory_rate+=10
            if pest_level<mon_level:victory_rate+=20
            if pest_speed<mon_speed:victory_rate+=10
            var random = randi()%pest_level*10
            if random<victory_rate:
                x.remove_pest()
                pokemon.mon.get_exp("battle",pest_level)
                pokemon.mon.get_exp('farm',1)
                x.change_happiness(5)
            else:
                pokemon.mon.take_damage(pest_level)
                start_work_timer()
                return
        else: await get_tree().create_timer(.5).timeout
            
        if pokemon.available_water>1:
            if x.tile not in Refs.current_level.watered_plots:
                Refs.current_level.add_watered_plot(x.tile)                    
        
        if x.stage==4:
            x.pick_berries(pokemon.assigned_station.chest.chest_inv)
    start_work_timer()
       
func start_work_timer():
    work_timer.start(pokemon.mon.get_stat(Entity.stats.WorkSpeed))            
    
