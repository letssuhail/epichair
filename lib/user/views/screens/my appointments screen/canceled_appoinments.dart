import 'dart:ui';

import 'package:epic/user/providers/appointmentGet_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:epic/consts/colors.dart';
import 'package:epic/components/custom_button.dart';
import 'package:epic/components/custom_text.dart';

class CalcelTabView extends ConsumerWidget {
  const CalcelTabView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double screenWidth = MediaQuery.of(context).size.width;
    // Listen to appointments provider to get the latest data
    final appointmentsAsync = ref.watch(appointmentsProvider);

    return RefreshIndicator(
      backgroundColor: primary,
      color: white,
      onRefresh: () async {
        // Manually refresh the appointments by invalidating the provider
        ref.invalidate(appointmentsProvider);
      },
      child: appointmentsAsync.when(
        data: (data) {
          final ongoingAppointments = data['cancelled'] ?? [];

          if (ongoingAppointments.isEmpty) {
            return Center(
                child: Text(
              'No cancelled appointments',
              style: TextStyle(color: red),
            ));
          }

          return ListView.builder(
            padding: const EdgeInsets.only(top: 10),
            itemCount: ongoingAppointments.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final appointment = ongoingAppointments[index];

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
                // Parse the time string to extract hour and minute
                // Here we use 'hh:mm a' instead of 'jm()' to ensure the format matches the input
                TimeOfDay parsedTime = TimeOfDay.fromDateTime(
                    DateFormat('hh:mm').parse(appointmentTime));

                // Create a new DateTime by combining the date and time
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
                String month = DateFormat('MMM')
                    .format(appointmentDateTime); // 'MMM' for Oct
                String time = DateFormat('h:mm')
                    .format(appointmentDateTime); // 10:00 AM format

                return '${getOrdinalSuffix(int.parse(day))} $month $time';
              }

              // Usage
              // Parse appointmentDate
              DateTime appointmentDate =
                  DateTime.parse(appointment['appointmentDate']!);

              // Combine date and time
              DateTime appointmentDateTime = combineDateAndTime(
                  appointmentDate, appointment['appointmentTime']!);

              // Format the combined date and time
              String formattedDateTime = formatDateTime(appointmentDateTime);
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Container(
                  decoration: BoxDecoration(
                    color: white,
                    border: Border.all(color: grey, width: 1.0),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Stack(
                    children: [
                      // Background Image
                      Positioned.fill(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            'assets/backgroundImages/booking-cancel.jpg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      // Black Blur Effect
                      Positioned.fill(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 1.0, sigmaY: 1.0),
                            child: Container(
                              color: Colors.black.withOpacity(0.1),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Colors.grey,
                                    radius: screenWidth > 360 ? 35 : 30,
                                    backgroundImage: NetworkImage(
                                      appointment['barber']?['image_url'] ??
                                          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT9nHrLn6HQN45iNAfQ2DXKp5nTyosP_2xxR8JDlZNwqgqfHnAjJys4oGh6_PWxP0RbtbY&usqp=CAU',
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                            text: appointment['service']
                                                ['name'],
                                            fontweight: FontWeight.w700,
                                            fontsize:
                                                screenWidth > 360 ? 18 : 14,
                                            textcolor: white,
                                          ),
                                          customTextOne(
                                            text:
                                                ',  Price: CA\$${appointment['service']['price'].toString()}',
                                            fontweight: FontWeight.w700,
                                            fontsize:
                                                screenWidth > 360 ? 18 : 14,
                                            textcolor: white,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      customTextOne(
                                          text: 'Cancelled',
                                          fontweight: FontWeight.bold,
                                          fontsize: screenWidth > 360 ? 16 : 12,
                                          textcolor: red)
                                    ],
                                  ),
                                ],
                              ),
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
          color: primary,
        )),
        error: (error, _) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
