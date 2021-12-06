import 'package:flutter/material.dart';
import 'package:audiofileplayer/audiofileplayer.dart';

// A state that actually don't do any state management, it just holds the audio and manages playback
class AudioController extends ChangeNotifier {

	final Audio correctSfx = Audio.load('assets/audio/correct.ogg');
	final Audio wrongSfx = Audio.load('assets/audio/wrong.ogg');
	final Audio bgm = Audio.load('assets/audio/triviaking.ogg', looping: true);

	AudioController() {
		correctSfx.setVolume(1);
		wrongSfx.setVolume(1);
		bgm.setVolume(1);
	}

}