import 'dart:ui';

import 'package:epic/user/api%20services/appointment_api.dart';
import 'package:epic/components/custom_button.dart';
import 'package:epic/components/custom_text.dart';
import 'package:epic/consts/colors.dart';
import 'package:epic/user/views/screens/confirm%20appointment%20screen/confirm_appointment_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:intl/intl.dart';

final appointmentServiceProvider = Provider<AppointmentService>((ref) {
  return AppointmentService();
});

class BookAppointmentScreen extends StatefulWidget {
  final String barberId;
  final String barberName;
  final String serviceId;
  final String barberImage;
  final String serviceName;
  final String servicePrice;

  const BookAppointmentScreen(
      {super.key,
      required this.barberId,
      required this.barberName,
      required this.serviceId,
      required this.barberImage,
      required this.serviceName,
      required this.servicePrice});

  @override
  // ignore: library_private_types_in_public_api
  _BookAppointmentScreenState createState() => _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends State<BookAppointmentScreen> {
  // Selected date and time variables
  DateTime? _selectedDate;
  String? _selectedTimeSlot;

  // List of available dates (for example purposes, adjust as needed)
  final List<DateTime> availableDates = List.generate(8, (index) {
    return DateTime.now().add(Duration(days: index));
  });

  // List of available time slots (for example purposes, adjust as needed)
  final List<String> availableTimeSlots = [
    "10:00",
    "10:30",
    "11:00",
    "12:00",
    "12:30",
    "01:00",
  ];

  // Function to handle date selection
  void _onDateSelected(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
  }

  // Function to handle time slot selection
  void _onTimeSlotSelected(String timeSlot) {
    setState(() {
      _selectedTimeSlot = timeSlot;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        foregroundColor: black,
        title: customTextOne(
          text: 'Book an appointment',
          fontweight: FontWeight.normal,
          fontsize: screenWidth > 360 ? 16 : 12,
          textcolor: black,
        ),
        backgroundColor: background,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: 14, right: 14, bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildTopSection(),
              SizedBox(
                height: 15,
              ),
              _buildDateSelector(),
              SizedBox(
                height: 8,
              ),
              _buildTimeSlotSelector(),
              SizedBox(
                height: 15,
              ),
              _buildExpertSelector(widget.barberImage),
              SizedBox(
                height: 10,
              ),
              _buildBookButton(context),
              SizedBox(
                height: 6,
              ),
              // _buildCancelButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopSection() {
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      height: 120,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                'assets/backgroundImages/hair-cut-bg.jpg',
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
          // Content on top
          Padding(
            padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    customText(widget.serviceName, FontWeight.normal,
                        screenWidth > 360 ? 24 : 18, white),
                    Text(
                      'Rs. ${widget.servicePrice}',
                      style: TextStyle(
                        fontSize: screenWidth > 360 ? 18 : 15,
                        color: white, // Text color
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  widget.barberName,
                  style: TextStyle(
                    fontSize: screenWidth > 360 ? 16 : 12,
                    color: white, // Text color
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelector() {
    double screenWidth = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            // border: Border.all(color: grey, width: 1),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(availableDates.length, (index) {
              DateTime date = availableDates[index];
              bool isSelected = date == _selectedDate;

              return GestureDetector(
                onTap: () => _onDateSelected(date),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: screenWidth > 360 ? 8 : 6),
                  child: Column(
                    children: [
                      customTextOne(
                          text: DateFormat.E().format(date),
                          fontweight: FontWeight.w400,
                          fontsize: screenWidth > 360 ? 16 : 10,
                          textcolor: newGrey),
                      SizedBox(
                        height: 2.h,
                      ),
                      customTextOne(
                          text: DateFormat.d().format(date), // Date
                          fontweight: FontWeight.w400,
                          fontsize: screenWidth > 360 ? 16 : 14,
                          textcolor: isSelected ? red : black),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeSlotSelector() {
    double screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          customText('Available Slot', FontWeight.normal,
              screenWidth > 360 ? 16 : 12, black),
          const SizedBox(height: 6),
          SizedBox(
            height: 160,
            child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: availableTimeSlots.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    mainAxisExtent: 45),
                itemBuilder: (context, index) {
                  String timeSlot = availableTimeSlots[index];
                  bool isSelected = timeSlot == _selectedTimeSlot;
                  return GestureDetector(
                    onTap: () => _onTimeSlotSelected(timeSlot),
                    child: Container(
                        height: 45,
                        width: 100,
                        decoration: BoxDecoration(
                            color: isSelected ? Colors.red : Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: isSelected ? Colors.red : blue,
                                width: 1)),
                        child: Center(
                          child: customTextOne(
                              text: timeSlot,
                              fontweight: FontWeight.w600,
                              fontsize: screenWidth > 360 ? 16 : 12,
                              textcolor: isSelected ? white : black),
                        )),
                  );
                }),
          ),
        ],
      ),
    );
  }

  Widget _buildExpertSelector(String barberImage) {
    double screenWidth = MediaQuery.of(context).size.width;
    // For now, we will leave this unchanged
    return Column(
      children: [
        customText('This Your Expert', FontWeight.normal,
            screenWidth > 360 ? 16 : 12, black),
        SizedBox(
          height: 2.h,
        ),
        Center(
          child: Stack(
            children: [
              // CircleAvatar with the background image
              CircleAvatar(
                backgroundImage: NetworkImage(barberImage),
                backgroundColor: Colors.transparent,
                radius: 40,
              ),

              // Light black background overlay
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                ),
              ),

              // Name centered on top of the image
              Positioned.fill(
                child: Align(
                  alignment: Alignment.center,
                  child: customText(widget.barberName, FontWeight.normal,
                      screenWidth > 360 ? 16 : 10, white),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBookButton(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return SizedBox(
      height: 50,
      width: 180,
      child: customButton(
        ontap: () {
          // Check if both date and time slot are selected
          if (_selectedDate == null || _selectedTimeSlot == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Please select a date and time slot'),
                backgroundColor: Colors.red,
              ),
            );
          } else {
            // If both are selected, navigate to ConfirmAppointmentScreen
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ConfirmAppointmentScreen(
                  barberImage: widget.barberImage,
                  barberName: widget.barberName,
                  barberId: widget.barberId,
                  serviceId: widget.serviceId,
                  appointmentDate: _selectedDate.toString(),
                  appointmentTime: _selectedTimeSlot.toString(),
                  serviceName: widget.serviceName,
                ),
              ),
            );
          }
        },
        backgroundcolor: blue,
        text: 'Book Appointment',
        fontsize: screenWidth > 360 ? 16 : 10,
        radius: 12,
        borderwidth: 1,
        textcolor: white,
        borderColor: blue,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}
