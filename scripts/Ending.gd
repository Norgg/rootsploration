extends Node2D

var timer = 3

var holly
var acre
var mum
var elapsed_time := 0.0

func _ready():
    acre = find_child('PlayerAcre(boy)')
    holly = find_child('PlayerHolly(girl)')
    mum = find_child('Mum')


func _process(delta):
    elapsed_time += delta
    if fmod(elapsed_time, 0.5) > 0.25: 
        acre.position.y = 544
        holly.position.y = 524
        mum.position.y = 444
    else:
        acre.position.y = 524
        holly.position.y = 544
        mum.position.y = 464
    timer -= delta
    if timer < 0:
        $RestartText.show()
        if Input.is_action_just_pressed('start'):
            get_tree().change_scene_to_file('res://start.tscn')

