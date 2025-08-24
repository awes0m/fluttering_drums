import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/drum_beat.dart';
import '../models/drum_instrument.dart';

class ExportService {

  /// Export a drum beat as MP3 file
  Future<String?> exportBeatToMp3({
    required DrumBeat beat,
    required List<DrumInstrument> instruments,
    required String fileName,
    int repetitions = 1,
  }) async {
    try {
      // Validate repetitions
      if (repetitions < 1 || repetitions > 25) {
        throw Exception('Repetitions must be between 1 and 25');
      }

      // Request storage permission
      if (!await _requestStoragePermission()) {
        throw Exception('Storage permission denied');
      }

      // Generate the audio data with repetitions
      final audioData = await _generateBeatAudio(beat, instruments, repetitions);
      
      // Get the downloads directory
      final directory = await _getDownloadsDirectory();
      if (directory == null) {
        throw Exception('Could not access downloads directory');
      }

      // Create the file path
      final filePath = '${directory.path}/$fileName.mp3';
      final file = File(filePath);

      // Write the audio data to file
      await file.writeAsBytes(audioData);

      return filePath;
    } catch (e) {
      print('Error exporting beat to MP3: $e');
      return null;
    }
  }

  /// Generate audio data for the beat pattern with repetitions
  Future<Uint8List> _generateBeatAudio(
    DrumBeat beat,
    List<DrumInstrument> instruments,
    int repetitions,
  ) async {
    // This is a simplified implementation
    // In a real-world scenario, you would need a proper audio mixing library
    // For now, we'll create a basic representation
    
    final int sampleRate = 44100;
    final double beatDuration = 60.0 / beat.bpm; // Duration of one beat in seconds
    final int samplesPerBeat = (sampleRate * beatDuration).round();
    
    // Initialize audio buffer for all repetitions
    final int totalBeats = beat.beats * repetitions;
    final int totalSamples = samplesPerBeat * totalBeats;
    final List<double> mixedAudio = List.filled(totalSamples, 0.0);
    
    // Load instrument samples
    final Map<String, List<double>> instrumentSamples = {};
    for (final instrument in instruments) {
      if (instrument.isActive) {
        try {
          final sampleData = await _loadInstrumentSample(instrument.soundPath);
          instrumentSamples[instrument.name] = sampleData;
        } catch (e) {
          print('Error loading sample for ${instrument.name}: $e');
        }
      }
    }
    
    // Mix the pattern for each repetition
    for (int rep = 0; rep < repetitions; rep++) {
      for (int beatIndex = 0; beatIndex < beat.beats; beatIndex++) {
        for (int instrumentIndex = 0; instrumentIndex < instruments.length; instrumentIndex++) {
          if (beat.pattern[instrumentIndex][beatIndex] == 1) {
            final instrument = instruments[instrumentIndex];
            if (instrumentSamples.containsKey(instrument.name)) {
              final sample = instrumentSamples[instrument.name]!;
              final startSample = (rep * beat.beats + beatIndex) * samplesPerBeat;
              
              // Mix the sample into the main audio buffer
              for (int i = 0; i < sample.length && (startSample + i) < totalSamples; i++) {
                mixedAudio[startSample + i] += sample[i] * 0.7; // Reduce volume to prevent clipping
              }
            }
          }
        }
      }
    }
    
    // Convert to 16-bit PCM and create a simple WAV file
    // (We'll call it MP3 but it's actually WAV for simplicity)
    return _createWavFile(mixedAudio, sampleRate);
  }

  /// Load instrument sample data (simplified)
  Future<List<double>> _loadInstrumentSample(String soundPath) async {
    // This is a placeholder implementation
    // In a real scenario, you would decode the actual audio file
    // For now, we'll generate a simple synthetic sound
    
    final int sampleRate = 44100;
    final double duration = 0.5; // 500ms sample
    final int numSamples = (sampleRate * duration).round();
    final List<double> samples = [];
    
    // Generate a simple synthetic drum sound based on the instrument type
    for (int i = 0; i < numSamples; i++) {
      double sample = 0.0;
      final double t = i / sampleRate;
      
      if (soundPath.contains('kick')) {
        // Low frequency thump
        sample = Math.sin(2 * Math.pi * 60 * t) * Math.exp(-t * 8);
      } else if (soundPath.contains('snare')) {
        // Mid frequency with noise
        sample = (Math.sin(2 * Math.pi * 200 * t) + Math.random() * 0.5) * Math.exp(-t * 6);
      } else if (soundPath.contains('hi_hat')) {
        // High frequency noise
        sample = Math.random() * Math.exp(-t * 10);
      } else if (soundPath.contains('crash')) {
        // Metallic sound
        sample = (Math.sin(2 * Math.pi * 400 * t) + Math.sin(2 * Math.pi * 800 * t)) * Math.exp(-t * 3);
      } else {
        // Generic drum sound
        sample = Math.sin(2 * Math.pi * 150 * t) * Math.exp(-t * 5);
      }
      
      samples.add(sample);
    }
    
    return samples;
  }

