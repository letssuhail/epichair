import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';
import 'package:epic/components/custom_button.dart';
import 'package:epic/components/custom_text.dart';
import 'package:epic/consts/colors.dart';
import 'package:epic/consts/const.dart';
import 'package:epic/user/models/user_profile_model.dart';
import 'package:epic/user/utils/navigator_function.dart';
import 'package:epic/user/views/screens/profile_screen/profile_screen.dart';
import 'package:epic/user/views/screens/services%20screen/services_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';
import '../../../../staff/providers/staff_provider.dart';
import '../../../providers/selectedService_notifier.dart';
import '../../../providers/service_provider.dart';
import '../barber list screen/barber_list_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final Color prim = const Color.fromRGBO(210, 174, 109, 1);
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
    // const token = userToken;

    if (token != null) {
      const url = 'https://epichair.vercel.app/api/user/profile';

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

          // Check if the profile details are updated
          if (_username == 'Dummy Name') {
            _showProfileUpdateDialog();
          }
        } else {
          // log('Failed to fetch profile data');
        }
      } catch (e) {
        // log('Error fetching profile data: $e');
      }
    }
  }

  void _showProfileUpdateDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: background,
          title: Text(
            'Profile Update Required',
            style: TextStyle(color: red),
          ),
          content: Text(
            'Please update your profile details.',
            style: TextStyle(color: red),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const ProfileScreen(
                          isHomeScreen: true,
                        ))); // Navigate to profile update screen
              },
              child: Text(
                'Update Profile',
                style: TextStyle(color: red),
              ),
            ),
          ],
        );
      },
    );
  }

  final serviceItems = [
    {
      'image': 'assets/backgroundImages/hair-cut.jpg',
      'title': 'HAIR\nCUT',
    },
    {
      'image': 'assets/backgroundImages/beard.jpg',
      'title': 'BEARD',
    },
    {
      'image': 'assets/backgroundImages/mani-cure.jpg',
      'title': 'MANI\nCURE',
    },
    {
      'image': 'assets/backgroundImages/massage.png',
      'title': 'MASS\nAGE',
    },
  ];

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    final servicesAsyncValue =
        ref.watch(serviceProvider); // Watch the serviceProvider
    final staffAsyncValue = ref.watch(staffProvider);
    String getGreetingMessage() {
      final hour = DateTime.now().hour;

      if (hour >= 5 && hour < 12) {
        return 'GOOD\nMORNING';
      } else if (hour >= 12 && hour < 17) {
        return 'GOOD\nAFTERNOON';
      } else if (hour >= 17 && hour < 22) {
        return 'GOOD\nEVENING';
      } else {
        return 'GOOD\nNIGHT';
      }
    }

    final greetingMessage = getGreetingMessage();
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: customTextOne(
            text: 'Dashboard',
            fontweight: FontWeight.bold,
            fontsize: screenWidth > 360 ? 18 : 16,
            textcolor: black),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SvgPicture.asset('assets/icons/notify.svg'),
                      RichText(
                          text: TextSpan(children: [
                        TextSpan(
                            text: '$greetingMessage\n',
                            style: TextStyle(
                                fontSize: screenWidth > 360 ? 20 : 18,
                                color: blue)),
                        TextSpan(
                            text: _username ?? 'New User',
                            style: TextStyle(
                                fontSize: screenWidth > 360 ? 16 : 14,
                                color: black)),
                      ])),
                    ],
                  ),
                  SizedBox(
                    height: 160,
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: blue, // Always show blue background
                          child: _profileImageUrl != null &&
                                  _profileImageUrl!.isNotEmpty
                              ? ClipOval(
                                  child: Image.network(
                                    _profileImageUrl!,
                                    fit: BoxFit.cover,
                                    width: 100,
                                    height: 100,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Icon(Icons.person,
                                          color: white, size: 50);
                                    },
                                  ),
                                )
                              : Icon(Icons.person, color: white, size: 50),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Rest of the code remains unchanged...
            // "Your Regulars" and "What's New" sections
            Column(
              children: [
                servicesAsyncValue.when(
                  data: (services) {
                    if (services == null || services.isEmpty) {
                      return Center(
                        child: Text(
                          'No services available',
                          style: TextStyle(color: black),
                        ),
                      );
                    }

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(serviceItems.length, (index) {
                        final serviceData = services[index];
                        return GestureDetector(
                          onTap: () {
                            final id = serviceData['_id'] ?? 'unknown id';
                            final label = serviceData['name'] ?? 'New Service';

                            final price = serviceData['price'] ?? '0';
                            // Update the selected service
                            ref.read(selectedServiceProvider.notifier).state =
                                label;

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BarberListScreen(
                                        serviceId: id,
                                        serviceName: label,
                                        servicePrice: price.toString(),
                                      )),
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.only(left: index == 0 ? 0 : 10),
                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image:
                                    AssetImage(serviceItems[index]['image']!),
                                fit: BoxFit.cover,
                                colorFilter: ColorFilter.mode(
                                  Colors.black.withOpacity(0.3),
                                  BlendMode.darken,
                                ),
                              ),
                            ),
                            child: Center(
                              child: customTextOne(
                                  text: serviceData['name'] ?? 'New Service',
                                  fontweight: FontWeight.bold,
                                  fontsize: screenWidth > 360 ? 13 : 10,
                                  textcolor: white),
                            ),
                          ),
                        );
                      }),
                    );
                  },
                  loading: () => Shimmer.fromColors(
                    baseColor: Colors.grey.withOpacity(.2),
                    highlightColor: Colors.white.withOpacity(.6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(4, (index) {
                        return Container(
                          margin: EdgeInsets.only(left: index == 0 ? 0 : 10),
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: grey.withOpacity(.5),
                          ),
                        );
                      }),
                    ),
                  ),
                  error: (error, _) => Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Text(
                          error.toString(),
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 3.h),
                GestureDetector(
                  onTap: () {
                    pushScreenTo(context, const ServicesScreen());
                  },
                  child: Text(
                    "View all",
                    style: TextStyle(
                        color: black,
                        fontSize: screenWidth > 360 ? 16 : 12,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),

            SizedBox(height: 3.h),
            // "What's New" and Updates sections
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  height: 200,
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
                        padding: EdgeInsets.only(
                            left: 16, right: 16, top: 16, bottom: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            customText('START AFRESH', FontWeight.bold,
                                screenWidth > 360 ? 18 : 16, white),
                            const SizedBox(height: 2),
                            customText('Get 20% Off', FontWeight.bold,
                                screenWidth > 360 ? 20 : 16, white),
                            const SizedBox(height: 4),
                            customText(
                                'On haircuts Between 9-10 AM.',
                                FontWeight.bold,
                                screenWidth > 360 ? 16 : 12,
                                white),
                            const Spacer(),
                            customButton(
                              ontap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        const ServicesScreen()));
                              },
                              backgroundcolor: lightfontgrey.withOpacity(.6),
                              text: 'Book Now',
                              fontsize: 12,
                              textcolor: white,
                              radius: screenWidth > 360 ? 16 : 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),

            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  customText('OUR TEAM', FontWeight.bold,
                      screenWidth > 360 ? 16 : 14, blue),
                  const SizedBox(height: 16),
                  staffAsyncValue.when(
                    data: (staffList) {
                      if (staffList.isEmpty) {
                        return Center(
                          child: customTextOne(
                              text: "No staff members found",
                              fontweight: FontWeight.normal,
                              fontsize: 16,
                              textcolor: red),
                        );
                      }
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(staffList.length, (index) {
                            final staff = staffList[index];
                            return Padding(
                                padding:
                                    EdgeInsets.only(left: index == 0 ? 0 : 10),
                                child: Column(
                                  children: [
                                    staff.imageUrl != null
                                        ? CircleAvatar(
                                            backgroundColor: blue,
                                            backgroundImage:
                                                NetworkImage(staff.imageUrl!),
                                            radius: 40,
                                          )
                                        : CircleAvatar(
                                            backgroundColor: blue,
                                            radius: 40,
                                            child: Icon(Icons.person,
                                                color: white, size: 50),
                                          ),
                                    const SizedBox(height: 5),
                                    customText(
                                        staff?.username ?? 'New Stylist',
                                        FontWeight.normal,
                                        screenWidth > 360 ? 14 : 10,
                                        black),
                                  ],
                                ));
                          }),
                        ),
                      );
                    },
                    loading: () => Shimmer.fromColors(
                      baseColor: Colors.grey.withOpacity(.2),
                      highlightColor: Colors.white.withOpacity(.6),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(8, (index) {
                            return Padding(
                                padding:
                                    EdgeInsets.only(left: index == 0 ? 0 : 10),
                                child: CircleAvatar(
                                  backgroundColor: grey.withOpacity(.5),
                                  radius: 40,
                                ));
                          }),
                        ),
                      ),
                    ),
                    error: (error, stack) => Center(
                        child: Text(
                      "Error: $error",
                      style: const TextStyle(color: Colors.red),
                    )),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  // Helper function to build icons with text
}

class ReusableCircleWidget extends StatelessWidget {
  final String label;
  final String paths;
  final Color? color;
  const ReusableCircleWidget(
      {super.key, this.color, required this.label, required this.paths});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          paths,
          color: color,
          height: 25,
        ),
        SizedBox(height: 10.sp),
        Text(
          label,
          style: TextStyle(color: red, fontSize: 14.sp),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
