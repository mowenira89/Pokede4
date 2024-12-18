class_name TallGrass extends Node2D

signal get_wild_pokemon

func _on_area_2d_body_entered(body: Node2D) -> void:
    if body.is_in_group("Player"):
        if Refs.check_remaining()>0:
            var r = randi()%101
            if r<30:  
                get_wild_pokemon.emit()
            
