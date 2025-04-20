import 'dart:convert';
import 'dart:developer';
import 'package:epic/user/models/staff_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

final barberListProvider =
    FutureProvider.family<List<Map<String, dynamic>>, String>(
  (ref, serviceId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('userToken');

    final response = await http.get(
      Uri.parse('https://epichair.vercel.app/api/staffinfo'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    log('response body: ${response.body}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final staffModel = StaffModel.fromJson(data);
      final staffMembers = staffModel.staffMembers ?? [];

      List<Map<String, dynamic>> filteredStaff = [];

      for (var staff in staffMembers) {
        if (staff.services != null &&
            staff.services!.contains(serviceId) &&
            staff.workingHours != null) {
          filteredStaff.add({
            'id': staff.id ?? 'unknown',
            'name': staff.username ?? 'unknown',
            'imageUrl': staff.imageUrl ??
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT9nHrLn6HQN45iNAfQ2DXKp5nTyosP_2xxR8JDlZNwqgqfHnAjJys4oGh6_PWxP0RbtbY&usqp=CAU',
            'isOnHoliday': staff.isOnHoliday ?? false,
            'workingHours': {
              'start': staff.workingHours?.start ?? 'N/A',
              'end': staff.workingHours?.end ?? 'N/A',
            },
          });
        }
      }

      return filteredStaff;
    } else {
      throw Exception('Failed to fetch staff');
    }
  },
);
