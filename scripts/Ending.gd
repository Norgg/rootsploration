extends Node2D

var timer = 3

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    timer -= delta
    if timer < 0:
        $RestartText.show()
        if Input.is_action_just_pressed('start'):
            get_tree().change_scene_to_file('res://start.tscn')

