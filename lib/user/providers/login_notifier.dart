import 'package:epic/user/auth_services/auth_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginNotifier extends StateNotifier<String?> {
  LoginNotifier() : super(null);

  final AuthService _authService = AuthService();

  Future<String?> login(String email) async {
    bool result = await _authService.login(email);
    if (result) {
      state = email; // Update the state to the email if signup is successful
      return email; // Return email if signup is successful
    }
    return null; // Return null if signup fails
  }

  Future<Map<String, dynamic>?> verifyOtp(String email, String otp) async {
    return await _authService.loginVerifyOtp(
        email, otp); // Return the response map
  }
}

final loginProvider = StateNotifierProvider<LoginNotifier, String?>((ref) {
  return LoginNotifier();
});
