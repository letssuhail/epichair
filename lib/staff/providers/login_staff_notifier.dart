import 'package:epic/staff/auth_service/auth_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginNotifier extends StateNotifier<String?> {
  LoginNotifier() : super(null);

  final StaffAuthService _staffAuthService = StaffAuthService();

  Future<String?> login(String email) async {
    bool result = await _staffAuthService.loginStaff(email);
    if (result) {
      state = email; // Update the state to the email if signup is successful
      return email; // Return email if signup is successful
    }
    return null; // Return null if signup fails
  }

  Future<Map<String, dynamic>?> verifyOtp(String email, String otp) async {
    return await _staffAuthService.loginStaffVerifyOtp(
        email, otp); // Return the response map
  }
}

final loginStaffProvider = StateNotifierProvider<LoginNotifier, String?>((ref) {
  return LoginNotifier();
});
