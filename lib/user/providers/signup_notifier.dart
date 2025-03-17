import 'package:epic/user/auth_services/auth_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignupNotifier extends StateNotifier<String?> {
  SignupNotifier() : super(null); // Initially, no email

  final AuthService _authService = AuthService();

  Future<String?> signup(String email) async {
    bool result = await _authService.signup(email);
    if (result) {
      state = email; // Update the state to the email if signup is successful
      return email; // Return email if signup is successful
    }
    return null; // Return null if signup fails
  }

  Future<Map<String, dynamic>?> verifyOtp(String email, String otp) async {
    return await _authService.verifyOtp(email, otp); // Return the response map
  }
}

// Provider for SignupNotifier
final signupProvider = StateNotifierProvider<SignupNotifier, String?>((ref) {
  return SignupNotifier();
});
