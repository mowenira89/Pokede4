class_name Stench extends Ability

var apply_buff:ApplyBuff

func init(o):
    super(o)
    apply_buff=ApplyBuff.new()
    apply_buff.buff=FlinchBuff.new()
    apply_buff.chance=10

func on_contact(user:Pokemon,target:Pokemon,move=null):
    apply_buff.apply(user,target,move)
