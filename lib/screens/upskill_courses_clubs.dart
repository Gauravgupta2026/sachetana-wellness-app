

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UpskillScreen1 extends StatefulWidget {
  const UpskillScreen1({super.key});

  @override
  _UpskillScreenState createState() => _UpskillScreenState();
}

class _UpskillScreenState extends State<UpskillScreen1> {
  bool isCoursesSelected = true;
  bool isClubsSelected = false;
  bool isDepartmentsSelected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/home.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Texts placed at the top of the screen
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 100), // Space for the top of the screen
                // Center "Upskill Yourself" Text
                Text(
                  'Upskill Yourself',
                  style: TextStyle(
                      fontFamily: 'DMSans',
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                SizedBox(height: 40), // Space between titles
                // Two-line "Check out these clubs & courses" text
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Check out these',
                      style: TextStyle(
                          fontFamily: 'DMSans',
                          fontSize: 25,
                          color: Colors.white),
                    ),
                    Text(
                      'clubs, courses & departments',
                      style: TextStyle(
                          fontFamily: 'DMSans',
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ],
                ),
                SizedBox(height: 20), // Space before white rectangle
              ],
            ),
          ),

          // Curved white rectangle
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.67,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  topRight: Radius.circular(15.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 30),
                    // Left-aligned Courses, Clubs, and Departments buttons
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          TabButton(
                            title: 'Courses',
                            isSelected: isCoursesSelected,
                            onTap: () {
                              setState(() {
                                isCoursesSelected = true;
                                isClubsSelected = false;
                                isDepartmentsSelected = false;
                              });
                            },
                          ),
                          const SizedBox(width: 8),
                          TabButton(
                            title: 'Clubs',
                            isSelected: isClubsSelected,
                            onTap: () {
                              setState(() {
                                isCoursesSelected = false;
                                isClubsSelected = true;
                                isDepartmentsSelected = false;
                              });
                            },
                          ),
                          const SizedBox(width: 8),
                          TabButton(
                            title: 'Departments',
                            isSelected: isDepartmentsSelected,
                            onTap: () {
                              setState(() {
                                isCoursesSelected = false;
                                isClubsSelected = false;
                                isDepartmentsSelected = true;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    Expanded(
                      child: isCoursesSelected
                          ? _buildCoursesSection()
                          : isClubsSelected
                          ? _buildClubsSection()
                          : _buildDepartmentsSection(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Build the Courses section
  Widget _buildCoursesSection() {
    return ListView(
      children: [
        const SizedBox(height: 50),
        const SectionHeader(title: 'Coping Skills'),
        const SizedBox(height: 15),
        SizedBox(
          height: 180,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: const [
              CourseTile(
                courseTitle: 'Why is Sisyphus Happy?',
                platform: 'YouTube',
                thumbnailUrl:
                'https://img.youtube.com/vi/Nq5C5qL1nsc/hqdefault.jpg', // Thumbnail URL
                videoUrl:
                'https://www.youtube.com/watch?v=Nq5C5qL1nsc', // YouTube link
              ),
              CourseTile(
                courseTitle:
                'Who are you, really? The puzzle of personality | Brian Little | TED',
                platform: 'TedX',
                thumbnailUrl:
                'https://img.youtube.com/vi/qYvXk_bqlBk/hqdefault.jpg', // Thumbnail URL
                videoUrl:
                'https://www.youtube.com/watch?v=qYvXk_bqlBk', // YouTube link
              ),
              CourseTile(
                courseTitle:
                'This could be why youre depressed or anxious | Johann Hari | TED',
                platform: 'TedX',
                thumbnailUrl:
                'https://img.youtube.com/vi/MB5IX-np5fE/hqdefault.jpg', // Thumbnail URL
                videoUrl:
                'https://www.youtube.com/watch?v=MB5IX-np5fE', // YouTube link
              ),
            ],
          ),
        ),
        const SizedBox(height: 50),
        const SectionHeader(title: 'Relationship Issues'),
        const SizedBox(height: 15),
        SizedBox(
          height: 180,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: const [
              CourseTile(
                courseTitle: 'For Her',
                platform: 'YouTube',
                thumbnailUrl:
                'https://img.youtube.com/vi/rYxK7Cdu7uI/hqdefault.jpg', // Thumbnail URL
                videoUrl:
                'https://www.youtube.com/watch?v=rYxK7Cdu7uI', // YouTube link
              ),
              CourseTile(
                courseTitle: 'Shiv Kumar Batalvi - Interview',
                platform: 'YouTube',
                thumbnailUrl:
                'https://img.youtube.com/vi/EgpSHpATAIM/hqdefault.jpg', // Thumbnail URL
                videoUrl:
                'https://www.youtube.com/watch?v=EgpSHpATAIM', // YouTube link
              ),
              CourseTile(
                courseTitle: 'So You Have a Crush',
                platform: 'YouTube',
                thumbnailUrl:
                'https://img.youtube.com/vi/dcuHm_N1mtk/hqdefault.jpg', // Thumbnail URL
                videoUrl:
                'https://www.youtube.com/watch?v=dcuHm_N1mtk', // YouTube link
              ),
            ],
          ),
        ),
        const SizedBox(height: 50),
        const SectionHeader(title: 'Social Skills'),
        const SizedBox(height: 15),
        SizedBox(
          height: 180,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: const [
              CourseTile(
                courseTitle: 'Your Boring Life is Beautiful',
                platform: 'YouTube',
                thumbnailUrl:
                'https://img.youtube.com/vi/zv231-Szz78/hqdefault.jpg', // Thumbnail URL
                videoUrl:
                'https://www.youtube.com/watch?v=zv231-Szz78', // YouTube link
              ),
              CourseTile(
                courseTitle:
                'Do You Want to be Loved or Do You Want to be Yourself?',
                platform: 'YouTube',
                thumbnailUrl:
                'https://img.youtube.com/vi/3Y81L_CUV3M/hqdefault.jpg', // Thumbnail URL
                videoUrl:
                'https://www.youtube.com/watch?v=3Y81L_CUV3M', // YouTube link
              ),
              CourseTile(
                courseTitle: 'How I Learned to Make More Friends',
                platform: 'YouTube',
                thumbnailUrl:
                'https://img.youtube.com/vi/nm7OMGjbCgc/hqdefault.jpg', // Thumbnail URL
                videoUrl:
                'https://www.youtube.com/watch?v=nm7OMGjbCgc', // YouTube link
              ),
            ],
          ),
        ),
        const SectionHeader(title: 'Life Skills'),
        const SizedBox(height: 15),
        SizedBox(
          height: 180,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: const [
              CourseTile(
                courseTitle: 'Sisyphus and the Impossible Dream',
                platform: 'YouTube',
                thumbnailUrl:
                'https://img.youtube.com/vi/jJdgmWbZ3FU/hqdefault.jpg', // Thumbnail URL
                videoUrl:
                'https://www.youtube.com/watch?v=jJdgmWbZ3FU', // YouTube link
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Build the Clubs section
  Widget _buildClubsSection() {
    return Container(
      alignment: Alignment.center,
      child: const Text('Clubs Section Coming Soon'),
    );
  }

  // Build the Departments section
  Widget _buildDepartmentsSection() {
    return Container(
      alignment: Alignment.center,
      child: const Text('Departments Section Coming Soon'),
    );
  }
}

class TabButton extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const TabButton({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              color: isSelected ? Colors.black : Colors.grey,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          if (isSelected)
            Container(
              height: 3,
              width: 30,
              color: Colors.black,
              margin: const EdgeInsets.only(top: 5),
            ),
        ],
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;

  const SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class CourseTile extends StatelessWidget {
  final String courseTitle;
  final String platform;
  final String thumbnailUrl;
  final String videoUrl;

  const CourseTile({
    required this.courseTitle,
    required this.platform,
    required this.thumbnailUrl,
    required this.videoUrl,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _launchURL(videoUrl),
      child: Container(
        width: 150,
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              thumbnailUrl,
              height: 100,
              width: 150,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 10),
            Text(
              courseTitle,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 5),
            Text(
              platform,
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }
}
