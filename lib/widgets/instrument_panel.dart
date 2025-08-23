import 'package:flutter/material.dart';
import '../viewmodels/drum_view_model.dart';
import '../services/theme_service.dart';

class InstrumentPanel extends StatefulWidget {
  final DrumViewModel viewModel;

  const InstrumentPanel({super.key, required this.viewModel});

  @override
  State<InstrumentPanel> createState() => _InstrumentPanelState();
}

class _InstrumentPanelState extends State<InstrumentPanel> {
  bool _isCollapsed = false;

  @override
  Widget build(BuildContext context) {
    final state = widget.viewModel.state;
    final screenWidth = MediaQuery.of(context).size.width;
    final themeService = ThemeService();
    final isDark = themeService.themeMode == ThemeMode.dark;

    // Auto-collapse on very narrow screens, but keep visible
    if (screenWidth < 500 && !_isCollapsed) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _isCollapsed = true;
          });
        }
      });
    }

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

    // Responsive width based on screen size
    final maxWidth = screenWidth < 600 ? 160.0 : 200.0;
    final collapsedWidth = screenWidth < 600 ? 50.0 : 60.0;
    final currentWidth = _isCollapsed ? collapsedWidth : maxWidth;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: currentWidth,
      margin: EdgeInsets.all(screenWidth < 600 ? 8.0 : 16.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header with collapse button
          Container(
            padding: EdgeInsets.all(screenWidth < 600 ? 12.0 : 16.0),
            decoration: BoxDecoration(
              color: headerColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                if (!_isCollapsed) ...[
                  Icon(
                    Icons.music_note,
                    color: Colors.orange,
                    size: screenWidth < 600 ? 16 : 20,
                  ),
                  SizedBox(width: screenWidth < 600 ? 6 : 8),
                  Expanded(
                    child: Text(
                      'Instruments',
                      style: TextStyle(
                        color: textColor,
                        fontSize: screenWidth < 600 ? 14 : 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
                IconButton(
                  onPressed: () {
                    if (mounted) {
                      setState(() {
                        _isCollapsed = !_isCollapsed;
                      });
                    }
                  },
                  icon: Icon(
                    _isCollapsed ? Icons.chevron_right : Icons.chevron_left,
                    color: Colors.orange,
                    size: screenWidth < 600 ? 18 : 20,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(
                    minWidth: screenWidth < 600 ? 20 : 24,
                    minHeight: screenWidth < 600 ? 20 : 24,
                  ),
                ),
              ],
            ),
          ),

          // Instruments List
          Expanded(
            child: _isCollapsed
                ? _buildCollapsedView(
                    isDark,
                    textColor,
                    secondaryTextColor,
                    borderColor,
                    screenWidth,
                  )
                : _buildExpandedView(
                    isDark,
                    textColor,
                    secondaryTextColor,
                    borderColor,
                    screenWidth,
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandedView(
    bool isDark,
    Color textColor,
    Color secondaryTextColor,
    Color borderColor,
    double screenWidth,
  ) {
    final state = widget.viewModel.state;
    final isSmallScreen = screenWidth < 600;

    return ListView.builder(
      padding: EdgeInsets.all(isSmallScreen ? 12.0 : 16.0),
      itemCount: state.instruments.length,
      itemBuilder: (context, index) {
        final instrument = state.instruments[index];
        return Container(
          margin: EdgeInsets.only(bottom: isSmallScreen ? 8.0 : 12.0),
          child: Column(
            children: [
              // Instrument Row
              Row(
                children: [
                  // Toggle Button
                  GestureDetector(
                    onTap: () => widget.viewModel.toggleInstrument(index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: isSmallScreen ? 20 : 24,
                      height: isSmallScreen ? 20 : 24,
                      decoration: BoxDecoration(
                        color: instrument.isActive ? Colors.green : Colors.grey,
                        borderRadius: BorderRadius.circular(
                          isSmallScreen ? 10 : 12,
                        ),
                        border: Border.all(color: borderColor, width: 2),
                      ),
                      child: instrument.isActive
                          ? Icon(
                              Icons.check,
                              color: isDark ? Colors.white : Colors.black87,
                              size: isSmallScreen ? 12 : 16,
                            )
                          : null,
                    ),
                  ),

                  SizedBox(width: isSmallScreen ? 8 : 12),

                  // Instrument Name
                  Expanded(
                    child: Text(
                      instrument.displayName,
                      style: TextStyle(
                        color: instrument.isActive
                            ? textColor
                            : secondaryTextColor,
                        fontSize: isSmallScreen ? 12 : 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  // Play Button
                  GestureDetector(
                    onTap: () => widget.viewModel.playInstrument(index),
                    child: Container(
                      width: isSmallScreen ? 28 : 32,
                      height: isSmallScreen ? 28 : 32,
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(
                          isSmallScreen ? 14 : 16,
                        ),
                        border: Border.all(color: Colors.orange),
                      ),
                      child: Icon(
                        Icons.play_arrow,
                        color: Colors.orange,
                        size: isSmallScreen ? 16 : 20,
                      ),
                    ),
                  ),
                ],
              ),

              // Divider
              if (index < state.instruments.length - 1)
                Container(
                  margin: EdgeInsets.only(top: isSmallScreen ? 8 : 12),
                  height: 1,
                  color: borderColor,
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCollapsedView(
    bool isDark,
    Color textColor,
    Color secondaryTextColor,
    Color borderColor,
    double screenWidth,
  ) {
    final state = widget.viewModel.state;
    final isSmallScreen = screenWidth < 600;

    return ListView.builder(
      padding: EdgeInsets.symmetric(
        vertical: isSmallScreen ? 6 : 8,
        horizontal: isSmallScreen ? 4 : 8,
      ),
      itemCount: state.instruments.length,
      itemBuilder: (context, index) {
        final instrument = state.instruments[index];
        return Container(
          margin: EdgeInsets.symmetric(vertical: isSmallScreen ? 2 : 4),
          child: Column(
            children: [
              // Toggle Button
              GestureDetector(
                onTap: () => widget.viewModel.toggleInstrument(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: isSmallScreen ? 28 : 32,
                  height: isSmallScreen ? 28 : 32,
                  decoration: BoxDecoration(
                    color: instrument.isActive ? Colors.green : Colors.grey,
                    borderRadius: BorderRadius.circular(
                      isSmallScreen ? 14 : 16,
                    ),
                    border: Border.all(color: borderColor, width: 2),
                  ),
                  child: instrument.isActive
                      ? Icon(
                          Icons.check,
                          color: isDark ? Colors.white : Colors.black87,
                          size: isSmallScreen ? 12 : 16,
                        )
                      : null,
                ),
              ),

              // Play Button
              SizedBox(height: isSmallScreen ? 2 : 4),
              GestureDetector(
                onTap: () => widget.viewModel.playInstrument(index),
                child: Container(
                  width: isSmallScreen ? 20 : 24,
                  height: isSmallScreen ? 20 : 24,
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(
                      isSmallScreen ? 10 : 12,
                    ),
                    border: Border.all(color: Colors.orange),
                  ),
                  child: Icon(
                    Icons.play_arrow,
                    color: Colors.orange,
                    size: isSmallScreen ? 10 : 14,
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
