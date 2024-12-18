class_name CraftableEntry extends TextureRect
@onready var cursor: TextureRect = $Cursor

var recipe:CraftableData=null

func set_data(d:CraftableData):
    recipe=d
    texture=d.item.data.image

func select():
    cursor.visible=true
    
func unselect():
    cursor.visible=false
