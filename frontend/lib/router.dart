import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:test_app/providers/auth_provider.dart';
import 'package:test_app/screens/dashboard_screen.dart';
import 'package:test_app/screens/forgot_password_screen.dart';
import 'package:test_app/screens/login_screen.dart';
import 'package:test_app/screens/profile_screen.dart';
import 'package:test_app/screens/reset_password_screen.dart';
import 'package:test_app/screens/signup_screen.dart';
import 'package:test_app/screens/splash_screen.dart';
import 'package:test_app/screens/verification_pending_screen.dart';

// ── Global Navigator Key ────────────────────────────────
final rootNavigatorKey = GlobalKey<NavigatorState>();

/// Riverpod provider for the GoRouter instance.
///
/// Reacts to changes in [authProvider] to automatically redirect
/// users based on their authentication and verification status.
final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/',
    // ── Redirect Logic ──────────────────────────────────
    redirect: (context, state) {
      final isAuth = authState.status == AuthStatus.authenticated;
      final isUnauth = authState.status == AuthStatus.unauthenticated;
      final isUnknown = authState.status == AuthStatus.unknown;
      final isVerified = authState.user?.isVerified ?? false;

      final path = state.uri.path;
      final isNavigatingToAuth = path == '/login' ||
          path == '/signup' ||
          path == '/forgot-password' ||
          path == '/reset-password';

      // 1. App is starting up -> stay on splash
      if (isUnknown && path == '/') return null;

      // 2. Unauthenticated user trying to access protected route -> go to login
      // (Exception: reset-password deep links are allowed for unauth users)
      if (isUnauth && !isNavigatingToAuth && path != '/') {
        return '/login';
      }

      // 3. Authenticated user logic
      if (isAuth) {
        // Unverified users are strictly locked to the verification screen
        if (!isVerified && path != '/verification-pending') {
          return '/verification-pending';
        }

        // Verified users trying to access auth screens or verification screen -> go to dashboard
        if (isVerified &&
            (isNavigatingToAuth ||
                path == '/verification-pending' ||
                path == '/')) {
          return '/dashboard';
        }
      }

      // No redirect needed
      return null;
    },
    // ── Routes ──────────────────────────────────────────
    routes: [
      // Splash (Entry Point)
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),

      // Auth Flow
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/reset-password',
        builder: (context, state) {
          // Deep links come in as /reset-password?token=XYZ
          final token = state.uri.queryParameters['token'] ?? '';
          return ResetPasswordScreen(token: token);
        },
      ),
      GoRoute(
        path: '/verification-pending',
        builder: (context, state) => const VerificationPendingScreen(),
      ),

      // Protected UI
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
    ],
  );
});
