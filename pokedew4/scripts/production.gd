class_name Production extends Node

@onready var pokemon: Fieldmon = $".."
@onready var mon = pokemon.mon

var current_production:Produce
var production_points:int

func _ready():
    Signals.ten_minutes_passed.connect(_on_ten_minutes)

func _on_ten_minutes():
    if mon.holding_produce!=null: return
    if current_production==null:
        if mon.produce.is_empty(): pass
        else:
            var total=0
            for x in mon.produce:
                total+=x.weight
            while total>0:
                var p = mon.produce.pick_random()
                total-=p.weight
                if total<=0:
                    current_production=p
                    production_points=p.production_time
    elif production_points>0:
        production_points-=1
        if production_points==0:
            mon.holding_produce=current_production.item
            mon.holding_produce.quantity=randi_range(current_production.min,current_production.max)
