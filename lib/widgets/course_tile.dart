import 'package:flutter/material.dart';

class CourseTile extends StatelessWidget {
  final String courseTitle;
  final String platform;

  const CourseTile({super.key, required this.courseTitle, required this.platform});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Container(
        width: 200,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.play_circle_fill, size: 40),
            const SizedBox(height: 10),
            Text(courseTitle, textAlign: TextAlign.center),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(platform, style: const TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
