import 'package:flutter/material.dart';
import '../viewmodels/drum_view_model.dart';
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

  @override
  void initState() {
    super.initState();
    _viewModel = DrumViewModel();
    _viewModel.addListener(_onViewModelChanged);
    _viewModel.initialize();
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChanged);
    _viewModel.dispose();
    super.dispose();
  }

  void _onViewModelChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF2D2D2D),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.music_note,
                    color: Colors.orange,
                    size: 32,
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Fluttering Drums',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto',
                    ),
                  ),
                  const Spacer(),
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
                ],
              ),
            ),
            
            // Main Content
            Expanded(
              child: Row(
                children: [
                  // Left Panel - Instruments
                  SizedBox(
                    width: 200,
                    child: InstrumentPanel(
                      viewModel: _viewModel,
                    ),
                  ),
                  
                  // Center - Drum Grid
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2D2D2D),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: DrumGrid(
                        viewModel: _viewModel,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Bottom Control Panel
            ControlPanel(
              viewModel: _viewModel,
            ),
          ],
        ),
      ),
    );
  }
}
