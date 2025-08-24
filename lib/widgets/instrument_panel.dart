import 'package:flutter/material.dart';
import '../viewmodels/drum_view_model.dart';
import '../services/theme_service.dart';

class InstrumentPanel extends StatelessWidget {
  final DrumViewModel viewModel;
  final bool isMobileLandscape;

  const InstrumentPanel({
    super.key, 
    required this.viewModel,
    this.isMobileLandscape = false,
  });

  @override
  Widget build(BuildContext context) {
    final state = viewModel.state;
    final themeService = ThemeService();
    final isDark = themeService.themeMode == ThemeMode.dark;

    if (state.instruments.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.orange),
      );
    }

    final backgroundColor = isDark ? const Color(0xFF2D2D2D) : Colors.white;
    final headerColor = isDark
        ? const Color(0xFF3D3D3D)
        : (Colors.grey[100] ?? Colors.grey.shade100);
    final textColor = isDark ? Colors.white : Colors.black87;
    final secondaryTextColor = isDark ? Colors.white54 : Colors.black54;
    final borderColor = isDark
        ? Colors.white30
        : (Colors.grey[300] ?? Colors.grey.shade300);

    // Fixed width - no more collapsing
    final panelWidth = isMobileLandscape ? 120.0 : 160.0;

    return Container(
      width: panelWidth,
      margin: EdgeInsets.all(isMobileLandscape ? 4.0 : 8.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Modern Header Design
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: isMobileLandscape ? 8.0 : 12.0,
              vertical: isMobileLandscape ? 8.0 : 12.0,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.orange.withOpacity(0.8),
                  Colors.deepOrange.withOpacity(0.6),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.library_music,
                  color: Colors.white,
                  size: isMobileLandscape ? 16 : 20,
                ),
                SizedBox(width: isMobileLandscape ? 6 : 8),
                Expanded(
                  child: Text(
                    'Instruments',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isMobileLandscape ? 12 : 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Instruments List with improved design
          Expanded(
            child: _buildInstrumentsList(
              isDark,
              textColor,
              secondaryTextColor,
              borderColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstrumentsList(
    bool isDark,
    Color textColor,
    Color secondaryTextColor,
    Color borderColor,
  ) {
    final state = viewModel.state;

    return ListView.builder(
      padding: EdgeInsets.all(isMobileLandscape ? 6.0 : 8.0),
      itemCount: state.instruments.length,
      itemBuilder: (context, index) {
        final instrument = state.instruments[index];
        return Container(
          margin: EdgeInsets.only(bottom: isMobileLandscape ? 4.0 : 6.0),
          padding: EdgeInsets.all(isMobileLandscape ? 6.0 : 8.0),
          decoration: BoxDecoration(
            color: instrument.isActive 
                ? Colors.orange.withOpacity(0.1)
                : (isDark ? Colors.grey[800] : Colors.grey[50]),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: instrument.isActive 
                  ? Colors.orange.withOpacity(0.3)
                  : borderColor.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              // Modern Toggle Switch
              GestureDetector(
                onTap: () => viewModel.toggleInstrument(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: isMobileLandscape ? 20 : 24,
                  height: isMobileLandscape ? 20 : 24,
                  decoration: BoxDecoration(
                    gradient: instrument.isActive
                        ? LinearGradient(
                            colors: [Colors.green, Colors.green.shade400],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : LinearGradient(
                            colors: [Colors.grey, Colors.grey.shade400],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: (instrument.isActive ? Colors.green : Colors.grey)
                            .withOpacity(0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: instrument.isActive
                      ? Icon(
                          Icons.check,
                          color: Colors.white,
                          size: isMobileLandscape ? 12 : 14,
                        )
                      : null,
                ),
              ),

              SizedBox(width: isMobileLandscape ? 6 : 8),

              // Instrument Name with better typography
              Expanded(
                child: Text(
                  instrument.displayName,
                  style: TextStyle(
                    color: instrument.isActive ? textColor : secondaryTextColor,
                    fontSize: isMobileLandscape ? 10 : 12,
                    fontWeight: instrument.isActive 
                        ? FontWeight.w600 
                        : FontWeight.w500,
                    letterSpacing: 0.3,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),

              SizedBox(width: isMobileLandscape ? 4 : 6),

              // Modern Play Button
              GestureDetector(
                onTap: () => viewModel.playInstrument(index),
                child: Container(
                  width: isMobileLandscape ? 20 : 24,
                  height: isMobileLandscape ? 20 : 24,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.orange.withOpacity(0.8),
                        Colors.deepOrange.withOpacity(0.6),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.orange.withOpacity(0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                    size: isMobileLandscape ? 12 : 14,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}