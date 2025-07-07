// import 'dart:developer';
// import 'dart:ui';

// import 'package:epic/user/api%20services/appointment_api.dart';
// import 'package:epic/components/custom_button.dart';
// import 'package:epic/components/custom_text.dart';
// import 'package:epic/consts/colors.dart';
// import 'package:epic/user/models/staff_model.dart';
// import 'package:epic/user/views/screens/confirm%20appointment%20screen/confirm_appointment_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:responsive_sizer/responsive_sizer.dart';
// import 'package:intl/intl.dart';

// final appointmentServiceProvider = Provider<AppointmentService>((ref) {
//   return AppointmentService();
// });

// class BookAppointmentScreen extends StatefulWidget {
//   final String barberId;
//   final String barberName;
//   final String serviceId;
//   final String barberImage;
//   final String serviceName;
//   final String servicePrice;
//   final List<dynamic> availableSlot;

//   const BookAppointmentScreen({
//     super.key,
//     required this.barberId,
//     required this.barberName,
//     required this.serviceId,
//     required this.barberImage,
//     required this.serviceName,
//     required this.servicePrice,
//     required this.availableSlot,
//   });

//   @override
//   // ignore: library_private_types_in_public_api
//   _BookAppointmentScreenState createState() => _BookAppointmentScreenState();
// }

// class _BookAppointmentScreenState extends State<BookAppointmentScreen> {
//   // Selected date and time variables
//   DateTime? _selectedDate;
//   String? _selectedTimeSlot;

//   // List of available dates (for example purposes, adjust as needed)
//   final List<DateTime> availableDates = List.generate(8, (index) {
//     return DateTime.now().add(Duration(days: index));
//   });

//   // Function to handle date selection
//   void _onDateSelected(DateTime date) {
//     setState(() {
//       _selectedDate = date;
//     });
//   }

//   // Function to handle time slot selection
//   void _onTimeSlotSelected(String timeSlot) {
//     setState(() {
//       _selectedTimeSlot = timeSlot;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     return Scaffold(
//       backgroundColor: background,
//       appBar: AppBar(
//         foregroundColor: black,
//         title: customTextOne(
//           text: 'Book an appointment',
//           fontweight: FontWeight.normal,
//           fontsize: screenWidth > 360 ? 16 : 12,
//           textcolor: black,
//         ),
//         backgroundColor: background,
//         elevation: 0,
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: EdgeInsets.only(left: 14, right: 14, bottom: 10),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               _buildTopSection(),
//               SizedBox(
//                 height: 15,
//               ),
//               _buildDateSelector(),
//               SizedBox(
//                 height: 10,
//               ),
//               _buildExpertSelector(widget.barberImage),
//               SizedBox(
//                 height: 8,
//               ),
//               _buildTimeSlotSelector(),
//               SizedBox(
//                 height: 15,
//               ),

