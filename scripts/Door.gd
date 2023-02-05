extends Sprite2D

@export var teleport_to := Vector2()
@export var end := false
@export var cutscene := false

func _ready():
    $DoorArea.connect('body_entered', collided)


func collided(body: Node):
    if body.name.begins_with('Player'):
        if end:
            get_tree().change_scene_to_file("res://ending.tscn")
        elif cutscene:
            get_tree().change_scene_to_file("res://cutscene.tscn")
        else:
            State.teleport_to = teleport_to
            State.last_checkpoint = teleport_to


func _process(_delta):
    pass
