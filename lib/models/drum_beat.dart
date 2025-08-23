import 'package:flutter/foundation.dart';

@immutable
class DrumBeat {
  final String name;
  final int beats;
  final int bpm;
  final List<List<int>> pattern;
  final DateTime createdAt;

  DrumBeat({
    required this.name,
    required this.beats,
    required this.bpm,
    required this.pattern,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  DrumBeat copyWith({
    String? name,
    int? beats,
    int? bpm,
    List<List<int>>? pattern,
    DateTime? createdAt,
  }) {
    return DrumBeat(
      name: name ?? this.name,
      beats: beats ?? this.beats,
      bpm: bpm ?? this.bpm,
      pattern: pattern ?? this.pattern,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'beats': beats,
      'bpm': bpm,
      'pattern': pattern,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory DrumBeat.fromJson(Map<String, dynamic> json) {
    return DrumBeat(
      name: json['name'] as String,
      beats: json['beats'] as int,
      bpm: json['bpm'] as int,
      pattern: (json['pattern'] as List)
          .map((e) => (e as List).map((e) => e as int).toList())
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DrumBeat &&
        other.name == name &&
        other.beats == beats &&
        other.bpm == bpm &&
        listEquals(other.pattern, pattern) &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        beats.hashCode ^
        bpm.hashCode ^
        pattern.hashCode ^
        createdAt.hashCode;
  }

  @override
  String toString() {
    return 'DrumBeat(name: $name, beats: $beats, bpm: $bpm, pattern: $pattern, createdAt: $createdAt)';
  }
}
