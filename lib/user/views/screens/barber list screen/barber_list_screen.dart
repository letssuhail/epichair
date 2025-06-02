import 'dart:developer';

import 'package:epic/user/views/screens/book%20appointment%20screen/book_appointment_screen.dart';
import 'package:flutter/material.dart';
import 'package:epic/consts/colors.dart';
import 'package:epic/user/providers/barberList_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:intl/intl.dart'; // To format time in AM/PM format

class BarberListScreen extends ConsumerStatefulWidget {
  final String serviceId;
  final String serviceName;
  final String servicePrice;

  const BarberListScreen({
    required this.serviceName,
    required this.serviceId,
    required this.servicePrice,
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _BarberListScreenState();
}

class _BarberListScreenState extends ConsumerState<BarberListScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.invalidate(barberListProvider(widget.serviceName));
    });
  }

  // Helper function to convert 24-hour format time to 12-hour format with AM/PM
  String convertToAMPM(String time24) {
    final format = DateFormat("hh:mm a"); // 12-hour format with AM/PM
    final parsedTime = DateFormat("HH:mm").parse(time24); // Parse 24-hour time
    return format.format(parsedTime); // Convert to AM/PM format
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    final barberListAsync = ref.watch(barberListProvider(widget.serviceName));

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        foregroundColor: black,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: red,
        child: Icon(
          Icons.refresh,
          color: white,
        ),
        onPressed: () {
          try {
            ref.invalidate(barberListProvider(widget.serviceName));
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: background,
                content: Text(
                  'Refresh successfully',
                  style: TextStyle(color: red),
                )));
          } catch (e) {
            SnackBar(
                backgroundColor: Colors.red,
                content: Text(
                  'Refresh Field',
                  style: TextStyle(color: white),
                ));
          }
        },
      ),
      body: barberListAsync.when(
        data: (barbers) {
          if (barbers == null || barbers.isEmpty) {
            return Center(
              child: Text(
                'No barbers available for this service',
                style: TextStyle(color: black),
              ),
            );
          }

          return ListView.builder(
            itemCount: barbers.length,
            itemBuilder: (context, index) {
              final barber = barbers[index];

              log('availableSlot ${barber['availableSlot']}');
              final workingHours = barber['workingHours'];
              final startTime = workingHours != null
                  ? convertToAMPM(workingHours['start']!)
                  : 'N/A';
              final endTime = workingHours != null
                  ? convertToAMPM(workingHours['end']!)
                  : 'N/A';

              return Column(
                children: [
                  if (index == 0)
                    Text(
                      'Our Barbers',
                      style: TextStyle(
                        color: newGrey,
                        fontWeight: FontWeight.bold,
                        fontSize: screenWidth > 360 ? 20 : 16,
                      ),
                    ),
                  SizedBox(height: index == 0 ? 20 : 10),
                  Container(
                    padding: EdgeInsets.symmetric(
                        vertical: screenWidth > 360 ? 5 : 2),
                    margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: newGrey),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 22,
                        backgroundColor: grey,
                        backgroundImage: NetworkImage(barber['imageUrl']!),
                      ),
                      title: Text(
                        barber['name']!,
                        style: TextStyle(
                          fontSize: screenWidth > 360 ? 20 : 14,
                          color: black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        '$startTime - $endTime',
                        style: TextStyle(
                          fontSize: screenWidth > 360 ? 14 : 12,
                          color: black.withOpacity(0.6),
                        ),
                      ),
                      trailing: Text(
                        barber['isOnHoliday'] == true
                            ? 'On Holiday'
                            : 'Available',
                        style: TextStyle(
                          fontSize: screenWidth > 360 ? 18 : 12,
                          color: barber['isOnHoliday'] == true
                              ? red
                              : Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: () {
                        if (barber['isOnHoliday'] == true) {
                          Fluttertoast.showToast(
                            msg:
                                'The barber is on holiday. Choose another barber.',
                            backgroundColor: red,
                            textColor: white,
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BookAppointmentScreen(
                                barberId: barber['id']!,
                                barberName: barber['name']!,
                                serviceId: widget.serviceId,
                                barberImage: barber['imageUrl']!,
                                serviceName: widget.serviceName,
                                servicePrice: widget.servicePrice,
                                availableSlot: barber['availableSlot'],
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              );
            },
          );
        },
        loading: () => Center(
          child: CircularProgressIndicator(
            color: red,
          ),
        ),
        error: (error, _) {
          log('error $error');
          return Center(
            child: Text(
              'Failed to load barbers: ${error.toString()}',
              style: TextStyle(color: Colors.red),
            ),
          );
        },
      ),
    );
  }
}
