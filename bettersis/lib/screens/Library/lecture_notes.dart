import 'package:flutter/material.dart';
import 'package:bettersis/modules/bettersis_appbar.dart';
import 'package:bettersis/utils/themes.dart';

class LectureNotesPage extends StatefulWidget {
  final String userDept;
  final VoidCallback onLogout;

  const LectureNotesPage({
    Key? key,
    required this.userDept,
    required this.onLogout,
  }) : super(key: key);

  @override
  _LectureNotesPageState createState() => _LectureNotesPageState();
}

class _LectureNotesPageState extends State<LectureNotesPage> {
  String? _selectedProgram;
  String? _selectedSemester;
  String? _selectedCourse;
  String? _selectedLectureTopic;

  final List<String> programs = ['CSE', 'SWE'];
  final List<String> semesters = [
    'Semester 1', 'Semester 2', 'Semester 3', 'Semester 4',
    'Semester 5', 'Semester 6', 'Semester 7', 'Semester 8'
  ];

  final List<String> semester1Courses = ['CSE 4105', 'CSE 4107', 'Math 4141', 'Phy 4141'];
  final List<String> semester2Courses = ['CSE 4203', 'CSE 4205', 'Math 4241', 'Phy 4241'];
  final List<String> semester3Courses = ['CSE 4301', 'CSE 4303', 'CSE 4307', 'Math 4341'];
  final List<String> semester4Courses = ['CSE 4403', 'CSE 4405', 'CSE 4407', 'Math 4441'];
  final List<String> semester5Courses = ['CSE 4501', 'CSE 4503', 'CSE 4511', 'CSE 4513'];
  final List<String> semester6Courses = ['CSE 4615', 'CSE 4619', 'CSE 4621', 'Math 4641'];
  final List<String> semester7Courses = ['CSE 4703', 'CSE 4711', 'CSE 4733', 'Math 4741'];
  final List<String> semester8Courses = ['CSE 4801', 'CSE 4803', 'CSE 4805', 'CSE 4807'];

  List<String> currentCourses = [];
  final List<String> lectureTopics = ['Introduction', 'Advanced Concepts', 'Review']; // Example topics

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.getTheme(widget.userDept);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final double paddingValue = screenWidth * 0.05;

    return Scaffold(
      appBar: BetterSISAppBar(
        onLogout: widget.onLogout,
        theme: theme,
        title: 'Lecture Notes',
      ),
      body: Padding(
        padding: EdgeInsets.all(paddingValue),
        child: ListView(
          children: [
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Program',
                border: OutlineInputBorder(),
              ),
              value: _selectedProgram,
              items: programs
                  .map((program) => DropdownMenuItem<String>(
                value: program,
                child: Text(program),
              ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedProgram = value;
                });
              },
            ),
            SizedBox(height: screenHeight * 0.02),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Semester',
                border: OutlineInputBorder(),
              ),
              value: _selectedSemester,
              items: semesters
                  .map((semester) => DropdownMenuItem<String>(
                value: semester,
                child: Text(semester),
              ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedSemester = value;
                  _selectedCourse = null;

                  // Update course list based on the selected semester
                  switch (_selectedSemester) {
                    case 'Semester 1':
                      currentCourses = semester1Courses;
                      break;
                    case 'Semester 2':
                      currentCourses = semester2Courses;
                      break;
                    case 'Semester 3':
                      currentCourses = semester3Courses;
                      break;
                    case 'Semester 4':
                      currentCourses = semester4Courses;
                      break;
                    case 'Semester 5':
                      currentCourses = semester5Courses;
                      break;
                    case 'Semester 6':
                      currentCourses = semester6Courses;
                      break;
                    case 'Semester 7':
                      currentCourses = semester7Courses;
                      break;
                    case 'Semester 8':
                      currentCourses = semester8Courses;
                      break;
                    default:
                      currentCourses = [];
                  }
                });
              },
            ),
            SizedBox(height: screenHeight * 0.02),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Course',
                border: OutlineInputBorder(),
              ),
              value: _selectedCourse,
              items: currentCourses
                  .map((course) => DropdownMenuItem<String>(
                value: course,
                child: Text(course),
              ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCourse = value;
                });
              },
            ),
            SizedBox(height: screenHeight * 0.02),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Lecture Topic',
                border: OutlineInputBorder(),
              ),
              value: _selectedLectureTopic,
              items: lectureTopics
                  .map((topic) => DropdownMenuItem<String>(
                value: topic,
                child: Text(topic),
              ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedLectureTopic = value;
                });
              },
            ),
            SizedBox(height: screenHeight * 0.02),
            ElevatedButton(
              onPressed: () {
                print('Program: $_selectedProgram');
                print('Semester: $_selectedSemester');
                print('Course: $_selectedCourse');
                print('Lecture Topic: $_selectedLectureTopic');
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
