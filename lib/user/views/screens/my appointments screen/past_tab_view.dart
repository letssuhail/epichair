import 'dart:ui';

import 'package:epic/user/providers/appointmentGet_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:epic/consts/colors.dart';
import 'package:epic/components/custom_text.dart';
import 'package:custom_rating_bar/custom_rating_bar.dart';
import 'package:epic/user/providers/feedback_provider.dart';

class PastTabView extends ConsumerWidget {
  const PastTabView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double screenWidth = MediaQuery.of(context).size.width;
    final appointmentsAsync = ref.watch(appointmentsProvider);

    return appointmentsAsync.when(
      data: (data) {
        final pastAppointments = data['completed'] ?? [];

        if (pastAppointments.isEmpty) {
          return Center(
              child: Text(
            'No completed appointments',
            style: TextStyle(color: red),
          ));
        }

        return ListView.builder(
          padding: const EdgeInsets.only(top: 10),
          itemCount: pastAppointments.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            final appointment = pastAppointments[index];

            final appointmentId = appointment['_id'];
            final userId =
                appointment['user']['_id']; // Assume user ID is provided here
            String feedback = appointment['feedback'] ?? 'Great service!';
            int initialRating = appointment['rating'] ?? 0;

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xffE5F0FF),
                  border: Border.all(color: grey, width: 1.0),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Stack(
                  children: [
                    // Background Image
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          'assets/backgroundImages/booking-past.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    // Black Blur Effect
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 1.0, sigmaY: 1.0),
                          child: Container(
                            color: Colors.black.withOpacity(0.1),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.grey,
                                  radius: screenWidth > 360 ? 35 : 30,
                                  backgroundImage: NetworkImage(
                                    appointment['barber']?['image_url'] ??
                                        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT9nHrLn6HQN45iNAfQ2DXKp5nTyosP_2xxR8JDlZNwqgqfHnAjJys4oGh6_PWxP0RbtbY&usqp=CAU',
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    customTextOne(
                                      text: appointment['service']['name'],
                                      fontweight: FontWeight.w700,
                                      fontsize: screenWidth > 360 ? 18 : 14,
                                      textcolor: white,
                                    ),
                                    const SizedBox(height: 5),
                                    customTextOne(
                                      text:
                                          'Price: CA\$${appointment['service']['price'].toString()}',
                                      fontweight: FontWeight.w700,
                                      fontsize: screenWidth > 360 ? 18 : 14,
                                      textcolor: white,
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        RatingBar(
                                          size: screenWidth > 360 ? 18 : 14,
                                          filledIcon: Icons.star,
                                          emptyIcon: Icons.star_border,
                                          initialRating:
                                              initialRating.toDouble(),
                                          maxRating: 5,
                                          emptyColor: white,
                                          filledColor: const Color(0xffF2D688),
                                          onRatingChanged: (newRating) {
                                            ref
                                                .read(feedbackProvider.notifier)
                                                .submitFeedback(
                                                  appointmentId: appointmentId,
                                                  userId: userId,
                                                  feedback: feedback,
                                                  rating: newRating.toInt(),
                                                )
                                                .then((success) {
                                              if (success) {
                                                ref.invalidate(
                                                    appointmentsProvider);
                                                // print(appointmentId);
                                                // print(userId);

                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      'Rating updated successfully!',
                                                      style: TextStyle(
                                                          color: white),
                                                    ),
                                                    backgroundColor: black,
                                                  ),
                                                );
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      'Field update rating',
                                                      style: TextStyle(
                                                          color: white),
                                                    ),
                                                    backgroundColor: red,
                                                  ),
                                                );
                                              }
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                    customTextOne(
                                      text: 'Completed',
                                      fontweight: FontWeight.w700,
                                      fontsize: screenWidth > 360 ? 18 : 14,
                                      textcolor: white,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      loading: () => Center(
          child: CircularProgressIndicator(
        color: red,
      )),
      error: (error, _) => Center(child: Text('Error: $error')),
    );
  }
}
