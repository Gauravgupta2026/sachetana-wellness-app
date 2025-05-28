import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Add this import for launching URLs

class UpskillScreen2 extends StatefulWidget {
  const UpskillScreen2({super.key});

  @override
  _UpskillScreenState createState() => _UpskillScreenState();
}

class _UpskillScreenState extends State<UpskillScreen2> {
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
                padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
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
        const SizedBox(height: 30),
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
                courseTitle: 'for her',
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
                courseTitle: 'so you have a crush',
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
                courseTitle: 'your boring life is beautiful.',
                platform: 'YouTube',
                thumbnailUrl:
                'https://img.youtube.com/vi/zv231-Szz78/hqdefault.jpg', // Thumbnail URL
                videoUrl:
                'https://www.youtube.com/watch?v=zv231-Szz78', // YouTube link
              ),
              CourseTile(
                courseTitle:
                'do you want to be loved or do you want to be yourself?',
                platform: 'YouTube',
                thumbnailUrl:
                'https://img.youtube.com/vi/3Y81L_CUV3M/hqdefault.jpg', // Thumbnail URL
                videoUrl:
                'https://www.youtube.com/watch?v=3Y81L_CUV3M', // YouTube link
              ),
              CourseTile(
                courseTitle: 'How I learned to make more friends',
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
                'https://img.youtube.com/vi/9IiTdSnmS7E/hqdefault.jpg', // Thumbnail URL
                videoUrl:
                'https://www.youtube.com/watch?v=9IiTdSnmS7E', // YouTube link
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
              CourseTile(
                courseTitle: 'Its Just a Corecore',
                platform: 'YouTube',
                thumbnailUrl:
                'https://img.youtube.com/vi/MfkD16san8w/hqdefault.jpg', // Thumbnail URL
                videoUrl:
                'https://www.youtube.com/watch?v=MfkD16san8w', // YouTube link
              ),
              CourseTile(
                courseTitle: 'Sleep Is Your Superpower | Matt Walker | TED',
                platform: 'TedX',
                thumbnailUrl:
                'https://img.youtube.com/vi/5MuIMqhT8DM/hqdefault.jpg', // Thumbnail URL
                videoUrl:
                'https://www.youtube.com/watch?v=5MuIMqhT8DM', // YouTube link
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Build the Clubs section
  Widget _buildClubsSection() {
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 4 / 4,
      ),
      itemCount: 4,
      itemBuilder: (context, index) {
        List<String> clubs = ['MRC', 'Rotaract', 'NSS', 'MTTN'];
        List<String> images = [
          'assets/images/mrc.jpeg',
          'assets/images/rotaract.jpeg',
          'assets/images/nss.png',
          'assets/images/mttn.jpg',
        ];
        List<String> clubUrls = [
          'https://www.instagram.com/mrc.manipal/',
          'https://www.instagram.com/rotaractclubofmahe/',
          'https://www.instagram.com/nss.mit.mahe/',
          'https://www.instagram.com/manipalthetalk/',
        ];

        return ClubTile(
          clubTitle :clubs[index],
          imagePath :images[index],
          onTap :() async {
            final url = clubUrls[index];
            if (await canLaunch(url)) {
              await launch(url);
            }
          },
        );
      },
    );
  }

  // Build the Departments section (similar to Clubs)
  Widget _buildDepartmentsSection() {
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 4 / 4,
      ),
      itemCount: 4,
      itemBuilder: (context, index) {
        List<String> departments = [
          'Student Counsellors',
          'Student Support Centre',
          'Department of Psychiatry',
          'Department of Clinical Psychology'
        ];
        List<String> images = [
          'assets/images/counts.jpg',
          'assets/images/ssc.avif',
          'assets/images/psyc.jpg',
          'assets/images/psycho.jpg',
        ];
        List<String> departmentUrls = [
          'https://www.manipal.edu/mu/campus-life/studentaffairs.html',
          'https://ssc.manipal.edu/our_story.aspx',
          'https://khmanipal.com/psychiatry/',
          'https://khmanipal.com/clinicalpsychology/',
        ];

        return ClubTile(
          clubTitle :departments[index],
          imagePath :images[index],
          onTap :() async {
            final url = departmentUrls[index];
            if (await canLaunch(url)) {
              await launch(url);
            }
          },
        );
      },
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
      onTap:() => _launchURL(videoUrl),
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              thumbnailUrl,
              height: 100,
              width: 150,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 5),
            Text(
              courseTitle,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              platform,
              style: const TextStyle(
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void _launchURL(String url) async {
  final Uri uri = Uri.parse(url);
  if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
    throw 'Could not launch $url';
  }
}





class ClubTile extends StatelessWidget {
  final String clubTitle;
  final String imagePath;
  final VoidCallback onTap;

  const ClubTile({
    required this.clubTitle,
    required this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade300, width: 1.5),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              clubTitle,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
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
    Key? key,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.shade300 : Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}













