import 'package:epic/user/views/screens/book%20appointment%20screen/book_appointment_screen.dart';
import 'package:flutter/material.dart';
import 'package:epic/consts/colors.dart';
import 'package:epic/user/providers/barberList_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class BarberListScreen extends ConsumerWidget {
  final String serviceId;
  final String serviceName;
  final String servicePrice;
  const BarberListScreen(
      {required this.serviceName,
      required this.serviceId,
      required this.servicePrice,
      super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the barberListProvider with the current serviceId
    final barberListAsync = ref.watch(barberListProvider(serviceName));

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        foregroundColor: black,
      ),
      body: barberListAsync.when(
        data: (barbers) {
          // Ensure barbers list is not null or empty
          if (barbers == null || barbers.isEmpty) {
            return Center(
                child: Text(
              'No barbers available for this service',
              style: TextStyle(color: black),
            ));
          }
          return ListView.builder(
            itemCount: barbers.length,
            itemBuilder: (context, index) {
              final barber = barbers[index];
              return Column(
                children: [
                  if (index == 0)
                    Text(
                      'Our Barbers',
                      style: TextStyle(
                        color: newGrey,
                        fontWeight: FontWeight.bold,
                        fontSize: 22.sp,
                      ),
                    ),
                  SizedBox(height: index == 0 ? 20.sp : 10.sp),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10.sp),
                    margin:
                        EdgeInsets.symmetric(horizontal: 15.sp, vertical: 5.sp),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: newGrey),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 22,
                        backgroundColor: grey,
                        backgroundImage: NetworkImage(barber['imageUrl']!),
                      ),
                      title: Text(
                        barber['name']!,
                        style: TextStyle(
                          fontSize: 20,
                          color: black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: () {
                        // Navigate to Book Appointment Screen with selected barber
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BookAppointmentScreen(
                              barberId: barber['id']!,
                              barberName: barber['name']!,
                              serviceId: serviceId,
                              barberImage: barber['imageUrl']!,
                              serviceName: serviceName,
                              servicePrice: servicePrice,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          );
        },
        loading: () => Center(
          child: CircularProgressIndicator(
            color: red,
          ),
        ),
        error: (error, _) => Center(
          child: Text(
            'Failed to load barbers: ${error.toString()}',
            style: TextStyle(color: Colors.red),
          ),
        ),
      ),
    );
  }
}
