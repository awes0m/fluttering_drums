import 'package:flutter/material.dart';
import '../viewmodels/drum_view_model.dart';

class ControlPanel extends StatelessWidget {
  final DrumViewModel viewModel;

  const ControlPanel({
    super.key,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    final state = viewModel.state;
    
    return Container(
      height: 120,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2D2D2D),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Play/Pause Button
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: state.isPlaying ? Colors.red : Colors.green,
              borderRadius: BorderRadius.circular(40),
              boxShadow: [
                BoxShadow(
                  color: (state.isPlaying ? Colors.red : Colors.green).withOpacity(0.3),
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
                size: 40,
              ),
            ),
          ),
          
          const SizedBox(width: 24),
          
          // BPM Controls
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'BPM',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  IconButton(
                    onPressed: () => viewModel.setBpm(state.bpm - 5),
                    icon: const Icon(
                      Icons.remove_circle_outline,
                      color: Colors.orange,
                      size: 24,
                    ),
                  ),
                  Container(
                    width: 60,
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => viewModel.setBpm(state.bpm + 5),
                    icon: const Icon(
                      Icons.add_circle_outline,
                      color: Colors.orange,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          const SizedBox(width: 32),
          
          // Beats Controls
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Beats',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  IconButton(
                    onPressed: () => viewModel.setBeats(state.beats - 1),
                    icon: const Icon(
                      Icons.remove_circle_outline,
                      color: Colors.blue,
                      size: 24,
                    ),
                  ),
                  Container(
                    width: 60,
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => viewModel.setBeats(state.beats + 1),
                    icon: const Icon(
                      Icons.add_circle_outline,
                      color: Colors.blue,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          const SizedBox(width: 32),
          
          // Action Buttons
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Actions',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  IconButton(
                    onPressed: viewModel.clearPattern,
                    icon: const Icon(
                      Icons.clear,
                      color: Colors.red,
                      size: 24,
                    ),
                    tooltip: 'Clear Pattern',
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () => _showSaveDialog(context),
                    icon: const Icon(
                      Icons.save,
                      color: Colors.green,
                      size: 24,
                    ),
                    tooltip: 'Save Beat',
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () => _showLoadDialog(context),
                    icon: const Icon(
                      Icons.folder_open,
                      color: Colors.blue,
                      size: 24,
                    ),
                    tooltip: 'Load Beat',
                  ),
                ],
              ),
            ],
          ),
          
          const Spacer(),
          
          // Current Beat Indicator
          if (state.isPlaying)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.orange),
              ),
              child: Text(
                'Beat ${state.currentBeat + 1}',
                style: const TextStyle(
                  color: Colors.orange,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showSaveDialog(BuildContext context) {
    final textController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2D2D2D),
        title: const Text(
          'Save Beat',
          style: TextStyle(color: Colors.white),
        ),
        content: TextField(
          controller: textController,
          decoration: const InputDecoration(
            labelText: 'Beat Name',
            labelStyle: TextStyle(color: Colors.white70),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.orange),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.orange, width: 2),
            ),
          ),
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel', style: TextStyle(color: Colors.white70)),
          ),
          ElevatedButton(
            onPressed: () {
              if (textController.text.trim().isNotEmpty) {
                viewModel.saveBeat(textController.text.trim());
                Navigator.of(context).pop();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
            ),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showLoadDialog(BuildContext context) {
    final state = viewModel.state;
    
    if (state.savedBeats.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: const Color(0xFF2D2D2D),
          title: const Text(
            'No Saved Beats',
            style: TextStyle(color: Colors.white),
          ),
          content: const Text(
            'You haven\'t saved any beats yet.',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
              ),
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
        backgroundColor: const Color(0xFF2D2D2D),
        title: const Text(
          'Load Beat',
          style: TextStyle(color: Colors.white),
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
                  style: const TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  '${beat.beats} beats, ${beat.bpm} BPM',
                  style: const TextStyle(color: Colors.white70),
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
            child: const Text('Cancel', style: TextStyle(color: Colors.white70)),
          ),
        ],
      ),
    );
  }
}
