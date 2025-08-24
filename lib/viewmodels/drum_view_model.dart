import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/drum_instrument.dart';
import '../models/drum_beat.dart';
import '../services/audio_service.dart';
import '../services/storage_service.dart';
import '../services/export_service.dart';

class DrumViewModel extends ChangeNotifier {
  Timer? _playbackTimer;
  final AudioService _audioService = AudioService();
  final StorageService _storageService = StorageService();
  final ExportService _exportService = ExportService();

  DrumState _state = const DrumState();
  DrumState get state => _state;

  Future<void> initialize() async {
    await _audioService.initialize();
    
    // Load default instruments
    final instruments = [
      DrumInstrument(
        name: 'hi_hat',
        soundPath: 'assets/sounds/hi_hat.wav',
        displayName: 'Hi Hat',
        index: 0,
      ),
      DrumInstrument(
        name: 'snare',
        soundPath: 'assets/sounds/snare.wav',
        displayName: 'Snare',
        index: 1,
      ),
      DrumInstrument(
        name: 'kick',
        soundPath: 'assets/sounds/kick.wav',
        displayName: 'Kick',
        index: 2,
      ),
      DrumInstrument(
        name: 'crash',
        soundPath: 'assets/sounds/crash.wav',
        displayName: 'Crash',
        index: 3,
      ),
      DrumInstrument(
        name: 'clap',
        soundPath: 'assets/sounds/clap.wav',
        displayName: 'Clap',
        index: 4,
      ),
      DrumInstrument(
        name: 'tom',
        soundPath: 'assets/sounds/tom.wav',
        displayName: 'Floor Tom',
        index: 5,
      ),
    ];

    // Initialize pattern grid
    final pattern = List.generate(
      instruments.length,
      (i) => List.generate(_state.beats, (j) => -1),
    );

    _updateState(_state.copyWith(
      instruments: instruments,
      pattern: pattern,
    ));

    // Preload all sounds
    for (final instrument in instruments) {
      await _audioService.loadSound(instrument.soundPath);
    }
  }

  void toggleInstrument(int instrumentIndex) {
    final instruments = List<DrumInstrument>.from(_state.instruments);
    instruments[instrumentIndex] = instruments[instrumentIndex].copyWith(
      isActive: !instruments[instrumentIndex].isActive,
    );
    
    _updateState(_state.copyWith(instruments: instruments));
  }

  void toggleBeat(int instrumentIndex, int beatIndex) {
    final pattern = List.generate(
      _state.pattern.length,
      (i) => List<int>.from(_state.pattern[i]),
    );
    
    if (pattern[instrumentIndex][beatIndex] == -1) {
      pattern[instrumentIndex][beatIndex] = 1;
    } else {
      pattern[instrumentIndex][beatIndex] = -1;
    }
    
    _updateState(_state.copyWith(pattern: pattern));
  }

  void setBeats(int beats) {
    if (beats < 1 || beats > 16) return;
    
    final pattern = List.generate(
      _state.instruments.length,
      (i) => List.generate(beats, (j) {
        if (j < _state.beats) {
          return _state.pattern[i][j];
        }
        return -1;
      }),
    );
    
    _updateState(_state.copyWith(
      beats: beats,
      pattern: pattern,
    ));
  }

  void setBpm(int bpm) {
    if (bpm < 60 || bpm > 300) return;
    _updateState(_state.copyWith(bpm: bpm));
  }

  void playPause() {
    if (_state.isPlaying) {
      _stopPlayback();
    } else {
      _startPlayback();
    }
  }

  void _startPlayback() {
    if (_state.isPlaying) return;
    
    _updateState(_state.copyWith(
      isPlaying: true,
      currentBeat: 0,
    ));
    
    _playbackTimer = Timer.periodic(
      Duration(milliseconds: (60000 / _state.bpm).round()),
      (timer) {
        _playCurrentBeat();
        _advanceBeat();
      },
    );
  }

  void _stopPlayback() {
    _playbackTimer?.cancel();
    _playbackTimer = null;
    
    _updateState(_state.copyWith(
      isPlaying: false,
      currentBeat: 0,
    ));
  }

