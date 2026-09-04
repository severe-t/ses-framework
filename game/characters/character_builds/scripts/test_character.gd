extends CharacterBody2D

var uses_signals = true


func _ready():
	var taulukko = ["data1", "data2"]
	SignalManager.send_command("player", "test", taulukko)
	pass

func on_command_signal(id, command, data):
	match id:
		"player":
			match command:
				"test":
					match data:
						"what it should be but is not going to be":
							print("JEEEEE")
						_:
							print("Data passed")
				_:
					print("Command passed")
		_:
			print("id_passed")