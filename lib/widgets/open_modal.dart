import 'package:flutter/material.dart';
import 'package:sachetana_firebase/screens/general_settings.dart';
import 'package:sachetana_firebase/screens/satistics/dashboard.dart';
import 'sos_modal.dart'; // Import your SOSModal class

class OpenModal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end, // Makes sure the modal takes only the needed height
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildIconButton(
                context,
                Icons.show_chart,
                "Your Stats",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DashboardPage()),
                  );
                  // Navigate to Your Stats page (to be configured later)
                  print('Your Stats button tapped');
                  // Uncomment and configure when the page is ready
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => YourStatsPage()));
                },
              ),

              _buildIconButton(
                context,
                Icons.send,
                "SOS",
                isSOS: true,
              ), // Pass isSOS flag

              _buildIconButton(
                context,
                Icons.settings,
                "Settings",
                onTap: () {
                  // Navigate to General Settings page
                  print('Settings button tapped');
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SettingsScreen()),
                  );
                },
              ), // Add settings button
            ],
          ),
          SizedBox(height: 50),
        ],
      ),
    );
  }

  Widget _buildIconButton(
      BuildContext context,
      IconData icon,
      String label, {
        bool isSOS = false,
        VoidCallback? onTap,
      }) {
    return GestureDetector(
      onTap: onTap ??
              () {
            if (isSOS) {
              // Show SOS Modal when SOS button is tapped
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return const SOSModal(); // Replace with your SOSModal class
                },
              );
            } else {
              // Handle other buttons if needed
              print('$label button tapped');
            }
          },
      child: Column(
        children: [
          Container(
            width: 90, // Adjust width as needed
            height: 90, // Adjust height as needed
            decoration: BoxDecoration(
              color: Colors.blue[100], // Adjust color as needed
              borderRadius: BorderRadius.circular(25), // Adjust border radius as needed
            ),
            child: Icon(icon, size: 25, color: Colors.black),
          ),
          SizedBox(height: 15),
          Text(label, style: TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
