class_name SkillBoxContainer extends StatBoxContainer

@onready var progress_bar: ProgressBar = $ProgressBar
@onready var level: Label = $level

func _ready():
    Signals.set_stats.connect(set_box)

func set_box(p:Pokemon):
    iv.text = str(p.ivs[_stat])
    ev.text = str(p.evs[_stat])
    stat_amount.text = str(p.get_stat(_stat))
    stat.text = title+": "
    var stat_name = p.skill_name_converter(_stat)
    progress_bar.max_value = p.level_to_next[stat_name]
    progress_bar.value = p.exp[stat_name]
    level.text = str(p.level[stat_name])
