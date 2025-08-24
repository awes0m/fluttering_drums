import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
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
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;

    // Mobile landscape detection - prioritize height over width for mobile landscape
    final isMobileLandscape = screenHeight < 600 && screenWidth > screenHeight;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Compact Header for mobile landscape
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: isMobileLandscape ? 8.0 : 16.0,
                vertical: isMobileLandscape ? 4.0 : 8.0,
              ),
              decoration: BoxDecoration(
                color: headerColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.music_note,
                    color: Colors.orange,
                    size: isMobileLandscape ? 20 : 24,
                  ),
                  SizedBox(width: isMobileLandscape ? 6 : 8),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        launchUrl(Uri.parse('https://awes0m.github.io'));
                      },
                      child: Text(
                        'aweSom ❤️ Fluttering Drums',
                        style: TextStyle(
                          color: textColor,
                          fontSize: isMobileLandscape ? 16 : 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Roboto',
                        ),
                      ),
                    ),
                  ),
                  // Always show BPM in landscape for quick reference
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobileLandscape ? 8 : 12,
                      vertical: isMobileLandscape ? 3 : 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.orange),
                    ),
                    child: Text(
                      '${_viewModel.state.bpm} BPM',
                      style: TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                        fontSize: isMobileLandscape ? 12 : 14,
                      ),
                    ),
                  ),
                  SizedBox(width: isMobileLandscape ? 8 : 12),
                  // Theme Toggle Button
                  IconButton(
                    onPressed: _themeService.toggleTheme,
                    icon: Icon(
                      isDark ? Icons.light_mode : Icons.dark_mode,
                      color: Colors.orange,
                      size: isMobileLandscape ? 18 : 20,
                    ),
                    tooltip: isDark
                        ? 'Switch to Light Mode'
                        : 'Switch to Dark Mode',
                    padding: EdgeInsets.all(isMobileLandscape ? 4 : 8),
                    constraints: BoxConstraints(
                      minWidth: isMobileLandscape ? 32 : 40,
                      minHeight: isMobileLandscape ? 32 : 40,
                    ),
                  ),
                ],
              ),
            ),

            // Main Content - Optimized for landscape
            Expanded(
              child: Row(
                children: [
                  // Left Panel - Instruments (Collapsible for mobile)
                  InstrumentPanel(
                    viewModel: _viewModel,
                    isMobileLandscape: isMobileLandscape,
                  ),

                  // Center - Drum Grid (Takes most space)
                  Expanded(
                    flex: isMobileLandscape ? 3 : 2,
                    child: Container(
                      margin: EdgeInsets.all(isMobileLandscape ? 4.0 : 8.0),
                      decoration: BoxDecoration(
                        color: headerColor,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: DrumGrid(
                        viewModel: _viewModel,
                        isMobileLandscape: isMobileLandscape,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Bottom Control Panel - Compact for mobile landscape
            ControlPanel(
              viewModel: _viewModel,
              isMobileLandscape: isMobileLandscape,
            ),
          ],
        ),
      ),
    );
  }
}
