class_name Static extends Ability

@export var apply_buff:ApplyMainStatus

func init(o):
    super(o)
    apply_buff=ApplyMainStatus.new()
    apply_buff.chance=30
    apply_buff.status=Entity.main_status.PRLZ

func on_contact(user,target,move=null):
    apply_buff.apply(user,target)
        
