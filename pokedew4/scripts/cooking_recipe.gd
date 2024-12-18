class_name CookingRecipe extends Resource

enum tools {Knife,ParingKnife,Whisk,Mortar,FryingPan}
enum machines {ElectricOven,DeepFryer,Smoker}

@export var craft_name:String
@export var item:ItemData
@export var quantity_crafted:int=1
@export var ingredients = {}
@export var cooking_level:int
@export var needed_tools:Array[tools]
@export var needed_machine:Array[machines]
@export var combination_recipe:bool#combination recipes are sped up by a combiner
@export var needs_fire:bool
@export var exp:int
