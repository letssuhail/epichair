import 'package:epic/staff/staff_api_services/appointment_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final staffAppointmentUpdateProvider =
    StateNotifierProvider<StaffAppointmentUpdateNotifier, bool>((ref) {
  return StaffAppointmentUpdateNotifier();
});

class StaffAppointmentUpdateNotifier extends StateNotifier<bool> {
  StaffAppointmentUpdateNotifier() : super(false);
  final staffApiService = StaffApiService();
  Future<bool> updateStaffAppointmentAPI({
    required String id,
    required String appointmentDate,
    required String appointmentTime,
    required String status,
  }) async {
    state = true; // Set loading state to true

    final isSuccess = await staffApiService.updateStaffAppointmentAPI(
      id: id,
      appointmentDate: appointmentDate,
      appointmentTime: appointmentTime,
      status: status,
    );

    if (isSuccess) {
      // log('Appointment updated successfully');
      state = true;
    } else {
      // log('Failed to update appointment');

      state = false;
    }

    return state; // Reset loading state
  }
}
