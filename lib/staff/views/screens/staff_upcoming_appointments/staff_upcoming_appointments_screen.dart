import 'package:epic/components/custom_text.dart';
import 'package:epic/consts/colors.dart';
import 'package:epic/staff/providers/get_appointments_provider.dart';
import 'package:epic/staff/views/screens/staff_upcoming_appointments/staff_cancel_tab_view.dart';
import 'package:epic/staff/views/screens/staff_upcoming_appointments/staff_confirm_tab_view.dart';
import 'package:epic/staff/views/screens/staff_upcoming_appointments/staff_upcoming_tab_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class StaffUpcomingAppointmentsScreen extends ConsumerWidget {
  const StaffUpcomingAppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          foregroundColor: black,
          title: customTextOne(
            text: 'Upcoming appointments',
            fontweight: FontWeight.normal,
            fontsize: 16.sp,
            textcolor: black,
          ),
          backgroundColor: background, // Makes AppBar background transparent
          elevation: 0, // Removes the AppBar shadow
        ),
        backgroundColor: background,
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
        body: Center(
          child: Padding(
            padding: EdgeInsets.only(left: 5.w, right: 5.w, bottom: 5.h),
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
                        'Upcoming',
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 16.sp),
                      ),
                      Text(
                        'Confirmed',
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 16.sp),
                      ),
                      Text(
                        'Cancelled',
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 16.sp),
                      ),
                    ]),
                const Flexible(
                  child: TabBarView(children: [
                    StaffUpcomingTabView(),
                    StaffConfirmTabView(),
                    StaffCancelTabView(),
                  ]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
