// staff_provider.dart
import 'package:epic/staff/models/staff_model.dart';
import 'package:epic/staff/staff_api_services/appointment_service.dart';
// staff_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Define a provider to fetch staff information
final staffProvider = FutureProvider<List<Staff>>((ref) async {
  final apiService = StaffApiService();
  try {
    final response = await apiService.getStaffInformation();
    if (response != null) {
      return response.map<Staff>((data) => Staff.fromJson(data)).toList();
    } else {
      return [];
    }
  } catch (e) {
    print("Error fetching staff members: $e");
    return [];
  }
});
