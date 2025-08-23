import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/drum_beat.dart';

class StorageService {
  static const String _beatsKey = 'saved_beats';
  
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  Future<void> saveBeat(DrumBeat beat) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedBeats = await getSavedBeats();
      
      // Check if beat with same name already exists
      final existingIndex = savedBeats.indexWhere((b) => b.name == beat.name);
      if (existingIndex != -1) {
        savedBeats[existingIndex] = beat;
      } else {
        savedBeats.add(beat);
      }
      
      final beatsJson = savedBeats.map((b) => b.toJson()).toList();
      await prefs.setString(_beatsKey, jsonEncode(beatsJson));
    } catch (e) {
      print('Error saving beat: $e');
    }
  }

  Future<List<DrumBeat>> getSavedBeats() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final beatsString = prefs.getString(_beatsKey);
      
      if (beatsString == null || beatsString.isEmpty) {
        return [];
      }
      
      final beatsList = jsonDecode(beatsString) as List;
      return beatsList
          .map((beatJson) => DrumBeat.fromJson(beatJson as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error loading beats: $e');
      return [];
    }
  }

  Future<void> deleteBeat(String beatName) async {
    try {
      final savedBeats = await getSavedBeats();
      savedBeats.removeWhere((beat) => beat.name == beatName);
      
      final prefs = await SharedPreferences.getInstance();
      final beatsJson = savedBeats.map((b) => b.toJson()).toList();
      await prefs.setString(_beatsKey, jsonEncode(beatsJson));
    } catch (e) {
      print('Error deleting beat: $e');
    }
  }

  Future<void> clearAllBeats() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_beatsKey);
    } catch (e) {
      print('Error clearing beats: $e');
    }
  }
}
