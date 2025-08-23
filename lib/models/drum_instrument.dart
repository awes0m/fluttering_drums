import 'package:flutter/foundation.dart';

@immutable
class DrumInstrument {
  final String name;
  final String soundPath;
  final String displayName;
  final bool isActive;
  final int index;

  const DrumInstrument({
    required this.name,
    required this.soundPath,
    required this.displayName,
    this.isActive = true,
    required this.index,
  });

  DrumInstrument copyWith({
    String? name,
    String? soundPath,
    String? displayName,
    bool? isActive,
    int? index,
  }) {
    return DrumInstrument(
      name: name ?? this.name,
      soundPath: soundPath ?? this.soundPath,
      displayName: displayName ?? this.displayName,
      isActive: isActive ?? this.isActive,
      index: index ?? this.index,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DrumInstrument &&
        other.name == name &&
        other.soundPath == soundPath &&
        other.displayName == displayName &&
        other.isActive == isActive &&
        other.index == index;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        soundPath.hashCode ^
        displayName.hashCode ^
        isActive.hashCode ^
        index.hashCode;
  }

  @override
  String toString() {
    return 'DrumInstrument(name: $name, soundPath: $soundPath, displayName: $displayName, isActive: $isActive, index: $index)';
  }
}
