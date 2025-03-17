import 'package:epic/components/custom_button.dart';
import 'package:epic/consts/colors.dart';
import 'package:epic/staff/views/screens/staff_login/staff_login.dart';
import 'package:epic/user/utils/navigator_function.dart';
import 'package:epic/user/views/screens/login%20screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../components/custom_text.dart';

class UserTypeDecideScreen extends StatelessWidget {
  const UserTypeDecideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: black,
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                      'assets/backgroundImages/user-type-decide.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(
                  right: 20.0,
                  left: 20.0,
                  top: 160,
                  bottom: 50,
                ), // Add some padding for better layout
                child: Column(
                  mainAxisSize: MainAxisSize
                      .min, // Center content vertically within available space
                  crossAxisAlignment:
                      CrossAxisAlignment.center, // Center horizontally
                  children: [
                    // Logo
                    Image.asset(
                      'assets/logo/epic-hair.png',
                      width: 140,
                    ),
                    const SizedBox(
                        height: 20), // Space between heading and logo

                    const Spacer(), // Add spacing between logo and buttons
                    customTextOne(
                        text: 'Welcome',
                        fontweight: FontWeight.bold,
                        fontsize: 30.sp,
                        textcolor: white),
                    customTextOne(
                        text: 'Choose your role to begin.',
                        fontweight: FontWeight.bold,
                        fontsize: 18.sp,
                        textcolor: white),

                    // Log in button
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 10.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 50,
                              child: customButton(
                                  ontap: () {
                                    pushScreenTo(context, const LoginScreen());
                                  },
                                  backgroundcolor: black,
                                  text: 'Client',
                                  fontsize: 16.sp,
                                  radius: 26,
                                  textcolor: white,
                                  fontWeight: FontWeight.normal),
                            ),
                          ),
                          SizedBox(
                            width: 10.sp,
                          ),
                          Expanded(
                            child: SizedBox(
                              height: 50,
                              child: customButton(
                                  ontap: () {
                                    pushScreenTo(
                                        context, const StaffLoginScreen());
                                  },
                                  backgroundcolor: black,
                                  text: 'Staff',
                                  fontsize: 16.sp,
                                  radius: 26,
                                  textcolor: white,
                                  fontWeight: FontWeight.normal),
                            ),
                          ),
                          // InkWell(
                          //   onTap: () {
                          //     pushScreenTo(context, const LoginScreen());
                          //   },
                          //   child: SizedBox(
                          //     width: 115,
                          //     child: Card(
                          //       shape: RoundedRectangleBorder(
                          //         borderRadius: BorderRadius.circular(8),
                          //       ),
                          //       child: Padding(
                          //         padding: const EdgeInsets.symmetric(
                          //             horizontal: 26, vertical: 10),
                          //         child: SvgPicture.asset(
                          //           'assets/icons/client.svg',
                          //           color: newGrey,
                          //         ),
                          //       ),
                          //     ),
                          //   ),
                          // ),

                          // InkWell(
                          //   onTap: () {
                          //     pushScreenTo(context, const StaffLoginScreen());
                          //   },
                          //   child: SizedBox(
                          //     width: 115,
                          //     child: Card(
                          //       shape: RoundedRectangleBorder(
                          //         borderRadius: BorderRadius.circular(8),
                          //       ),
                          //       child: Padding(
                          //         padding: const EdgeInsets.symmetric(
                          //             horizontal: 26, vertical: 10),
                          //         child: SvgPicture.asset(
                          //           'assets/icons/staff.svg',
                          //           color: newGrey,
                          //         ),
                          //       ),
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
