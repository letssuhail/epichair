import 'dart:async';
import 'package:epic/user%20decide%20screen/user_type_decide_screen.dart';
import 'package:epic/user/providers/appointmentGet_provider.dart';
import 'package:epic/user/providers/appointmentService_provider.dart';
import 'package:epic/user/views/screens/login%20screen/login_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

final logoutProvider = StateNotifierProvider<LogoutNotifier, bool>((ref) {
  return LogoutNotifier(ref);
});

class LogoutNotifier extends StateNotifier<bool> {
  final Ref ref;

  LogoutNotifier(this.ref) : super(false);

  // Function to handle the logout logic
  Future<void> logout(BuildContext context) async {
    try {
      // Get the SharedPreferences instance
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      ref.invalidate(appointmentServiceProvider);
      ref.invalidate(appointmentsProvider);
      ref.invalidate(appointmentBookingProvider); // Example: reset profile data
      ref.invalidate(logoutProvider); // Reset this provider itself
      state = true;

      // Navigate to the login screen
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const UserTypeDecideScreen()),
        (route) => false,
      );
    } catch (e) {
      print('Error during logout: $e');
    }
  }
}
