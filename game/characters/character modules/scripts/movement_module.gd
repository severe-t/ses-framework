extends CharacterModule
class_name MovementModule

enum AccelerationModes{
	OFF,
	LINEAR
}


@export var parent: CharacterBody2D
@export var input_source: ControlModule
@export var print_velocity: bool

@export var acceleration_mode: AccelerationModes
@export var speed: int
@export var acceleration: int

var last_measurement: Vector2

var input : Vector2


func _process(_delta):
	move(_delta)

	

	
func move(delta):
	match acceleration_mode:
		AccelerationModes.OFF:
			movement_without_acceleration(delta)
		AccelerationModes.LINEAR:
			movement_with_linear_acceleration(delta)
	if print_velocity == true and parent.velocity != last_measurement:
		print("Velocity: ", parent.velocity)
		last_measurement = parent.velocity
	parent.move_and_collide(parent.velocity)


func movement_without_acceleration(delta):
	parent.velocity = input_source.movement_input.normalized() * speed * delta
	

func movement_with_linear_acceleration(delta):
	var target_velocity = input_source.movement_input.normalized() * speed * delta
	parent.velocity = parent.velocity.move_toward(target_velocity, acceleration * delta)
