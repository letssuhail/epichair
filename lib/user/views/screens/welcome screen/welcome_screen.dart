import 'package:epic/components/custom_button.dart';
import 'package:epic/components/custom_text.dart';
import 'package:epic/consts/colors.dart';
import 'package:epic/user/utils/navigator_function.dart';
import 'package:epic/user/views/screens/login%20screen/login_screen.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image

          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/backgroundImages/welcomebg.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Center the content on the screen
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
                    'assets/logo/logo.png',
                    width: 138,
                  ),

                  const Spacer(), // Add spacing between logo and buttons

                  // Log in button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 54,
                          width: double.infinity,
                          child: customButton(
                            ontap: () {
                              pushScreenTo(context, const LoginScreen());
                            },
                            backgroundcolor: red,
                            text: 'Log in',
                            fontsize: 29,
                            radius: 45,
                            borderwidth: 0,
                            textcolor: black,
                            borderColor: red,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        // const SizedBox(
                        //     height: 15), // Add spacing between buttons

                        // // Guest button
                        // SizedBox(
                        //   height: 54,
                        //   width: double.infinity,
                        //   child: customButton(
                        //     ontap: () {},
                        //     backgroundcolor: black,
                        //     text: 'Guest',
                        //     fontsize: 29,
                        //     radius: 45,
                        //     borderwidth: 1,
                        //     textcolor: lightbrown,
                        //     borderColor: lightbrown,
                        //     fontWeight: FontWeight.w700,
                        // ),
                        // ),
                      ],
                    ),
                  ),

                  const SizedBox(
                      height: 30), // Add spacing between button and text

                  // Additional text
                  customTextWithAlignment(
                    text: 'No account? No problem',
                    fontweight: FontWeight.w700,
                    fontsize: 12,
                    textcolor: red,
                    textalign: TextAlign.center,
                  ),
                  TextButton(
                    onPressed: () {},
                    child: customTextWithAlignment(
                      text: 'Sign up',
                      fontweight: FontWeight.w700,
                      fontsize: 14,
                      textcolor: red,
                      textalign: TextAlign.center,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
