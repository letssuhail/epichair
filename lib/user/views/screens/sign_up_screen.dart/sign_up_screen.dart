import 'package:epic/components/custom_button.dart';
import 'package:epic/components/custom_text.dart';
import 'package:epic/consts/colors.dart';
import 'package:epic/user/providers/signup_notifier.dart';
import 'package:epic/user/utils/navigator_function.dart';
import 'package:epic/user/views/screens/login%20screen/login_screen.dart';
import 'package:epic/user/views/screens/login%20screen/otp_verification_screen.dart';
import 'package:epic/user/views/screens/sign_up_screen.dart/otp_verification_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final TextEditingController emailController = TextEditingController();

  bool isLoading = false;

  Future<void> handleSignup() async {
    String code = '+1';
    final email = emailController.text;

    setState(() {
      isLoading = true;
    });

    final result = await ref.read(signupProvider.notifier).signup(code + email);

    setState(() {
      isLoading = false;
    });

    if (result != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OtpVerificationSignupScreen(email: result),
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            backgroundColor: red,
            content: Text(
              'Otp sent successfully. Please check.',
              style: TextStyle(color: white),
            )),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Signup failed. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: black,
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
                padding: EdgeInsets.symmetric(horizontal: 5.4.h),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildLogo(),
                      const SizedBox(height: 40),
                      _buildTitle(),
                      const SizedBox(height: 20),
                      _buildEmailField(emailController: emailController),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
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
                            onPressed: isLoading ? null : handleSignup,
                            child: isLoading
                                ? CircularProgressIndicator(
                                    color: white,
                                  )
                                : customTextWithAlignment(
                                    text: 'Sign Up',
                                    fontweight: FontWeight.w700,
                                    fontsize: 20,
                                    textcolor: white,
                                    textalign: TextAlign.center)),
                      ),
                      const SizedBox(height: 10),
                      const SizedBox(height: 40),
                      _buildSignUpSection(context),
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
      text: 'Sign Up',
      fontweight: FontWeight.w700,
      fontsize: 40,
      textcolor: white,
      textalign: TextAlign.center,
    );
  }

  Widget _buildEmailField({
    required TextEditingController emailController,
  }) {
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
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: black,
                ),
              ),
              Expanded(
                child: TextField(
                  inputFormatters: [
                    FilteringTextInputFormatter
                        .digitsOnly, // Allow only numeric input
                    LengthLimitingTextInputFormatter(
                        10), // Limit input to 10 digits
                  ],
                  controller: emailController,
                  cursorColor: grey,
                  keyboardType: TextInputType.phone,
                  style: TextStyle(color: black, fontSize: 20),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(left: 10, bottom: 2),
                    hintText: 'Enter your phone',
                    hintStyle: TextStyle(
                      fontSize: 20,
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

  Widget _buildSignUpSection(context) {
    return Column(
      children: [
        customTextWithAlignment(
          text: 'You have an already account?',
          fontweight: FontWeight.w400,
          fontsize: 14,
          textcolor: white,
          textalign: TextAlign.center,
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: customTextOne(
            text: 'Log In',
            fontweight: FontWeight.w700,
            fontsize: 16,
            textcolor: red,
          ),
        ),
      ],
    );
  }
}
