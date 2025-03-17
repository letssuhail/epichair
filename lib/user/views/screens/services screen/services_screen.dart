import 'package:epic/user/providers/selectedService_notifier.dart';
import 'package:epic/user/providers/service_provider.dart';
import 'package:epic/user/views/screens/barber%20list%20screen/barber_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:epic/consts/colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ServicesScreen extends ConsumerWidget {
  const ServicesScreen({super.key});

  Future<void> _refreshServices(WidgetRef ref) async {
    // Trigger a refresh by calling the notifier method that fetches services
    ref.refresh(serviceProvider);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final servicesAsyncValue =
        ref.watch(serviceProvider); // Watch the serviceProvider

    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
              left: 10.0, right: 10.0, top: 20.0), // Use pixels for padding
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Choose your Service',
                style: TextStyle(
                  color: newGrey,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.sp,
                  decoration: TextDecoration.underline,
                  decorationColor: newGrey,
                  decorationThickness: 2,
                ),
              ),
              SizedBox(height: 20.sp),

              // Add RefreshIndicator to allow pull-to-refresh functionality
              Expanded(
                child: RefreshIndicator(
                  color: blue,
                  onRefresh: () => _refreshServices(ref),
                  child: servicesAsyncValue.when(
                    data: (services) {
                      if (services == null || services.isEmpty) {
                        return Center(
                          child: Text(
                            'No services available',
                            style: TextStyle(color: black),
                          ),
                        );
                      }

                      return GridView.builder(
                        padding: const EdgeInsets.all(8.0),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1, // Adjust size of grid items
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                        ),
                        itemCount: services.length,
                        itemBuilder: (context, index) {
                          final service = services[index];
                          final serviceName = service['name'] ?? 'New Service';
                          final servicePrice = service['price'] ?? '0';
                          final serviceId = service['_id'] ?? 'unknown id';

                          return NewHaircutWidget(
                            id: serviceId,
                            label: serviceName,
                            pathh: "assets/new-icons/hair-cut.svg",
                            price: servicePrice
                                .toString(), // Placeholder for service icons
                          );
                        },
                      );
                    },
                    loading: () => Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(child: CircularProgressIndicator(color: red)),
                      ],
                    ),
                    error: (error, _) => Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Text(
                            error.toString(),
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NewHaircutWidget extends ConsumerWidget {
  final String id;
  final String label;
  final String pathh;
  final String price;
  const NewHaircutWidget(
      {super.key,
      required this.label,
      required this.pathh,
      required this.id,
      required this.price});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () {
        // Update the selected service
        ref.read(selectedServiceProvider.notifier).state =
            label; // Set serviceId
        // Navigate to the barber list screen with the correct serviceId
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => BarberListScreen(
                    serviceId: id,
                    serviceName: label,
                    servicePrice: price,
                  )),
        );
      },
      child: Card(
        color: white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        shadowColor: Colors.grey,
        elevation: 4,
        child: Container(
          width: 100,
          padding: const EdgeInsets.all(10), // Padding inside the container

          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  pathh,
                  color: blue,
                ),
                const SizedBox(height: 10), // Spacing between icon and text
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    color: newGrey, // Text color
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5), // Spacing between icon and text
                Text(
                  '₹$price.00',
                  style: TextStyle(
                    fontSize: 13,
                    color: black, // Text color
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
