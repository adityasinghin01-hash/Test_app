import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:test_app/providers/auth_provider.dart';

/// Splash screen — shown on app launch.
///
/// 1. Displays animated branding.
/// 2. Calls [AuthNotifier.checkAuthStatus] to validate stored tokens.
/// 3. Routes to `/dashboard` (authenticated) or `/login` (unauthenticated).
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Let the branding animation play for a moment
    await Future.delayed(const Duration(milliseconds: 1500));

    // Check stored tokens → sets AuthStatus.authenticated or .unauthenticated
    await ref.read(authProvider.notifier).checkAuthStatus();
  }

  @override
  Widget build(BuildContext context) {
    // Listen for auth status changes to navigate
    ref.listen<AuthState>(authProvider, (previous, next) {
      if (!mounted) return;

      switch (next.status) {
        case AuthStatus.authenticated:
          if (next.user?.isVerified == false) {
            context.go('/verification-pending');
          } else {
            context.go('/dashboard');
          }
          break;
        case AuthStatus.unauthenticated:
          context.go('/login');
          break;
        case AuthStatus.unknown:
          break; // Still loading
      }
    });

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1A1A2E),
              Color(0xFF16213E),
              Color(0xFF0F3460),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ── App icon ──────────────────────────────
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF6C63FF),
                    Color(0xFF3F8EFC),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6C63FF).withValues(alpha: 0.4),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Icon(
                Icons.shield_rounded,
                size: 48,
                color: Colors.white,
              ),
            )
                .animate()
                .fadeIn(duration: 600.ms)
                .scale(
                  begin: const Offset(0.5, 0.5),
                  end: const Offset(1, 1),
                  duration: 600.ms,
                  curve: Curves.elasticOut,
                ),

            const SizedBox(height: 28),

            // ── App name ──────────────────────────────
            Text(
              'TestApp',
              style: GoogleFonts.outfit(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.2,
              ),
            )
                .animate()
                .fadeIn(delay: 300.ms, duration: 500.ms)
                .slideY(begin: 0.3, end: 0, duration: 500.ms),

            const SizedBox(height: 8),

            // ── Tagline ───────────────────────────────
            Text(
              'Secure Authentication',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.white.withValues(alpha: 0.6),
                letterSpacing: 2,
              ),
            )
                .animate()
                .fadeIn(delay: 600.ms, duration: 500.ms),

            const SizedBox(height: 60),

            // ── Loading indicator ─────────────────────
            SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Colors.white.withValues(alpha: 0.7),
                ),
              ),
            )
                .animate()
                .fadeIn(delay: 900.ms, duration: 400.ms),
          ],
        ),
      ),
    );
  }
}
