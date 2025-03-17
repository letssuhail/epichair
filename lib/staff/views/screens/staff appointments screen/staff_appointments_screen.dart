import 'package:epic/components/custom_text.dart';
import 'package:epic/consts/colors.dart';
import 'package:epic/staff/providers/get_appointments_provider.dart';
import 'package:epic/staff/views/screens/staff_upcoming_appointments/staff_upcoming_appointments_screen.dart';
import 'package:epic/user/utils/navigator_function.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:responsive_sizer/responsive_sizer.dart';

class StaffAppointmentsScreen extends ConsumerStatefulWidget {
  const StaffAppointmentsScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _StaffAppointmentsScreenState();
}

class _StaffAppointmentsScreenState
    extends ConsumerState<StaffAppointmentsScreen> {
  @override
  Widget build(BuildContext context) {
    final appointmentsAsync = ref.watch(staffAppointmentsProvider);
    return Scaffold(
      //extendBodyBehindAppBar: true,
      floatingActionButton: FloatingActionButton(
        backgroundColor: red,
        child: Icon(
          Icons.refresh,
          color: white,
        ),
        onPressed: () {
          try {
            ref.invalidate(staffAppointmentsProvider);
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
      backgroundColor: background,
      appBar: AppBar(
        foregroundColor: black,
        title: customTextOne(
          text: 'Appointments',
          fontweight: FontWeight.normal,
          fontsize: 16.sp,
          textcolor: black,
        ),
        backgroundColor: background, // Makes AppBar background transparent
        elevation: 0, // Removes the AppBar shadow
      ),
      body: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
            AppointmentsWidget(
              title: "Upcoming Appointments",
              ontap: () {
                pushScreenTo(context, const StaffUpcomingAppointmentsScreen());
              },
            ),
            // AppointmentsWidget(
            //   title: "History",
            //   ontap: () {},
            // ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Container(
                // width: 300,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: grey,
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total customers today",
                      style: TextStyle(
                        color: newGrey,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    appointmentsAsync.when(
                      data: (data) {
                        final todayCount = data['todayAppointmentsCount'] ?? 0;
                        return Text(
                          '$todayCount',
                          style: TextStyle(
                            color: newGrey,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        );
                      },
                      loading: () => SizedBox(
                        height: 10,
                        width: 10,
                        child: CircularProgressIndicator(
                          color: red,
                        ),
                      ),
                      error: (error, stack) => Text('Error: $error'),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 4.h,
            ),
            Text(
              "Completed Appointments",
              style: TextStyle(color: newGrey, fontSize: 20),
            ),
            SizedBox(
              height: 2.h,
            ),
            appointmentsAsync.when(
              data: (data) {
                final completedAppointments = data['completed'] ?? [];

                if (completedAppointments.isEmpty) {
                  return Center(
                      child: Text(
                    'No completed appointments',
                    style: TextStyle(color: red),
                  ));
                }

                return ListView.builder(
                    scrollDirection: Axis.vertical,
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: completedAppointments.length,
                    itemBuilder: (context, index) {
                      final data = completedAppointments[index];
                      String maskText(String text) {
                        if (text.length >= 4) {
                          return '***${text.substring(text.length - 4)}';
                        } else {
                          return text;
                        }
                      }

                      // String defaultImageUrl =
                      //     'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT9nHrLn6HQN45iNAfQ2DXKp5nTyosP_2xxR8JDlZNwqgqfHnAjJys4oGh6_PWxP0RbtbY&usqp=CAU';
                      String fullText = data['service']['_id'];
                      String maskedText = maskText(fullText);
                      String serviceName = data['service']['name'];
                      String serviceStatus = data['status'];
                      String clientImagePath = data['user']['image_url'];
                      String staffImagePath = data['barber']['image_url'];
                      return CompletedWidget(
                        id: maskedText,
                        service: serviceName,
                        status: serviceStatus,
                        clientImagePath: clientImagePath,
                        staffImagePath: staffImagePath,
                      );
                    });
              },
              loading: () => Center(
                  child: CircularProgressIndicator(
                color: red,
              )),
              error: (error, _) => Center(child: Text('Error: $error')),
            )
          ])),
    );
  }
}

class CompletedWidget extends StatelessWidget {
  final String id, status, service, clientImagePath, staffImagePath;
  const CompletedWidget({
    super.key,
    required this.id,
    required this.service,
    required this.status,
    required this.staffImagePath,
    required this.clientImagePath,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(
            color: grey,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                staffImagePath.isNotEmpty
                    ? CircleAvatar(
                        radius: 15,
                        backgroundColor: blue,
                        backgroundImage: NetworkImage(staffImagePath),
                      )
                    : CircleAvatar(
                        backgroundColor: blue,
                        radius: 15,
                        child: Icon(Icons.person, color: white, size: 20),
                      ),

                const SizedBox(width: 8), // Space between icon and text
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      id,
                      style: TextStyle(
                        color: black,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      service,
                      style: TextStyle(
                        color: black,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(width: 8),
            CircleAvatar(
              backgroundColor: grey,
              backgroundImage:
                  NetworkImage(clientImagePath), // Use your image path
              radius: 15,
            ),
            Row(
              children: [
                const Icon(
                  Icons.check,
                  color: Colors.green,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  status,
                  style: TextStyle(
                    color: primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class AppointmentsWidget extends StatelessWidget {
  final String title;
  final VoidCallback ontap;
  const AppointmentsWidget(
      {super.key, required this.title, required this.ontap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      child: GestureDetector(
        onTap: ontap,
        child: Container(
          //width: 300,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            border: Border.all(
              color: newGrey,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: newGrey,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: newGrey,
              )
            ],
          ),
        ),
      ),
    );
  }
}
