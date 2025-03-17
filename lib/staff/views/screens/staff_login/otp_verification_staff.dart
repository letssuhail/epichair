import 'dart:developer';

import 'package:epic/components/custom_button.dart';
import 'package:epic/components/custom_text.dart';
import 'package:epic/consts/colors.dart';
import 'package:epic/main.dart';
import 'package:epic/staff/views/screens/bottom_nav_bar_staff_screen/bottom_nav_bar_staff.dart';
import 'package:epic/user/providers/login_notifier.dart';
import 'package:epic/user/utils/navigator_function.dart';
import 'package:epic/user/views/screens/bottom_nav_bar_client_screen/bottom_nav_bar_client.dart';
import 'package:epic/user/views/screens/home%20screen/home_screen.dart';
import 'package:epic/user/views/screens/profile_screen/profile_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinput/pinput.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class OtpVerificationLoginStaffScreen extends ConsumerStatefulWidget {
  final email;
  const OtpVerificationLoginStaffScreen({super.key, required this.email});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _OtpVerificationLoginStaffScreenState();
}

class _OtpVerificationLoginStaffScreenState
    extends ConsumerState<OtpVerificationLoginStaffScreen> {
  final TextEditingController otpController = TextEditingController();
  bool isLoading = false;
  String? errorMessage;

  Future<void> verifyOtp(WidgetRef ref) async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    final otp = otpController.text;

    final result =
        await ref.read(loginProvider.notifier).verifyOtp(widget.email, otp);

    log(result.toString());

    setState(() {
      isLoading = false;
    });

    if (result != null) {
      // Extract the message, role, and token from the result
      final message = result['message'];
      final roleTopLevel = result['role']; // Role from the top level
      final roleNested = result['tokenData']?['role']; // Role from tokenData

      if (roleTopLevel == 'staff' || roleNested == 'staff') {
        // Navigate to the home screen for staff
        // ignore: use_build_context_synchronously
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const BottomNavBarStaff()),
          (Route<dynamic> route) => false,
        );

        // Show a success message in a SnackBar
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: black,
            content: Text(
              message,
              style: TextStyle(color: red),
            ),
          ),
        );
      } else {
        // If the user is not staff, show an error SnackBar
        // ignore: use_build_context_synchronously
        ref.read(logoutProvider.notifier).logout(context);
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: primary,
            content: Text(
              'This is not a staff phone number. Check your credentials',
              style: TextStyle(color: white),
            ),
          ),
        );
      }
    } else {
      // If OTP verification failed, show an invalid OTP error
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: white,
          content: Text(
            'Invalid OTP. Please try again.',
            style: TextStyle(color: red),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: black,
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/backgroundImages/otp.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.4.h),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildLogo(),
                      SizedBox(height: 3.h),
                      _buildTitle(),
                      SizedBox(height: 4.h),
                      _buildPinField(
                          email: widget.email, otpController: otpController),
                      SizedBox(height: 4.h),
                      _buildSubmmitButton(context),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  Widget _buildLogo() {
    return Image.asset(
      'assets/logo/epic-hair.png',
      width: 120,
    );
  }

  Widget _buildTitle() {
    return customTextWithAlignment(
      text: 'Otp Verification',
      fontweight: FontWeight.w700,
      fontsize: 40,
      textcolor: white,
      textalign: TextAlign.center,
    );
  }

  Widget _buildSubmmitButton(BuildContext context) {
    return Column(
      children: [
        Container(
            padding: EdgeInsets.symmetric(horizontal: 2.h),
            height: 54,
            width: double.infinity,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    // minimumSize: const Size(double.infinity, 40),
                    backgroundColor: red,
                    // side: BorderSide(color: borderColor, width: borderwidth),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(45),
                    )),
                onPressed: isLoading ? null : () => verifyOtp(ref),
                child: isLoading
                    ? CircularProgressIndicator(
                        color: white,
                      )
                    : customTextWithAlignment(
                        text: 'Submmit',
                        fontweight: FontWeight.w700,
                        fontsize: 20,
                        textcolor: white,
                        textalign: TextAlign.center))),
      ],
    );
  }

  Widget _buildPinField(
      {required String email, required TextEditingController otpController}) {
    final defaultPinTheme = PinTheme(
      width: 60,
      height: 50,
      textStyle:
          TextStyle(fontSize: 20, color: white, fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
          border: Border.all(color: grey),
          borderRadius: BorderRadius.circular(10),
          color: white),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
        border: Border.all(color: black),
        borderRadius: BorderRadius.circular(10),
        color: white);

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(color: grey),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Pinput(
          length: 6,
          controller: otpController,
          defaultPinTheme: defaultPinTheme,
          focusedPinTheme: focusedPinTheme,
          submittedPinTheme: submittedPinTheme,
          // validator: (s) {
          //   return s == '2222' ? null : 'Pin is incorrect';
          // },
          pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
          showCursor: true,
          // ignore: avoid_print
          onCompleted: (pin) => print(pin),
        ),
        SizedBox(height: 2.h),
        customTextOne(
            alignment: TextAlign.center,
            text: 'Enter the Code sent to $email',
            fontweight: FontWeight.w700,
            fontsize: 16.sp,
            textcolor: white),
      ],
    );
  }
}
