import 'package:bettersis/modules/bettersis_appbar.dart';
import 'package:bettersis/screens/Misc/appdrawer.dart';
import 'package:bettersis/utils/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CourseRegistration extends StatefulWidget {
  final String userId;
  final String userName;
  final String userDept;
  final String userSemester;
  //final String userAY;
  final String imageUrl;
  final VoidCallback onLogout;

  const CourseRegistration({
    super.key,
    required this.userId,
    required this.userName,
    required this.userDept,
    required this.userSemester,
    required this.imageUrl,
    required this.onLogout,
  });

  @override
  State<CourseRegistration> createState() => _CourseRegistrationState();
}

class _CourseRegistrationState extends State<CourseRegistration> {
  // Number of courses and course data
  int totalCourses = 10; 
  
  // Can be adjusted
  final List<Map<String, dynamic>> offeredCourses = [
    {'code': 'CSE 4501', 'title': 'Operating Systems', 'credit': 3.00},
    {'code': 'CSE 4502', 'title': 'Operating Systems Lab', 'credit': 1.00},
    {'code': 'CSE 4503', 'title': 'Microprocessor and Assembly Language', 'credit': 3.00},
    {'code': 'CSE 4504', 'title': 'Microprocessor and Assembly Language Lab', 'credit': 1.00},
    {'code': 'CSE 4508', 'title': 'RDBMS', 'credit': 1.5},
    {'code': 'CSE 4510', 'title': 'Software Development', 'credit': 0.75},
                  {'code': 'CSE 4511', 'title': 'Computer Networks', 'credit': 3.0},
                  {'code': 'CSE 4512', 'title': 'Computer Networks Lab', 'credit': 1.5},
                  {'code': 'CSE 4513', 'title': 'SWEOOD', 'credit': 3.0},
                  {'code': 'CSE 4551', 'title': 'Graphics', 'credit': 3.0},
                  {'code': 'CSE 4552', 'title': 'Graphics Lab', 'credit': 0.75},
                  {'code': 'MATH 4541', 'title': 'Calculus', 'credit': 3.0},
    // Add more courses here as needed...
  ];

  List<Map<String, dynamic>> selectedCourses = [];

  // void toggleCourseSelection(int index) {
  //   setState(() {
  //     final course = offeredCourses[index];
  //     if (selectedCourses.contains(course)) {
  //       selectedCourses.remove(course);
  //     } else {
  //       selectedCourses.add(course);
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = AppTheme.getTheme(widget.userDept);
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    final String studentName = widget.userName;
    final String studentId = widget.userId;
    final String currentSemester = widget.userSemester;
    const String currentAcademicYear = '2023-2024';

    return Scaffold(
        drawer: CustomAppDrawer(theme: theme),
        appBar: BetterSISAppBar(
          onLogout: widget.onLogout,
          theme: theme,
          title: 'Course Registration',
        ),
        body: Column(
        children: [
          // Blue Box for Profile Information
          Container(
            padding: const EdgeInsets.all(16.0),
            width: double.infinity,
            color: theme.primaryColor,
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(widget.imageUrl),
                      onBackgroundImageError: (exception, stackTrace){
                        print('Error loading image: $exception');
                      },
                    ),
                    const SizedBox(width: 16.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          studentName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: theme.secondaryHeaderColor.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            studentId,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(color: Colors.white),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Current Semester: $currentSemester',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Current AY: $currentAcademicYear',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 15),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              //color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'OFFERED COURSES',
                      style: TextStyle(
                        color: theme.secondaryHeaderColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Expanded(
                    child: ListView.builder(
                      itemCount: offeredCourses.length,
                      itemBuilder: (context, index) {
                        final course = offeredCourses[index];
                        bool isSelected = selectedCourses.contains(course);
                        
                        return Card(
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 3,
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                            title: Text(
                              course['code']!,
                              style: TextStyle(
                                color: theme.primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(course['title']),
                                Text('${course['credit']} credit'),
                              ],
                            ),
                            //Text('${course['title']} - ${course['credit']} credit'),
                            trailing: GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (isSelected) {
                                    selectedCourses.remove(course);
                                  } else {
                                    selectedCourses.add(course);
                                  }
                                });
                              },
                              child: CircleAvatar(
                                radius: 20,
                                backgroundColor: isSelected ? theme.primaryColor : Colors.grey.shade300,
                                child: const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                ]
              )
            ),
          ),
        ],
      ),
    );
  }
}