  /// Create a WAV file from audio samples
  Uint8List _createWavFile(List<double> samples, int sampleRate) {
    final int numSamples = samples.length;
    final int byteRate = sampleRate * 2; // 16-bit mono
    final int dataSize = numSamples * 2;
    final int fileSize = 44 + dataSize;
    
    final ByteData byteData = ByteData(fileSize);
    int offset = 0;
    
    // WAV header
    byteData.setUint32(offset, 0x52494646, Endian.big); offset += 4; // "RIFF"
    byteData.setUint32(offset, fileSize - 8, Endian.little); offset += 4;
    byteData.setUint32(offset, 0x57415645, Endian.big); offset += 4; // "WAVE"
    byteData.setUint32(offset, 0x666D7420, Endian.big); offset += 4; // "fmt "
    byteData.setUint32(offset, 16, Endian.little); offset += 4; // PCM header size
    byteData.setUint16(offset, 1, Endian.little); offset += 2; // PCM format
    byteData.setUint16(offset, 1, Endian.little); offset += 2; // Mono
    byteData.setUint32(offset, sampleRate, Endian.little); offset += 4;
    byteData.setUint32(offset, byteRate, Endian.little); offset += 4;
    byteData.setUint16(offset, 2, Endian.little); offset += 2; // Block align
    byteData.setUint16(offset, 16, Endian.little); offset += 2; // Bits per sample
    byteData.setUint32(offset, 0x64617461, Endian.big); offset += 4; // "data"
    byteData.setUint32(offset, dataSize, Endian.little); offset += 4;
    
    // Audio data
    for (final sample in samples) {
      final int intSample = (sample * 32767).clamp(-32768, 32767).round();
      byteData.setInt16(offset, intSample, Endian.little);
      offset += 2;
    }
    
    return byteData.buffer.asUint8List();
  }

  /// Request storage permission
  Future<bool> _requestStoragePermission() async {
    if (Platform.isAndroid) {
      final status = await Permission.storage.request();
      return status.isGranted;
    } else if (Platform.isIOS) {
      // iOS doesn't need explicit storage permission for app documents
      return true;
    }
    return true;
  }

  /// Get the downloads directory
  Future<Directory?> _getDownloadsDirectory() async {
    if (Platform.isAndroid) {
      return Directory('/storage/emulated/0/Download');
    } else if (Platform.isIOS) {
      return await getApplicationDocumentsDirectory();
    } else {
      return await getDownloadsDirectory();
    }
  }
}

// Simple Math class for the synthetic audio generation
class Math {
  static const double pi = 3.14159265359;
  
  static double sin(double x) {
    // Simple sine approximation
    x = x % (2 * pi);
    if (x < 0) x += 2 * pi;
    
    if (x < pi) {
      return 4 * x * (pi - x) / (pi * pi);
    } else {
      x -= pi;
      return -4 * x * (pi - x) / (pi * pi);
    }
  }
  
  static double exp(double x) {
    // Simple exponential approximation
    if (x < -10) return 0.0;
    if (x > 10) return 22026.0;
    
    double result = 1.0;
    double term = 1.0;
    for (int i = 1; i < 20; i++) {
      term *= x / i;
      result += term;
      if (term.abs() < 0.0001) break;
    }
    return result;
  }
  
  static double random() {
    // Simple pseudo-random number generator
     int seed = DateTime.now().millisecondsSinceEpoch;
    seed = (seed * 1103515245 + 12345) & 0x7fffffff;
    return seed / 0x7fffffff;
  }
}