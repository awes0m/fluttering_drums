# Fluttering Drums 🥁

A modern Flutter application that replicates the functionality of a digital drum machine, converted from a Python Pygame application.
Android Download- [here](buillt_app\fdrums_byAwesom.apk)


## ✨ Features

- **6 Drum Instruments**: Hi Hat, Snare, Kick, Crash, Clap, and Floor Tom
- **Beat Sequencer**: Create patterns with 1-16 beats
- **BPM Control**: Adjustable tempo from 60-300 BPM
- **Real-time Playback**: Play your patterns with visual beat tracking
- **Save/Load System**: Save your custom beats and load them later
- **Responsive UI**: Works on mobile, web, and desktop
- **Low-latency Audio**: Optimized audio playback using just_audio
- **Dark Theme**: Modern, musical interface design

## 🏗️ Architecture

This application follows **MVVM (Model-View-ViewModel)** architecture with clean separation of concerns:

- **Models**: `DrumInstrument`, `DrumBeat`
- **ViewModels**: `DrumViewModel` (manages state and business logic)
- **Views**: `DrumScreen`, `DrumGrid`, `InstrumentPanel`, `ControlPanel`
- **Services**: `AudioService`, `StorageService`

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.8.1 or higher)
- Dart SDK
- Android Studio / VS Code with Flutter extensions

### Installation

1. **Clone the repository**

   ```bash
   git clone <repository-url>
   cd fluttering_drums
   ```
2. **Install dependencies**

   ```bash
   flutter pub get
   ```
3. **Run the application**

   ```bash
   flutter run
   ```

## 🎵 How to Use

### Basic Operation

1. **Create a Pattern**: Click on the grid squares to activate beats
2. **Adjust BPM**: Use the +/- buttons to change tempo
3. **Set Beats**: Choose how many beats per pattern (1-16)
4. **Play/Pause**: Use the large play button to start/stop playback
5. **Toggle Instruments**: Click the toggle buttons to enable/disable instruments

### Advanced Features

- **Save Beats**: Click the save button to save your current pattern
- **Load Beats**: Click the folder button to load previously saved patterns
- **Clear Pattern**: Use the clear button to reset the current pattern
- **Individual Play**: Click the play button next to each instrument to test sounds

## 🎨 UI Components

### Drum Grid

- Visual representation of your beat pattern
- Orange highlight shows current beat during playback
- Green squares indicate active beats
- Click to toggle beats on/off

### Instrument Panel

- Left sidebar with all drum instruments
- Toggle switches to enable/disable instruments
- Individual play buttons for testing sounds
- Visual feedback for active/inactive instruments

### Control Panel

- Large play/pause button
- BPM adjustment controls
- Beat count controls
- Action buttons (clear, save, load)
- Current beat indicator during playback

## 🔧 Technical Details

### Dependencies

- **just_audio**: Low-latency audio playback
- **audio_session**: Audio session management
- **shared_preferences**: Local storage for saved beats
- **flutter_animate**: Smooth animations and transitions

### Audio Implementation

- Uses `just_audio` package for reliable audio playback
- Preloads all sound files for instant response
- Supports simultaneous playback of multiple sounds
- Optimized for low latency on mobile devices

### State Management

- Uses `ChangeNotifier` pattern for reactive UI updates
- Clean separation between UI and business logic
- Efficient state updates with minimal rebuilds

## 📱 Platform Support

- ✅ Android
- ✅ iOS
- ✅ Web
- ✅ Windows
- ✅ macOS
- ✅ Linux

## 🎯 Future Enhancements

- [ ] MIDI support
- [ ] More drum kits and sounds
- [ ] Recording functionality
- [ ] Export to audio files
- [ ] Social sharing of beats
- [ ] Customizable themes
- [ ] Touch-friendly mobile interface

## 🐛 Troubleshooting

### Common Issues

1. **Audio not working**: Ensure device volume is up and audio permissions are granted
2. **Performance issues**: Reduce BPM or number of beats for better performance
3. **Sounds not loading**: Check that sound files are properly placed in `assets/sounds/`

### Debug Mode

Run with debug information:

```bash
flutter run --debug
```

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📞 Support

If you encounter any issues or have questions, please open an issue on the repository.

---

**Made with ❤️ and Flutter**
