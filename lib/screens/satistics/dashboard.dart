// // import 'package:flutter/material.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:fl_chart/fl_chart.dart';
// //
// // class DashboardPage extends StatefulWidget {
// //   @override
// //   _DashboardPageState createState() => _DashboardPageState();
// // }
// //
// // class _DashboardPageState extends State<DashboardPage> {
// //   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
// //   final FirebaseAuth _auth = FirebaseAuth.instance;
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //
// //       body: SingleChildScrollView(
// //         child: Padding(
// //           padding: EdgeInsets.all(16),
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               _buildOverviewCards(),
// //               SizedBox(height: 20),
// //               _buildAverageScoreChart(),
// //               SizedBox(height: 20),
// //               _buildCommonProblems(),
// //               SizedBox(height: 20),
// //               _buildRecentAssessments(),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildOverviewCards() {
// //     return StreamBuilder<QuerySnapshot>(
// //       stream: _firestore.collection('users').snapshots(),
// //       builder: (context, userSnapshot) {
// //         return StreamBuilder<QuerySnapshot>(
// //           stream: _firestore.collection('assessments').snapshots(),
// //           builder: (context, assessmentSnapshot) {
// //             if (!userSnapshot.hasData || !assessmentSnapshot.hasData) {
// //               return CircularProgressIndicator();
// //             }
// //
// //             int totalUsers = userSnapshot.data?.docs.length ?? 0;
// //             int totalAssessments = assessmentSnapshot.data?.docs.length ?? 0;
// //             double averageScore = 0;
// //
// //             if (totalAssessments > 0) {
// //               try {
// //                 double totalScore = assessmentSnapshot.data!.docs
// //                     .map((doc) =>
// //                         (doc.data() as Map<String, dynamic>)['totalScore']
// //                             as num? ??
// //                         0)
// //                     .fold(0, (sum, score) => sum + score);
// //                 averageScore = totalScore / totalAssessments;
// //               } catch (e) {
// //                 print('Error calculating average score: $e');
// //               }
// //             }
// //
// //             return Row(
// //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// //               children: [
// //                 _buildOverviewCard(
// //                     'Total Users', totalUsers.toString(), Colors.blue[700]!),
// //                 _buildOverviewCard('Total Assessments',
// //                     totalAssessments.toString(), Colors.green[600]!),
// //                 _buildOverviewCard('Avg Score', averageScore.toStringAsFixed(2),
// //                     Colors.orange[600]!),
// //               ],
// //             );
// //           },
// //         );
// //       },
// //     );
// //   }
// //
// //   Widget _buildOverviewCard(String title, String value, Color color) {
// //     return Card(
// //       color: color,
// //       child: Padding(
// //         padding: EdgeInsets.all(16),
// //         child: Column(
// //           children: [
// //             Text(title, style: TextStyle(color: Colors.white)),
// //             SizedBox(height: 8),
// //             Text(value,
// //                 style: TextStyle(
// //                     color: Colors.white,
// //                     fontSize: 24,
// //                     fontWeight: FontWeight.bold)),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildAverageScoreChart() {
// //     return Card(
// //       child: Padding(
// //         padding: EdgeInsets.all(16),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             Text('Average Scores by Test Type',
// //                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
// //             SizedBox(height: 16),
// //             AspectRatio(
// //               aspectRatio: 1.7,
// //               child: StreamBuilder<QuerySnapshot>(
// //                 stream: _firestore.collection('assessments').snapshots(),
// //                 builder: (context, snapshot) {
// //                   if (!snapshot.hasData) return CircularProgressIndicator();
// //
// //                   Map<String, List<double>> scoresByType = {};
// //                   snapshot.data!.docs.forEach((doc) {
// //                     var data = doc.data() as Map<String, dynamic>;
// //                     String testType = data['testType'] as String? ?? 'Unknown';
// //                     double score =
// //                         (data['totalScore'] as num?)?.toDouble() ?? 0.0;
// //                     if (!scoresByType.containsKey(testType)) {
// //                       scoresByType[testType] = [];
// //                     }
// //                     scoresByType[testType]!.add(score);
// //                   });
// //
// //                   List<BarChartGroupData> barGroups = [];
// //                   scoresByType.forEach((type, scores) {
// //                     double average =
// //                         scores.reduce((a, b) => a + b) / scores.length;
// //                     barGroups.add(BarChartGroupData(
// //                       x: barGroups.length,
// //                       barRods: [BarChartRodData(toY: average)],
// //                     ));
// //                   });
// //
// //                   return BarChart(
// //                     BarChartData(
// //                       alignment: BarChartAlignment.spaceAround,
// //                       maxY: 100,
// //                       titlesData: FlTitlesData(
// //                         bottomTitles: AxisTitles(
// //                           sideTitles: SideTitles(
// //                             showTitles: true,
// //                             getTitlesWidget: (value, meta) {
// //                               List<String> types = scoresByType.keys.toList();
// //                               if (value.toInt() < types.length) {
// //                                 return Text(types[value.toInt()][0]);
// //                               }
// //                               return Text('');
// //                             },
// //                           ),
// //                         ),
// //                       ),
// //                       barGroups: barGroups,
// //                     ),
// //                   );
// //                 },
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildCommonProblems() {
// //     return Card(
// //       child: Padding(
// //         padding: EdgeInsets.all(16),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             Text('Most Common Problems',
// //                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
// //             SizedBox(height: 16),
// //             StreamBuilder<QuerySnapshot>(
// //               stream: _firestore.collection('assessments').snapshots(),
// //               builder: (context, snapshot) {
// //                 if (!snapshot.hasData) return CircularProgressIndicator();
// //
// //                 Map<String, int> problemCounts = {};
// //                 snapshot.data!.docs.forEach((doc) {
// //                   var data = doc.data() as Map<String, dynamic>;
// //                   List<dynamic> problems =
// //                       (data['problems'] as List<dynamic>?) ?? [];
// //                   problems.forEach((problem) {
// //                     if (problem is String) {
// //                       problemCounts[problem] =
// //                           (problemCounts[problem] ?? 0) + 1;
// //                     }
// //                   });
// //                 });
// //
// //                 var sortedProblems = problemCounts.entries.toList()
// //                   ..sort((a, b) => b.value.compareTo(a.value));
// //
// //                 return Column(
// //                   children: sortedProblems.take(5).map((entry) {
// //                     return ListTile(
// //                       title: Text(entry.key),
// //                       trailing: Text(entry.value.toString()),
// //                     );
// //                   }).toList(),
// //                 );
// //               },
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildRecentAssessments() {
// //     return Card(
// //       child: Padding(
// //         padding: EdgeInsets.all(16),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             Text('Recent Assessments',
// //                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
// //             SizedBox(height: 16),
// //             StreamBuilder<QuerySnapshot>(
// //               stream: _firestore
// //                   .collection('assessments')
// //                   .orderBy('timestamp', descending: true)
// //                   .limit(5)
// //                   .snapshots(),
// //               builder: (context, snapshot) {
// //                 if (!snapshot.hasData) return CircularProgressIndicator();
// //
// //                 return Column(
// //                   children: snapshot.data!.docs.map((doc) {
// //                     var data = doc.data() as Map<String, dynamic>;
// //                     return ListTile(
// //                       title: Text('User: ${data['userId'] ?? 'Unknown'}'),
// //                       subtitle: Text('Test: ${data['testType'] ?? 'Unknown'}'),
// //                       trailing: Text(
// //                           'Score: ${data['totalScore']?.toString() ?? 'N/A'}'),
// //                     );
// //                   }).toList(),
// //                 );
// //               },
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
//
//
//
//
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:fl_chart/fl_chart.dart';
//
// class DashboardPage extends StatefulWidget {
//   @override
//   _DashboardPageState createState() => _DashboardPageState();
// }
//
// class _DashboardPageState extends State<DashboardPage> {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               SizedBox(height: 80),
//               Center(
//                 child: Text(
//                   'User Statistics',
//                   style: TextStyle(
//                     fontFamily: 'DMSans',
//                     fontSize: 30,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//               SizedBox(height: 80),
//               _buildOverviewCards(),
//               SizedBox(height: 20),
//
//
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildOverviewCards() {
//     return StreamBuilder<QuerySnapshot>(
//       stream: _firestore.collection('users').snapshots(),
//       builder: (context, userSnapshot) {
//         return StreamBuilder<QuerySnapshot>(
//           stream: _firestore.collection('assessments').snapshots(),
//           builder: (context, assessmentSnapshot) {
//             if (!userSnapshot.hasData || !assessmentSnapshot.hasData) {
//               return CircularProgressIndicator();
//             }
//
//             int totalUsers = userSnapshot.data?.docs.length ?? 0;
//             int totalAssessments = assessmentSnapshot.data?.docs.length ?? 0;
//             double averageScore = 0;
//
//             if (totalAssessments > 0) {
//               try {
//                 double totalScore = assessmentSnapshot.data!.docs
//                     .map((doc) =>
//                 (doc.data() as Map<String, dynamic>)['totalScore']
//                 as num? ??
//                     0)
//                     .fold(0, (sum, score) => sum + score);
//                 averageScore = totalScore / totalAssessments;
//               } catch (e) {
//                 print('Error calculating average score: $e');
//               }
//             }
//
//             return Column(
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Expanded(
//                       child: _buildOverviewCard(
//                         'Total\nUsers',
//                         totalUsers.toString(),
//                         Colors.blueAccent.shade700,
//                       ),
//                     ),
//                     const SizedBox(width: 5),
//                     Expanded(
//                       child: _buildOverviewCard(
//                         'Total\nAssessments',
//                         totalAssessments.toString(),
//                         Colors.blue[200]!,
//                       ),
//                     ),
//                   ],
//                 ),
//
//               ],
//             );
//           },
//         );
//       },
//     );
//   }
//
//   Widget _buildOverviewCard(String title, String value, Color color,
//       {bool fullWidth = false}) {
//     return Card(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(20), // more rounded corners
//       ),
//       color: color,
//       child: Container(
//         height: 150,
//         // Increase height to 130
//         width: fullWidth ? double.infinity : null,
//         // Stretch to full width if required
//         padding: EdgeInsets.all(16),
//         child: Stack(
//           children: [
//             Align(
//               alignment: Alignment.topLeft,
//               child: Text(
//                 title,
//                 style: TextStyle(color: Colors.white, fontSize: 16),
//               ),
//             ),
//             Align(
//               alignment: Alignment.bottomLeft,
//               child: Text(
//                 value,
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 32, // Larger font for value
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//             Align(
//               alignment: Alignment.topRight,
//               child: Container(
//                 height: 50,
//                 width: 50,
//                 decoration: const BoxDecoration(
//                   color: Colors.white, // White circle
//                   shape: BoxShape.circle,
//                 ),
//                 child: const Icon(
//                   Icons.analytics, // Example blue icon
//                   color: Colors.blue,
//                   size: 22,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//
// }



import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<DateTime> _months = [];
  Map<DateTime, Map<String, double>> _assessmentScores = {};
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _getMonths();
    _getAssessmentScores();
    _pageController = PageController(initialPage: 0);
  }

  void _getMonths() {
    DateTime now = DateTime.now();
    DateTime? registeredDate = _auth.currentUser?.metadata.creationTime;
    if (registeredDate == null) return;

    DateTime currentMonth = DateTime(now.year, now.month, 1);
    DateTime startMonth = DateTime(registeredDate.year, registeredDate.month, 1);

    while (currentMonth.isAfter(startMonth) || currentMonth.isAtSameMomentAs(startMonth)) {
      _months.add(currentMonth);
      currentMonth = DateTime(currentMonth.year, currentMonth.month - 1, 1);
    }

    setState(() {});
  }

  void _getAssessmentScores() {
    final user = _auth.currentUser;
    if (user != null) {
      _firestore
          .collection('assessments')
          .where('userId', isEqualTo: user.uid)
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          DateTime date = doc.get('timestamp').toDate();
          String testType = doc.get('testType');
          double score = doc.get('totalScore');

          DateTime dateKey = DateTime(date.year, date.month, date.day);
          if (!_assessmentScores.containsKey(dateKey)) {
            _assessmentScores[dateKey] = {};
          }
          _assessmentScores[dateKey]![testType] = score;
        });
        setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 80),
              Center(
                child: Text(
                  'User Statistics',
                  style: TextStyle(
                    fontFamily: 'DMSans',
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 40),
              _buildOverviewCards(),
              SizedBox(height: 20),
              // Calendar directly added to the Column, outside the container
              _buildCalendar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOverviewCards() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('users').snapshots(),
      builder: (context, userSnapshot) {
        return StreamBuilder<QuerySnapshot>(
          stream: _firestore.collection('assessments').snapshots(),
          builder: (context, assessmentSnapshot) {
            if (!userSnapshot.hasData || !assessmentSnapshot.hasData) {
              return CircularProgressIndicator();
            }

            int totalUsers = userSnapshot.data?.docs.length ?? 0;
            int totalAssessments = assessmentSnapshot.data?.docs.length ?? 0;

            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: _buildOverviewCard(
                        'Total\nUsers',
                        totalUsers.toString(),
                        Colors.blueAccent.shade700,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: _buildOverviewCard(
                        'Total\nAssessments',
                        totalAssessments.toString(),
                        Colors.blue[200]!,
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildOverviewCard(String title, String value, Color color,
      {bool fullWidth = false}) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      color: color,
      child: Container(
        height: 150,
        width: fullWidth ? double.infinity : null,
        padding: EdgeInsets.all(16),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                title,
                style: TextStyle(fontFamily: 'DMSans', color: Colors.white, fontSize: 16),
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'DMSans',
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Container(
                height: 50,
                width: 50,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.analytics,
                  color: Colors.blue,
                  size: 22,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendar() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      // child: Card(
      //   color: Colors.white, // Changed calendar background to white
      //   // shape: RoundedRectangleBorder(
      //   //   borderRadius: BorderRadius.circular(20),
      //   // ),
        child: Container(
          height: 900, // Adjust the height based on your need
          child: PageView.builder(
            itemCount: _months.length,
            reverse: true,
            itemBuilder: (context, index) {
              return MonthCard(
                month: _months[index],
                assessmentScores: _assessmentScores,
                onDayTap: _showDayScores,
              );
            },
          ),
        ),

    );
  }

  void _showDayScores(DateTime date) {
    Map<String, double>? scores = _assessmentScores[date];
    if (scores == null || scores.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No tests taken on this day')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Test Scores for ${DateFormat('MMM d, yyyy').format(date)}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: scores.entries.map((entry) {
              return Text('${entry.key}: ${entry.value.toStringAsFixed(2)}');
            }).toList(),
          ),
          actions: [
            TextButton(
              child: Text('Close'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }
}

class MonthCard extends StatelessWidget {
  final DateTime month;
  final Map<DateTime, Map<String, double>> assessmentScores;
  final Function(DateTime) onDayTap;

  MonthCard({
    required this.month,
    required this.assessmentScores,
    required this.onDayTap,
  });

  Color _getColorShade(String testType, double? score) {
    if (score == null) {
      return Colors.grey[300]!;
    }
    double normalizedScore = _normalizeScore(testType, score);
    switch (testType) {
      case 'PHQ-9':
        return Color.lerp(
            Colors.green[700]!, Colors.red[700]!, normalizedScore)!;
      case 'GAD-7':
        return Color.lerp(
            Colors.blue[700]!, Colors.orange[700]!, normalizedScore)!;
      case 'CAGE':
        return Color.lerp(
            Colors.purple[700]!, Colors.yellow[700]!, normalizedScore)!;
      default:
        return Colors.grey[800]!;
    }
  }

  Widget _buildMonthGrid(String testType) {
    List<String> weekdays = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    int daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    int firstWeekday = DateTime(month.year, month.month, 1).weekday - 1;

    return Column(
      children: [
        Text(
          testType,
          style: TextStyle(
            fontFamily: 'DMSans',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            letterSpacing: 1.2,
          ),
        ),
        SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            childAspectRatio: 1,
          ),
          itemCount: 7 + daysInMonth + firstWeekday,
          itemBuilder: (context, index) {
            if (index < 7) {
              return Center(
                child: Text(
                  weekdays[index],
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              );
            }

            int dayNumber = index - 7 - firstWeekday + 1;
            if (dayNumber < 1 || dayNumber > daysInMonth) {
              return Container();
            }

            DateTime date = DateTime(month.year, month.month, dayNumber);
            double? score = assessmentScores[date]?[testType];

            return GestureDetector(
              onTap: () => onDayTap(date),
              child: Container(
                margin: EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: _getColorShade(testType, score),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: score != null
                      ? const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 18,
                  )
                      : Text(
                    '$dayNumber',
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            DateFormat('MMMM yyyy').format(month),
            style: TextStyle(
              fontSize: 28,
              fontFamily: 'DMSans',
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 24),
          Divider(height: 20),
          Expanded(
            child: ListView(
              children: [
                _buildMonthGrid('PHQ-9'),
                SizedBox(height: 24),
                _buildMonthGrid('GAD-7'),
                SizedBox(height: 24),
                _buildMonthGrid('CAGE'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  double _normalizeScore(String testType, double score) {
    switch (testType) {
      case 'PHQ-9':
        return score / 27; // PHQ-9 max score is 27
      case 'GAD-7':
        return score / 21; // GAD-7 max score is 21
      case 'CAGE':
        return score / 4; // CAGE max score is 4
      default:
        return score;
    }
  }
}