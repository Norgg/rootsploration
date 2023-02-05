extends Sprite2D

@export var teleport_to := Vector2()
@export var end := false

func _ready():
    $DoorArea.connect('body_entered', collided)


func collided(body: Node):
    if body.name.begins_with('Player'):
        if end:
            get_tree().change_scene_to_file("res://ending.tscn")
        else:
            var player := body as Player
            player.teleport_to = teleport_to
            player.last_checkpoint = teleport_to


func _process(_delta):
    pass
