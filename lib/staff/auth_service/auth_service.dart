import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer';

class StaffAuthService {
  final loginUrl = 'https://epichair.vercel.app/api/auth/login';
  final loginOtpVerifyUrl =
      'https://epichair.vercel.app/api/auth/login/verifyOtp';

  Future<bool> loginStaff(String email) async {
    try {
      final response = await http.post(
        Uri.parse(loginUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({'phoneNumber': email}),
      );

      // print('Login Response: ${response.statusCode} - ${response.body}');
      return response.statusCode == 200;
    } catch (e) {
      // print('Login error: $e');
      return false;
    }
  }

  Future<Map<String, dynamic>?> loginStaffVerifyOtp(
      String email, String otp) async {
    try {
      // print('Verifying login OTP for $email with OTP $otp');
      final response = await http.post(
        Uri.parse(loginOtpVerifyUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({'otp': otp, 'phoneNumber': email}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        String token = responseData['token'];

        log(token);

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('userToken', token);

        // print('Token stored: $token');

        return responseData;
      } else {
        // print('Error: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      // print('Login OTP verification error: $e');
      return null;
    }
  }
}
