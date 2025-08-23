import 'dart:async';
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  final Map<String, AudioPlayer> _players = {};
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;

    // Configure audio session for low latency
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration(
      avAudioSessionCategory: AVAudioSessionCategory.playback,
      avAudioSessionCategoryOptions: AVAudioSessionCategoryOptions.allowBluetooth,
      avAudioSessionMode: AVAudioSessionMode.defaultMode,
      avAudioSessionRouteSharingPolicy: AVAudioSessionRouteSharingPolicy.defaultPolicy,
      avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
      androidAudioAttributes: const AndroidAudioAttributes(
        contentType: AndroidAudioContentType.music,
        flags: AndroidAudioFlags.none,
        usage: AndroidAudioUsage.media,
      ),
      androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
      androidWillPauseWhenDucked: true,
    ));

    _isInitialized = true;
  }

  Future<void> loadSound(String soundPath) async {
    if (_players.containsKey(soundPath)) return;

    try {
      final player = AudioPlayer();
      await player.setAsset(soundPath);
      _players[soundPath] = player;
    } catch (e) {
      print('Error loading sound $soundPath: $e');
    }
  }

  Future<void> playSound(String soundPath) async {
    if (!_isInitialized) await initialize();
    
    final player = _players[soundPath];
    if (player != null) {
      try {
        // Stop and seek to beginning to ensure clean playback
        await player.stop();
        await player.seek(Duration.zero);
        await player.play();
      } catch (e) {
        print('Error playing sound $soundPath: $e');
      }
    } else {
      // Load the sound if not already loaded
      await loadSound(soundPath);
      await playSound(soundPath);
    }
  }

  Future<void> playMultipleSounds(List<String> soundPaths) async {
    if (!_isInitialized) await initialize();
    
    // Play all sounds simultaneously
    final futures = soundPaths.map((path) => playSound(path));
    await Future.wait(futures);
  }

  Future<void> stopAllSounds() async {
    for (final player in _players.values) {
      await player.stop();
    }
  }

  Future<void> dispose() async {
    for (final player in _players.values) {
      await player.dispose();
    }
    _players.clear();
    _isInitialized = false;
  }

  bool get isInitialized => _isInitialized;
}
