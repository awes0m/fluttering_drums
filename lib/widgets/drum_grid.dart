import 'package:flutter/material.dart';
import '../viewmodels/drum_view_model.dart';
import '../services/theme_service.dart';

class DrumGrid extends StatelessWidget {
  final DrumViewModel viewModel;
  final bool isMobileLandscape;

  const DrumGrid({
    super.key, 
    required this.viewModel,
    this.isMobileLandscape = false,
  });

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
        // Grid Header - Compact for mobile landscape
        Container(
          padding: EdgeInsets.all(isMobileLandscape ? 8.0 : 12.0),
          decoration: BoxDecoration(
            color: headerColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
          ),
          child: Row(
            children: [
              Text(
                'Beat Pattern',
                style: TextStyle(
                  color: textColor,
                  fontSize: isMobileLandscape ? 14 : 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Text(
                '${state.beats} Beats',
                style: TextStyle(
                  color: Colors.orange,
                  fontSize: isMobileLandscape ? 12 : 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),

        // Grid Content - Optimized for mobile landscape
        Expanded(
          child: Container(
            padding: EdgeInsets.all(isMobileLandscape ? 6.0 : 12.0),
            child: Column(
              children: [
                // Beat numbers row - Compact for mobile
                Row(
                  children: [
                    SizedBox(width: isMobileLandscape ? 60 : 80), // Space for instrument names
                    ...List.generate(state.beats, (beatIndex) {
                      return Expanded(
                        child: Container(
                          height: isMobileLandscape ? 20 : 24,
                          margin: EdgeInsets.symmetric(
                            horizontal: isMobileLandscape ? 1 : 2,
                          ),
                          child: Center(
                            child: Text(
                              '${beatIndex + 1}',
                              style: TextStyle(
                                color: secondaryTextColor,
                                fontSize: isMobileLandscape ? 10 : 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),

                SizedBox(height: isMobileLandscape ? 4 : 8),

                // Drum pattern grid - Compact rows for mobile landscape
                Expanded(
                  child: ListView.builder(
                    itemCount: state.instruments.length,
                    itemBuilder: (context, instrumentIndex) {
                      final instrument = state.instruments[instrumentIndex];
                      return Container(
                        height: isMobileLandscape ? 36 : 48,
                        margin: EdgeInsets.only(
                          bottom: isMobileLandscape ? 4 : 6,
                        ),
                        child: Row(
                          children: [
                            // Instrument name - Shorter for mobile
                            SizedBox(
                              width: isMobileLandscape ? 60 : 80,
                              child: Text(
                                instrument.displayName,
                                style: TextStyle(
                                  color: instrument.isActive
                                      ? textColor
                                      : secondaryTextColor,
                                  fontSize: isMobileLandscape ? 10 : 12,
                                  fontWeight: FontWeight.w500,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),

                            // Beat buttons - Optimized touch targets for mobile
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
                                      height: isMobileLandscape ? 32 : 40,
                                      margin: EdgeInsets.symmetric(
                                        horizontal: isMobileLandscape ? 1 : 2,
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
                                              width: isCurrentBeat ? 2 : 1,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              isMobileLandscape ? 6 : 8,
                                            ),
                                          ),
                                          child: Center(
                                            child: isActive
                                                ? Icon(
                                                    Icons.music_note,
                                                    color: isDark
                                                        ? Colors.white
                                                        : Colors.black87,
                                                    size: isMobileLandscape ? 14 : 18,
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
