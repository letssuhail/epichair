import 'package:epic/components/custom_text.dart';
import 'package:epic/consts/colors.dart';
import 'package:epic/user/providers/login_notifier.dart';
import 'package:epic/user/utils/navigator_function.dart';
import 'package:epic/user/views/screens/login%20screen/otp_verification_screen.dart';
import 'package:epic/user/views/screens/sign_up_screen.dart/sign_up_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController emailController = TextEditingController();

  bool isLoading = false;

  Future<void> handleLogin() async {
    final email = emailController.text;
    String code = '+1';
    setState(() {
      isLoading = true;
    });

    final result = await ref.read(loginProvider.notifier).login(code + email);

    setState(() {
      isLoading = false;
    });

    if (result != null) {
      Navigator.push(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(
          builder: (context) => OtpVerificationLoginScreen(email: result),
        ),
      );
      // ignore: use_build_context_synchronously
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
        SnackBar(
            backgroundColor: white,
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
                padding: EdgeInsets.symmetric(horizontal: 5.4.h),
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
      text: 'Login',
      fontweight: FontWeight.w700,
      fontsize: 40,
      textcolor: white,
      textalign: TextAlign.center,
    );
  }

  Widget _buildEmailField() {
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
                  cursorColor: red,
                  keyboardType: TextInputType.phone,
                  style: TextStyle(color: black, fontSize: 20),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(left: 10),
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

  Widget _buildLoginButton(BuildContext context) {
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
                  fontsize: 20,
                  textcolor: white,
                  textalign: TextAlign.center)),
    );
  }

  Widget _buildSignUpSection(context) {
    return Column(
      children: [
        customTextWithAlignment(
          text: 'No account? No problem',
          fontweight: FontWeight.w400,
          fontsize: 14,
          textcolor: white,
          textalign: TextAlign.center,
        ),
        TextButton(
          onPressed: () {
            pushScreenTo(context, const SignUpScreen());
          },
          child: customTextOne(
            text: 'Sign up',
            fontweight: FontWeight.w700,
            fontsize: 16,
            textcolor: red,
          ),
        ),
      ],
    );
  }
}
