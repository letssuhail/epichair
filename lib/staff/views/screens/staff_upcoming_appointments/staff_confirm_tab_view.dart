import 'dart:ui';

import 'package:epic/staff/providers/get_appointments_provider.dart';
import 'package:epic/staff/providers/staff_appointment_update_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:epic/consts/colors.dart';
import 'package:epic/components/custom_button.dart';
import 'package:epic/components/custom_text.dart';

class StaffConfirmTabView extends ConsumerWidget {
  const StaffConfirmTabView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double screenWidth = MediaQuery.of(context).size.width;
    final appointmentsAsync = ref.watch(staffAppointmentsProvider);

    return RefreshIndicator(
      backgroundColor: red,
      color: white,
      onRefresh: () async {
        ref.invalidate(staffAppointmentsProvider);
      },
      child: appointmentsAsync.when(
        data: (data) {
          final ongoingAppointments = data['confirmed'] ?? [];

          if (ongoingAppointments.isEmpty) {
            return Center(
                child: Text(
              'No confirm appointments',
              style: TextStyle(color: black),
            ));
          }

          return ListView.builder(
            padding: const EdgeInsets.only(top: 10),
            itemCount: ongoingAppointments.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final appointment = ongoingAppointments[index];
              final appointmentId = appointment['_id'];
              final serviceId = appointment['service']['_id'];

              String getOrdinalSuffix(int day) {
                if (day >= 11 && day <= 13) return '${day}th';
                switch (day % 10) {
                  case 1:
                    return '${day}st';
                  case 2:
                    return '${day}nd';
                  case 3:
                    return '${day}rd';
                  default:
                    return '${day}th';
                }
              }

              DateTime combineDateAndTime(
                  DateTime appointmentDate, String appointmentTime) {
                TimeOfDay parsedTime = TimeOfDay.fromDateTime(
                    DateFormat('hh:mm').parse(appointmentTime));
                return DateTime(
                  appointmentDate.year,
                  appointmentDate.month,
                  appointmentDate.day,
                  parsedTime.hour,
                  parsedTime.minute,
                );
              }

              String formatDateTime(DateTime appointmentDateTime) {
                String day = DateFormat('d').format(appointmentDateTime);
                String month = DateFormat('MMM').format(appointmentDateTime);
                String time = DateFormat('h:mm').format(appointmentDateTime);

                return '${getOrdinalSuffix(int.parse(day))} $month $time';
              }

              DateTime appointmentDate =
                  DateTime.parse(appointment['appointmentDate']!);

              DateTime appointmentDateTime = combineDateAndTime(
                  appointmentDate, appointment['appointmentTime']!);

              String formattedDateTime = formatDateTime(appointmentDateTime);

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Container(
                  decoration: BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Stack(
                    children: [
                      // Background Image
                      Positioned.fill(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            'assets/backgroundImages/my-booking.jpg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                appointment['user']?['image_url'] != null
                                    ? CircleAvatar(
                                        radius: screenWidth > 360 ? 35 : 30,
                                        backgroundColor: blue,
                                        backgroundImage: NetworkImage(
                                            appointment['user']?['image_url']),
                                      )
                                    : CircleAvatar(
                                        backgroundColor: blue,
                                        radius: screenWidth > 360 ? 35 : 30,
                                        child: Icon(Icons.person,
                                            color: white, size: 26),
                                      ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    customTextOne(
                                      text: formattedDateTime,
                                      fontweight: FontWeight.w700,
                                      fontsize: screenWidth > 360 ? 18 : 14,
                                      textcolor: white,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        customTextOne(
                                          text: appointment['service']['name'],
                                          fontweight: FontWeight.w700,
                                          fontsize: screenWidth > 360 ? 18 : 14,
                                          textcolor: white,
                                        ),
                                        customTextOne(
                                          text:
                                              ',  Price: ${appointment['service']['price'].toString()}',
                                          fontweight: FontWeight.w700,
                                          fontsize: screenWidth > 360 ? 18 : 14,
                                          textcolor: white,
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 14.sp),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    height: 35,
                                    child: customButton(
                                      ontap: () {
                                        _showCompletedConfirmationDialog(
                                            context,
                                            ref,
                                            appointmentId,
                                            serviceId,
                                            appointmentDate,
                                            appointment['appointmentTime']!);
                                      },
                                      backgroundcolor: newGrey,
                                      text: 'Completed',
                                      fontsize: screenWidth > 360 ? 16 : 12,
                                      radius: 45,
                                      borderwidth: 1,
                                      textcolor: white,
                                      borderColor: newGrey,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => Center(
            child: CircularProgressIndicator(
          color: red,
        )),
        error: (error, _) => Center(child: Text('Error: $error')),
      ),
    );
  }

  // Dialog for Cancel Confirmation
  Future<void> _showCompletedConfirmationDialog(
      BuildContext context,
      WidgetRef ref,
      String appointmentId,
      String serviceId,
      DateTime appointmentDate,
      String appointmentTime) async {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        double screenWidth = MediaQuery.of(context).size.width;
        return AlertDialog(
          backgroundColor: white,
          title: Text(
            'Completed Appointment',
            style: TextStyle(
              color: black,
              fontSize: screenWidth > 360 ? 18 : 14,
            ),
          ),
          content: Text(
            'Are you sure you want to completed this appointment?',
            style:
                TextStyle(color: black, fontSize: screenWidth > 360 ? 16 : 12),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('No',
                  style: TextStyle(
                      color: black, fontSize: screenWidth > 360 ? 16 : 12)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Yes',
                  style: TextStyle(
                      color: black, fontSize: screenWidth > 360 ? 16 : 12)),
              onPressed: () {
                ref
                    .read(staffAppointmentUpdateProvider.notifier)
                    .updateStaffAppointmentAPI(
                        id: appointmentId,
                        appointmentDate: appointmentDate.toIso8601String(),
                        appointmentTime: appointmentTime,
                        status: 'completed')
                    .then((success) {
                  if (success) {
                    ref.invalidate(
                        staffAppointmentsProvider); // Refresh the list upon success
                  }
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
