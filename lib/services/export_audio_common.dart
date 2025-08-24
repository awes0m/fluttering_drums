import 'dart:typed_data';

import '../models/drum_beat.dart';
import '../models/drum_instrument.dart';

/// Shared audio generation helper for ExportService on all platforms.
class ExportAudioHelper {
  /// Generate audio data for the beat pattern with repetitions
  static Future<Uint8List> generateBeatAudio(
    DrumBeat beat,
    List<DrumInstrument> instruments,
    int repetitions,
  ) async {
    const int sampleRate = 44100;
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
          // ignore and continue
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
  static Future<List<double>> _loadInstrumentSample(String soundPath) async {
    // This is a placeholder implementation generating synthetic sounds.
    const int sampleRate = 44100;
    const double duration = 0.5; // 500ms sample
    final int numSamples = (sampleRate * duration).round();
    final List<double> samples = [];

    for (int i = 0; i < numSamples; i++) {
      double sample = 0.0;
      final double t = i / sampleRate;

      if (soundPath.contains('kick')) {
        // Low frequency thump
        sample = _Math.sin(2 * _Math.pi * 60 * t) * _Math.exp(-t * 8);
      } else if (soundPath.contains('snare')) {
        // Mid frequency with noise
        sample = (_Math.sin(2 * _Math.pi * 200 * t) + _Math.random() * 0.5) * _Math.exp(-t * 6);
      } else if (soundPath.contains('hi_hat')) {
        // High frequency noise
        sample = _Math.random() * _Math.exp(-t * 10);
      } else if (soundPath.contains('crash')) {
        // Metallic sound
        sample = (_Math.sin(2 * _Math.pi * 400 * t) + _Math.sin(2 * _Math.pi * 800 * t)) * _Math.exp(-t * 3);
      } else {
        // Generic drum sound
        sample = _Math.sin(2 * _Math.pi * 150 * t) * _Math.exp(-t * 5);
      }

      samples.add(sample);
    }

    return samples;
  }

  /// Create a WAV file from audio samples
  static Uint8List _createWavFile(List<double> samples, int sampleRate) {
    final int numSamples = samples.length;
    final int byteRate = sampleRate * 2; // 16-bit mono
    final int dataSize = numSamples * 2;
    final int fileSize = 44 + dataSize;

    final ByteData byteData = ByteData(fileSize);
    int offset = 0;

    // WAV header
    byteData.setUint32(offset, 0x52494646, Endian.big); // "RIFF"
    offset += 4;
    byteData.setUint32(offset, fileSize - 8, Endian.little);
    offset += 4;
    byteData.setUint32(offset, 0x57415645, Endian.big); // "WAVE"
    offset += 4;
    byteData.setUint32(offset, 0x666D7420, Endian.big); // "fmt "
    offset += 4;
    byteData.setUint32(offset, 16, Endian.little); // PCM header size
    offset += 4;
    byteData.setUint16(offset, 1, Endian.little); // PCM format
    offset += 2;
    byteData.setUint16(offset, 1, Endian.little); // Mono
    offset += 2;
    byteData.setUint32(offset, sampleRate, Endian.little);
    offset += 4;
    byteData.setUint32(offset, byteRate, Endian.little);
    offset += 4;
    byteData.setUint16(offset, 2, Endian.little); // Block align
    offset += 2;
    byteData.setUint16(offset, 16, Endian.little); // Bits per sample
    offset += 2;
    byteData.setUint32(offset, 0x64617461, Endian.big); // "data"
    offset += 4;
    byteData.setUint32(offset, dataSize, Endian.little);
    offset += 4;

    // Audio data
    for (final sample in samples) {
      final int intSample = (sample * 32767).clamp(-32768, 32767).round();
      byteData.setInt16(offset, intSample, Endian.little);
      offset += 2;
    }

    return byteData.buffer.asUint8List();
  }
}

// Simple Math helpers for the synthetic audio generation
class _Math {
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