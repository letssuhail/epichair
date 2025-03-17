import 'package:epic/components/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:epic/components/custom_text.dart';
import 'package:epic/consts/colors.dart';

class ContactUsScreen extends StatelessWidget {
  ContactUsScreen({super.key});

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _messageController = TextEditingController();

  void _submitForm(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      // Handle form submission (e.g., send email, store data)
      // You can integrate with an email service or backend API here

      // Clear the controllers
      _nameController.clear();
      _emailController.clear();
      _messageController.clear();

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: customText('Thank You', FontWeight.bold, 18, Colors.teal),
          content: customText('Your message has been sent successfully!',
              FontWeight.normal, 14, Colors.black87),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: customText('OK', FontWeight.bold, 16, Colors.teal),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              color: primary,
              size: screenWidth > 360 ? 24 : 20,
            )),
        title: customText('PREPMEDIX CONTACT US', FontWeight.bold,
            screenWidth > 360 ? 13 : 10, primary),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              customText(
                'We would love to hear from you! Please fill out the form below to get in touch with us.',
                FontWeight.normal,
                16,
                Colors.black87,
              ),
              const SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Name',
                        labelStyle: TextStyle(
                          fontSize: screenWidth > 360 ? 14 : 11,
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: primary)),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: primary)),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(
                          fontSize: screenWidth > 360 ? 14 : 11,
                        ),
                        border: const OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: primary)),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                            .hasMatch(value)) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        labelText: 'Message',
                        labelStyle: TextStyle(
                          fontSize: screenWidth > 360 ? 14 : 11,
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: primary)),
                        border: const OutlineInputBorder(),
                      ),
                      maxLines: 5,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your message';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 45,
                      width: double.infinity,
                      child: customButton(
                          ontap: () {},
                          backgroundcolor: primary,
                          text: 'Send Message',
                          fontsize: screenWidth > 360 ? 12 : 11,
                          radius: 10,
                          borderwidth: 1,
                          textcolor: white,
                          borderColor: primary,
                          fontWeight: FontWeight.w600),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 30),
              // customText(
              //   'Contact Information',
              //   FontWeight.bold,
              //   screenWidth > 360 ? 18 : 14,
              //   Colors.teal,
              // ),
              // const SizedBox(height: 8),
              // customText(
              //   'Email: support@yourapp.com',
              //   FontWeight.normal,
              //   screenWidth > 360 ? 16 : 14,
              //   Colors.black87,
              // ),
              // customText(
              //   'Phone: +123 456 7890',
              //   FontWeight.normal,
              //   screenWidth > 360 ? 16 : 14,
              //   Colors.black87,
              // ),
              // Add more contact information if needed
            ],
          ),
        ),
      ),
    );
  }
}
