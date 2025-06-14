import 'package:epic/components/custom_button.dart';
import 'package:epic/components/custom_text.dart';
import 'package:epic/consts/colors.dart';
import 'package:epic/user/providers/appointmentService_provider.dart';
import 'package:epic/user/views/screens/bottom_nav_bar_client_screen/bottom_nav_bar_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decode/jwt_decode.dart';

class ConfirmAppointmentScreen extends ConsumerWidget {
  final String barberId;
  final String barberName;
  final String serviceName;
  final String serviceId;
  final String appointmentDate;
  final String appointmentTime;
  final String barberImage;

  const ConfirmAppointmentScreen({
    super.key,
    required this.barberId,
    required this.barberName,
    required this.barberImage,
    required this.serviceName,
    required this.serviceId,
    required this.appointmentDate,
    required this.appointmentTime,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double screenWidth = MediaQuery.of(context).size.width;

    ref.listen<AsyncValue<bool>>(appointmentBookingProvider, (previous, next) {
      if (next.isLoading) {
        // Show loading indicator
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => Center(
            child: CircularProgressIndicator(
              color: red,
            ),
          ),
        );
      } else if (next.hasError) {
        Navigator.pop(context); // Close the loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error.toString())),
        );
      } else if (next.value == true) {
        Navigator.pop(context); // Close the loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Appointment booked successfully!')),
        );
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    const BottomNavBarClient())); // Go back to previous screen after booking
      }
    });

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        foregroundColor: black,
        title: customTextOne(
          text: 'Confirm appointment',
          fontweight: FontWeight.normal,
          fontsize: screenWidth > 360 ? 16 : 12,
          textcolor: black,
        ),
        backgroundColor: background, // Makes AppBar background transparent
        elevation: 0, // Removes the AppBar shadow
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 14, right: 14, bottom: 14, top: 10),
        child: Column(
          children: [
            _buildExpertDetailsSection(context, ref),
          ],
        ),
      ),
    );
  }

  Widget _buildExpertDetailsSection(BuildContext context, WidgetRef ref) {
    double screenWidth = MediaQuery.of(context).size.width;
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

    String formatDate(DateTime dateTime) {
      String day = DateFormat('d').format(dateTime); // Day without leading zero
      String month = DateFormat('MMMM').format(dateTime); // Full month name
      String year = DateFormat('y').format(dateTime); // Year in 4 digits

      return '${getOrdinalSuffix(int.parse(day))} $month $year';
    }

    DateTime appointmentDatee = DateTime.parse(appointmentDate);
    String formattedDate = formatDate(appointmentDatee);

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage(
                'assets/backgroundImages/confirm-appointment-screen-bg.jpg'),
            fit: BoxFit.cover),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
        child: Column(
          children: [
            Stack(
              children: [
                // CircleAvatar with the background image
                CircleAvatar(
                  backgroundImage: NetworkImage(barberImage),
                  backgroundColor: Colors.transparent,
                  radius: screenWidth > 360 ? 45 : 40,
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
              ],
            ),
            SizedBox(height: 10),
            Text(
              barberName,
              style: TextStyle(
                color: white,
                fontWeight: FontWeight.w700,
                fontSize: screenWidth > 360 ? 18 : 14,
              ),
            ),
            SizedBox(height: 10),
            Text(
              serviceName,
              style: TextStyle(
                color: white,
                fontWeight: FontWeight.w700,
                fontSize: screenWidth > 360 ? 18 : 14,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Date : $formattedDate',
              style: TextStyle(
                color: white,
                fontWeight: FontWeight.w700,
                fontSize: screenWidth > 360 ? 18 : 14,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Time : $appointmentTime ',
              style: TextStyle(
                color: white,
                fontWeight: FontWeight.w700,
                fontSize: screenWidth > 360 ? 18 : 14,
              ),
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                height: 50,
                width: double.infinity,
                child: customButton(
                  ontap: () => _confirmBooking(ref),
                  backgroundcolor: blue,
                  text: 'Confirm',
                  fontsize: screenWidth > 360 ? 16 : 12,
                  radius: 12,
                  borderwidth: 1,
                  textcolor: white,
                  borderColor: blue,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmBooking(WidgetRef ref) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('userToken');
    // const token = userToken;

    // Decode the JWT token to get the user ID
    Map<String, dynamic> decodedToken = Jwt.parseJwt(token!);
    decodedToken['userId']; // Change this key based on your token structure

    final DateFormat dateFormatter = DateFormat('yyyy-MM-dd');

    String formattedDate = dateFormatter
        .format(DateTime.parse(appointmentDate)); // Format the date
    String formattedTime = appointmentTime;
    ref.read(appointmentBookingProvider.notifier).bookAppointment(
        barberId: barberId.toString(),
        //userId: decodedToken.toString(),
        serviceId: serviceId.toString(),
        appointmentDate: formattedDate,
        appointmentTime: formattedTime);
  }
}
