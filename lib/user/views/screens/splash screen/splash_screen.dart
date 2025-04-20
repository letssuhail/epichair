import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:epic/user%20decide%20screen/user_type_decide_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:epic/consts/colors.dart';
import 'package:epic/staff/views/screens/bottom_nav_bar_staff_screen/bottom_nav_bar_staff.dart';
import 'package:epic/user/views/screens/bottom_nav_bar_client_screen/bottom_nav_bar_client.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () => navigateBasedOnAuth());
  }

  Future<void> navigateBasedOnAuth() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('userToken');

    if (token != null && token.isNotEmpty) {
      log('token $token');
      final parts = token.split('.');
      if (parts.length == 3) {
        try {
          final payload =
              utf8.decode(base64Url.decode(base64Url.normalize(parts[1])));
          final decodedPayload = jsonDecode(payload);

          bool isStaff = decodedPayload['role'] == 'staff';

          // Navigate after some delay to prevent UI lag
          await Future.delayed(const Duration(seconds: 2));

          if (!mounted)
            return; // Prevents calling Navigator after widget is disposed

          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => isStaff
                  ? const BottomNavBarStaff()
                  : const BottomNavBarClient(),
            ),
          );
          return;
        } catch (e) {
          debugPrint('Token decoding error: $e');
        }
      }
    }

    // If token is invalid or not present, navigate to UserTypeDecideScreen
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const UserTypeDecideScreen()),
    );
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
          // Logo and Loading Indicator
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
                  const SizedBox(height: 20),
                  const CircularProgressIndicator(
                      color: Colors.white), // Show loading
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