//               _buildBookButton(context),
//               SizedBox(
//                 height: 6,
//               ),
//               // _buildCancelButton(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildTopSection() {
//     double screenWidth = MediaQuery.of(context).size.width;
//     return Container(
//       height: 120,
//       width: double.infinity,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Stack(
//         children: [
//           // Background Image
//           Positioned.fill(
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(10),
//               child: Image.asset(
//                 'assets/backgroundImages/hair-cut-bg.jpg',
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//           // Black Blur Effect
//           Positioned.fill(
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(10),
//               child: BackdropFilter(
//                 filter: ImageFilter.blur(sigmaX: 1.0, sigmaY: 1.0),
//                 child: Container(
//                   color: Colors.black.withOpacity(0.1),
//                 ),
//               ),
//             ),
//           ),
//           // Content on top
//           Padding(
//             padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 20),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     customText(widget.serviceName, FontWeight.normal,
//                         screenWidth > 360 ? 24 : 18, white),
//                     Text(
//                       'CA\$${widget.servicePrice}',
//                       style: TextStyle(
//                         fontSize: screenWidth > 360 ? 18 : 15,
//                         color: white, // Text color
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   widget.barberName,
//                   style: TextStyle(
//                     fontSize: screenWidth > 360 ? 16 : 12,
//                     color: white, // Text color
//                     fontWeight: FontWeight.normal,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDateSelector() {
//     double screenWidth = MediaQuery.of(context).size.width;
//     return Column(
//       children: [
//         Container(
//           padding: const EdgeInsets.symmetric(vertical: 10),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(12),
//             // border: Border.all(color: grey, width: 1),
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: List.generate(availableDates.length, (index) {
//               DateTime date = availableDates[index];
//               bool isSelected = date == _selectedDate;

//               return GestureDetector(
//                 onTap: () => _onDateSelected(date),
//                 child: Padding(
//                   padding: EdgeInsets.symmetric(
//                       horizontal: screenWidth > 360 ? 7 : 6),
//                   child: Column(
//                     children: [
//                       customTextOne(
//                           text: DateFormat.E().format(date),
//                           fontweight: FontWeight.w400,
//                           fontsize: screenWidth > 360 ? 16 : 10,
//                           textcolor: newGrey),
//                       SizedBox(
//                         height: 2.h,
//                       ),
//                       Container(
//                         padding: EdgeInsets.all(4),
//                         decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             border: Border.all(
//                                 color: isSelected ? red : Colors.transparent,
//                                 width: 1.2)),
//                         child: customTextOne(
//                             text: DateFormat.d().format(date), // Date
//                             fontweight: FontWeight.w400,
//                             fontsize: screenWidth > 360 ? 16 : 14,
//                             textcolor: isSelected ? red : black),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             }),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildTimeSlotSelector() {
//     double screenWidth = MediaQuery.of(context).size.width;
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           customText('Available Slot', FontWeight.normal,
//               screenWidth > 360 ? 16 : 12, black),
//           const SizedBox(height: 6),
//           SizedBox(
//             height: 600,
//             child: GridView.builder(
//                 physics: const NeverScrollableScrollPhysics(),
//                 itemCount: widget.availableSlot.length,
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 3,
//                     crossAxisSpacing: 10,
//                     mainAxisSpacing: 10,
//                     mainAxisExtent: 45),
//                 itemBuilder: (context, index) {
//                   final timeSlot = widget.availableSlot[index];

//                   final time = timeSlot['slots']['time'] as String;
//                   final isAvailable =
//                       timeSlot['slots']['isAvailable'] as bool? ?? true;

//                   bool isSelected = time == _selectedTimeSlot;

//                   return GestureDetector(
//                     onTap: () {
//                       if (!isAvailable) {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           const SnackBar(
//                             content: Text('This time is already booked'),
//                             backgroundColor: Colors.red,
//                           ),
//                         );
//                       } else {
//                         _onTimeSlotSelected(time);
//                       }
//                     },
//                     child: Container(
//                         height: 45,
//                         width: 100,
//                         decoration: BoxDecoration(
//                           color: isAvailable
//                               ? (isSelected ? Colors.red : Colors.white)
//                               : Colors.grey.shade300,
//                           borderRadius: BorderRadius.circular(10),
//                           border: Border.all(
//                             color: isAvailable
//                                 ? (isSelected ? Colors.red : blue)
//                                 : Colors.grey,
//                             width: 1,
//                           ),
//                         ),
//                         child: Center(
//                           child: customTextOne(
//                             text: time,
//                             fontweight: FontWeight.w600,
//                             fontsize: screenWidth > 360 ? 16 : 12,
//                             textcolor: isAvailable
//                                 ? (isSelected ? white : black)
//                                 : Colors.grey,
//                           ),
//                         )),
//                   );
//                 }),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildExpertSelector(String barberImage) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     // For now, we will leave this unchanged
//     return Column(
//       children: [
//         customText('This Your Expert', FontWeight.normal,
//             screenWidth > 360 ? 16 : 12, black),
//         SizedBox(
//           height: 2.h,
//         ),
//         Container(
//           padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
//           decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(8),
//               border: Border.all(color: lightfontgrey, width: 1)),
//           child: Column(
//             children: [
//               CircleAvatar(
//                 radius: 40,
//                 backgroundImage: NetworkImage(barberImage),
//               ),
//               SizedBox(
//                 height: 2.h,
//               ),
//               customText(widget.barberName, FontWeight.normal,
//                   screenWidth > 360 ? 14 : 10, black),
//             ],
//           ),
//         )
//       ],
//     );
//   }

//   Widget _buildBookButton(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     return SizedBox(
//       height: 50,
//       width: 180,
//       child: customButton(
//         ontap: () {
//           // Check if both date and time slot are selected
//           if (_selectedDate == null || _selectedTimeSlot == null) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(
//                 content: Text('Please select a date and time slot'),
//                 backgroundColor: Colors.red,
//               ),
//             );
//           } else {
//             // If both are selected, navigate to ConfirmAppointmentScreen
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => ConfirmAppointmentScreen(
//                   barberImage: widget.barberImage,
//                   barberName: widget.barberName,
//                   barberId: widget.barberId,
//                   serviceId: widget.serviceId,
//                   appointmentDate: _selectedDate.toString(),
//                   appointmentTime: _selectedTimeSlot.toString(),
//                   serviceName: widget.serviceName,
//                 ),
//               ),
//             );
//           }
//         },
//         backgroundcolor: blue,
//         text: 'Book Appointment',
//         fontsize: screenWidth > 360 ? 16 : 10,
//         radius: 12,
//         borderwidth: 1,
//         textcolor: white,
//         borderColor: blue,
//         fontWeight: FontWeight.w700,
//       ),
//     );
//   }
// }

import 'dart:developer';
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
  final List<dynamic> availableSlot;

  const BookAppointmentScreen({
    super.key,
    required this.barberId,
    required this.barberName,
    required this.serviceId,
    required this.barberImage,
    required this.serviceName,
    required this.servicePrice,
    required this.availableSlot,
  });

  @override
  _BookAppointmentScreenState createState() => _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends State<BookAppointmentScreen> {
  // Selected date and time variables
  DateTime? _selectedDate;
  String? _selectedTimeSlot;

  // Function to handle date selection
  void _onDateSelected(DateTime date) {
    setState(() {
      _selectedDate = date;
      _selectedTimeSlot = null;
    });
  }

  // Function to handle time slot selection
  void _onTimeSlotSelected(String timeSlot) {
    setState(() {
      _selectedTimeSlot = timeSlot;
    });
  }

  @override
  void initState() {
    super.initState();
    // Pre-select the first available date
    if (widget.availableSlot.isNotEmpty) {
      _selectedDate = DateTime.parse(widget.availableSlot[0]['date']);
    }
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
              SizedBox(height: 15),
              _buildDateSelector(),
              SizedBox(height: 10),
              _buildExpertSelector(widget.barberImage),
              SizedBox(height: 8),
              _buildTimeSlotSelector(),
              SizedBox(height: 15),
              _buildBookButton(context),
              SizedBox(height: 6),
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
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                'assets/backgroundImages/hair-cut-bg.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
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
                      'CA\$${widget.servicePrice}',
                      style: TextStyle(
                        fontSize: screenWidth > 360 ? 18 : 15,
                        color: white,
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
                    color: white,
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
    // Extract unique dates from available slots
    final availableDates = widget.availableSlot
        .map((slot) => DateTime.parse(slot['date']))
        .toSet()
        .toList()
      ..sort((a, b) => a.compareTo(b));

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
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
                      horizontal: screenWidth > 360 ? 7 : 6),
                  child: Column(
                    children: [
                      customTextOne(
                          text: DateFormat.E().format(date),
                          fontweight: FontWeight.w400,
                          fontsize: screenWidth > 360 ? 16 : 10,
                          textcolor: newGrey),
                      SizedBox(height: 2.h),
                      Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: isSelected ? red : Colors.transparent,
                                width: 1.2)),
                        child: customTextOne(
                            text: DateFormat.d().format(date),
                            fontweight: FontWeight.w400,
                            fontsize: screenWidth > 360 ? 16 : 14,
                            textcolor: isSelected ? red : black),
                      ),
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
    // Find slots for the selected date
    final selectedDateSlots = widget.availableSlot.firstWhere(
      (slot) =>
          DateTime.parse(slot['date']).day == _selectedDate?.day &&
          DateTime.parse(slot['date']).month == _selectedDate?.month &&
          DateTime.parse(slot['date']).year == _selectedDate?.year,
      orElse: () => {'slots': []},
    )['slots'] as List<dynamic>;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          customText('Available Slots', FontWeight.normal,
              screenWidth > 360 ? 16 : 12, black),
          const SizedBox(height: 6),
          selectedDateSlots.isEmpty
              ? Center(
                  child: customText('No slots available for this date',
                      FontWeight.normal, screenWidth > 360 ? 16 : 12, black),
                )
              : SizedBox(
                  height: 600,
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: selectedDateSlots.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            mainAxisExtent: 45),
                    itemBuilder: (context, index) {
                      final timeSlot = selectedDateSlots[index];
                      final time = timeSlot['time'] as String;
                      final isAvailable = timeSlot['available'] as bool;

                      // Convert time to AM/PM format
                      final timeFormat = DateFormat('hh:mm a')
                          .format(DateFormat('HH:mm').parse(time));

                      bool isSelected = time == _selectedTimeSlot;

                      return GestureDetector(
                        onTap: () {
                          if (!isAvailable) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('This time is already booked'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          } else {
                            _onTimeSlotSelected(time);
                          }
                        },
                        child: Container(
                          height: 45,
                          width: 100,
                          decoration: BoxDecoration(
                            color: isAvailable
                                ? (isSelected ? Colors.red : Colors.white)
                                : Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: isAvailable
                                  ? (isSelected ? Colors.red : blue)
                                  : Colors.grey,
                              width: 1,
                            ),
                          ),
                          child: Center(
                            child: customTextOne(
                              text: timeFormat,
                              fontweight: FontWeight.w600,
                              fontsize: screenWidth > 360 ? 16 : 12,
                              textcolor: isAvailable
                                  ? (isSelected ? white : black)
                                  : Colors.grey,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildExpertSelector(String barberImage) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Column(
      children: [
        customText('This Your Expert', FontWeight.normal,
            screenWidth > 360 ? 16 : 12, black),
        SizedBox(height: 2.h),
        Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: lightfontgrey, width: 1)),
          child: Column(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(barberImage),
              ),
              SizedBox(height: 2.h),
              customText(widget.barberName, FontWeight.normal,
                  screenWidth > 360 ? 14 : 10, black),
            ],
          ),
        )
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
          if (_selectedDate == null || _selectedTimeSlot == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Please select a date and time slot'),
                backgroundColor: Colors.red,
              ),
            );
          } else {
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
