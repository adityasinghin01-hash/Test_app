import 'package:dio/dio.dart';
import 'package:test_app/config/app_config.dart';
import 'package:test_app/services/api_client.dart';

/// API wrapper for password reset endpoints.
class PasswordService {
  PasswordService._();
  static final PasswordService instance = PasswordService._();

  Dio get _dio => ApiClient.instance.dio;

  /// `POST /api/forgot-password`
  /// Triggers a password reset email. Backend returns a generic
  /// success response regardless of whether the email exists (security).
  Future<Response> forgotPassword({required String email}) {
    return _dio.post(
      AppConfig.forgotPasswordPath,
      data: {'email': email},
    );
  }

  /// `POST /api/reset-password`
  /// Resets the password using the token from the reset email.
  ///
  /// Note: For this build we use browser-based reset (Option B).
  /// The user resets in the browser, then comes back to the app to login.
  /// This method exists if we ever switch to in-app reset.
  Future<Response> resetPassword({
    required String token,
    required String newPassword,
  }) {
    return _dio.post(
      AppConfig.resetPasswordPath,
      data: {
        'token': token,
        'newPassword': newPassword,
      },
    );
  }
}
