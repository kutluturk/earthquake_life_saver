import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class BroadcastView extends StatefulWidget {
  const BroadcastView({Key? key}) : super(key: key);

  @override
  State<BroadcastView> createState() => _BroadcastViewState();
}

class _BroadcastViewState extends State<BroadcastView> {
  final FlutterBlue flutterBlue = FlutterBlue.instance;
  String bloodType = 'A+';
  String name = '';
  String surname = '';
  int floor = 1;
  bool isBroadcasting = false;

  // ... other code for UI elements and Bluetooth LE operations

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Earthquake Life Saver - Broadcast'),
        backgroundColor: Theme.of(context).colorScheme.primary, // Use theme color
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0), // Adjust padding
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Blood Type'),
              DropdownButton<String>(
                value: bloodType,
                items: <String>['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) => setState(() => bloodType = value!),
              ),
              const SizedBox(height: 20.0), // Add spacing
              Row( // Arrange name and surname fields horizontally
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'Enter your name',
                      ),
                      onChanged: (value) => setState(() => name = value),
                    ),
                  ),
                  const SizedBox(width: 16.0), // Add spacing between fields
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'Enter your surname',
                      ),
                      onChanged: (value) => setState(() => surname = value),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20.0), // Add spacing
              const Text('Floor'),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Enter the floor number',
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) => setState(() => floor = int.tryParse(value) ?? 1),
              ),
              const SizedBox(height: 30.0), // Add spacing before switch
              SwitchListTile(
                title: const Text('Start Broadcasting'),
                value: isBroadcasting,
                onChanged: (value) => handleBroadcastToggle(value),
                activeColor: Theme.of(context).colorScheme.primary, // Use theme color
              ),
            ],
          ),
        ),
      ),
    );
  }

  void handleBroadcastToggle(bool value) {
    setState(() {
      isBroadcasting = value;
      if (value) {
        startBroadcast();
      } else {
        stopBroadcast();
      }
    });
  }

void startBroadcast() async {
  try {
    // 1. Get Bluetooth state
    var state = flutterBlue.state;
    if (state != BluetoothState.on) {
      // Handle Bluetooth not enabled
      throw Exception('Bluetooth is not enabled');
    }

    // 2. Create a Bluetooth advertisement data packet
    var advertisementData = Uint8List.fromList([
      // Add your custom data bytes here, e.g.,
      ...utf8.encode('Blood Type: $bloodType'),
      ...utf8.encode('Name: $name $surname'),
      ...utf8.encode('Floor: $floor'),
    ]);

    // 3. Start advertising
    await flutterBlue.startAdvertising(
      id: 'earthquake_life_saver', // Unique identifier for your app
      name: 'Earthquake Life Saver', // Device name in advertising
      serviceUuids: [], // Add service UUIDs if needed
      manufacturerData: advertisementData, // Your custom data
    );

    setState(() {
      isBroadcasting = true;
    });
  } catch (error) {
    // Handle errors, e.g., display an error message
    print('Error starting broadcast: $error');
  }
}


  void stopBroadcast() async {
  try {
    await flutterBlue.stopAdvertising();
    setState(() {
      isBroadcasting = false;
    });
  } catch (error) {
    // Handle errors
    print('Error stopping broadcast: $error');
  }
}

}
