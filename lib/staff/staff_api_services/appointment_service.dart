import 'dart:convert';
import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../consts/const.dart';

// String token = userToken;

const String appointmentApiUrl =
    'https://epichair.vercel.app/api/staff/appointment';

const String staffInfoApiUrl = 'https://epichair.vercel.app/api/staffinfo';

class StaffApiService {
  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userToken');
  }

  // GET request - Fetch all appointments for the user
  Future<List<dynamic>?> getStaffAppointments() async {
    final token = await getToken();
    try {
      final response = await http.get(
        Uri.parse(appointmentApiUrl),
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

  // PUT request - Update an existing appointment
  Future<bool> updateStaffAppointmentAPI({
    required String id,
    // required String service,
    required String appointmentDate,
    required String appointmentTime,
    required String status,
  }) async {
    const apiUrl = 'https://epichair.vercel.app/api/staff/appointment';
    final token = await getToken();
    try {
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          '_id': id,
          // 'service': service,
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

  Future<List<dynamic>?> getStaffInformation() async {
    final token = await getToken();
    try {
      final response = await http.get(Uri.parse(staffInfoApiUrl), headers: {
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        log(response.body);
        final data = json.decode(response.body);

        return data['staffWithSlots']; // Return the list of staff members
      } else {
        print('Failed to fetch staff information: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching staff information: $e');
      return null;
    }
  }
}
