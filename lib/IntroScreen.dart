import 'package:flutter/material.dart';
import 'package:intro_screen_onboarding_flutter/intro_app.dart';
import 'package:upasthiti/LoginScreen.dart';

class IntroSlides extends StatelessWidget {
  final List<Introduction> list = [
    Introduction(
      title: 'Convenient',
      subTitle: 'Get your attendence marked easily',
      imageUrl: 'GIF/img3.webp',
    ),
    Introduction(
      title: 'History',
      subTitle: 'Get your attendence history at your finger tips',
      imageUrl: 'GIF/gif4.webp',
    ),
    Introduction(
      title: 'Profile',
      subTitle: 'Maintain your personal profile',
      imageUrl: 'GIF/img1.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IntroScreenOnboarding(
        backgroudColor: Colors.white,
        foregroundColor: Color(0xFF0165ff),
        introductionList: list,
        onTapSkipButton: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Login(),
            ), //MaterialPageRoute
          );
        },
        // foregroundColor: Colors.red,
      ),
    );
  }
}
