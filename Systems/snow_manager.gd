extends Node3D

enum WeatherState {
	CLEAR,
	SPRINKLE,
	SNOWSTORM,
	BLIZZARD,
	AVALANCHE,
	RAIN,
}

var current_state: WeatherState = WeatherState.SPRINKLE

@onready var snowflakes: GPUParticles3D = $Snowflakes
@onready var big_snowflakes: GPUParticles3D = $BigSnowflakes
@onready var clouds: GPUParticles3D = $Clouds


func change_state(new_state: WeatherState) -> void:
	print(new_state)
	current_state = new_state
	match new_state:
		WeatherState.CLEAR:
			clouds.emitting = false
			await get_tree().create_timer(6.0).timeout
			snowflakes.emitting = false
			big_snowflakes.emitting = false


func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"debug"):
		change_state(
			{
				WeatherState.CLEAR: WeatherState.SPRINKLE,
				WeatherState.SPRINKLE: WeatherState.SNOWSTORM,
				WeatherState.SNOWSTORM: WeatherState.BLIZZARD,
				WeatherState.BLIZZARD: WeatherState.AVALANCHE,
				WeatherState.AVALANCHE: WeatherState.RAIN,
				WeatherState.RAIN: WeatherState.CLEAR,
			}[current_state]
		)
