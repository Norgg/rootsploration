extends Node2D

var timer = 5

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    timer -= delta
    if timer < 0:
        State.teleport_to = Vector2(1321, 4250)
        get_tree().change_scene_to_file("res://game.tscn")

    $Holly.position.y += delta * 200
