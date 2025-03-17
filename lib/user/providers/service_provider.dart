import 'package:epic/user/api%20services/service_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final serviceProvider = FutureProvider<List<dynamic>?>((ref) async {
  final apiService = ApiService();
  return await apiService.getServices();
});
