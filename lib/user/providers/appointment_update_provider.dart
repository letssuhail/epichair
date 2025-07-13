import 'package:epic/user/api%20services/appointment_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final appointmentUpdateProvider =
    StateNotifierProvider<AppointmentUpdateNotifier, bool>((ref) {
  return AppointmentUpdateNotifier();
});

class AppointmentUpdateNotifier extends StateNotifier<bool> {
  AppointmentUpdateNotifier() : super(false);
  final appointmentService = AppointmentService();
  Future<bool> updateAppointment({
    required String id,
    required String service,
    required String appointmentDate,
    required String appointmentTime,
    required String status,
  }) async {
    state = true; // Set loading state to true

    final isSuccess = await appointmentService.updateAppointmentAPI(
      id: id,
      service: service,
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
