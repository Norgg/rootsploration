extends RigidBody2D
class_name Player

const move_acc := 3000
const max_speed := 400
const jump_impulse := 800
var grounded := 0.0
const control_smoothing := 0.5
const air_control := 0.02

var protection := 0
var star: Sprite2D

var start_pos: Vector2
var last_checkpoint: Vector2
var teleport_to: Vector2

var sprite: AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
    start_pos = position
    last_checkpoint = start_pos
    connect('body_entered', collided)
    sprite = $AnimatedSprite2D
    star = $Star


func collided(body: Node):
    print('Bumped with: ', body.name)
    if body.name.begins_with('Shroomies'):
        if protection > 0:
            protection -= 1
            if protection == 0:
                star.hide()
        else:
            teleport_to = last_checkpoint
    elif body.name.begins_with('GoldShroomies'):
        protection = 1
        print('Showing star')
        star.show()
    elif body.name.begins_with('Door'):
        print('door!')


func _integrate_forces(state: PhysicsDirectBodyState2D):
    if Input.is_action_just_pressed('respawn'):
        teleport_to = last_checkpoint

    if position.y > 10000:
        teleport_to = last_checkpoint

    if teleport_to != Vector2.ZERO:
        print('Teleporting')
        state.transform.origin = teleport_to
        state.linear_velocity = Vector2()
        state.angular_velocity = 0
        teleport_to = Vector2.ZERO

    var move_dir = Vector2()
    if Input.is_action_pressed('right'):
        move_dir.x += 1
    elif Input.is_action_pressed('left'):
        move_dir.x -= 1
    
    if move_dir.x != 0:
        sprite.animation = 'run'
        if move_dir.x > 0:
            sprite.flip_h = false
        else:
            sprite.flip_h = true
    else:
        sprite.animation = 'default'

    if grounded:
        state.linear_velocity.x = lerp(state.linear_velocity.x, move_dir.x * max_speed, control_smoothing)
    else:
        state.linear_velocity.x = lerp(state.linear_velocity.x, move_dir.x * max_speed, air_control)


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

    if Input.is_action_just_pressed('jump') and grounded > 0:
        apply_central_impulse(Vector2(0, -jump_impulse * mass))
    
    elif Input.is_action_just_released('jump'):
        if linear_velocity.y < 0:
            apply_central_impulse(Vector2(0, -linear_velocity.y * mass / 2))

    
