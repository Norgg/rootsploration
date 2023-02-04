extends RigidBody2D

const move_acc := 2000
const max_speed := 300
const jump_impulse := 700
var grounded := 0.0
const air_control := 0.5

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


func check_grounded():
    var state := get_world_2d().direct_space_state
    var raycast_params := PhysicsRayQueryParameters2D.new()
    for x in range(-20, 20, 5):
        raycast_params.from = position + Vector2(x, 30)
        raycast_params.to = raycast_params.from + Vector2(0, 15)
        raycast_params.exclude = [get_rid()]
        var result := state.intersect_ray(raycast_params)
        if result:
            grounded = 0.1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

    check_grounded()
    grounded = max(grounded - delta, 0)

    var move_dir = Vector2()
    if Input.is_action_pressed('right'):
        move_dir.x += 1
    elif Input.is_action_pressed('left'):
        move_dir.x -= 1

    if move_dir.length() < 0.001 and grounded > 0:
        physics_material_override.friction = 1
        linear_damp = 1
    else:
        linear_damp = 0
        physics_material_override.friction = 0

    var impulse = move_dir * move_acc * delta * mass

    if linear_velocity.length() > max_speed:
        if sign(impulse.x) == sign(linear_velocity.x):
            impulse.x = 0
        if sign(impulse.y) == sign(linear_velocity.y):
            impulse.y = 0

    if !grounded:
        impulse *= air_control

    apply_central_impulse(impulse)

    if Input.is_action_just_pressed('jump') and grounded > 0:
        apply_central_impulse(Vector2(0, -jump_impulse * mass))        

    