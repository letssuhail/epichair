import 'package:epic/user/api%20services/appointment_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Define a provider for AppointmentService
final appointmentServiceProvider = Provider((ref) => AppointmentService());

// Define a StateNotifier for managing the appointment booking state
final appointmentBookingProvider =
    StateNotifierProvider<AppointmentBookingNotifier, AsyncValue<bool>>((ref) {
  final appointmentService = ref.watch(appointmentServiceProvider);
  return AppointmentBookingNotifier(appointmentService);
});

class AppointmentBookingNotifier extends StateNotifier<AsyncValue<bool>> {
  final AppointmentService appointmentService;

  AppointmentBookingNotifier(this.appointmentService)
      : super(const AsyncValue.data(false));

  Future<void> bookAppointment({
    required String barberId,
    required String serviceId,
    required String appointmentDate,
    required String appointmentTime,
  }) async {
    state = const AsyncValue.loading();
    try {
      // print(barberId);
      // print(serviceId);
      // print(appointmentDate);
      // print(appointmentTime);
      final success = await appointmentService.createAppointment(
        barberId: barberId,
        serviceId: serviceId,
        appointmentDate: appointmentDate,
        appointmentTime: appointmentTime,
      );
      if (success) {
        state = const AsyncValue.data(true);
      } else {
        state = AsyncValue.error(
            'There is a pending appointment at the selected time. Next available time',
            StackTrace.current);
      }
    } catch (e, StackTrace) {
      state = AsyncValue.error(e, StackTrace);
    }
  }
}
