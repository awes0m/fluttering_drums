// Picks the correct implementation based on the platform at compile time.
// - Web: uses package:web for browser APIs (no dart:html)
// - IO (Android/Desktop/iOS): uses dart:io and local storage

export 'export_service_io.dart' if (dart.library.html) 'export_service_web.dart';