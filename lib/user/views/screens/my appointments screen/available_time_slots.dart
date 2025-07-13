import 'dart:developer';
import 'dart:ui';

import 'package:epic/components/custom_button.dart';
import 'package:epic/components/custom_text.dart';
import 'package:epic/consts/colors.dart';
import 'package:epic/user/providers/appointmentGet_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/appointment_update_provider.dart';
import '../../../providers/barberList_provider.dart';

class AvailableTimeSlots extends ConsumerStatefulWidget {
  final String serviceName;
  final String appointmentBarberName;
  final String appointmentId;
  final String serviceId;
  const AvailableTimeSlots({
    super.key,
    required this.serviceName,
    required this.appointmentBarberName,
    required this.appointmentId,
    required this.serviceId,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AvailableTimeSlotsState();
}

class _AvailableTimeSlotsState extends ConsumerState<AvailableTimeSlots> {
  String? selectedDate;
  String? selectedTime;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.refresh(barberListProvider(widget.serviceName));
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    final barberListAsync = ref.watch(barberListProvider(widget.serviceName));

    return Stack(
      children: [
        Scaffold(
          floatingActionButton: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            child: SizedBox(
              height: 50,
              width: double.infinity,
              child: customButton(
                ontap: () async {
                  if (selectedDate == null || selectedTime == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Please select both date and time')),
                    );
                    return;
                  }

                  setState(() => isLoading = true);

                  final timeParts = selectedTime!.split(':');
                  final hour = int.parse(timeParts[0]);
                  final minute = int.parse(timeParts[1]);

                  final formattedTime =
                      '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';

                  final formattedDate =
                      DateTime.parse(selectedDate!).toString().substring(0, 10);

                  final success = await ref
                      .read(appointmentUpdateProvider.notifier)
                      .updateAppointment(
                        id: widget.appointmentId,
                        service: widget.serviceId,
                        appointmentDate: formattedDate,
                        appointmentTime: formattedTime,
                        status: 'pending',
                      );

                  setState(() => isLoading = false);

                  if (success) {
                    ref.invalidate(appointmentsProvider);
                    Navigator.of(context).pop();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content:
                              Text('Failed to reschedule the appointment')),
                    );
                  }
                },
                backgroundcolor: blue,
                text: '${widget.appointmentBarberName} Complete Reschedule',
                fontsize: screenWidth > 360 ? 16 : 10,
                radius: 12,
                borderwidth: 1,
                textcolor: white,
                borderColor: blue,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          backgroundColor: background,
          appBar: AppBar(
            backgroundColor: background,
            automaticallyImplyLeading: true,
            foregroundColor: black,
            title: customTextOne(
              text: 'Reschedule Appointment',
              fontweight: FontWeight.normal,
              fontsize: screenWidth > 360 ? 16 : 12,
              textcolor: black,
            ),
            elevation: 0,
          ),
          body: barberListAsync.when(
            data: (data) {
              final barber = data.firstWhere(
                (barber) =>
                    barber['name'].toString().toLowerCase() ==
                    widget.appointmentBarberName.toLowerCase(),
                orElse: () => <String, dynamic>{},
              );

              if (barber.isEmpty) {
                return Center(
                  child: Text(
                    'No available slots for ${widget.appointmentBarberName}',
                    style: TextStyle(color: red, fontSize: 16),
                  ),
                );
              }

              final availableSlots = barber['availableSlot'] ?? [];
              final dates = availableSlots
                  .map<String>((slot) => slot['date'] as String)
                  .toList();

              selectedDate ??= dates.isNotEmpty ? dates.first : null;

              final selectedSlot = availableSlots.firstWhere(
                (slot) => slot['date'] == selectedDate,
                orElse: () => <String, dynamic>{},
              );

              final List<dynamic> slots = selectedSlot['slots'] ?? [];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 50,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: dates.length,
                      itemBuilder: (context, index) {
                        final date = dates[index];
                        final dateStr = DateTime.parse(date)
                            .toLocal()
                            .toString()
                            .substring(0, 10);
                        final isSelected = selectedDate == date;

                        return Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedDate = date;
                                selectedTime = null;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: isSelected ? blue : white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: blue),
                              ),
                              child: Center(
                                child: customTextOne(
                                  text: dateStr,
                                  fontweight: FontWeight.w500,
                                  fontsize: 14,
                                  textcolor: isSelected ? white : black,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (slots.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: customTextOne(
                        text: 'No available slots for selected date',
                        fontweight: FontWeight.normal,
                        fontsize: 14,
                        textcolor: red,
                      ),
                    )
                  else
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 16),
                        child: GridView.builder(
                          itemCount: slots.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            mainAxisExtent: 45,
                          ),
                          itemBuilder: (context, index) {
                            final time = slots[index]['time'];
                            final availablity = slots[index]['available'];
                            final isSelected = selectedTime == time;

                            return GestureDetector(
                              onTap: () {
                                if (availablity != true) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'This time slot is already booked'),
                                    ),
                                  );
                                  return;
                                }
                                setState(() {
                                  selectedTime = time;
                                });
                              },
                              child: Container(
                                height: 45,
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? blue
                                      : (availablity == true
                                          ? white
                                          : Colors.grey),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: isSelected
                                        ? blue
                                        : (availablity == true
                                            ? blue
                                            : Colors.grey),
                                  ),
                                ),
                                child: Center(
                                  child: customTextOne(
                                    text: time,
                                    fontweight: FontWeight.w600,
                                    fontsize: screenWidth > 360 ? 16 : 12,
                                    textcolor: isSelected
                                        ? white
                                        : (availablity == true
                                            ? black
                                            : Colors.grey.shade600),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  const SizedBox(height: 80),
                ],
              );
            },
            loading: () => Center(child: CircularProgressIndicator(color: red)),
            error: (error, _) => Center(child: Text('Error: $error')),
          ),
        ),
        if (isLoading)
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
              child: Container(
                color: Colors.black.withOpacity(0.3),
                child: const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
