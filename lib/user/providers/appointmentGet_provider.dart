import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:epic/user/api%20services/appointment_api.dart';

final appointmentsProvider =
    FutureProvider<Map<String, List<Map<String, dynamic>>>>((ref) async {
  final appointmentService = AppointmentService();
  final appointments = await appointmentService.getAppointments();

  if (appointments == null) {
    return {
      'ongoing': [],
      'confirmed': [],
      'cancelled': [],
      'completed': [],
    };
  }

  // Separate appointments into ongoing and past
  List<Map<String, dynamic>> ongoing = [];
  List<Map<String, dynamic>> confirmed = [];
  List<Map<String, dynamic>> past = [];
  List<Map<String, dynamic>> cancel = [];

  for (var appointment in appointments) {
    if (appointment['status'] == 'pending') {
      print(appointment);
      ongoing.add(appointment);
    } else if (appointment['status'] == 'confirmed') {
      confirmed.add(appointment);
    } else if (appointment['status'] == 'cancelled') {
      cancel.add(appointment);
    } else if (appointment['status'] == 'completed') {
      //print(appointment);
      past.add(appointment);
    }
  }

  return {
    'ongoing': ongoing,
    'confirmed': confirmed,
    'cancelled': cancel,
    'completed': past,
  };
});
