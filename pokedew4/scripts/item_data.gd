class_name ItemData extends Resource

enum types {Medicine,Food,Berry,Sapling,Tool,Mat,Forage,Machine,Pokeball,Mulch}
enum mulch_types {Growth,Damp,Stable,Gooey,Amaze,Boost,Rich,Surprise}

@export var image:Texture2D
@export var item_name:String
@export var item_type:types
@export var rarity:int
@export_multiline var flavor_text:String
@export var has_use_effect:bool
@export var untossable:bool
@export var unthrowable:bool
@export var ungivable:bool
@export var use_from_bag:bool
@export var unstackable:bool
@export var use_effect:Array[Effect]
@export var throw_effect:Array[Effect]
@export var equip_effect:Array[Effect]
@export var base_value:int
@export var sales_restriction:int
@export var consumable:bool
@export var stone:bool
@export var wood:bool
@export var mulchable:bool
@export var mulch_type:mulch_types
@export var fuel:bool
@export var fuel_amount:int
@export var has_modulate:bool
@export var _modulate:Color

func set_sprite(s):
    s.texture=image
    if has_modulate:
        s.self_modulate=_modulate
    
