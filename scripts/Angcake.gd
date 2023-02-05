extends RigidBody2D
class_name Angcake

var bounce = 50000
const bounce_time = 2
var bounce_timer = bounce_time
var sound: AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
    sound = $Sound

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    bounce_timer -= delta
    if bounce_timer < 0:
        apply_central_force(Vector2(0, -bounce))
        bounce_timer = bounce_time
