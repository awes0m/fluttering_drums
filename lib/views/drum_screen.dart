import 'package:flutter/material.dart';
import '../viewmodels/drum_view_model.dart';
import '../services/theme_service.dart';
import '../widgets/drum_grid.dart';
import '../widgets/control_panel.dart';
import '../widgets/instrument_panel.dart';

class DrumScreen extends StatefulWidget {
  const DrumScreen({super.key});

  @override
  State<DrumScreen> createState() => _DrumScreenState();
}

class _DrumScreenState extends State<DrumScreen> {
  late DrumViewModel _viewModel;
  late ThemeService _themeService;

  @override
  void initState() {
    super.initState();
    _viewModel = DrumViewModel();
    _themeService = ThemeService();
    _viewModel.addListener(_onViewModelChanged);
    _themeService.addListener(_onThemeChanged);
    _viewModel.initialize();
    _themeService.initialize();
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChanged);
    _themeService.removeListener(_onThemeChanged);
    _viewModel.dispose();
    super.dispose();
  }

  void _onViewModelChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  void _onThemeChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = _themeService.themeMode == ThemeMode.dark;
    final backgroundColor = isDark ? const Color(0xFF1A1A1A) : Colors.grey[50];
    final headerColor = isDark ? const Color(0xFF2D2D2D) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: EdgeInsets.all(isSmallScreen ? 12.0 : 16.0),
              decoration: BoxDecoration(
                color: headerColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.music_note,
                    color: Colors.orange,
                    size: isSmallScreen ? 24 : 32,
                  ),
                  SizedBox(width: isSmallScreen ? 8 : 12),
                  Expanded(
                    child: Text(
                      'Fluttering Drums',
                      style: TextStyle(
                        color: textColor,
                        fontSize: isSmallScreen ? 18 : 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ),
                  if (!isSmallScreen) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.orange),
                      ),
                      child: Text(
                        '${_viewModel.state.bpm} BPM',
                        style: const TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                  ],
                  // Theme Toggle Button
                  IconButton(
                    onPressed: _themeService.toggleTheme,
                    icon: Icon(
                      isDark ? Icons.light_mode : Icons.dark_mode,
                      color: Colors.orange,
                      size: isSmallScreen ? 20 : 24,
                    ),
                    tooltip: isDark
                        ? 'Switch to Light Mode'
                        : 'Switch to Dark Mode',
                  ),
                ],
              ),
            ),

            // Main Content
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Row(
                    children: [
                      // Left Panel - Instruments (Always visible, collapsible)
                      InstrumentPanel(viewModel: _viewModel),

                      // Center - Drum Grid
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.all(isSmallScreen ? 8.0 : 16.0),
                          decoration: BoxDecoration(
                            color: headerColor,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: DrumGrid(viewModel: _viewModel),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            // Bottom Control Panel
            ControlPanel(viewModel: _viewModel),
          ],
        ),
      ),
    );
  }
}
