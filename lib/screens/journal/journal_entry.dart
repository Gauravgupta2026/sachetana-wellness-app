import 'package:flutter/material.dart';
import 'dart:async';

class JournalEntry{
  final String content;
  final String date;
  final String mood;
  final String timestamp;
  final String userId;
  JournalEntry({
    required this.content,
    required this.date,
    required this.mood,
    required this.timestamp,
    required this.userId,
});

  Map<String, dynamic> toMap() {
    return {
      'content' : content,
      'date' : date,
      'mood' :  mood,
      'timestamp' : timestamp,
      'userId' : userId,
    };
  }

  factory JournalEntry.fromMap(Map<String, dynamic> map) {
    return JournalEntry(
      content: map['content'] ?? '',
      date: map['date'] ?? '',
      mood: map['mood'] ?? 'Unknown',
      timestamp: (map['timestamp'] as Timestamp).toDate(),
      userId: map['userId'] ?? '',
    );
  }
}


// Journal Entry Card Widget
class JournalEntryCard extends StatelessWidget {
  final String content;
  final String date;
  final String mood;

  const JournalEntryCard({
    Key? key,
    required this.content,
    required this.date,
    required this.mood,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      height: 100,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              content,
              style: TextStyle(
                color: Colors.black87,
                fontSize: 14,
                fontFamily: 'PoltawskiNowy',
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  date,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                    fontFamily: 'Poppins',
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    mood,
                    style: TextStyle(
                      color: Colors.green[800],
                      fontSize: 12,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}