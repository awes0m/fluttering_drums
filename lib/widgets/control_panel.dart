import 'package:flutter/material.dart';
import '../viewmodels/drum_view_model.dart';
import '../services/theme_service.dart';

class ControlPanel extends StatelessWidget {
  final DrumViewModel viewModel;
  final bool isMobileLandscape;

  const ControlPanel({
    super.key, 
    required this.viewModel,
    this.isMobileLandscape = false,
  });

  @override
  Widget build(BuildContext context) {
    final state = viewModel.state;
    final themeService = ThemeService();
    final isDark = themeService.themeMode == ThemeMode.dark;

    final backgroundColor = isDark ? const Color(0xFF2D2D2D) : Colors.white;
    final textColor = isDark ? Colors.white70 : Colors.black54;

    // Compact layout for mobile landscape
    final controlHeight = isMobileLandscape ? 60.0 : 80.0;
    final buttonSize = isMobileLandscape ? 40.0 : 50.0;
    final iconSize = isMobileLandscape ? 20.0 : 24.0;
    final fontSize = isMobileLandscape ? 10.0 : 12.0;
    final spacing = isMobileLandscape ? 8.0 : 12.0;

    return Container(
      height: controlHeight,
      padding: EdgeInsets.symmetric(
        horizontal: isMobileLandscape ? 6.0 : 12.0,
        vertical: isMobileLandscape ? 4.0 : 8.0,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Play/Pause Button - Compact for mobile landscape
            Container(
              width: buttonSize,
              height: buttonSize,
              decoration: BoxDecoration(
                color: state.isPlaying ? Colors.red : Colors.green,
                borderRadius: BorderRadius.circular(buttonSize / 2),
                boxShadow: [
                  BoxShadow(
                    color: (state.isPlaying ? Colors.red : Colors.green)
                        .withOpacity(0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                onPressed: viewModel.playPause,
                icon: Icon(
                  state.isPlaying ? Icons.pause : Icons.play_arrow,
                  color: Colors.white,
                  size: iconSize,
                ),
                padding: EdgeInsets.zero,
              ),
            ),

            SizedBox(width: spacing),

            // BPM Controls - Horizontal layout for mobile landscape
            if (isMobileLandscape) ...[
              Text(
                'BPM',
                style: TextStyle(
                  color: textColor,
                  fontSize: fontSize,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 4),
              IconButton(
                onPressed: () => viewModel.setBpm(state.bpm - 5),
                icon: const Icon(
                  Icons.remove_circle_outline,
                  color: Colors.orange,
                  size: 16,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(
                  minWidth: 24,
                  minHeight: 24,
                ),
              ),
              Container(
                width: 40,
                padding: const EdgeInsets.symmetric(
                  horizontal: 4,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.orange),
                ),
                child: Text(
                  '${state.bpm}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.orange,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => viewModel.setBpm(state.bpm + 5),
                icon: const Icon(
                  Icons.add_circle_outline,
                  color: Colors.orange,
                  size: 16,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(
                  minWidth: 24,
                  minHeight: 24,
                ),
              ),
            ] else ...[
              // Vertical layout for larger screens
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'BPM',
                    style: TextStyle(
                      color: textColor,
                      fontSize: fontSize,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => viewModel.setBpm(state.bpm - 5),
                        icon: Icon(
                          Icons.remove_circle_outline,
                          color: Colors.orange,
                          size: iconSize,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(
                          minWidth: iconSize,
                          minHeight: iconSize,
                        ),
                      ),
                      Container(
                        width: 50,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.orange),
                        ),
                        child: Text(
                          '${state.bpm}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.orange,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => viewModel.setBpm(state.bpm + 5),
                        icon: Icon(
                          Icons.add_circle_outline,
                          color: Colors.orange,
                          size: iconSize,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(
                          minWidth: iconSize,
                          minHeight: iconSize,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],

            SizedBox(width: spacing),

            // Beats Controls - Similar responsive layout
            if (isMobileLandscape) ...[
              Text(
                'Beats',
                style: TextStyle(
                  color: textColor,
                  fontSize: fontSize,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 4),
              IconButton(
                onPressed: () => viewModel.setBeats(state.beats - 1),
                icon: const Icon(
                  Icons.remove_circle_outline,
                  color: Colors.blue,
                  size: 16,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(
                  minWidth: 24,
                  minHeight: 24,
                ),
              ),
              Container(
                width: 40,
                padding: const EdgeInsets.symmetric(
                  horizontal: 4,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.blue),
                ),
                child: Text(
                  '${state.beats}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.blue,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => viewModel.setBeats(state.beats + 1),
                icon: const Icon(
                  Icons.add_circle_outline,
                  color: Colors.blue,
                  size: 16,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(
                  minWidth: 24,
                  minHeight: 24,
                ),
              ),
            ] else ...[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Beats',
                    style: TextStyle(
                      color: textColor,
                      fontSize: fontSize,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => viewModel.setBeats(state.beats - 1),
                        icon: Icon(
                          Icons.remove_circle_outline,
                          color: Colors.blue,
                          size: iconSize,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(
                          minWidth: iconSize,
                          minHeight: iconSize,
                        ),
                      ),
                      Container(
                        width: 50,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.blue),
                        ),
                        child: Text(
                          '${state.beats}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.blue,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => viewModel.setBeats(state.beats + 1),
                        icon: Icon(
                          Icons.add_circle_outline,
                          color: Colors.blue,
                          size: iconSize,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(
                          minWidth: iconSize,
                          minHeight: iconSize,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],

            SizedBox(width: spacing),

            // Action Buttons - Horizontal for mobile landscape
            Row(
              children: [
                IconButton(
                  onPressed: viewModel.clearPattern,
                  icon: Icon(
                    Icons.clear,
                    color: Colors.red,
                    size: isMobileLandscape ? 18 : iconSize,
                  ),
                  tooltip: 'Clear Pattern',
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(
                    minWidth: isMobileLandscape ? 28 : 32,
                    minHeight: isMobileLandscape ? 28 : 32,
                  ),
                ),
                SizedBox(width: isMobileLandscape ? 4 : 6),
                IconButton(
                  onPressed: () => _showSaveDialog(context),
                  icon: Icon(
                    Icons.save,
                    color: Colors.green,
                    size: isMobileLandscape ? 18 : iconSize,
                  ),
                  tooltip: 'Save Beat',
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(
                    minWidth: isMobileLandscape ? 28 : 32,
                    minHeight: isMobileLandscape ? 28 : 32,
                  ),
                ),
                SizedBox(width: isMobileLandscape ? 4 : 6),
                IconButton(
                  onPressed: () => _showLoadDialog(context),
                  icon: Icon(
                    Icons.folder_open,
                    color: Colors.blue,
                    size: isMobileLandscape ? 18 : iconSize,
                  ),
                  tooltip: 'Load Beat',
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(
                    minWidth: isMobileLandscape ? 28 : 32,
                    minHeight: isMobileLandscape ? 28 : 32,
                  ),
                ),
                SizedBox(width: isMobileLandscape ? 4 : 6),
                IconButton(
                  onPressed: () => _showExportDialog(context),
                  icon: Icon(
                    Icons.download,
                    color: Colors.purple,
                    size: isMobileLandscape ? 18 : iconSize,
                  ),
                  tooltip: 'Export as MP3',
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(
                    minWidth: isMobileLandscape ? 28 : 32,
                    minHeight: isMobileLandscape ? 28 : 32,
                  ),
                ),
              ],
            ),

            // Current Beat Indicator - Compact for mobile landscape
            if (state.isPlaying) ...[
              SizedBox(width: spacing),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobileLandscape ? 8 : 12,
                  vertical: isMobileLandscape ? 4 : 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.orange),
                ),
                child: Text(
                  'Beat ${state.currentBeat + 1}',
                  style: TextStyle(
                    color: Colors.orange,
                    fontSize: isMobileLandscape ? 10 : 12,
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
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.orange),
            ),
            focusedBorder: const OutlineInputBorder(
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
                        Navigator.of(context).pop();
                        _showExportSavedBeatDialog(context, beat);
                      },
                      icon: const Icon(Icons.download, color: Colors.purple),
                      tooltip: 'Export as MP3',
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

  void _showExportDialog(BuildContext context) {
    final textController = TextEditingController();
    final repetitionsController = TextEditingController();
    final themeService = ThemeService();
    final isDark = themeService.themeMode == ThemeMode.dark;

    // Set default filename with timestamp
    final now = DateTime.now();
    final defaultName = 'beat_${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}_${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}';
    textController.text = defaultName;
    repetitionsController.text = '1'; // Default repetitions

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF2D2D2D) : Colors.white,
        title: Row(
          children: [
            Icon(
              Icons.download,
              color: Colors.purple,
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              'Export Beat as MP3',
              style: TextStyle(color: isDark ? Colors.white : Colors.black87),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Enter a filename for your beat:',
                style: TextStyle(
                  color: isDark ? Colors.white70 : Colors.black54,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: textController,
                decoration: InputDecoration(
                  labelText: 'Filename',
                  suffixText: '.mp3',
                  labelStyle: TextStyle(
                    color: isDark ? Colors.white70 : Colors.black54,
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.purple),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.purple, width: 2),
                  ),
                ),
                style: TextStyle(color: isDark ? Colors.white : Colors.black87),
              ),
              const SizedBox(height: 16),
              Text(
                'Number of repetitions (1-25):',
                style: TextStyle(
                  color: isDark ? Colors.white70 : Colors.black54,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: repetitionsController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Repetitions',
                  hintText: 'Enter 1-25',
                  labelStyle: TextStyle(
                    color: isDark ? Colors.white70 : Colors.black54,
                  ),
                  hintStyle: TextStyle(
                    color: isDark ? Colors.white38 : Colors.black38,
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.orange),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.orange, width: 2),
                  ),
                ),
                style: TextStyle(color: isDark ? Colors.white : Colors.black87),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.repeat,
                      color: Colors.orange,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'The beat pattern will loop the specified number of times',
                        style: TextStyle(
                          color: isDark ? Colors.white70 : Colors.black54,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.purple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.purple.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.purple,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'The file will be saved to your Downloads folder',
                        style: TextStyle(
                          color: isDark ? Colors.white70 : Colors.black54,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
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
          ElevatedButton(
            onPressed: () async {
              if (textController.text.trim().isNotEmpty) {
                final repetitions = int.tryParse(repetitionsController.text) ?? 1;
                if (repetitions >= 1 && repetitions <= 25) {
                  Navigator.of(context).pop();
                  await _exportCurrentBeat(context, textController.text.trim(), repetitions);
                } else {
                  // Show error for invalid repetitions
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please enter a number between 1 and 25 for repetitions'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple,
              foregroundColor: Colors.white,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.download, size: 18),
                const SizedBox(width: 4),
                const Text('Export'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _exportCurrentBeat(BuildContext context, String fileName, int repetitions) async {
    final themeService = ThemeService();
    final isDark = themeService.themeMode == ThemeMode.dark;

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF2D2D2D) : Colors.white,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(color: Colors.purple),
            const SizedBox(height: 16),
            Text(
              'Exporting beat with $repetitions repetition${repetitions > 1 ? 's' : ''}...',
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );

    try {
      final filePath = await viewModel.exportCurrentBeatToMp3(fileName, repetitions: repetitions);
      
      // Close loading dialog
      if (context.mounted) {
        Navigator.of(context).pop();
      }

      if (filePath != null) {
        // Show success dialog
        if (context.mounted) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              backgroundColor: isDark ? const Color(0xFF2D2D2D) : Colors.white,
              title: Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Export Successful!',
                    style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your beat has been exported successfully with $repetitions repetition${repetitions > 1 ? 's' : ''}!',
                    style: TextStyle(
                      color: isDark ? Colors.white70 : Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'File: $fileName.mp3',
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black87,
                        fontFamily: 'monospace',
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
      } else {
        // Show error dialog
        if (context.mounted) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              backgroundColor: isDark ? const Color(0xFF2D2D2D) : Colors.white,
              title: Row(
                children: [
                  Icon(
                    Icons.error,
                    color: Colors.red,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Export Failed',
                    style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                  ),
                ],
              ),
              content: Text(
                'Failed to export the beat. Please check permissions and try again.',
                style: TextStyle(
                  color: isDark ? Colors.white70 : Colors.black54,
                ),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
      }
    } catch (e) {
      // Close loading dialog
      if (context.mounted) {
        Navigator.of(context).pop();
      }

      // Show error dialog
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: isDark ? const Color(0xFF2D2D2D) : Colors.white,
            title: Row(
              children: [
                Icon(
                  Icons.error,
                  color: Colors.red,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Export Error',
                  style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                ),
              ],
            ),
            content: Text(
              'An error occurred while exporting: ${e.toString()}',
              style: TextStyle(
                color: isDark ? Colors.white70 : Colors.black54,
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  void _showExportSavedBeatDialog(BuildContext context, beat) {
    final textController = TextEditingController();
    final repetitionsController = TextEditingController();
    final themeService = ThemeService();
    final isDark = themeService.themeMode == ThemeMode.dark;

    // Set default filename based on beat name
    textController.text = beat.name.replaceAll(' ', '_').toLowerCase();
    repetitionsController.text = '1'; // Default repetitions

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF2D2D2D) : Colors.white,
        title: Row(
          children: [
            Icon(
              Icons.download,
              color: Colors.purple,
              size: 24,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Export "${beat.name}" as MP3',
                style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Beat Details:',
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '• ${beat.beats} beats\n• ${beat.bpm} BPM',
                    style: TextStyle(
                      color: isDark ? Colors.white70 : Colors.black54,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Enter a filename for export:',
              style: TextStyle(
                color: isDark ? Colors.white70 : Colors.black54,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: textController,
              decoration: InputDecoration(
                labelText: 'Filename',
                suffixText: '.mp3',
                labelStyle: TextStyle(
                  color: isDark ? Colors.white70 : Colors.black54,
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.purple),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.purple, width: 2),
                ),
              ),
              style: TextStyle(color: isDark ? Colors.white : Colors.black87),
            ),
            const SizedBox(height: 16),
            Text(
              'Number of repetitions (1-25):',
              style: TextStyle(
                color: isDark ? Colors.white70 : Colors.black54,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: repetitionsController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Repetitions',
                hintText: 'Enter 1-25',
                labelStyle: TextStyle(
                  color: isDark ? Colors.white70 : Colors.black54,
                ),
                hintStyle: TextStyle(
                  color: isDark ? Colors.white38 : Colors.black38,
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.orange),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.orange, width: 2),
                ),
              ),
              style: TextStyle(color: isDark ? Colors.white : Colors.black87),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.repeat,
                    color: Colors.orange,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'The beat pattern will loop the specified number of times',
                      style: TextStyle(
                        color: isDark ? Colors.white70 : Colors.black54,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.purple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.purple.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Colors.purple,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'The file will be saved to your Downloads folder',
                      style: TextStyle(
                        color: isDark ? Colors.white70 : Colors.black54,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
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
            onPressed: () async {
              if (textController.text.trim().isNotEmpty) {
                final repetitions = int.tryParse(repetitionsController.text) ?? 1;
                if (repetitions >= 1 && repetitions <= 25) {
                  Navigator.of(context).pop();
                  await _exportSavedBeat(context, beat, textController.text.trim(), repetitions);
                } else {
                  // Show error for invalid repetitions
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please enter a number between 1 and 25 for repetitions'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple,
              foregroundColor: Colors.white,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.download, size: 18),
                const SizedBox(width: 4),
                const Text('Export'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _exportSavedBeat(BuildContext context, beat, String fileName, int repetitions) async {
    final themeService = ThemeService();
    final isDark = themeService.themeMode == ThemeMode.dark;

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF2D2D2D) : Colors.white,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(color: Colors.purple),
            const SizedBox(height: 16),
            Text(
              'Exporting "${beat.name}" with $repetitions repetition${repetitions > 1 ? 's' : ''}...',
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );

    try {
      final filePath = await viewModel.exportSavedBeatToMp3(beat, fileName, repetitions: repetitions);
      
      // Close loading dialog
      if (context.mounted) {
        Navigator.of(context).pop();
      }

      if (filePath != null) {
        // Show success dialog
        if (context.mounted) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              backgroundColor: isDark ? const Color(0xFF2D2D2D) : Colors.white,
              title: Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Export Successful!',
                    style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Beat "${beat.name}" has been exported successfully with $repetitions repetition${repetitions > 1 ? 's' : ''}!',
                    style: TextStyle(
                      color: isDark ? Colors.white70 : Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'File: $fileName.mp3',
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black87,
                        fontFamily: 'monospace',
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
      } else {
        // Show error dialog
        if (context.mounted) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              backgroundColor: isDark ? const Color(0xFF2D2D2D) : Colors.white,
              title: Row(
                children: [
                  Icon(
                    Icons.error,
                    color: Colors.red,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Export Failed',
                    style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                  ),
                ],
              ),
              content: Text(
                'Failed to export the beat. Please check permissions and try again.',
                style: TextStyle(
                  color: isDark ? Colors.white70 : Colors.black54,
                ),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
      }
    } catch (e) {
      // Close loading dialog
      if (context.mounted) {
        Navigator.of(context).pop();
      }

      // Show error dialog
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: isDark ? const Color(0xFF2D2D2D) : Colors.white,
            title: Row(
              children: [
                Icon(
                  Icons.error,
                  color: Colors.red,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Export Error',
                  style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                ),
              ],
            ),
            content: Text(
              'An error occurred while exporting: ${e.toString()}',
              style: TextStyle(
                color: isDark ? Colors.white70 : Colors.black54,
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }
}