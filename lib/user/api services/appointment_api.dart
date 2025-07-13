import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

const String apiUrl = 'https://epichair.vercel.app/api/user/appointment';
const String feedbackUrl =
    'https://epichair.vercel.app/api/user/appointment/feedback';
// const token = userToken;

class AppointmentService {
  // Helper function to get the token from SharedPreferences
  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userToken');
  }

  // GET request - Fetch all appointments for the user
  Future<List<dynamic>?> getAppointments() async {
    final token = await getToken();
    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        // print(response.body);
        return json.decode(response.body); // Parse response as JSON
      } else {
        // print('Failed to fetch appointments: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      // print('Error fetching appointments: $e');
      return null;
    }
  }

  // POST request - Create a new appointment
  Future<bool> createAppointment({
    required String barberId,
    required String serviceId,
    required String appointmentDate,
    required String appointmentTime,
  }) async {
    final token = await getToken();
    try {
      // print('Token: $token');
      // print(appointmentTime);
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'barberId': barberId,
          'service': serviceId,
          'appointmentDate': appointmentDate,
          'appointmentTime': appointmentTime,
        }),
      );
      if (response.statusCode == 201) {
        // print('Appointment created successfully');
        return true;
      } else {
        // print('Failed to create appointment: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      // print('Error creating appointment: $e');
      return false;
    }
  }

  // PUT request - Update an existing appointment
  Future<bool> updateAppointmentAPI({
    required String id,
    required String service,
    required String appointmentDate,
    required String appointmentTime,
    required String status,
  }) async {
    const apiUrl = 'https://epichair.vercel.app/api/user/appointment';
    final token = await getToken();
    // log('_id: $id');
    // log('service: $service');
    // log('appointmentDate: $appointmentDate');
    // log('appointmentTime: $appointmentTime');
    // log('status: $status');
    try {
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          '_id': id,
          'service': service,
          'appointmentDate': appointmentDate,
          'appointmentTime': appointmentTime,
          'status': status,
        }),
      );
      if (response.statusCode == 200) {
        // print('Appointment updated successfully');
        return true;
      } else {
        // print('Failed to update appointment: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      // print('Error updating appointment: $e');
      return false;
    }
  }

  Future<bool> updateFeedback({
    required String appointmentId,
    required String userId,
    required String feedback,
    required int rating,
  }) async {
    try {
      final token = await getToken();
      // print(token);
      final response = await http.put(
        Uri.parse(feedbackUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'appointmentId': appointmentId,
          'userId': userId,
          'feedback': feedback,
          'rating': rating,
        }),
      );

      if (response.statusCode == 200) {
        // print('Feedback updated successfully');
        return true;
      } else {
        // print('Failed to update feedback: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      // print('Error updating feedback: $e');
      return false;
    }
  }
}
