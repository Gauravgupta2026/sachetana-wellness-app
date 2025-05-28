import 'package:flutter/material.dart';

class ClubTile extends StatelessWidget {
  final String clubTitle;

  const ClubTile({super.key, required this.clubTitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          clubTitle,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