  void _playCurrentBeat() {
    final soundsToPlay = <String>[];
    
    for (int i = 0; i < _state.instruments.length; i++) {
      if (_state.pattern[i][_state.currentBeat] == 1 && 
          _state.instruments[i].isActive) {
        soundsToPlay.add(_state.instruments[i].soundPath);
      }
    }
    
    if (soundsToPlay.isNotEmpty) {
      _audioService.playMultipleSounds(soundsToPlay);
    }
  }

  void _advanceBeat() {
    final nextBeat = (_state.currentBeat + 1) % _state.beats;
    _updateState(_state.copyWith(currentBeat: nextBeat));
  }

  void clearPattern() {
    final pattern = List.generate(
      _state.instruments.length,
      (i) => List.generate(_state.beats, (j) => -1),
    );
    
    _updateState(_state.copyWith(pattern: pattern));
  }

  void playInstrument(int instrumentIndex) {
    if (instrumentIndex >= 0 && instrumentIndex < _state.instruments.length) {
      final instrument = _state.instruments[instrumentIndex];
      if (instrument.isActive) {
        _audioService.playSound(instrument.soundPath);
      }
    }
  }

  Future<void> saveBeat(String name) async {
    if (name.trim().isEmpty) return;
    
    final beat = DrumBeat(
      name: name.trim(),
      beats: _state.beats,
      bpm: _state.bpm,
      pattern: _state.pattern,
    );
    
    await _storageService.saveBeat(beat);
    _updateState(_state.copyWith(
      savedBeats: await _storageService.getSavedBeats()
    ));
  }

  Future<void> loadBeat(DrumBeat beat) async {
    _updateState(_state.copyWith(
      beats: beat.beats,
      bpm: beat.bpm,
      pattern: beat.pattern,
    ));
  }

  Future<void> deleteBeat(String beatName) async {
    await _storageService.deleteBeat(beatName);
    _updateState(_state.copyWith(
      savedBeats: await _storageService.getSavedBeats()
    ));
  }

  Future<void> loadSavedBeats() async {
    final savedBeats = await _storageService.getSavedBeats();
    _updateState(_state.copyWith(savedBeats: savedBeats));
  }

  /// Export current beat pattern as MP3
  Future<String?> exportCurrentBeatToMp3(String fileName, {int repetitions = 1}) async {
    if (_state.instruments.isEmpty || _state.pattern.isEmpty) {
      return null;
    }

    final beat = DrumBeat(
      name: fileName,
      beats: _state.beats,
      bpm: _state.bpm,
      pattern: _state.pattern,
    );

    return await _exportService.exportBeatToMp3(
      beat: beat,
      instruments: _state.instruments,
      fileName: fileName,
      repetitions: repetitions,
    );
  }

  /// Export a saved beat as MP3
  Future<String?> exportSavedBeatToMp3(DrumBeat beat, String fileName, {int repetitions = 1}) async {
    return await _exportService.exportBeatToMp3(
      beat: beat,
      instruments: _state.instruments,
      fileName: fileName,
      repetitions: repetitions,
    );
  }

  void _updateState(DrumState newState) {
    _state = newState;
    notifyListeners();
  }

  @override
  void dispose() {
    _playbackTimer?.cancel();
    _audioService.dispose();
    super.dispose();
  }
}

@immutable
class DrumState {
  final List<DrumInstrument> instruments;
  final List<List<int>> pattern;
  final int beats;
  final int bpm;
  final bool isPlaying;
  final int currentBeat;
  final List<DrumBeat> savedBeats;

  const DrumState({
    this.instruments = const [],
    this.pattern = const [],
    this.beats = 8,
    this.bpm = 120,
    this.isPlaying = false,
    this.currentBeat = 0,
    this.savedBeats = const [],
  });

  DrumState copyWith({
    List<DrumInstrument>? instruments,
    List<List<int>>? pattern,
    int? beats,
    int? bpm,
    bool? isPlaying,
    int? currentBeat,
    List<DrumBeat>? savedBeats,
  }) {
    return DrumState(
      instruments: instruments ?? this.instruments,
      pattern: pattern ?? this.pattern,
      beats: beats ?? this.beats,
      bpm: bpm ?? this.bpm,
      isPlaying: isPlaying ?? this.isPlaying,
      currentBeat: currentBeat ?? this.currentBeat,
      savedBeats: savedBeats ?? this.savedBeats,
    );
  }
}