class_name MultiTurnHit2 extends Buff

@export var min:int
@export var max:int
var turns:int
@export var move:Move
@export var confusion:bool
@export var recharge:bool

func init(o):
    super(o)
    turns = randi_range(min,max+1)

func next_turn_attack():
    return move
    
func on_turn_end():
    turns-=1
    if turns<=0:
        if confusion:
            var b = Confusion.new()
            owner.add_buff(b)
            Signals.add_message.emit(owner.nickname + "became confused!")
        owner.remove_buff(self)
        
