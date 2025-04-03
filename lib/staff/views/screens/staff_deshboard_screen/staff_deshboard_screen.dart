import 'dart:convert';
import 'package:epic/components/custom_text.dart';
import 'package:epic/consts/colors.dart';
import 'package:epic/staff/providers/get_appointments_provider.dart';
import 'package:epic/staff/providers/staff_provider.dart';
import 'package:epic/staff/views/screens/admin%20clients%20screen/staff_clients_screen.dart';
import 'package:epic/staff/views/screens/all_staff_details_screen/all_staff_details_screen.dart';
import 'package:epic/staff/views/screens/staff%20appointments%20screen/staff_appointments_screen.dart';
import 'package:epic/user/models/user_profile_model.dart';
import 'package:epic/user/utils/navigator_function.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class StaffDeshboardScreen extends ConsumerStatefulWidget {
  const StaffDeshboardScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _StaffDeshboardScreenState();
}

class _StaffDeshboardScreenState extends ConsumerState<StaffDeshboardScreen> {
  String? _username;
  String? _profileImageUrl;

  @override
  void initState() {
    super.initState();
    _fetchProfileData();
  }

  Future<void> _fetchProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('userToken');

    // String token = userToken;

    if (token != null) {
      const url = 'https://epichair.vercel.app/api/staff/profile';

      try {
        final response = await http.get(
          Uri.parse(url),
          headers: {'Authorization': 'Bearer $token'},
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final userProfile = UserProfile.fromJson(data['user']);

          // Save profile data to local storage
          prefs.setString('username', userProfile.username ?? 'Dummy Name');
          prefs.setString(
              'profileImageUrl',
              userProfile.imageUrl ??
                  'https://example.com/dummy_profile_image.png');

          setState(() {
            _username = prefs.getString('username');
            _profileImageUrl = prefs.getString('profileImageUrl');
          });
        } else {
          // log('Failed to fetch profile data');
        }
      } catch (e) {
        // log('Error fetching profile data: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final appointmentsAsync = ref.watch(staffAppointmentsProvider);
    final staffAsyncValue = ref.watch(staffProvider);
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 14, right: 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    customTextOne(
                        text: (_username ?? 'New Name').toUpperCase(),
                        fontweight: FontWeight.bold,
                        fontsize: screenWidth > 360 ? 18 : 16,
                        textcolor: blue),
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: blue,
                      child: _profileImageUrl != null
                          ? CircleAvatar(
                              radius: 45,
                              backgroundColor: blue,
                              backgroundImage: NetworkImage(_profileImageUrl!),
                            )
                          : CircleAvatar(
                              backgroundColor: blue,
                              radius: 45,
                              child: Icon(Icons.person, color: white, size: 50),
                            ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 20),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  // height: 110,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: const DecorationImage(
                          image: AssetImage(
                              'assets/backgroundImages/staff-home.jpg'),
                          fit: BoxFit.cover)),
                  child: Column(
                    children: [
                      customText('Today Appointments & Staff', FontWeight.bold,
                          screenWidth > 360 ? 18 : 12, white),
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: blue,
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Today Appointments".toUpperCase(),
                                  style: TextStyle(
                                    color: white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: screenWidth > 360 ? 14 : 10,
                                  ),
                                ),
                                //SizedBox(width: 30,),
                                appointmentsAsync.when(
                                  data: (data) {
                                    final todayCount =
                                        data['todayAppointmentsCount'] ?? 0;
                                    return Text(
                                      '$todayCount',
                                      style: TextStyle(
                                        color: white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                    );
                                  },
                                  loading: () => SizedBox(
                                    height: 10,
                                    width: 10,
                                    child: CircularProgressIndicator(
                                      color: white,
                                    ),
                                  ),
                                  error: (error, stack) =>
                                      Text('Error: $error'),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5), // Spacing between rows
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Total Staff Members".toUpperCase(),
                                  style: TextStyle(
                                    color: white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: screenWidth > 360 ? 14 : 10,
                                  ),
                                ),
                                //SizedBox(width: 30,),
                                staffAsyncValue.when(
                                  data: (staffMembers) {
                                    final totalStaffMembers =
                                        staffMembers.length;
                                    return Text(
                                      '$totalStaffMembers',
                                      style: TextStyle(
                                        color: white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                    );
                                  },
                                  loading: () => SizedBox(
                                    height: 10,
                                    width: 10,
                                    child: CircularProgressIndicator(
                                      color: white,
                                    ),
                                  ),
                                  error: (error, stack) =>
                                      Text('Error: $error'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  HaircutWidget(
                    label: "Appointments",
                    pathh: "assets/new-icons/ap-white.svg",
                    ontap: () {
                      pushScreenTo(context, const StaffAppointmentsScreen());
                    },
                  ),
                  HaircutWidget(
                    label: "Clients",
                    pathh: "assets/new-icons/new-client.svg",
                    ontap: () {
                      pushScreenTo(context, const StaffClientsScreen());
                    },
                  )
                ],
              ),
              SizedBox(
                height: 3.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  HaircutWidget(
                    label: "Staffs",
                    pathh: "assets/new-icons/new-staff.svg",
                    ontap: () {
                      pushScreenTo(context, const AllStaffDetailsScreen());
                    },
                  ),
                  // HaircutWidget(
                  //   label: "Clienteles",
                  //   pathh: "assets/icons/Clienteles3.png",
                  //   ontap: () {},
                  // )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HaircutWidget extends StatelessWidget {
  final String label;
  final String pathh;
  final VoidCallback ontap;
  const HaircutWidget(
      {super.key,
      required this.label,
      required this.pathh,
      required this.ontap});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: ontap,
      child: Card(
        color: white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        shadowColor: Colors.grey,
        elevation: 4,
        child: Container(
          width: 130,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(pathh, color: black, width: 40),
              const SizedBox(height: 10),
              Text(
                label,
                style: TextStyle(
                  fontSize: screenWidth > 360 ? 14 : 10,
                  color: blue, // Text color
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
