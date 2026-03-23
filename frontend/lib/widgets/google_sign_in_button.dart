import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A specialized, highly-branded button strictly for Google Sign-In.
///
/// Features a pure white background (matching Google's branding guidelines),
/// the Google "G" logo, and built-in loading state management.
class GoogleSignInButton extends StatelessWidget {
  const GoogleSignInButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
  });

  /// Action triggered when tapped. If null, the button is disabled.
  final VoidCallback? onPressed;

  /// If true, disables the button and replaces the "G" with a spinner.
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    // Determine the active onPressed callback
    final activeOnPressed = isLoading ? null : onPressed;

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: activeOnPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          disabledBackgroundColor: Colors.white.withValues(alpha: 0.5),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: Colors.white.withValues(alpha: 0.1),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ── Icon or Loading Spinner ────────────────────────
            if (isLoading)
              const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.black54),
                ),
              )
            else
              _buildGoogleLogo(),

            const SizedBox(width: 16),

            // ── Text Label ─────────────────────────────────────
            Text(
              'Continue with Google',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the Google 'G' using a local asset if available,
  /// or a fallback constructed from primitive shapes/text if not.
  /// Standardized to exactly 24x24 logical pixels.
  Widget _buildGoogleLogo() {
    // In a full production app, you would use an Image.asset('assets/google_logo.png').
    // Since we don't assume the asset exists in this repository yet,
    // we use an elegant typographic fallback that fits the design.
    return Container(
      width: 24,
      height: 24,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        'G',
        style: GoogleFonts.outfit(
          fontSize: 18,
          fontWeight: FontWeight.w900,
          color: const Color(0xFFDB4437), // Google Red
        ),
      ),
    );
  }
}
