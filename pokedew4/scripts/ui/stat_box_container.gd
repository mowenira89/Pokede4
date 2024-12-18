class_name StatBoxContainer extends HBoxContainer
@onready var stat: Label = $Stat
@onready var stat_amount: Label = $StatAmount
@onready var ev: Label = $EV
@onready var iv: Label = $IV

@export var _stat:Pokemon.stats
@export var title:String


func _ready():
    Signals.set_stats.connect(set_box)

func set_box(p:Pokemon):
    iv.text = str(p.ivs[_stat])
    ev.text = str(p.evs[_stat])
    stat_amount.text = str(p.get_stat(_stat))
    stat.text = title+": "
