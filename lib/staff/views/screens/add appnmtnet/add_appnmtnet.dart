import 'package:epic/components/custom_button.dart';
import 'package:epic/components/custom_text.dart';
import 'package:epic/consts/colors.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AddAppnmtnetScreen extends StatefulWidget {
  const AddAppnmtnetScreen({super.key});

  @override
  State<AddAppnmtnetScreen> createState() => _AddAppnmtnetScreenState();
}

class _AddAppnmtnetScreenState extends State<AddAppnmtnetScreen> {
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
      body: SingleChildScrollView(
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
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: greydark,
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 2.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                            style: IconButton.styleFrom(
                                backgroundColor: black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                )),
                            onPressed: () {},
                            icon: Icon(
                              Icons.more_horiz,
                              size: 20,
                              color: red,
                            )),
                        IconButton(
                            style: IconButton.styleFrom(
                                backgroundColor: black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                )),
                            onPressed: () {},
                            icon: Icon(
                              Icons.edit,
                              size: 20,
                              color: red,
                            )),
                        SizedBox(
                          width: 18.sp,
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          top: 20.sp, left: 20.sp, right: 20.sp, bottom: 26.sp),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: black,
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              top: 20.sp,
                              left: 23.sp,
                              right: 23.sp,
                            ),
                            child: Column(
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  backgroundColor: grey,
                                  backgroundImage: const NetworkImage(
                                      'https://images.unsplash.com/photo-1461800919507-79b16743b257?q=80&w=1374&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
                                ),
                                customTextOne(
                                    text: 'Jon sen',
                                    fontweight: FontWeight.w700,
                                    fontsize: 20.sp,
                                    textcolor: red),
                                customTextOne(
                                    text: 'Customer since Dec 23',
                                    fontweight: FontWeight.w700,
                                    fontsize: 16.sp,
                                    textcolor: grey),
                                customTextOne(
                                    text: 'Regular*',
                                    fontweight: FontWeight.w700,
                                    fontsize: 16.sp,
                                    textcolor: white),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // left side items
                                    Column(
                                      children: [
                                        customTextOne(
                                            text: 'Date',
                                            fontweight: FontWeight.w700,
                                            fontsize: 18.sp,
                                            textcolor: grey),
                                        customTextOne(
                                            text: '17-10-24',
                                            fontweight: FontWeight.w700,
                                            fontsize: 18.sp,
                                            textcolor: white),
                                        SizedBox(
                                          height: 5.h,
                                        ),
                                        customTextOne(
                                            text: 'Service',
                                            fontweight: FontWeight.w700,
                                            fontsize: 18.sp,
                                            textcolor: grey),
                                        customTextOne(
                                            text: 'Haircut',
                                            fontweight: FontWeight.w700,
                                            fontsize: 18.sp,
                                            textcolor: white),
                                      ],
                                    ),

                                    // right side items
                                    Column(
                                      children: [
                                        customTextOne(
                                            text: 'Time',
                                            fontweight: FontWeight.w700,
                                            fontsize: 18.sp,
                                            textcolor: grey),
                                        customTextOne(
                                            text: '11:00 AM',
                                            fontweight: FontWeight.w700,
                                            fontsize: 18.sp,
                                            textcolor: white),
                                        SizedBox(
                                          height: 5.h,
                                        ),
                                        customTextOne(
                                            text: 'Staff',
                                            fontweight: FontWeight.w700,
                                            fontsize: 18.sp,
                                            textcolor: grey),
                                        customTextOne(
                                            text: 'Adam S',
                                            fontweight: FontWeight.w700,
                                            fontsize: 18.sp,
                                            textcolor: white),
                                      ],
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 5.h,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Expanded(
                                      child: SizedBox(
                                        height: 4.3.h,
                                        child: customButton(
                                          ontap: () {},
                                          backgroundcolor: black,
                                          text: 'Re-schedule',
                                          fontsize: 15.sp,
                                          radius: 45,
                                          borderwidth: 1,
                                          textcolor: red,
                                          borderColor: red,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 4.w,
                                    ),
                                    Expanded(
                                      child: SizedBox(
                                        height: 4.3.h,
                                        child: customButton(
                                          ontap: () {},
                                          backgroundcolor: black,
                                          text: 'Contact',
                                          fontsize: 15.sp,
                                          radius: 45,
                                          borderwidth: 1,
                                          textcolor: red,
                                          borderColor: red,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 3.h,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    customTextOne(
                                        text: 'Send a reminder to Jon',
                                        fontweight: FontWeight.w400,
                                        fontsize: 16.sp,
                                        textcolor: white),
                                    SizedBox(
                                      width: 2.w,
                                    ),
                                    Switch(
                                      value: isSwitched,
                                      onChanged: (value) {
                                        setState(() {
                                          isSwitched = value;
                                        });
                                      },
                                      activeTrackColor:
                                          red, // Switch track color when active
                                      activeColor:
                                          black, // Switch thumb color when active
                                      inactiveTrackColor:
                                          black, // Switch track color when inactive
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              customTextOne(
                                  text: '*10% Auto-discount',
                                  fontweight: FontWeight.w400,
                                  fontsize: 15.sp,
                                  textcolor: white),
                              SizedBox(
                                width: 5.w,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5.h,
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
      ),
    );
  }

  Widget _buildTopSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        customTextOne(
            text: 'Add appointment',
            fontweight: FontWeight.w700,
            fontsize: 22.sp,
            textcolor: red),
      ],
    );
  }
}
