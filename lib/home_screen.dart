// Import necessary libraries
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Build your home screen's UI
    // ...

    // Include a button or navigation link to trigger BroadcastView
    return ElevatedButton(
      onPressed: () {
        Navigator.pushNamed(context, '/broadcast'); // Navigate to BroadcastView
      },
      child: const Text('Start Broadcasting'),
    );
  }
}
