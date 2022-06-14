import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttering_drums/board.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Drum-ru',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Board(),
    );
  }
}
