import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'model/User.dart';
import 'HomeScreen.dart';
import 'IntroScreen.dart';

class Access extends StatefulWidget {
  @override
  State<Access> createState() => _AccessState();
}

class _AccessState extends State<Access> {
  bool userAvailable = false;
  late SharedPreferences sharedPreferences;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    sharedPreferences = await SharedPreferences.getInstance();

    try {
      if (sharedPreferences.getString("StudentId") != null) {
        setState(() {
          User.studentId = sharedPreferences.getString("StudentId")!;
          userAvailable = true;
        });
      }
    } catch (e) {
      setState(() {
        userAvailable = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return userAvailable ? Home() : IntroSlides();
  }
}
