import 'dart:developer';

import 'package:epic/consts/colors.dart';
import 'package:epic/staff/providers/get_appointments_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class StaffClientsScreen extends ConsumerStatefulWidget {
  const StaffClientsScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _StaffClientsScreenState();
}

class _StaffClientsScreenState extends ConsumerState<StaffClientsScreen> {
  @override
  Widget build(BuildContext context) {
    final appointmentsAsync = ref.watch(staffAppointmentsProvider);
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        foregroundColor: black,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              "Past Customers",
              style: TextStyle(
                  color: newGrey,
                  fontSize: screenWidth > 360 ? 18 : 14,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 4.h,
            ),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: appointmentsAsync.when(
                    data: (data) {
                      final clientDataList = data['completed'] ?? [];

                      final uniqueClients = <Map<String, dynamic>>[];
                      final seenUserIds = <String>{};

                      for (var clientData in clientDataList) {
                        final user = clientData['user'];
                        if (user != null) {
                          final userId = user['_id'];
                          if (!seenUserIds.contains(userId)) {
                            seenUserIds.add(userId);
                            uniqueClients.add(clientData);
                          }
                        }
                      }

                      log('Unique Clients Count: ${uniqueClients.length}');

                      if (uniqueClients.isEmpty) {
                        return Center(
                          child: Text(
                            'No Past Customers',
                            style: TextStyle(
                              color: red,
                              fontSize: screenWidth > 360 ? 18 : 14,
                            ),
                          ),
                        );
                      }

                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 0.9,
                        ),
                        itemCount: uniqueClients.length,
                        itemBuilder: (context, index) {
                          final clientData = uniqueClients[index];
                          log(clientData.toString());
                          return avatarWidget(
                              imagePath: clientData['user']['image_url'],
                              name: clientData['user']['username'],
                              context: context);
                        },
                      );
                    },
                    loading: () => Center(
                            child: CircularProgressIndicator(
                          color: red,
                        )),
                    error: (error, _) => Center(child: Text('Error: $error')))),
          ],
        ),
      ),
    );
  }
}

Widget avatarWidget({
  required String imagePath,
  required String name,
  required BuildContext context,
}) {
  double screenWidth = MediaQuery.of(context).size.width;
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      imagePath.isNotEmpty
          ? CircleAvatar(
              radius: 40,
              backgroundColor: blue,
              backgroundImage: NetworkImage(imagePath),
            )
          : CircleAvatar(
              backgroundColor: blue,
              radius: 40,
              child: Icon(Icons.person, color: white, size: 60),
            ),
      SizedBox(height: 8),
      Text(
        name,
        style: TextStyle(
          fontSize: screenWidth > 360 ? 16 : 12,
          fontWeight: FontWeight.bold,
          color: black,
        ),
      ),
    ],
  );
}
