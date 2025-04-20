import 'package:epic/consts/colors.dart';
import 'package:epic/user/views/screens/home%20screen/home_screen.dart';
import 'package:epic/user/views/screens/my%20appointments%20screen/my_appointments_screen.dart';
import 'package:epic/user/views/screens/profile_screen/profile_screen.dart';
import 'package:epic/user/views/screens/services%20screen/services_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final bottomNavIndexProvider = StateProvider<int>((ref) => 0);

class BottomNavBarClient extends ConsumerWidget {
  const BottomNavBarClient({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double screenWidth = MediaQuery.of(context).size.width;
    // Get the current selected index
    final selectedIndex = ref.watch(bottomNavIndexProvider);

    // Define a list of screens to display based on the selected index
    final List<Widget> screens = [
      const HomeScreen(),
      const ServicesScreen(),
      const MyAppointmentsScreen(),
      const ProfileScreen(
        isHomeScreen: false,
      ), // Screen at index 3
    ];

    return Scaffold(
      backgroundColor: background,
      body: screens[selectedIndex],

      // Bottom Navigation Bar
      bottomNavigationBar: BottomAppBar(
        color: background,
        child: Container(
          height: 60.0,
          width: double.infinity,
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
              SizedBox(width: screenWidth > 360 ? 40 : 20),
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
              SizedBox(width: screenWidth > 360 ? 40 : 20),
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
              SizedBox(width: screenWidth > 360 ? 40 : 20),
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
