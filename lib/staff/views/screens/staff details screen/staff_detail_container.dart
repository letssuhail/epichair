import 'package:custom_rating_bar/custom_rating_bar.dart';
import 'package:epic/components/custom_button.dart';
import 'package:epic/components/custom_text.dart';
import 'package:epic/consts/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

Widget staffDetailsContainer() {
  return ListView.builder(
      padding: const EdgeInsets.only(top: 10),
      itemCount: 10,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: red, width: 1.0),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment
                        .center, // Center the children in the row
                    children: [
                      Stack(
                        alignment: Alignment.topLeft,
                        children: [
                          SvgPicture.asset(
                            'assets/backgroundImages/expertbg.svg',
                            fit: BoxFit.cover,
                            height: 10.h,
                          ),
                          Positioned.fill(
                            child: Align(
                              alignment: Alignment
                                  .center, // Positions the CircleAvatar in the center
                              child: CircleAvatar(
                                backgroundColor: Colors.grey,
                                radius: 24
                                    .sp, // Adjust the size of the avatar as needed
                                backgroundImage: const NetworkImage(
                                    'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?q=80&w=1374&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.center, // Center the container
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              customTextOne(
                                  text: '11th Sep 18:30 PM',
                                  fontweight: FontWeight.w700,
                                  fontsize: 18.sp,
                                  textcolor: red),
                              customTextOne(
                                  text: 'Haircut',
                                  fontweight: FontWeight.w700,
                                  fontsize: 18.sp,
                                  textcolor: white),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 28.w,
                      ),
                      RatingBar.readOnly(
                        size: 19.sp,
                        filledIcon: Icons.star,
                        emptyIcon: Icons.star_border,
                        initialRating: 2,
                        maxRating: 5,
                        emptyColor: white,
                        filledColor: red,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      });
}
