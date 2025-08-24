import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../models/drum_beat.dart';
import '../models/drum_instrument.dart';
import 'export_audio_common.dart';

class ExportService {
  /// Export a drum beat as MP3 file (actually WAV for now)
  Future<String?> exportBeatToMp3({
    required DrumBeat beat,
    required List<DrumInstrument> instruments,
    required String fileName,
    int repetitions = 1,
  }) async {
    try {
      if (repetitions < 1 || repetitions > 25) {
        throw Exception('Repetitions must be between 1 and 25');
      }

      // Generate audio data
      final audioData = await ExportAudioHelper.generateBeatAudio(
        beat,
        instruments,
        repetitions,
      );

      // Save to device
      return await _downloadForMobile(audioData, fileName);
    } catch (e) {
      debugPrint('Error exporting beat to MP3 (IO): $e');
      return null;
    }
  }

  /// Public permission check to mirror old API used by UI
  Future<bool> isStoragePermissionGranted() async {
    if (!Platform.isAndroid) return true;
    try {
      final manageStatus = await Permission.manageExternalStorage.status;
      if (manageStatus.isGranted) return true;
      final storageStatus = await Permission.storage.status;
      return storageStatus.isGranted;
    } catch (_) {
      return true;
    }
  }

  /// Handle mobile/desktop download with proper permissions
  Future<String?> _downloadForMobile(
    List<int> audioData,
    String fileName,
  ) async {
    try {
      if (!await _requestStoragePermission()) {
        throw Exception('Storage permission denied');
      }

      final directory = await _getDownloadsDirectory();
      if (directory == null) {
        throw Exception('Could not access downloads directory');
      }

      final String filePath = '${directory.path}/$fileName.mp3';
      final File file = File(filePath);
      await file.writeAsBytes(audioData);
      return filePath;
    } catch (e) {
      debugPrint('Error downloading file on mobile/desktop: $e');
      return null;
    }
  }

  /// Request storage permission with proper handling
  Future<bool> _requestStoragePermission() async {
    // iOS/macOS generally don't need explicit storage permission for app docs
    if (!Platform.isAndroid) return true;

    // Android specific
    try {
      // Manage external storage (may be required on some devices/APIs)
      final manage = await Permission.manageExternalStorage.request();
      if (manage.isGranted) return true;

      final storage = await Permission.storage.request();
      return storage.isGranted;
    } catch (_) {
      return true; // fail-open to avoid blocking
    }
  }

  /// Get the downloads directory with proper fallbacks
  Future<Directory?> _getDownloadsDirectory() async {
    try {
      if (Platform.isAndroid) {
        // Public downloads path (works on many devices)
        final public = Directory('/storage/emulated/0/Download');
        if (await public.exists()) return public;

        // App-specific external dir fallback
        final appDir = await getExternalStorageDirectory();
        if (appDir != null) {
          final downloadsDir = Directory('${appDir.path}/Downloads');
          if (!await downloadsDir.exists()) {
            await downloadsDir.create(recursive: true);
          }
          return downloadsDir;
        }
      } else if (Platform.isIOS) {
        return await getApplicationDocumentsDirectory();
      } else if (Platform.isLinux || Platform.isMacOS || Platform.isWindows) {
        final dl = await getDownloadsDirectory();
        if (dl != null) return dl;
        return await getApplicationDocumentsDirectory();
      }
    } catch (e) {
      debugPrint('Error getting downloads directory: $e');
    }

    try {
      return await getApplicationDocumentsDirectory();
    } catch (_) {
      return null;
    }
  }
}
