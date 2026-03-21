import 'package:dio/dio.dart';
import 'package:test_app/config/app_config.dart';
import 'package:test_app/services/api_client.dart';

/// Pure API wrapper for auth endpoints.
///
/// Returns raw [Response] data — the provider/caller handles
/// token storage and state updates.
class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  Dio get _dio => ApiClient.instance.dio;

  /// `POST /api/signup`
  /// Returns `{ accessToken, refreshToken, user }`.
  Future<Response> signup({
    required String email,
    required String password,
    required String recaptchaToken,
  }) {
    return _dio.post(
      AppConfig.signupPath,
      data: {
        'email': email,
        'password': password,
        'recaptchaToken': recaptchaToken,
      },
    );
  }

  /// `POST /api/login`
  /// Returns `{ accessToken, refreshToken, user }`.
  Future<Response> login({
    required String email,
    required String password,
    required String recaptchaToken,
    bool rememberMe = false,
  }) {
    return _dio.post(
      AppConfig.loginPath,
      data: {
        'email': email,
        'password': password,
        'recaptchaToken': recaptchaToken,
        'rememberMe': rememberMe,
      },
    );
  }

  /// `POST /api/logout`
  /// Send the refresh token so the backend can invalidate the session.
  Future<Response> logout({required String refreshToken}) {
    return _dio.post(
      AppConfig.logoutPath,
      data: {'refreshToken': refreshToken},
    );
  }

  /// `POST /api/google-login`
  /// Send Google `idToken` → returns `{ accessToken, refreshToken, user }`.
  Future<Response> googleLogin({required String idToken}) {
    return _dio.post(
      AppConfig.googleLoginPath,
      data: {'idToken': idToken},
    );
  }

  /// `POST /api/refresh-token`
  /// Returns `{ accessToken, refreshToken }`.
  ///
  /// Note: The [AuthInterceptor] handles automatic refresh on 401.
  /// This method exists for explicit manual refresh if ever needed.
  Future<Response> refreshToken({required String refreshToken}) {
    return _dio.post(
      AppConfig.refreshTokenPath,
      data: {'refreshToken': refreshToken},
    );
  }
}
