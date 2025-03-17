import 'package:epic/components/custom_text.dart';
import 'package:epic/consts/colors.dart';
import 'package:flutter/material.dart';

// Define the AboutUsScreen widget
class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

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
            )),
        title: customText('ABOUT EPIC HAIR', FontWeight.bold,
            screenWidth > 360 ? 13 : 10, newGrey),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              customText(
                'Welcome to Epic Hair!',
                FontWeight.bold,
                screenWidth > 360 ? 20 : 12,
                newGrey,
              ),
              const SizedBox(height: 16.0),
              customText(
                'Epic Hair is your go-to destination for premium hair care and styling services. Our application makes it easier for you to book appointments with our top stylists, explore our services, and enjoy a seamless salon experience right at your fingertips.',
                FontWeight.normal,
                screenWidth > 360 ? 14 : 10,
                Colors.black87,
              ),
              const SizedBox(height: 16.0),
              customText(
                'Features:',
                FontWeight.bold,
                screenWidth > 360 ? 16 : 14,
                newGrey,
              ),
              const SizedBox(height: 8.0),
              customText(
                '• Browse our range of hair care services\n'
                '• Book appointments with your favorite stylists\n'
                '• Get real-time updates and notifications for your bookings\n'
                '• Explore exclusive offers and promotions\n'
                '• User-friendly interface for a hassle-free experience',
                FontWeight.normal,
                screenWidth > 360 ? 14 : 10,
                Colors.black87,
              ),
              const SizedBox(height: 16.0),
              customText(
                'How to Book:',
                FontWeight.bold,
                screenWidth > 360 ? 16 : 14,
                newGrey,
              ),
              const SizedBox(height: 8.0),
              customText(
                '• Choose your desired service from the list\n'
                '• Select a stylist and preferred time slot\n'
                '• Confirm your booking with a few simple taps\n'
                '• Receive a confirmation notification with booking details',
                FontWeight.normal,
                screenWidth > 360 ? 14 : 10,
                Colors.black87,
              ),
              const SizedBox(height: 16.0),
              customText(
                'Contact Us:',
                FontWeight.bold,
                screenWidth > 360 ? 16 : 14,
                newGrey,
              ),
              const SizedBox(height: 8.0),
              customText(
                'For support or inquiries, please reach out to us at:\n'
                'Email: epichair@gmail.com\n'
                'Phone: Coming soon\n'
                'Website: Coming soon',
                FontWeight.normal,
                screenWidth > 360 ? 14 : 10,
                Colors.black87,
              ),
              const SizedBox(height: 16.0),
              customText(
                'Acknowledgments:',
                FontWeight.bold,
                screenWidth > 360 ? 16 : 14,
                newGrey,
              ),
              const SizedBox(height: 8.0),
              customText(
                'We would like to thank our loyal customers, talented stylists, and the entire Epic Hair team for making this application possible.',
                FontWeight.normal,
                screenWidth > 360 ? 14 : 10,
                Colors.black87,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
