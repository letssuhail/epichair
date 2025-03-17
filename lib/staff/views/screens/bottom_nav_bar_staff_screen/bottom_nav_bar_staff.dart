import 'package:epic/consts/colors.dart';
import 'package:epic/staff/views/screens/admin%20services%20screen/admin_services_screen.dart';
import 'package:epic/staff/views/screens/all_staff_details_screen/all_staff_details_screen.dart';
import 'package:epic/staff/views/screens/staff%20details%20screen/staff_details_screen.dart';
import 'package:epic/staff/views/screens/staff_deshboard_screen/staff_deshboard_screen.dart';
import 'package:epic/staff/views/screens/staff_profile_screen/staff_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

final bottomNavIndexProvider = StateProvider<int>((ref) => 0);

class BottomNavBarStaff extends ConsumerWidget {
  const BottomNavBarStaff({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get the current selected index
    final selectedIndex = ref.watch(bottomNavIndexProvider);

    // Define a list of screens to display based on the selected index
    final screens = [
      const StaffDeshboardScreen(),
      const AllStaffDetailsScreen(),
      const StaffProfileScreen(),
    ];

    return Scaffold(
      // Set background color to transparent to avoid the white background issue
      backgroundColor: background,

      // Display the selected screen in the body based on the selected index
      body: screens[selectedIndex],

      // Bottom Navigation Bar
      bottomNavigationBar: BottomAppBar(
        color: background, // Set BottomAppBar background to transparent
        child: Container(
          height: 60.0,
          width: double.infinity, // Ensure the bottom bar takes full width
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [
              Color(0xffE7331A),
              Color(0xff0D98B9),
            ]),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: SvgPicture.asset(
                    'assets/new-icons/ap-white.svg',
                    color: Colors.white,
                  ),
                  onPressed: () {
                    ref.read(bottomNavIndexProvider.notifier).state = 0;
                  },
                ),
                const SizedBox(width: 30),

                IconButton(
                  icon: SvgPicture.asset(
                    'assets/new-icons/new-staff.svg',
                    color: Colors.white,
                  ),
                  onPressed: () {
                    ref.read(bottomNavIndexProvider.notifier).state = 1;
                  },
                ),
                const SizedBox(width: 30), // Space in the middle for the FAB
                IconButton(
                  icon: SvgPicture.asset(
                    'assets/new-icons/new-client.svg',
                    color: Colors.white,
                  ),
                  onPressed: () {
                    ref.read(bottomNavIndexProvider.notifier).state = 2;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
