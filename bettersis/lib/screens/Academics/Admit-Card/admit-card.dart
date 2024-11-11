import 'package:bettersis/modules/bettersis_appbar.dart';
import 'package:bettersis/screens/Misc/appdrawer.dart';
import 'package:bettersis/utils/themes.dart';
import 'package:flutter/material.dart';
import '../../../modules/Admit Card/generate-admit-card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdmitCard extends StatefulWidget {
  final VoidCallback onLogout;
  final String userId;
  final String userDept;
  final String userName;
  final String userProgram;
  final String userSemester;

  const AdmitCard(
      {super.key,
      required this.onLogout,
      required this.userDept,
      required this.userId,
      required this.userName,
      required this.userProgram,
      required this.userSemester});

  @override
  State<AdmitCard> createState() => _AdmitCardState();
}

class _AdmitCardState extends State<AdmitCard> {
  Future<List<String>> _fetchAllCourses() async {
    try {
      // Fetch all course documents from the specified department and semester collections
      QuerySnapshot courseSnapshot = await FirebaseFirestore.instance
          .collection('Courses')
          .doc(widget.userDept)
          .collection(widget.userSemester[0]) 
          .get();

      // List to store course details as strings
      List<String> coursesList = [];

      for (var courseDoc in courseSnapshot.docs) {
        String courseCode = courseDoc.id;
        Map<String, dynamic>? data = courseDoc.data() as Map<String, dynamic>?;
        String? courseName = data?['name'] ?? 'Unknown Course';
        String courseString = '$courseCode: $courseName';
        coursesList.add(courseString);
      }

      return coursesList;
    } catch (error) {
      print('Error fetching courses: $error');
      return ['Error fetching courses'];
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = AppTheme.getTheme(widget.userDept);

    return Scaffold(
      drawer: CustomAppDrawer(theme: theme),
      appBar: AppBar(
        title: Text('Admit Card'),
      ),
      body: FutureBuilder<List<String>>(
        future: _fetchAllCourses(),
        builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.hasData && snapshot.data != null) {
            return GenerateAdmitCard(
              semester: "Winter",
              examination: "Mid",
              registeredCourses: snapshot.data!, 
              userDept: widget.userDept,
              userId: widget.userId,
              userName: widget.userName,
              userProgram: widget.userProgram,
              userSemester: widget.userSemester,
            );
          }
          return Center(child: Text('No courses available'));
        },
      ),
    );
  }
}