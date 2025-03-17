import 'package:epic/components/custom_button.dart';
import 'package:epic/components/custom_text.dart';
import 'package:epic/consts/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class HolidaysScreen extends StatelessWidget {
  const HolidaysScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.menu,
              color: red,
            )),
        actions: [
          Row(
            children: [
              Icon(
                Icons.location_on,
                color: red,
              ),
              customTextOne(
                  text: 'West bank',
                  fontweight: FontWeight.w600,
                  fontsize: 14.sp,
                  textcolor: darkbrown),
              SizedBox(
                width: 3.w,
              ),
            ],
          )
        ],
        backgroundColor:
            Colors.transparent, // Makes AppBar background transparent
        elevation: 0, // Removes the AppBar shadow
      ),
      body: Stack(
        children: [
          _buildBackgroundImage(),
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + kToolbarHeight,
                  left: 5.w,
                  right: 5.w,
                  bottom: 5.h),
              child: Column(
                children: [
                  _buildTopSection(),
                  SizedBox(
                    height: 5.h,
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  _buildHolidaysSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackgroundImage() {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/backgroundImages/holidays-bg.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildTopSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset('assets/icons/wing-left.png'),
        customTextOne(
            text: 'My holidays',
            fontweight: FontWeight.w700,
            fontsize: 22.sp,
            textcolor: red),
        Image.asset('assets/icons/wing-right.png'),
      ],
    );
  }

  Widget _buildHolidaysSection() {
    return Column(
      children: [
        ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.only(top: 13),
            itemCount: 2,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(
                        Icons.edit,
                        color: red,
                      ),
                      SizedBox(
                        width: 8.sp,
                      ),
                      Icon(
                        Icons.delete_forever,
                        color: red,
                      )
                    ],
                  ),
                  SizedBox(
                    height: 8.sp,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Container(
                      decoration: BoxDecoration(
                        color: black,
                        border: Border.all(color: red, width: 1.0),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                customTextOne(
                                    text: 'Going on vacations',
                                    fontweight: FontWeight.w700,
                                    fontsize: 20.sp,
                                    textcolor: white),
                                SizedBox(
                                  height: 6.sp,
                                ),
                                customTextOne(
                                    text: '23rd August - 30th August',
                                    fontweight: FontWeight.w700,
                                    fontsize: 17.sp,
                                    textcolor: red),
                              ],
                            ),
                            SvgPicture.asset(
                              'assets/icons/holidays-card-icon.svg',
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }),
        SizedBox(
          height: 24.sp,
        ),
        SizedBox(
          height: 4.3.h,
          width: 40.w,
          child: customButton(
            ontap: () {},
            backgroundcolor: black,
            text: 'Add holiday',
            fontsize: 16.sp,
            radius: 45,
            borderwidth: 1,
            textcolor: red,
            borderColor: red,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
