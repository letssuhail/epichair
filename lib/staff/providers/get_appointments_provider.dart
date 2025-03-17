import 'package:epic/staff/staff_api_services/appointment_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

final staffAppointmentsProvider =
    FutureProvider<Map<String, dynamic>>((ref) async {
  final staffAppointmentService = StaffApiService();
  final appointments = await staffAppointmentService.getStaffAppointments();

  if (appointments == null) {
    return {
      'upcoming': [],
      'confirmed': [],
      'cancelled': [],
      'completed': [],
      'todayAppointmentsCount': 0,
    };
  }

  List<Map<String, dynamic>> upcoming = [];
  List<Map<String, dynamic>> confirmed = [];
  List<Map<String, dynamic>> past = [];
  List<Map<String, dynamic>> cancelled = [];
  int todayAppointmentsCount = 0;

  // Get today's date in yyyy-MM-dd format
  final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

  for (var appointment in appointments) {
    final appointmentDateStr = appointment['appointmentDate'];
    final appointmentStatus = appointment['status'];

    // Parse the date string from API
    final appointmentDate = DateTime.tryParse(appointmentDateStr);
    if (appointmentDate != null) {
      final formattedAppointmentDate =
          DateFormat('yyyy-MM-dd').format(appointmentDate);

      // Check if the appointment date is today
      if (formattedAppointmentDate == today) {
        todayAppointmentsCount++;
        // log('Today\'s Appointment Count: $todayAppointmentsCount');
      }
    }

    // Separate appointments by status
    if (appointmentStatus == 'pending') {
      upcoming.add(appointment);
    } else if (appointmentStatus == 'confirmed') {
      confirmed.add(appointment);
    } else if (appointmentStatus == 'cancelled') {
      cancelled.add(appointment);
    } else if (appointmentStatus == 'completed') {
      past.add(appointment);
    }
  }

  return {
    'upcoming': upcoming,
    'confirmed': confirmed,
    'cancelled': cancelled,
    'completed': past,
    'todayAppointmentsCount': todayAppointmentsCount,
  };
});
