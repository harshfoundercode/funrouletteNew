import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';

class NetworkAudioPlayer {
  final AudioPlayer _player = AudioPlayer();

  Future<void> play(String url) async {
    try {
      await _player.setAudioSource(AudioSource.uri(Uri.parse(url)));
      await _player.play();
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print('Error playing network audio: $e');
      }
    } catch (e) {
      // Handle other errors
      if (kDebugMode) {
        print('Error playing network audio: $e');
      }
    }
  }

  Future<void> pause() async {
    await _player.pause();
  }

  Future<void> stop() async {
    await _player.stop();
  }

  Future<void> dispose() async {
    await _player.dispose();
  }
}

final audioPlayer = NetworkAudioPlayer();

void playNetworkSound(String url) async {
  await audioPlayer.play(url);
}

void pauseNetworkSound() async {
  await audioPlayer.pause();
}

void stopNetworkSound() async {
  await audioPlayer.stop();
}

void releaseNetworkSoundResources() async {
  await audioPlayer.dispose();
}
