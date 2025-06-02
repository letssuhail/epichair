import 'dart:developer';

import 'package:epic/user/providers/appointmentGet_provider.dart';
import 'package:epic/user/providers/appointment_update_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:epic/consts/colors.dart';
import 'package:epic/components/custom_button.dart';
import 'package:epic/components/custom_text.dart';

class OnGoingTabView extends ConsumerStatefulWidget {
  const OnGoingTabView({super.key});

  @override
  ConsumerState<OnGoingTabView> createState() => _OnGoingTabViewState();
}

class _OnGoingTabViewState extends ConsumerState<OnGoingTabView> {
  final Set<String> _loadingItems = {};

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    final appointmentsAsync = ref.watch(appointmentsProvider);

    return RefreshIndicator(
      backgroundColor: red,
      color: white,
      onRefresh: () async {
        ref.invalidate(appointmentsProvider);
      },
      child: appointmentsAsync.when(
        data: (data) {
          final ongoingAppointments = data['ongoing'] ?? [];

          if (ongoingAppointments.isEmpty) {
            return Center(
              child:
                  Text('No ongoing appointments', style: TextStyle(color: red)),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.only(top: 10),
            itemCount: ongoingAppointments.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final appointment = ongoingAppointments[index];
              log('appointment: $appointment');
              final appointmentId = appointment['_id'];
              final appointmentCreatedAt = appointment['createdAt'];
              log('appointmentCreatedAt: ${appointmentCreatedAt.toString()}');
              final appointmentPrice = appointment['service']['price'];
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
                    border: Border.all(color: newGrey, width: 1.0),
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
                                appointment['barber']?['image_url'] != null
                                    ? CircleAvatar(
                                        radius: screenWidth > 360 ? 35 : 30,
                                        backgroundColor: blue,
                                        backgroundImage: NetworkImage(
                                            appointment['barber']
                                                ?['image_url']),
                                      )
                                    : CircleAvatar(
                                        backgroundColor: blue,
                                        radius: screenWidth > 360 ? 35 : 30,
                                        child: Icon(Icons.person,
                                            color: white, size: 20),
                                      ),
                                const SizedBox(height: 12),
                                Column(
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
                                              ',  Price: CA\$${appointmentPrice.toString()}',
                                          fontweight: FontWeight.w700,
                                          fontsize: screenWidth > 360 ? 18 : 14,
                                          textcolor: white,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 14),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    height: 35,
                                    child: customButton(
                                      ontap: () {
                                        _showRescheduleDialog(context, ref,
                                            appointmentId, serviceId);
                                      },
                                      backgroundcolor: newGrey,
                                      text: 'Reschedule',
                                      fontsize: screenWidth > 360 ? 14 : 10,
                                      radius: 45,
                                      borderwidth: 1,
                                      textcolor: white,
                                      borderColor: newGrey,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: SizedBox(
                                    height: 35,
                                    width: 120,
                                    child: customButton(
                                      ontap: () {
                                        _showConfirmationDialog(
                                            context,
                                            ref,
                                            appointmentId,
                                            serviceId,
                                            false,
                                            appointmentDate,
                                            appointment['appointmentTime']!,
                                            appointmentCreatedAt);
                                      },
                                      backgroundcolor: blue,
                                      text: 'Cancel',
                                      fontsize: screenWidth > 360 ? 14 : 10,
                                      radius: 45,
                                      borderwidth: 1,
                                      textcolor: white,
                                      borderColor: blue,
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
        loading: () => Center(child: CircularProgressIndicator(color: red)),
        error: (error, _) => Center(child: Text('Error: $error')),
      ),
    );
  }
}

// Dialog for Rescheduling
Future<void> _showRescheduleDialog(BuildContext context, WidgetRef ref,
    String appointmentId, String serviceId) async {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();

  await showDialog(
    context: context,
    builder: (BuildContext context) {
      double screenWidth = MediaQuery.of(context).size.width;
      return AlertDialog(
        backgroundColor: background,
        title: Text(
          'Reschedule Appointment',
          style:
              TextStyle(color: newGrey, fontSize: screenWidth > 360 ? 18 : 14),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: dateController,
              readOnly: true,
              decoration: InputDecoration(
                hintText: 'Select Date',
                hintStyle: TextStyle(color: grey),
              ),
              onTap: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2101),
                  builder: (BuildContext context, Widget? child) {
                    return Theme(
                      data: ThemeData.light().copyWith(
                          primaryColor: red,
                          hintColor: red,
                          colorScheme: ColorScheme.light(
                            primary: red,
                            onPrimary: Colors.white,
                            onSurface: Colors.black,
                          ),
                          dialogBackgroundColor: background),
                      child: child!,
                    );
                  },
                );

                if (picked != null) {
                  selectedDate = picked;
                  dateController.text =
                      picked.toIso8601String().split('T').first;
                }
              },
            ),
            TextField(
              controller: timeController,
              readOnly: true,
              decoration: InputDecoration(
                hintText: 'Select Time',
                hintStyle: TextStyle(color: grey),
              ),
              onTap: () async {
                final TimeOfDay? picked = await showTimePicker(
                  context: context,
                  initialTime: selectedTime,
                  builder: (BuildContext context, Widget? child) {
                    return Theme(
                      data: ThemeData.light().copyWith(
                        primaryColor: red,
                        colorScheme: ColorScheme.light(
                          primary: red,
                          onSurface: Colors.black,
                        ),
                        dialogBackgroundColor: background,
                      ),
                      child: child!,
                    );
                  },
                );

                if (picked != null) {
                  TimeOfDay roundedTime = _roundToNearestQuarter(picked);
                  selectedTime = roundedTime;
                  timeController.text = roundedTime.format(context);
                }
              },
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Cancel',
                style: TextStyle(
                    color: black, fontSize: screenWidth > 360 ? 16 : 12)),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('Confirm',
                style: TextStyle(
                    color: black, fontSize: screenWidth > 360 ? 16 : 12)),
            onPressed: () {
              ref
                  .read(appointmentUpdateProvider.notifier)
                  .updateAppointment(
                    id: appointmentId,
                    service: serviceId,
                    appointmentDate: dateController.text,
                    appointmentTime: timeController.text,
                    status: 'pending',
                  )
                  .then((success) {
                if (success) {
                  ref.invalidate(appointmentsProvider);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Failed to reschedule the appointment')),
                  );
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

// Function to round time to the nearest quarter (15-minute intervals)
TimeOfDay _roundToNearestQuarter(TimeOfDay time) {
  int minute = time.minute;
  int roundedMinute = (minute / 15).round() * 15;
  if (roundedMinute == 60) {
    return TimeOfDay(hour: (time.hour + 1) % 24, minute: 0);
  }
  return TimeOfDay(hour: time.hour, minute: roundedMinute);
}

// Dialog for Cancel Confirmation
Future<void> _showConfirmationDialog(
  BuildContext context,
  WidgetRef ref,
  String appointmentId,
  String serviceId,
  bool isConfirm,
  DateTime appointmentDate,
  String appointmentTime,
  String appointmentCreatedAt,
) async {
  final createdAt = DateTime.parse(appointmentCreatedAt);
  final now = DateTime.now();
  final differenceInMinutes = now.difference(createdAt).inMinutes;

  showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      double screenWidth = MediaQuery.of(context).size.width;
      return AlertDialog(
        backgroundColor: background,
        title: Text(
          isConfirm ? 'Confirm Appointment' : 'Cancel Appointment',
          style: TextStyle(color: red, fontSize: screenWidth > 360 ? 18 : 14),
        ),
        content: Text(
          isConfirm
              ? 'Are you sure you want to confirm this appointment?'
              : 'Are you sure you want to cancel this appointment?',
          style: TextStyle(color: red, fontSize: screenWidth > 360 ? 16 : 12),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('No',
                style: TextStyle(
                    color: red, fontSize: screenWidth > 360 ? 16 : 12)),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('Yes',
                style: TextStyle(
                    color: red, fontSize: screenWidth > 360 ? 16 : 12)),
            onPressed: () {
              if (!isConfirm && differenceInMinutes < 30) {
                final remainingMinutes = 30 - differenceInMinutes;
                Navigator.of(context).pop(); // close dialog
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(
                          'Wait to Cancel\nAppointment $remainingMinutes Can be cancelled after minutes.')),
                );
              } else {
                ref
                    .read(appointmentUpdateProvider.notifier)
                    .updateAppointment(
                      id: appointmentId,
                      service: serviceId,
                      appointmentDate: appointmentDate.toIso8601String(),
                      appointmentTime: appointmentTime,
                      status: isConfirm ? 'confirmed' : 'cancelled',
                    )
                    .then((success) {
                  if (success) {
                    ref.invalidate(appointmentsProvider);
                  }
                });
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      );
    },
  );
}
