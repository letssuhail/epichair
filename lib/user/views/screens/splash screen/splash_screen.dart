import 'dart:async';
import 'package:epic/components/custom_text.dart';
import 'package:epic/consts/colors.dart';
import 'package:epic/staff/views/screens/bottom_nav_bar_staff_screen/bottom_nav_bar_staff.dart';
import 'package:epic/user/views/screens/bottom_nav_bar_client_screen/bottom_nav_bar_client.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  final bool isStaff;
  const SplashScreen({super.key, required this.isStaff});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            builder: (context) => widget.isStaff
                ? const BottomNavBarStaff()
                : const BottomNavBarClient()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
      body: Stack(
        children: [
          // Background image

          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/backgroundImages/splash.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Content on top of the background
          Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 200),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Image.asset(
                    'assets/logo/epic-hair.png',
                    width: 170,
                  ),

                  // Add more widgets as needed
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
