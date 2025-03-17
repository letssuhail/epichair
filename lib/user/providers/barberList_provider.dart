import 'dart:convert';
import 'package:epic/consts/const.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// const token = userToken;
// Update barberListProvider to accept serviceId as a parameter
final barberListProvider =
    FutureProvider.family<List<Map<String, String>>, String>(
        (ref, serviceId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('userToken');

  // Fetch staff from the API
  final response = await http.get(
    Uri.parse('https://epichair.vercel.app/api/staffinfo'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);

    // Safely handle if 'staffMembers' is null or not a list
    final staffMembers = data['staffMembers'] as List<dynamic>? ?? [];

    List<Map<String, String>> filteredStaff = [];

    // Filter the staff based on the selected serviceId
    for (var staff in staffMembers) {
      if (staff.containsKey('services') &&
          staff['services'] != null &&
          staff['services'] is List &&
          staff['services'].contains(serviceId)) {
        filteredStaff.add({
          'id': staff['_id'] ?? 'unknown',
          'name': staff['username'] ?? 'unknown',
          'imageUrl': staff['image_url'] ??
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT9nHrLn6HQN45iNAfQ2DXKp5nTyosP_2xxR8JDlZNwqgqfHnAjJys4oGh6_PWxP0RbtbY&usqp=CAU',
        });
      }
    }
    // print(filteredStaff);
    return filteredStaff;
  } else {
    throw Exception('Failed to fetch staff');
  }
});
