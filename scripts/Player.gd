extends RigidBody2D
class_name Player

const move_acc := 3000
const max_speed := 400
const jump_impulse := 800
var grounded := 0.0
const control_smoothing := 0.5
const air_control := 0.02
var bounce = 0

var protection := 0
var star: Sprite2D



var sprite: AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready():

    State.start_pos = position
    if State.teleport_to == Vector2.ZERO:
        State.last_checkpoint = State.start_pos
    connect('body_entered', collided)
    connect('body_shape_entered', shape_collided)
    sprite = $AnimatedSprite2D
    star = $Star


func hurt():
    if protection > 0:
        protection -= 1
        if protection == 0:
            star.hide()
    else:
        State.teleport_to = State.last_checkpoint


func collided(body: Node):
    print('Bumped with: ', body.name)
    if body.name.begins_with('Shroomies'):
        if body.global_position.y - global_position.y > 20:
            body.queue_free()
            bounce = 500
        else:
            hurt()

    elif body.name.begins_with('GoldShroomies'):
        protection = 1
        print('Showing star')
        body.queue_free()
        star.show()


func shape_collided(_body_rid: RID, body: Node, body_shape_index: int, _local_shape_index: int):
    if body.name.begins_with('Angcake'):
        if body_shape_index == 1:
            hurt()
        else:
            # TODO: Play nom sound
            var sound = (body as Angcake).sound
            print(sound)
            if !sound.playing:
                sound.play()
                sound.get_parent().remove_child(sound)
                add_child(sound)
            body.queue_free()

func _integrate_forces(state: PhysicsDirectBodyState2D):
    if Input.is_action_just_pressed('respawn'):
        State.teleport_to = State.last_checkpoint

    if position.y > 10000:
        State.teleport_to = State.last_checkpoint

    if State.teleport_to != Vector2.ZERO:
        print('Teleporting')
        state.transform.origin = State.teleport_to
        state.linear_velocity = Vector2()
        state.angular_velocity = 0
        State.teleport_to = Vector2.ZERO

    var move_dir = Vector2()
    if Input.is_action_pressed('right'):
        move_dir.x += 1
    elif Input.is_action_pressed('left'):
        move_dir.x -= 1
    
    if linear_velocity.y > 600:
        sprite.animation = 'fall'
    elif move_dir.x != 0:
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
    for x in range(-15, 15, 5):
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
        if !$JumpSound.playing:
            $JumpSound.pitch_scale = 1 + (randf() - 0.5) * 0.4
            $JumpSound.play()
        apply_central_impulse(Vector2(0, -jump_impulse * mass))

    elif Input.is_action_just_released('jump'):
        if linear_velocity.y < 0:
            apply_central_impulse(Vector2(0, -linear_velocity.y * mass / 2))

    if bounce != 0:
        apply_central_impulse(Vector2(0, -bounce))
        bounce = 0
