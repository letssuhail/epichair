import 'package:epic/components/custom_text.dart';
import 'package:epic/consts/colors.dart';
import 'package:flutter/material.dart';

// Define the PrivacyPolicyScreen widget
class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: newGrey,
            size: screenWidth > 360 ? 24 : 20,
          ),
        ),
        title: customText('Privacy Policy', FontWeight.bold,
            screenWidth > 360 ? 13 : 10, newGrey),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            customText('Privacy Policy for Epic Hair', FontWeight.bold,
                screenWidth > 360 ? 20 : 12, newGrey),
            const SizedBox(height: 8.0),
            customText('Last Updated: 26/02/25', FontWeight.normal,
                screenWidth > 360 ? 14 : 10, Colors.black87),
            const SizedBox(height: 16.0),
            customText(
                'Welcome to the Epic Hair Application ("we," "our," or "us"). Your privacy is important to us, and we are committed to protecting your personal data. This Privacy Policy explains what information we collect, how we use it, and your rights regarding your data.',
                FontWeight.normal,
                screenWidth > 360 ? 14 : 10,
                Colors.black87),
            const SizedBox(height: 16.0),
            customText('1. Information We Collect', FontWeight.bold,
                screenWidth > 360 ? 16 : 14, newGrey),
            const SizedBox(height: 8.0),
            customText(
                'When you create an account on Epic Hair, we collect the following information:',
                FontWeight.normal,
                screenWidth > 360 ? 14 : 10,
                Colors.black87),
            customText(
                '• Mobile Number: Required for account creation and verification.',
                FontWeight.normal,
                screenWidth > 360 ? 14 : 10,
                Colors.black87),
            customText(
                '• Profile Picture (Optional): Users can upload a profile picture for personalization.',
                FontWeight.normal,
                screenWidth > 360 ? 14 : 10,
                Colors.black87),
            customText('• Name: Used for display within the app.',
                FontWeight.normal, screenWidth > 360 ? 14 : 10, Colors.black87),
            const SizedBox(height: 16.0),
            customText('2. How We Use Your Information', FontWeight.bold,
                screenWidth > 360 ? 16 : 14, newGrey),
            const SizedBox(height: 8.0),
            customText('We use your data to:', FontWeight.normal,
                screenWidth > 360 ? 14 : 10, Colors.black87),
            customText(
                '• Provide account authentication and secure access to the app.',
                FontWeight.normal,
                screenWidth > 360 ? 14 : 10,
                Colors.black87),
            customText('• Improve user experience and personalize the app.',
                FontWeight.normal, screenWidth > 360 ? 14 : 10, Colors.black87),
            customText(
                '• Ensure compliance with applicable laws and regulations.',
                FontWeight.normal,
                screenWidth > 360 ? 14 : 10,
                Colors.black87),
            const SizedBox(height: 16.0),
            customText('3. Permissions Used', FontWeight.bold,
                screenWidth > 360 ? 16 : 14, newGrey),
            const SizedBox(height: 8.0),
            customText('Our app requests the following permissions:',
                FontWeight.normal, screenWidth > 360 ? 14 : 10, Colors.black87),
            customText(
                '• Internet Access (android.permission.INTERNET): Required for account creation, profile uploads, and app functionality.',
                FontWeight.normal,
                screenWidth > 360 ? 14 : 10,
                Colors.black87),
            const SizedBox(height: 16.0),
            customText('4. Data Security', FontWeight.bold,
                screenWidth > 360 ? 16 : 14, newGrey),
            const SizedBox(height: 8.0),
            customText(
                'We take appropriate security measures to protect your personal data. However, no method of transmission over the internet is 100% secure.',
                FontWeight.normal,
                screenWidth > 360 ? 14 : 10,
                Colors.black87),
            const SizedBox(height: 16.0),
            customText('5. Data Sharing', FontWeight.bold,
                screenWidth > 360 ? 16 : 14, newGrey),
            const SizedBox(height: 8.0),
            customText(
                'We do not sell, rent, or share your personal data with third parties for marketing purposes. Your data is only used to provide and improve our services.',
                FontWeight.normal,
                screenWidth > 360 ? 14 : 10,
                Colors.black87),
            const SizedBox(height: 16.0),
            customText('6. Children’s Privacy', FontWeight.bold,
                screenWidth > 360 ? 16 : 14, newGrey),
            const SizedBox(height: 8.0),
            customText(
                'Our app is intended for users aged 13 and above. We do not knowingly collect data from children under 13. If you believe a child has provided personal information, please contact us to remove it.',
                FontWeight.normal,
                screenWidth > 360 ? 14 : 10,
                Colors.black87),
            const SizedBox(height: 16.0),
            customText('7. Updates to This Privacy Policy', FontWeight.bold,
                screenWidth > 360 ? 16 : 14, newGrey),
            const SizedBox(height: 8.0),
            customText(
                'We may update this policy from time to time. Any changes will be communicated within the app.',
                FontWeight.normal,
                screenWidth > 360 ? 14 : 10,
                Colors.black87),
            const SizedBox(height: 16.0),
            customText('8. Contact Us', FontWeight.bold,
                screenWidth > 360 ? 16 : 14, newGrey),
            const SizedBox(height: 8.0),
            customText(
                'If you have any questions or concerns, reach out to us at:',
                FontWeight.normal,
                screenWidth > 360 ? 14 : 10,
                Colors.black87),
            customText('📧 Email: epic.hair.support@gmail.com',
                FontWeight.normal, screenWidth > 360 ? 14 : 10, Colors.black87),
          ],
        ),
      ),
    );
  }
}
