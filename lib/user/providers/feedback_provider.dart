import 'package:epic/user/api%20services/appointment_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final feedbackProvider = StateNotifierProvider<FeedbackNotifier, bool>((ref) {
  return FeedbackNotifier();
});

class FeedbackNotifier extends StateNotifier<bool> {
  FeedbackNotifier() : super(false);
  final feedbackService = AppointmentService();

  Future<bool> submitFeedback({
    required String appointmentId,
    required String userId,
    required String feedback,
    required int rating,
  }) async {
    state = true; // Setting loading state to true

    final isSuccess = await feedbackService.updateFeedback(
      appointmentId: appointmentId,
      userId: userId,
      feedback: feedback,
      rating: rating,
    );

    state = false; // Resetting loading state

    return isSuccess;
  }
}
