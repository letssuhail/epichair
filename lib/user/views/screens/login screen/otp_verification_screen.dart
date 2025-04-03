import 'package:epic/components/custom_button.dart';
import 'package:epic/components/custom_text.dart';
import 'package:epic/consts/colors.dart';
import 'package:epic/user/providers/logout_notifier.dart';
import 'package:epic/main.dart';
import 'package:epic/user/providers/login_notifier.dart';
import 'package:epic/user/utils/navigator_function.dart';
import 'package:epic/user/views/screens/bottom_nav_bar_client_screen/bottom_nav_bar_client.dart';
import 'package:epic/user/views/screens/home%20screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinput/pinput.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class OtpVerificationLoginScreen extends ConsumerStatefulWidget {
  final email;
  const OtpVerificationLoginScreen({super.key, required this.email});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _OtpVerificationLoginScreenState();
}

class _OtpVerificationLoginScreenState
    extends ConsumerState<OtpVerificationLoginScreen> {
  final TextEditingController otpController = TextEditingController();
  bool isLoading = false;
  String? errorMessage;

  Future<void> verifyOtp(WidgetRef ref) async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    final otp = otpController.text;

    // Debug print for OTP and email
    print('Verifying OTP for email: ${widget.email} with OTP: $otp');

    final result =
        await ref.read(loginProvider.notifier).verifyOtp(widget.email, otp);

    setState(() {
      isLoading = false;
    });

    if (result != null) {
      // Extract the message, role, and token from the result
      final message = result['message'];
      final token = result['token'];
      final roleTopLevel = result['role']; // Role at the top level
      final roleNested = result['tokenData']?['role']; // Role in tokenData

      // Check if the role is user
      if (roleTopLevel == 'user' || roleNested == 'user') {
        // Navigate to the user home screen
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const BottomNavBarClient()),
          (Route<dynamic> route) => false,
        );

        // Show a success message in a SnackBar
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: red,
            content: Text(
              message,
              style: TextStyle(color: white),
            ),
          ),
        );
      } else {
        // Logout the user if role is not 'user'
        // ignore: use_build_context_synchronously

        ref.read(logoutProvider.notifier).logout(context);
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: primary,
            content: Text(
              'This is not a user phone number. Check your credentials',
              style: TextStyle(color: white),
            ),
          ),
        );
        // Show an error message in a SnackBar
      }
    } else {
      // If OTP verification failed, show an error message
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: black,
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
                padding: EdgeInsets.symmetric(horizontal: 35),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildLogo(),
                      SizedBox(height: 8),
                      _buildTitle(),
                      SizedBox(height: 15),
                      _buildPinField(
                          email: widget.email, otpController: otpController),
                      SizedBox(height: 15),
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
    double screenWidth = MediaQuery.of(context).size.width;
    return customTextWithAlignment(
      text: 'Otp Verification',
      fontweight: FontWeight.w700,
      fontsize: screenWidth > 360 ? 30 : 25,
      textcolor: white,
      textalign: TextAlign.center,
    );
  }

  Widget _buildSubmmitButton(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
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
                        fontsize: screenWidth > 360 ? 16 : 12,
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
