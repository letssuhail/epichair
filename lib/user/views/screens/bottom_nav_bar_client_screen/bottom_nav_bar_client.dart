import 'package:epic/consts/colors.dart';
import 'package:epic/user/views/screens/home%20screen/home_screen.dart';
import 'package:epic/user/views/screens/my%20appointments%20screen/my_appointments_screen.dart';
import 'package:epic/user/views/screens/profile_screen/profile_screen.dart';
import 'package:epic/user/views/screens/services%20screen/services_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

final bottomNavIndexProvider = StateProvider<int>((ref) => 0);

class BottomNavBarClient extends ConsumerWidget {
  const BottomNavBarClient({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get the current selected index
    final selectedIndex = ref.watch(bottomNavIndexProvider);

    // Define a list of screens to display based on the selected index
    final List<Widget> screens = [
      const HomeScreen(), // Screen at index 0
      const ServicesScreen(),
      const MyAppointmentsScreen(), // Calendar Screen (placeholder)
      const ProfileScreen(
        isHomeScreen: false,
      ), // Screen at index 3
    ];

    return Scaffold(
      // Set background color to transparent to avoid the white background issue
      backgroundColor: background,

      // Display the selected screen in the body based on the selected index
      body: screens[selectedIndex],

      // Bottom Navigation Bar
      bottomNavigationBar: BottomAppBar(
        // shape: const CircularNotchedRectangle(),
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.home,
                  color: Colors.white,
                  size: 40,
                ),
                onPressed: () {
                  ref.read(bottomNavIndexProvider.notifier).state = 0;
                },
              ),
              const SizedBox(width: 40),
              IconButton(
                icon: Image.asset(
                  'assets/icons/Services3.png',
                  color: Colors.white,
                  width: 32,
                ),
                onPressed: () {
                  ref.read(bottomNavIndexProvider.notifier).state = 1;
                },
              ),
              const SizedBox(width: 40),
              IconButton(
                icon: const Icon(
                  Icons.calendar_month,
                  color: Colors.white,
                  size: 40,
                ),
                onPressed: () {
                  ref.read(bottomNavIndexProvider.notifier).state = 2;
                },
              ),

              const SizedBox(width: 40), // Space in the middle for the FAB
              IconButton(
                icon: const Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 40,
                ),
                onPressed: () {
                  ref.read(bottomNavIndexProvider.notifier).state = 3;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
