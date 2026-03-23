import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Centralized utility for showing styled SnackBars consistently.
///
/// Prevents repetitive `ScaffoldMessenger.of(context).showSnackBar(...)`
/// boilerplate across screens and ensures standard styling.
class SnackbarHelper {
  SnackbarHelper._();

  /// Displays a red, floating error SnackBar.
  static void showError(BuildContext context, String message) {
    _showSnackBar(
      context: context,
      message: message,
      backgroundColor: Colors.redAccent,
      icon: Icons.error_outline_rounded,
    );
  }

  /// Displays a green, floating success SnackBar.
  static void showSuccess(BuildContext context, String message) {
    _showSnackBar(
      context: context,
      message: message,
      backgroundColor: const Color(0xFF4CAF50),
      icon: Icons.check_circle_outline_rounded,
    );
  }

  /// Displays an info/neutral SnackBar using the app's primary theme color.
  static void showInfo(BuildContext context, String message) {
    _showSnackBar(
      context: context,
      message: message,
      backgroundColor: const Color(0xFF6C63FF),
      icon: Icons.info_outline_rounded,
    );
  }

  static void _showSnackBar({
    required BuildContext context,
    required String message,
    required Color backgroundColor,
    required IconData icon,
  }) {
    // Clear any existing snackbar before showing a new one
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        duration: const Duration(seconds: 4),
      ),
    );
  }
}
