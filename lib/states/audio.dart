import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:audiofileplayer/audiofileplayer.dart';

class AudioService {
  final Audio correctSfx = Audio.load('assets/audio/correct.ogg');
  final Audio wrongSfx = Audio.load('assets/audio/wrong.ogg');
  final Audio bgm = Audio.load('assets/audio/triviaking.ogg', looping: true);

  AudioService() {
    correctSfx.setVolume(1);
    wrongSfx.setVolume(1);
    bgm.setVolume(1);
  }

  void playCorrect() => correctSfx.play();
  void playWrong() => wrongSfx.play();
  void playBgm() => bgm.play();
  void stopBgm() {
    bgm.pause();
    bgm.seek(0);
  }
}

final audioServiceProvider = Provider<AudioService>((ref) => AudioService());
