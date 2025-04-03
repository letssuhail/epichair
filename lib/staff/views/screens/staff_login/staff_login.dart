import 'package:epic/consts/colors.dart';
import 'package:epic/staff/providers/login_staff_notifier.dart';
import 'package:epic/staff/views/screens/staff_login/otp_verification_staff.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../components/custom_text.dart';

class StaffLoginScreen extends ConsumerStatefulWidget {
  const StaffLoginScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _StaffLoginScreenState();
}

class _StaffLoginScreenState extends ConsumerState<StaffLoginScreen> {
  final TextEditingController emailController = TextEditingController();

  bool isLoading = false;

  Future<void> handleLogin() async {
    final email = emailController.text;
    String code = '+1';
    setState(() {
      isLoading = true;
    });

    final result =
        await ref.read(loginStaffProvider.notifier).login(code + email);

    setState(() {
      isLoading = false;
    });

    if (result != null) {
      Navigator.push(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(
          builder: (context) => OtpVerificationLoginStaffScreen(email: result),
        ),
      );
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            backgroundColor: black,
            content: Text(
              'Otp sent successfully. Please check.',
              style: TextStyle(color: red),
            )),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            backgroundColor: black,
            content: Text(
              'Login failed. Please try again.',
              style: TextStyle(color: red),
            )),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/backgroundImages/login.png'),
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
                    const SizedBox(height: 40),
                    _buildTitle(),
                    const SizedBox(height: 30),
                    _buildEmailField(),
                    const SizedBox(
                      height: 20,
                    ),
                    _buildLoginButton(context),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
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
      text: 'Staff Login',
      fontweight: FontWeight.w700,
      fontsize: screenWidth > 360 ? 30 : 25,
      textcolor: white,
      textalign: TextAlign.center,
    );
  }

  Widget _buildEmailField() {
    double screenWidth = MediaQuery.of(context).size.width;
    return Card(
      color: white,
      child: Container(
        height: 49,
        decoration: BoxDecoration(
          border: Border.all(color: grey),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              const SizedBox(width: 10),
              Text(
                '+1',
                style: TextStyle(
                  fontSize: screenWidth > 360 ? 18 : 14,
                  fontWeight: FontWeight.w700,
                  color: black,
                ),
              ),
              Expanded(
                child: TextField(
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  controller: emailController,
                  cursorColor: grey,
                  keyboardType: TextInputType.phone,
                  style: TextStyle(
                      color: black, fontSize: screenWidth > 360 ? 16 : 12),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(left: 10),
                    hintText: 'Enter your phone',
                    hintStyle: TextStyle(
                      fontSize: screenWidth > 360 ? 16 : 12,
                      fontWeight: FontWeight.w700,
                      color: grey,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return SizedBox(
      height: 54,
      width: double.infinity,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              // minimumSize: const Size(double.infinity, 40),
              backgroundColor: red,
              side: BorderSide(color: red, width: 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(45),
              )),
          onPressed: isLoading ? null : handleLogin,
          child: isLoading
              ? CircularProgressIndicator(
                  color: white,
                )
              : customTextWithAlignment(
                  text: 'Login',
                  fontweight: FontWeight.w700,
                  fontsize: screenWidth > 360 ? 16 : 12,
                  textcolor: white,
                  textalign: TextAlign.center)),
    );
  }
}
