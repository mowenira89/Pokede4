class_name MiningPokeState extends PokeState

var mine:MiningStation
@onready var work_timer: Timer = $"../../WorkTimer"

func enter():
    mine = get_parent().get_parent().assigned_station
    work_timer.timeout.connect(work_timeout)
    work_timer.start(state_machine.mon.mon.get_stat(Entity.stats.WorkSpeed))
    state_machine.set_task_label("Mining")
    
func exit():
    work_timer.timeout.disconnect(work_timeout)

func work_timeout():
    mine.mine.mining.on_pressed(state_machine.mon.mon,mine.chest.chest_inv,randi_range(1,5))
