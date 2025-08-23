import 'package:flutter/material.dart';
import '../viewmodels/drum_view_model.dart';

class DrumGrid extends StatelessWidget {
  final DrumViewModel viewModel;

  const DrumGrid({
    super.key,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    final state = viewModel.state;
    
    if (state.instruments.isEmpty || state.pattern.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(
          color: Colors.orange,
        ),
      );
    }

    return Column(
      children: [
        // Grid Header
        Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Color(0xFF3D3D3D),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
          ),
          child: Row(
            children: [
              const Text(
                'Beat Pattern',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Text(
                '${state.beats} Beats',
                style: const TextStyle(
                  color: Colors.orange,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        
        // Grid Content
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Beat numbers row
                Row(
                  children: [
                    const SizedBox(width: 100), // Space for instrument names
                    ...List.generate(state.beats, (beatIndex) {
                      return Expanded(
                        child: Container(
                          height: 30,
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          child: Center(
                            child: Text(
                              '${beatIndex + 1}',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
                
                const SizedBox(height: 8),
                
                // Drum pattern grid
                Expanded(
                  child: ListView.builder(
                    itemCount: state.instruments.length,
                    itemBuilder: (context, instrumentIndex) {
                      final instrument = state.instruments[instrumentIndex];
                      return Container(
                        height: 60,
                        margin: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            // Instrument name
                            SizedBox(
                              width: 100,
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
                            
                            // Beat buttons
                            Expanded(
                              child: Row(
                                children: List.generate(state.beats, (beatIndex) {
                                  final isActive = state.pattern[instrumentIndex][beatIndex] == 1;
                                  final isCurrentBeat = state.isPlaying && 
                                                       state.currentBeat == beatIndex;
                                  
                                  return Expanded(
                                    child: Container(
                                      height: 50,
                                      margin: const EdgeInsets.symmetric(horizontal: 2),
                                      child: GestureDetector(
                                        onTap: () {
                                          if (instrument.isActive) {
                                            viewModel.toggleBeat(instrumentIndex, beatIndex);
                                          }
                                        },
                                        child: AnimatedContainer(
                                          duration: const Duration(milliseconds: 150),
                                          decoration: BoxDecoration(
                                            color: isActive
                                                ? (instrument.isActive 
                                                    ? Colors.green 
                                                    : Colors.grey)
                                                : Colors.transparent,
                                            border: Border.all(
                                              color: isCurrentBeat
                                                  ? Colors.orange
                                                  : Colors.white30,
                                              width: isCurrentBeat ? 3 : 1,
                                            ),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Center(
                                            child: isActive
                                                ? const Icon(
                                                    Icons.music_note,
                                                    color: Colors.white,
                                                    size: 20,
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
