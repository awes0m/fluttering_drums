import 'package:flutter/material.dart';
import '../viewmodels/drum_view_model.dart';
import '../services/theme_service.dart';

class ControlPanel extends StatelessWidget {
  final DrumViewModel viewModel;

  const ControlPanel({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final state = viewModel.state;
    final screenWidth = MediaQuery.of(context).size.width;
    final isVerySmallScreen = screenWidth < 600;
    final themeService = ThemeService();
    final isDark = themeService.themeMode == ThemeMode.dark;

    final backgroundColor = isDark ? const Color(0xFF2D2D2D) : Colors.white;
    final textColor = isDark ? Colors.white70 : Colors.black54;

    return Container(
      height: isVerySmallScreen ? 100 : 120,
      padding: EdgeInsets.all(isVerySmallScreen ? 8.0 : 16.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Play/Pause Button
            Container(
              width: isVerySmallScreen ? 60 : 80,
              height: isVerySmallScreen ? 60 : 80,
              decoration: BoxDecoration(
                color: state.isPlaying ? Colors.red : Colors.green,
                borderRadius: BorderRadius.circular(
                  isVerySmallScreen ? 30 : 40,
                ),
                boxShadow: [
                  BoxShadow(
                    color: (state.isPlaying ? Colors.red : Colors.green)
                        .withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: IconButton(
                onPressed: viewModel.playPause,
                icon: Icon(
                  state.isPlaying ? Icons.pause : Icons.play_arrow,
                  color: Colors.white,
                  size: isVerySmallScreen ? 30 : 40,
                ),
              ),
            ),

            SizedBox(width: isVerySmallScreen ? 16 : 24),

            // BPM Controls
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'BPM',
                  style: TextStyle(
                    color: textColor,
                    fontSize: isVerySmallScreen ? 12 : 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: isVerySmallScreen ? 4 : 8),
                Row(
                  children: [
                    IconButton(
                      onPressed: () => viewModel.setBpm(state.bpm - 5),
                      icon: Icon(
                        Icons.remove_circle_outline,
                        color: Colors.orange,
                        size: isVerySmallScreen ? 20 : 24,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(
                        minWidth: isVerySmallScreen ? 20 : 24,
                        minHeight: isVerySmallScreen ? 20 : 24,
                      ),
                    ),
                    Container(
                      width: isVerySmallScreen ? 50 : 60,
                      padding: EdgeInsets.symmetric(
                        horizontal: isVerySmallScreen ? 6 : 8,
                        vertical: isVerySmallScreen ? 2 : 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.orange),
                      ),
                      child: Text(
                        '${state.bpm}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.orange,
                          fontSize: isVerySmallScreen ? 16 : 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => viewModel.setBpm(state.bpm + 5),
                      icon: Icon(
                        Icons.add_circle_outline,
                        color: Colors.orange,
                        size: isVerySmallScreen ? 20 : 24,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(
                        minWidth: isVerySmallScreen ? 20 : 24,
                        minHeight: isVerySmallScreen ? 20 : 24,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(width: isVerySmallScreen ? 20 : 32),

            // Beats Controls
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Beats',
                  style: TextStyle(
                    color: textColor,
                    fontSize: isVerySmallScreen ? 12 : 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: isVerySmallScreen ? 4 : 8),
                Row(
                  children: [
                    IconButton(
                      onPressed: () => viewModel.setBeats(state.beats - 1),
                      icon: Icon(
                        Icons.remove_circle_outline,
                        color: Colors.blue,
                        size: isVerySmallScreen ? 20 : 24,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(
                        minWidth: isVerySmallScreen ? 20 : 24,
                        minHeight: isVerySmallScreen ? 20 : 24,
                      ),
                    ),
                    Container(
                      width: isVerySmallScreen ? 50 : 60,
                      padding: EdgeInsets.symmetric(
                        horizontal: isVerySmallScreen ? 6 : 8,
                        vertical: isVerySmallScreen ? 2 : 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue),
                      ),
                      child: Text(
                        '${state.beats}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: isVerySmallScreen ? 16 : 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => viewModel.setBeats(state.beats + 1),
                      icon: Icon(
                        Icons.add_circle_outline,
                        color: Colors.blue,
                        size: isVerySmallScreen ? 20 : 24,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(
                        minWidth: isVerySmallScreen ? 20 : 24,
                        minHeight: isVerySmallScreen ? 20 : 24,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(width: isVerySmallScreen ? 20 : 32),

            // Action Buttons
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Actions',
                  style: TextStyle(
                    color: textColor,
                    fontSize: isVerySmallScreen ? 12 : 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: isVerySmallScreen ? 4 : 8),
                Row(
                  children: [
                    IconButton(
                      onPressed: viewModel.clearPattern,
                      icon: Icon(
                        Icons.clear,
                        color: Colors.red,
                        size: isVerySmallScreen ? 20 : 24,
                      ),
                      tooltip: 'Clear Pattern',
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(
                        minWidth: isVerySmallScreen ? 20 : 24,
                        minHeight: isVerySmallScreen ? 20 : 24,
                      ),
                    ),
                    SizedBox(width: isVerySmallScreen ? 4 : 8),
                    IconButton(
                      onPressed: () => _showSaveDialog(context),
                      icon: Icon(
                        Icons.save,
                        color: Colors.green,
                        size: isVerySmallScreen ? 20 : 24,
                      ),
                      tooltip: 'Save Beat',
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(
                        minWidth: isVerySmallScreen ? 20 : 24,
                        minHeight: isVerySmallScreen ? 20 : 24,
                      ),
                    ),
                    SizedBox(width: isVerySmallScreen ? 4 : 8),
                    IconButton(
                      onPressed: () => _showLoadDialog(context),
                      icon: Icon(
                        Icons.folder_open,
                        color: Colors.blue,
                        size: isVerySmallScreen ? 20 : 24,
                      ),
                      tooltip: 'Load Beat',
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(
                        minWidth: isVerySmallScreen ? 20 : 24,
                        minHeight: isVerySmallScreen ? 20 : 24,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // Current Beat Indicator - Always show if playing, regardless of screen size
            if (state.isPlaying) ...[
              SizedBox(width: isVerySmallScreen ? 20 : 32),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isVerySmallScreen ? 12 : 16,
                  vertical: isVerySmallScreen ? 6 : 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.orange),
                ),
                child: Text(
                  'Beat ${state.currentBeat + 1}',
                  style: TextStyle(
                    color: Colors.orange,
                    fontSize: isVerySmallScreen ? 14 : 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showSaveDialog(BuildContext context) {
    final textController = TextEditingController();
    final themeService = ThemeService();
    final isDark = themeService.themeMode == ThemeMode.dark;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF2D2D2D) : Colors.white,
        title: Text(
          'Save Beat',
          style: TextStyle(color: isDark ? Colors.white : Colors.black87),
        ),
        content: TextField(
          controller: textController,
          decoration: InputDecoration(
            labelText: 'Beat Name',
            labelStyle: TextStyle(
              color: isDark ? Colors.white70 : Colors.black54,
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.orange),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.orange, width: 2),
            ),
          ),
          style: TextStyle(color: isDark ? Colors.white : Colors.black87),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: TextStyle(color: isDark ? Colors.white70 : Colors.black54),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (textController.text.trim().isNotEmpty) {
                viewModel.saveBeat(textController.text.trim());
                Navigator.of(context).pop();
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showLoadDialog(BuildContext context) {
    final state = viewModel.state;
    final themeService = ThemeService();
    final isDark = themeService.themeMode == ThemeMode.dark;

    if (state.savedBeats.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: isDark ? const Color(0xFF2D2D2D) : Colors.white,
          title: Text(
            'No Saved Beats',
            style: TextStyle(color: isDark ? Colors.white : Colors.black87),
          ),
          content: Text(
            'You haven\'t saved any beats yet.',
            style: TextStyle(color: isDark ? Colors.white70 : Colors.black54),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF2D2D2D) : Colors.white,
        title: Text(
          'Load Beat',
          style: TextStyle(color: isDark ? Colors.white : Colors.black87),
        ),
        content: SizedBox(
          width: double.maxFinite,
          height: 300,
          child: ListView.builder(
            itemCount: state.savedBeats.length,
            itemBuilder: (context, index) {
              final beat = state.savedBeats[index];
              return ListTile(
                title: Text(
                  beat.name,
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                subtitle: Text(
                  '${beat.beats} beats, ${beat.bpm} BPM',
                  style: TextStyle(
                    color: isDark ? Colors.white70 : Colors.black54,
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        viewModel.loadBeat(beat);
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.play_arrow, color: Colors.green),
                      tooltip: 'Load',
                    ),
                    IconButton(
                      onPressed: () {
                        viewModel.deleteBeat(beat.name);
                        Navigator.of(context).pop();
                        _showLoadDialog(context);
                      },
                      icon: const Icon(Icons.delete, color: Colors.red),
                      tooltip: 'Delete',
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: TextStyle(color: isDark ? Colors.white70 : Colors.black54),
            ),
          ),
        ],
      ),
    );
  }
}
