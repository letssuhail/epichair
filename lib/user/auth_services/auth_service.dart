import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final String signupUrl = 'https://epichair.vercel.app/api/auth/signup/user';
  final String verifyOtpUrl =
      'https://epichair.vercel.app/api/auth/signup/user/verifyOtp';
  final String loginUrl = 'https://epichair.vercel.app/api/auth/login';
  final String loginOtpVerifyUrl =
      'https://epichair.vercel.app/api/auth/login/verifyOtp';

  final String logoutUrl = 'https://epichair.vercel.app/api/auth/logout';

  Future<bool> signup(String email) async {
    try {
      final response = await http.post(
        Uri.parse(signupUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({'phoneNumber': email}),
      );

      print('Signup Response: ${response.statusCode} - ${response.body}');
      // Return true if the response status code is 200 or 201
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      // print('Signup error: $e');
      return false;
    }
  }

  Future<Map<String, dynamic>?> verifyOtp(String email, String otp) async {
    try {
      // print('Verifying OTP for $email with OTP $otp');
      final response = await http.post(
        Uri.parse(verifyOtpUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({'otp': otp, 'phoneNumber': email}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        String token = responseData['token'];

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('userToken', token);

        // print('Token stored: $token');
        return responseData;
      } else {
        // print('Error: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      // print('OTP verification error: $e');
      return null;
    }
  }

  Future<bool> login(String email) async {
    try {
      final response = await http.post(
        Uri.parse(loginUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({'phoneNumber': email}),
      );

      print('Login Response: ${response.statusCode} - ${response.body}');
      return response.statusCode == 200;
    } catch (e) {
      // print('Login error: $e');
      return false;
    }
  }

  Future<Map<String, dynamic>?> loginVerifyOtp(String email, String otp) async {
    try {
      // print('Verifying login OTP for $email with OTP $otp');
      final response = await http.post(
        Uri.parse(loginOtpVerifyUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({'otp': otp, 'phoneNumber': email}),
      );

      print(response.body);
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        String token = responseData['token'];

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

  Future<bool> logout() async {
    try {
      // Get the stored token from SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('userToken');

      if (token == null || token.isEmpty) {
        // print('No token found, user might not be logged in.');
        return false;
      }

      // Make the POST request to the logout endpoint
      final response = await http.post(
        Uri.parse(logoutUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Set the Bearer token
        },
      );

      if (response.statusCode == 200) {
        // If logout is successful, remove the token from SharedPreferences
        await prefs.remove('userToken');
        // print('Logout successful');
        return true;
      } else {
        // print('Logout failed: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      // print('Error during logout: $e');
      return false;
    }
  }
}
