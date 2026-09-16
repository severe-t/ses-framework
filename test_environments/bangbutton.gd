extends Button



func _on_pressed() -> void:
	AudioManager.play_se(SoundEffect.ids.REVOLVER_DEFAULT)

func _on_button_2_pressed() -> void:
	AudioManager.play_se_2d(SoundEffect.ids.REVOLVER_DEFAULT, get_global_mouse_position())


func _on_button_3_pressed() -> void:
	AudioManager.play_bgm(Bgm.ids.MAIN_MENU)
