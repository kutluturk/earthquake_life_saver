import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'broadcast_view.dart'; 
// Import BroadcastView
// Import other screens or widgets as needed

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Earthquake Life Saver',
      theme: ThemeData(
        // Define your app's theme colors, fonts, etc.
      ),
      home: const HomeScreen(), // Set the initial screen
      routes: {
        '/broadcast': (context) => const BroadcastView(), // Define a route for BroadcastView
      },
    );
  }
}
