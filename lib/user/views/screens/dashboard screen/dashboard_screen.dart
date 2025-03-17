// import 'package:epic/components/custom_button.dart';
// import 'package:epic/components/custom_text.dart';
// import 'package:epic/consts/colors.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:responsive_sizer/responsive_sizer.dart';

// class DashboardScreen extends StatelessWidget {
//   const DashboardScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: white,
//       appBar: AppBar(
//         leading: IconButton(
//             onPressed: () {},
//             icon: Icon(
//               Icons.menu,
//               color: brown,
//             )),
//         actions: [
//           Row(
//             children: [
//               Icon(
//                 Icons.location_on,
//                 color: brown,
//               ),
//               customTextOne(
//                   text: 'West bank',
//                   fontweight: FontWeight.w600,
//                   fontsize: 14.sp,
//                   textcolor: darkbrown),
//               SizedBox(
//                 width: 3.w,
//               ),
//             ],
//           )
//         ],
//         backgroundColor:
//             Colors.transparent, // Makes AppBar background transparent
//         elevation: 0, // Removes the AppBar shadow
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding:
//               EdgeInsets.only(left: 5.w, right: 5.w, bottom: 5.h, top: 1.h),
//           child: Column(
//             children: [
//               _buildTopSection(),
//               SizedBox(
//                 height: 5.h,
//               ),
//               _buildUserSection(),
//               SizedBox(
//                 height: 1.h,
//               ),
//               _buildUpcomingAppointmentSection(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildBackgroundImage() {
//     return Container(
//       decoration: const BoxDecoration(
//         image: DecorationImage(
//           image: AssetImage('assets/backgroundImages/dashboard-bg.png'),
//           fit: BoxFit.cover,
//         ),
//       ),
//     );
//   }

//   Widget _buildTopSection() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Image.asset('assets/icons/wing-left.png'),
//         customTextOne(
//             text: 'My dashboard',
//             fontweight: FontWeight.w700,
//             fontsize: 22.sp,
//             textcolor: brown),
//         Image.asset('assets/icons/wing-right.png'),
//       ],
//     );
//   }

//   Widget _buildUserSection() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.end,
//       children: [
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.end,
//           children: [
//             CircleAvatar(
//               radius: 50,
//               backgroundColor: grey,
//               backgroundImage: const NetworkImage(
//                   'https://images.unsplash.com/photo-1672761431764-61b8d9a00dbb?q=80&w=1530&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
//             ),
//             customTextOne(
//                 text: 'Sonu Deshwal',
//                 fontweight: FontWeight.w700,
//                 fontsize: 20.sp,
//                 textcolor: brown),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _buildUpcomingAppointmentSection() {
//     return Column(
//       children: [
//         customTextOne(
//             text: 'Upcoming appointment',
//             fontweight: FontWeight.w700,
//             fontsize: 20.sp,
//             textcolor: white),
//         ListView.builder(
//             physics: const NeverScrollableScrollPhysics(),
//             padding: const EdgeInsets.only(top: 10),
//             itemCount: 2,
//             shrinkWrap: true,
//             itemBuilder: (context, index) {
//               return Padding(
//                 padding: const EdgeInsets.only(bottom: 12),
//                 child: Container(
//                   decoration: BoxDecoration(
//                     color: black,
//                     border: Border.all(color: brown, width: 1.0),
//                     borderRadius: BorderRadius.circular(10.0),
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(10.0),
//                     child: Column(
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment
//                               .center, // Center the children in the row
//                           children: [
//                             Stack(
//                               alignment: Alignment.topLeft,
//                               children: [
//                                 SvgPicture.asset(
//                                   'assets/backgroundImages/expertbg.svg',
//                                   fit: BoxFit.cover,
//                                   height: 10.h,
//                                 ),
//                                 Positioned.fill(
//                                   child: Align(
//                                     alignment: Alignment
//                                         .center, // Positions the CircleAvatar in the center
//                                     child: CircleAvatar(
//                                       backgroundColor: Colors.grey,
//                                       radius: 24
//                                           .sp, // Adjust the size of the avatar as needed
//                                       backgroundImage: const NetworkImage(
//                                           'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?q=80&w=1374&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             Expanded(
//                               child: Align(
//                                 alignment:
//                                     Alignment.center, // Center the container
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.center,
//                                   children: [
//                                     customTextOne(
//                                         text: '13th August 11:30 AM',
//                                         fontweight: FontWeight.w700,
//                                         fontsize: 18.sp,
//                                         textcolor: brown),
//                                     customTextOne(
//                                         text: 'Haircut',
//                                         fontweight: FontWeight.w700,
//                                         fontsize: 18.sp,
//                                         textcolor: white),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             SizedBox(
//                               width: 24.w,
//                             ),
//                             Expanded(
//                               child: SizedBox(
//                                 height: 4.3.h,
//                                 child: customButton(
//                                   ontap: () {},
//                                   backgroundcolor: brown,
//                                   text: 'Reschedule',
//                                   fontsize: 14.sp,
//                                   radius: 45,
//                                   borderwidth: 1,
//                                   textcolor: black,
//                                   borderColor: brown,
//                                   fontWeight: FontWeight.w700,
//                                 ),
//                               ),
//                             ),
//                             SizedBox(
//                               width: 1.h,
//                             ),
//                             Expanded(
//                               child: SizedBox(
//                                 height: 4.3.h,
//                                 child: customButton(
//                                   ontap: () {},
//                                   backgroundcolor: black,
//                                   text: 'Cancel',
//                                   fontsize: 14.sp,
//                                   radius: 45,
//                                   borderwidth: 1,
//                                   textcolor: brown,
//                                   borderColor: brown,
//                                   fontWeight: FontWeight.w700,
//                                 ),
//                               ),
//                             ),
//                             SizedBox(
//                               width: 1.h,
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               );
//             }),
//         SizedBox(
//           height: 5.h,
//         ),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             Container(
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(10),
//                 border: Border.all(color: brown, width: 2),
//                 color: black,
//               ),
//               child: Padding(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                 child: Column(
//                   children: [
//                     SvgPicture.asset(
//                       'assets/icons/head.svg',
//                       height: 55,
//                     ),
//                     SizedBox(
//                       height: 2.h,
//                     ),
//                     customTextOne(
//                         text: 'My history',
//                         fontweight: FontWeight.w700,
//                         fontsize: 17.sp,
//                         textcolor: brown),
//                   ],
//                 ),
//               ),
//             ),
//             Container(
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(10),
//                 border: Border.all(color: brown, width: 2),
//                 color: black,
//               ),
//               child: Padding(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                 child: Column(
//                   children: [
//                     SvgPicture.asset(
//                       'assets/icons/seaf.svg',
//                       height: 55,
//                     ),
//                     SizedBox(
//                       height: 2.h,
//                     ),
//                     customTextOne(
//                         text: 'My history',
//                         fontweight: FontWeight.w700,
//                         fontsize: 17.sp,
//                         textcolor: brown),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         )
//       ],
//     );
//   }
// }
