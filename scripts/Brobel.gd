extends RigidBody2D
class_name Brobel

var bounce = 20000
const bounce_time = 1
var bounce_timer = bounce_time

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    bounce_timer -= delta
    if bounce_timer < 0:
        apply_central_force(Vector2(0, -bounce))
        bounce_timer = bounce_time
