// staff_screen.dart
import 'package:epic/components/custom_text.dart';
import 'package:epic/consts/colors.dart';
import 'package:epic/staff/providers/staff_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AllStaffDetailsScreen extends ConsumerWidget {
  const AllStaffDetailsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final staffAsyncValue = ref.watch(staffProvider);
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: background,
      floatingActionButton: FloatingActionButton(
        backgroundColor: red,
        child: Icon(
          Icons.refresh,
          color: white,
        ),
        onPressed: () {
          try {
            ref.invalidate(staffProvider);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: background,
                content: Text(
                  'Refresh successfully',
                  style: TextStyle(color: red),
                )));
          } catch (e) {
            SnackBar(
                backgroundColor: Colors.red,
                content: Text(
                  'Refresh Field',
                  style: TextStyle(color: white),
                ));
          }
        },
      ),
      appBar: AppBar(
        foregroundColor: black,
        backgroundColor: background,
        title: customTextOne(
            text: 'Staff Members',
            fontweight: FontWeight.bold,
            fontsize: screenWidth > 360 ? 18 : 14,
            textcolor: black),
      ),
      body: staffAsyncValue.when(
        data: (staffList) {
          if (staffList.isEmpty) {
            return Center(
              child: customTextOne(
                  text: "No staff members found",
                  fontweight: FontWeight.normal,
                  fontsize: screenWidth > 360 ? 16 : 12,
                  textcolor: red),
            );
          }
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: ListView.builder(
              itemCount: staffList.length,
              itemBuilder: (context, index) {
                final staff = staffList[index];
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  padding: const EdgeInsets.only(right: 6),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF00BCD4), Color(0xFFFF5252)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(100),
                        bottomLeft: Radius.circular(100)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.4),
                        spreadRadius: 2,
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      staff.imageUrl != null
                          ? CircleAvatar(
                              backgroundColor: blue,
                              backgroundImage: NetworkImage(staff.imageUrl!),
                              radius: screenWidth > 360 ? 50 : 45,
                            )
                          : CircleAvatar(
                              backgroundColor: blue,
                              radius: screenWidth > 360 ? 50 : 45,
                              child: Icon(Icons.person, color: white, size: 50),
                            ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            customTextOne(
                                text: staff?.username ?? 'New Stylist',
                                fontweight: FontWeight.bold,
                                fontsize: screenWidth > 360 ? 18 : 12,
                                textcolor: black),
                            customTextOne(
                                text: 'Email: ${staff.phoneNumber}"',
                                fontweight: FontWeight.bold,
                                fontsize: screenWidth > 360 ? 16 : 10,
                                textcolor: black),
                            customTextOne(
                              text: 'Services: ${staff.services.join(', ')}',
                              fontweight: FontWeight.bold,
                              fontsize: screenWidth > 360 ? 16 : 10,
                              textcolor: red,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          );
        },
        loading: () => Center(
            child: CircularProgressIndicator(
          color: red,
        )),
        error: (error, stack) => Center(
            child: Text(
          "Error: $error",
          style: const TextStyle(color: Colors.red),
        )),
      ),
    );
  }
}
