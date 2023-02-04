extends Sprite2D

@export var teleport_to := Vector2()


func _ready():
    $DoorArea.connect('body_entered', collided)


func collided(body: Node):
    if body.name.begins_with('Player'):
        var player := body as Player
        player.teleport_to = teleport_to


func _process(_delta):
    pass
