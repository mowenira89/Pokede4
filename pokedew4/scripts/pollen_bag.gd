class_name PollenBag extends ItemData

enum pollen {SLP,PSN,PRLZ}

var type:pollen
var contents:int
@export var max_amount:int

func select_content(s:String):
    match s:
        'slp':
            type=pollen.SLP
        'prlz':
            type=pollen.PRLZ
        'psn':
            type=pollen.PSN

func change_content_amount(d:int):
    contents = clamp(contents+d,0,max_amount)
    
