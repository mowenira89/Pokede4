class_name Ability extends Resource

var owner:Pokemon
@export var ability_name:String
@export_multiline var desc:String
@export_multiline var passive_desc:String
 
func init(o:Pokemon):
    owner=o
    
func on_contact(user:Pokemon,target:Pokemon,move=null):
    pass

func on_switch_in():
    pass
    
func check_immunity(status:Entity.main_status)->bool:
    return true
