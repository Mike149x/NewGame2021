extends Node

func play(sound):
	var audio_stream = AudioStreamPlayer.new()
	self.add_child(audio_stream)
	audio_stream.stream = load(sound)
	audio_stream.play()



