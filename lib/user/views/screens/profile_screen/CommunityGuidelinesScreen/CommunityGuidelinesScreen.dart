import 'package:epic/components/custom_text.dart';
import 'package:epic/consts/colors.dart';
import 'package:flutter/material.dart';

class CommunityGuidelinesScreen extends StatelessWidget {
  const CommunityGuidelinesScreen({super.key});

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
        title: customText(
          'Community Guidelines',
          FontWeight.bold,
          screenWidth > 360 ? 14 : 12,
          newGrey,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            customText(
              'Welcome to Epic Hair',
              FontWeight.bold,
              screenWidth > 360 ? 18 : 14,
              newGrey,
            ),
            const SizedBox(height: 16.0),
            customText(
              'These guidelines are in place to help maintain a positive and respectful community. By using Epic Hair, you agree to the following rules:',
              FontWeight.normal,
              screenWidth > 360 ? 14 : 12,
              Colors.black87,
            ),
            const SizedBox(height: 16.0),
            _buildGuidelineItem('Respect and Kindness',
                'Treat everyone with respect and kindness. Avoid harassment, hate speech, and abusive behavior.'),
            _buildGuidelineItem('No Discrimination or Harassment',
                'Discrimination based on race, gender, religion, or sexual orientation is strictly prohibited.'),
            _buildGuidelineItem('Authentic Content',
                'Share only content you own or have permission to use. Avoid spreading false or misleading information.'),
            _buildGuidelineItem('No Inappropriate Content',
                'Do not post explicit, violent, or illegal content. This includes nudity and sexually explicit material.'),
            _buildGuidelineItem('Privacy and Security',
                'Respect others\' privacy. Do not share personal information without consent.'),
            _buildGuidelineItem('No Spamming or Advertising',
                'Avoid spamming, repetitive content, or unsolicited promotions.'),
            _buildGuidelineItem('Report Misconduct',
                'Report any inappropriate content or behavior you encounter. We will take necessary action.'),
            _buildGuidelineItem('Follow Legal Standards',
                'Abide by local laws and regulations when using the app. Do not engage in illegal activities.'),
            _buildGuidelineItem('Constructive Feedback',
                'Share feedback respectfully. Help us improve the app with positive suggestions.'),
            _buildGuidelineItem('Keep It Fun and Positive',
                'Enjoy the app and keep the experience uplifting for everyone!'),
            const SizedBox(height: 16.0),
            customText(
              'Enforcement',
              FontWeight.bold,
              screenWidth > 360 ? 16 : 14,
              newGrey,
            ),
            const SizedBox(height: 8.0),
            customText(
              'Violation of these guidelines may result in content removal, suspension, or account ban. We reserve the right to take action based on the severity of the offense.',
              FontWeight.normal,
              screenWidth > 360 ? 14 : 12,
              Colors.black87,
            ),
            const SizedBox(height: 16.0),
            customText(
              'Contact Us',
              FontWeight.bold,
              screenWidth > 360 ? 16 : 14,
              newGrey,
            ),
            const SizedBox(height: 8.0),
            customText(
              'If you have any questions or concerns, please contact us at: epic.hair.support@gmail.com',
              FontWeight.normal,
              screenWidth > 360 ? 14 : 12,
              Colors.black87,
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build each guideline item
  Widget _buildGuidelineItem(String title, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        customText(title, FontWeight.bold, 16, newGrey),
        const SizedBox(height: 8.0),
        customText(description, FontWeight.normal, 14, Colors.black87),
        const SizedBox(height: 16.0),
      ],
    );
  }
}
