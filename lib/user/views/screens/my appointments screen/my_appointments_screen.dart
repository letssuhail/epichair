import 'dart:developer';

import 'package:epic/components/custom_text.dart';
import 'package:epic/consts/colors.dart';
import 'package:epic/user/providers/appointmentGet_provider.dart';
import 'package:epic/user/views/screens/my%20appointments%20screen/canceled_appoinments.dart';
import 'package:epic/user/views/screens/my%20appointments%20screen/confirmed_tab_view.dart';
import 'package:epic/user/views/screens/my%20appointments%20screen/ongoing_tab_view.dart';
import 'package:epic/user/views/screens/my%20appointments%20screen/past_tab_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class MyAppointmentsScreen extends ConsumerWidget {
  const MyAppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double screenWidth = MediaQuery.of(context).size.width;
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: background,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          foregroundColor: black,
          title: customTextOne(
            text: 'My bookings',
            fontweight: FontWeight.normal,
            fontsize: screenWidth > 360 ? 16 : 12,
            textcolor: black,
          ),
          backgroundColor: background,
          elevation: 0,
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: red,
          child: Icon(
            Icons.refresh,
            color: white,
          ),
          onPressed: () {
            try {
              ref.invalidate(appointmentsProvider);
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
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14),
          child: Column(
            children: [
              TabBar(
                  dividerColor: Colors.transparent,
                  indicatorColor: Colors.transparent,
                  labelColor:
                      const Color(0XFF0D98B9), // Color for selected tab text
                  unselectedLabelColor: const Color(
                      0XFFE7331A), // Co  lor for unselected tab text
                  tabs: [
                    Text(
                      'Ongoing',
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: screenWidth > 360 ? 12 : 8),
                    ),
                    Text(
                      'Confirmed',
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: screenWidth > 360 ? 12 : 8),
                    ),
                    Text(
                      'Past',
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: screenWidth > 360 ? 12 : 8),
                    ),
                    Text(
                      'Cancelled',
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: screenWidth > 360 ? 12 : 8),
                    ),
                  ]),
              const Flexible(
                child: TabBarView(children: [
                  OnGoingTabView(),
                  ConfirmedTabView(),
                  PastTabView(),
                  CalcelTabView(),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopSection(context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        customTextOne(
            text: 'My appointments',
            fontweight: FontWeight.w700,
            fontsize: screenWidth > 360 ? 18 : 14,
            textcolor: newGrey),
      ],
    );
  }
}
