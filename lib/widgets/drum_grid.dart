import 'package:flutter/material.dart';
import '../viewmodels/drum_view_model.dart';
import '../services/theme_service.dart';

class DrumGrid extends StatelessWidget {
  final DrumViewModel viewModel;

  const DrumGrid({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final state = viewModel.state;
    final themeService = ThemeService();
    final isDark = themeService.themeMode == ThemeMode.dark;

    if (state.instruments.isEmpty || state.pattern.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.orange),
      );
    }

    final headerColor = isDark
        ? const Color(0xFF3D3D3D)
        : (Colors.grey[200] ?? Colors.grey.shade200);
    final textColor = isDark ? Colors.white : Colors.black87;
    final secondaryTextColor = isDark ? Colors.white70 : Colors.black54;
    final borderColor = isDark
        ? Colors.white30
        : (Colors.grey[400] ?? Colors.grey.shade400);
    final activeBorderColor = Colors.orange;

    return Column(
      children: [
        // Grid Header
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: headerColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
          ),
          child: Row(
            children: [
              Text(
                'Beat Pattern',
                style: TextStyle(
                  color: textColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Text(
                '${state.beats} Beats',
                style: const TextStyle(
                  color: Colors.orange,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),

        // Grid Content
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Beat numbers row
                Row(
                  children: [
                    const SizedBox(width: 100), // Space for instrument names
                    ...List.generate(state.beats, (beatIndex) {
                      return Expanded(
                        child: Container(
                          height: 30,
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          child: Center(
                            child: Text(
                              '${beatIndex + 1}',
                              style: TextStyle(
                                color: secondaryTextColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),

                const SizedBox(height: 8),

                // Drum pattern grid
                Expanded(
                  child: ListView.builder(
                    itemCount: state.instruments.length,
                    itemBuilder: (context, instrumentIndex) {
                      final instrument = state.instruments[instrumentIndex];
                      return Container(
                        height: 60,
                        margin: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            // Instrument name
                            SizedBox(
                              width: 100,
                              child: Text(
                                instrument.displayName,
                                style: TextStyle(
                                  color: instrument.isActive
                                      ? textColor
                                      : secondaryTextColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),

                            // Beat buttons
                            Expanded(
                              child: Row(
                                children: List.generate(state.beats, (
                                  beatIndex,
                                ) {
                                  final isActive =
                                      state
                                          .pattern[instrumentIndex][beatIndex] ==
                                      1;
                                  final isCurrentBeat =
                                      state.isPlaying &&
                                      state.currentBeat == beatIndex;

                                  return Expanded(
                                    child: Container(
                                      height: 50,
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 2,
                                      ),
                                      child: GestureDetector(
                                        onTap: () {
                                          if (instrument.isActive) {
                                            viewModel.toggleBeat(
                                              instrumentIndex,
                                              beatIndex,
                                            );
                                          }
                                        },
                                        child: AnimatedContainer(
                                          duration: const Duration(
                                            milliseconds: 150,
                                          ),
                                          decoration: BoxDecoration(
                                            color: isActive
                                                ? (instrument.isActive
                                                      ? Colors.green
                                                      : Colors.grey)
                                                : Colors.transparent,
                                            border: Border.all(
                                              color: isCurrentBeat
                                                  ? activeBorderColor
                                                  : borderColor,
                                              width: isCurrentBeat ? 3 : 1,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: Center(
                                            child: isActive
                                                ? Icon(
                                                    Icons.music_note,
                                                    color: isDark
                                                        ? Colors.white
                                                        : Colors.black87,
                                                    size: 20,
                                                  )
                                                : null,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
