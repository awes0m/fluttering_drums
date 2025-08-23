import 'package:flutter/material.dart';
import '../viewmodels/drum_view_model.dart';

class InstrumentPanel extends StatelessWidget {
  final DrumViewModel viewModel;

  const InstrumentPanel({
    super.key,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    final state = viewModel.state;
    
    if (state.instruments.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(
          color: Colors.orange,
        ),
      );
    }

    return Container(
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
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Color(0xFF3D3D3D),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.music_note,
                  color: Colors.orange,
                  size: 20,
                ),
                SizedBox(width: 8),
                Text(
                  'Instruments',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          
          // Instruments List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.instruments.length,
              itemBuilder: (context, index) {
                final instrument = state.instruments[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Column(
                    children: [
                      // Instrument Row
                      Row(
                        children: [
                          // Toggle Button
                          GestureDetector(
                            onTap: () => viewModel.toggleInstrument(index),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: instrument.isActive 
                                    ? Colors.green 
                                    : Colors.grey,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.white30,
                                  width: 2,
                                ),
                              ),
                              child: instrument.isActive
                                  ? const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 16,
                                    )
                                  : null,
                            ),
                          ),
                          
                          const SizedBox(width: 12),
                          
                          // Instrument Name
                          Expanded(
                            child: Text(
                              instrument.displayName,
                              style: TextStyle(
                                color: instrument.isActive 
                                    ? Colors.white 
                                    : Colors.white54,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          
                          // Play Button
                          GestureDetector(
                            onTap: () => viewModel.playInstrument(index),
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: Colors.orange.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: Colors.orange),
                              ),
                              child: const Icon(
                                Icons.play_arrow,
                                color: Colors.orange,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                      // Divider
                      if (index < state.instruments.length - 1)
                        Container(
                          margin: const EdgeInsets.only(top: 12),
                          height: 1,
                          color: Colors.white10,
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
