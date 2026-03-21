import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// A standardized text input field that enforces the app's glassmorphism style.
///
/// Features built-in label rendering, password visibility toggling,
/// and smooth validation error handling leveraging [AppTheme]'s InputDecoration.
class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    required this.label,
    this.controller,
    this.hintText,
    this.prefixIcon,
    this.isPassword = false,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    this.onFieldSubmitted,
    this.autofillHints,
  });

  /// The label displayed above the field.
  final String label;

  /// Controls the text being edited.
  final TextEditingController? controller;

  /// Placeholder text shown when the field is empty.
  final String? hintText;

  /// Icon displayed at the left of the input field.
  final IconData? prefixIcon;

  /// If true, obscures text and adds an eye toggle icon button.
  final bool isPassword;

  /// Functional validation logic (e.g., email or length checks).
  final String? Function(String?)? validator;

  /// The type of keyboard to display (e.g. TextInputType.emailAddress).
  final TextInputType? keyboardType;

  /// The action button on the keyboard (e.g. TextInputAction.next).
  final TextInputAction? textInputAction;

  /// Triggered when the keyboard action button is pressed.
  final void Function(String)? onFieldSubmitted;

  /// Autofill hints for integrating with password managers and OS autofill.
  final Iterable<String>? autofillHints;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _obscureText;
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Label ──────────────────────────────────────────
        Text(
          widget.label,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white.withValues(alpha: _isFocused ? 1.0 : 0.8),
          ),
        ).animate(target: _isFocused ? 1 : 0).tint(
            color: const Color(0xFF6C63FF),
            duration: 200.ms,
          ),
        const SizedBox(height: 8),

        // ── TextFormField ──────────────────────────────────
        TextFormField(
          controller: widget.controller,
          focusNode: _focusNode,
          obscureText: _obscureText,
          validator: widget.validator,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          onFieldSubmitted: widget.onFieldSubmitted,
          autofillHints: widget.autofillHints,
          style: GoogleFonts.inter(color: Colors.white),
          // Fallback styling applied here to guarantee look even without context theme
          decoration: InputDecoration(
            hintText: widget.hintText,
            prefixIcon: widget.prefixIcon != null
                ? Icon(
                    widget.prefixIcon,
                    color: _isFocused
                        ? const Color(0xFF6C63FF)
                        : Colors.white.withValues(alpha: 0.4),
                    size: 20,
                  ).animate(target: _isFocused ? 1 : 0).scaleXY(
                      begin: 1.0, end: 1.1, duration: 150.ms)
                : null,
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                      _obscureText
                          ? Icons.visibility_off_rounded
                          : Icons.visibility_rounded,
                      color: Colors.white.withValues(alpha: 0.4),
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  )
                : null,
          ),
        ),
      ],
    );
  }
}
