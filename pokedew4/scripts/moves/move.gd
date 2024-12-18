class_name Move extends Resource 

enum types {PHYSICAL, SPECIAL, STATUS}
enum targets {Opponent,Self,AllOpponents,All}
enum perform_types {Fight,Magic,Music,Dance,Bad,Other,Cute,Spectacle}

@export var _name:String
@export var type:Entity.types
@export var level_learned:int
@export var power:int
@export var acc:int
@export var move_type:types
@export var energy:int
@export var targ:targets
@export var perform_type:perform_types
@export var perform_value:int
@export var mining_value:int
@export var priority:int=1
@export var effect:Array[Effect]
@export var passive_effect:Array[Effect]
@export var produce:Produce
@export var contact:bool
@export var sound:bool
@export var unmissable:bool
@export var description:String
@export var description_passive:String
@export var jaw_move:bool
@export var ice:int
@export var fire:int
@export var water:int
@export var electric:int
@export var psi:int
@export var depester:bool


func use(user:Entity,target:Entity):
    for x in effect:
        x.apply(user,target, self)
