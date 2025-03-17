import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectedServiceProvider = StateProvider<String?>((ref) => null);

// Function to update the selected service (ref is passed from the UI)
void selectService(WidgetRef ref, String service) {
  ref.read(selectedServiceProvider.notifier).state = service;
}
