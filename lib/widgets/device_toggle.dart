import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';

class LoginToggleSwitch extends StatelessWidget {
  final Function(int) onToggle; // Callback for navigation

  LoginToggleSwitch({required this.onToggle});

  @override
  Widget build(BuildContext context) {
    int selectedIndex = 0; // Define selectedIndex with a default value
    return ToggleSwitch(
      initialLabelIndex: selectedIndex,
      totalSwitches: 2,
      labels: ['Phone', 'Email'],
      minWidth: 160.0,
      minHeight: 40.0,
      fontSize: 12.0,
      cornerRadius: 15.0,
      activeBgColor: [Colors.white],
      activeFgColor: Colors.black,
      inactiveBgColor: Colors.grey[300],
      inactiveFgColor: Colors.black,
      onToggle: (index) {
        onToggle(index!); // Call the callback with the selected index
      },
    );
  }
}
