class_name MulchMachine extends Machine

@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var output_sprite: Sprite2D = $Sprite2D2
@onready var progress_bar: ProgressBar = $ProgressBar

var totals = {
    ItemData.mulch_types.Growth:0,
    ItemData.mulch_types.Damp:0,
    ItemData.mulch_types.Stable:0,
    ItemData.mulch_types.Gooey:0,
    ItemData.mulch_types.Amaze:0,
    ItemData.mulch_types.Boost:0,
    ItemData.mulch_types.Rich:0,
    ItemData.mulch_types.Surprise:0
}
var total_input:int=0

var can_turn=false
var needed_turns=10
var turns=0



func interact():
    super()
    if completed_object!=null:
        take_object()    
    elif total_input<5:
        var item = InvManager.equipped()
        if item.data.mulchable:
            total_input+=1
            totals[item.data.mulch_type]+=1
            InvManager.remove(item,1)
            if total_input==5:
                can_turn=true
                progress_bar.visible=true
    elif total_input==5 and can_turn:
        turn(Refs.player.data)
                        
func turn(turner:Entity):
    if !can_turn: return false
    turns+=1
    update_bar()
    if turns>=needed_turns:
        get_mulch()
        can_turn==false
        progress_bar.visible=false
    turner.change_energy(-1)
    turner.get_exp("craft",1)

func update_bar():
    progress_bar.max_value=needed_turns
    progress_bar.value=turns
    
func get_mulch():
    var mulch = get_mulch_type()
    var item = Item.new()
    item.data=mulch
    item.quantity=3
    set_output(item)
    progress_bar.visible=false
    totals = {
    ItemData.mulch_types.Growth:0,
    ItemData.mulch_types.Damp:0,
    ItemData.mulch_types.Stable:0,
    ItemData.mulch_types.Gooey:0,
    ItemData.mulch_types.Amaze:0,
    ItemData.mulch_types.Boost:0,
    ItemData.mulch_types.Rich:0,
    ItemData.mulch_types.Surprise:0
}

func get_mulch_type():
    var kind = ""
    var all_totals = []
    for x in totals:
        all_totals.append(x)
    
    if totals[ItemData.mulch_types.Amaze]>=3:
        kind="amaze"  
    elif totals[ItemData.mulch_types.Surprise]>=3:
        kind='surprise'
    elif totals[ItemData.mulch_types.Gooey]>=3:
        kind='gooey'
    elif totals[ItemData.mulch_types.Rich]>=3:
        kind='rich'
    elif totals[ItemData.mulch_types.Damp]>=3:
        kind='damp'
    elif totals[ItemData.mulch_types.Growth]>=3:
        kind='growth'
    elif totals[ItemData.mulch_types.Boost]>=3:
        kind='boost'
    else: 
        kind='stable'
    if all_totals.max()==1:
        kind=='amaze'
    var data = load("res://resources/items/mulch_"+kind+".tres")
    return data    
