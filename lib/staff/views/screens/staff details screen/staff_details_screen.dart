import 'package:epic/staff/views/screens/staff%20details%20screen/staff_detail_container.dart';
import 'package:epic/components/custom_text.dart';
import 'package:epic/consts/colors.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class StaffDetailsScreen extends StatefulWidget {
  const StaffDetailsScreen({super.key});

  @override
  State<StaffDetailsScreen> createState() => _StaffDetailsScreenState();
}

class _StaffDetailsScreenState extends State<StaffDetailsScreen> {
  bool isSwitched = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.arrow_back,
              color: white,
            )),
        actions: [
          Row(
            children: [
              Icon(
                Icons.menu,
                color: red,
              ),
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
                    height: 3.h,
                  ),
                  staffDetailsContainer(),
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
          image: AssetImage(
              'assets/backgroundImages/confirm-appointment-screen-bg.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildTopSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        customTextOne(
            text: 'Adam”s History',
            fontweight: FontWeight.w700,
            fontsize: 22.sp,
            textcolor: red),
      ],
    );
  }
}
