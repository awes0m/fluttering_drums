import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:web/web.dart' as web; // package:web replacement for dart:html

import '../models/drum_beat.dart';
import '../models/drum_instrument.dart';
import 'export_audio_common.dart';

class ExportService {
  /// Export a drum beat as MP3 file (actually WAV for now) and trigger browser download
  Future<String?> exportBeatToMp3({
    required DrumBeat beat,
    required List<DrumInstrument> instruments,
    required String fileName,
    int repetitions = 1,
  }) async {
    try {
      if (!kIsWeb) throw StateError('Web export called on non-web platform');
      if (repetitions < 1 || repetitions > 25) {
        throw Exception('Repetitions must be between 1 and 25');
      }

      final audioData = await ExportAudioHelper.generateBeatAudio(
        beat,
        instruments,
        repetitions,
      );

      await _downloadForWeb(audioData, fileName);
      return '$fileName.mp3';
    } catch (e) {
      debugPrint('Error exporting beat to MP3 (Web): $e');
      return null;
    }
  }

  /// Check storage permission on web (not needed)
  Future<bool> isStoragePermissionGranted() async => true;

  /// Handle web download using data URL to avoid Blob interop complexity
  Future<void> _downloadForWeb(List<int> audioData, String fileName) async {
    final dataUrl = 'data:audio/mpeg;base64,${base64Encode(audioData)}';

    // Create an anchor, set download attribute, click, and cleanup
    final anchor = web.HTMLAnchorElement()
      ..href = dataUrl
      ..download = '$fileName.mp3'
      ..style.display = 'none';

    web.document.body?.append(anchor);
    anchor.click();
    anchor.remove();
  }
}
