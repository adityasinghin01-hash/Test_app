import 'package:flutter/material.dart';

enum AppButtonType {
  primary,
  outlined,
  text,
}

/// A standardized application button that handles loading states,
/// icons, and the three core Material button types.
///
/// Automatically uses the theme configurations defined in `AppTheme`.
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.type = AppButtonType.primary,
    this.isFullWidth = true,
  });

  /// The text label displayed on the button.
  final String text;

  /// The callback when the button is pressed.
  /// If null, the button is rendered in a disabled state.
  final VoidCallback? onPressed;

  /// Whether the button is currently loading.
  /// When true, [onPressed] is ignored and a spinner is shown.
  final bool isLoading;

  /// An optional icon to display before the text.
  final IconData? icon;

  /// The visual style of the button (primary, outlined, text).
  final AppButtonType type;

  /// Whether the button should stretch to fill its parent's width.
  final bool isFullWidth;

  @override
  Widget build(BuildContext context) {
    // Determine the active onPressed callback
    final activeOnPressed = isLoading ? null : onPressed;

    Widget button;

    switch (type) {
      case AppButtonType.primary:
        button = icon != null
            ? ElevatedButton.icon(
                onPressed: activeOnPressed,
                icon: _buildIconOrLoading(context),
                label: _buildLabel(context),
              )
            : ElevatedButton(
                onPressed: activeOnPressed,
                child: _buildBody(context),
              );
        break;

      case AppButtonType.outlined:
        button = icon != null
            ? OutlinedButton.icon(
                onPressed: activeOnPressed,
                icon: _buildIconOrLoading(context),
                label: _buildLabel(context),
              )
            : OutlinedButton(
                onPressed: activeOnPressed,
                child: _buildBody(context),
              );
        break;

      case AppButtonType.text:
        button = icon != null
            ? TextButton.icon(
                onPressed: activeOnPressed,
                icon: _buildIconOrLoading(context),
                label: _buildLabel(context),
              )
            : TextButton(
                onPressed: activeOnPressed,
                child: _buildBody(context),
              );
        break;
    }

    if (isFullWidth && type != AppButtonType.text) {
      return SizedBox(
        width: double.infinity,
        height: 56, // Standard height for touch targets
        child: button,
      );
    }

    // Wrap in a SizedBox to enforce a consistent height even if not full width
    if (type != AppButtonType.text) {
      return SizedBox(
        height: 56,
        child: button,
      );
    }

    return button;
  }

  /// Builds the inner row consisting of the potential loading spinner/icon and text.
  Widget _buildBody(BuildContext context) {
    if (isLoading) {
      return _buildLoadingSpinner(context);
    }

    return _buildLabel(context);
  }

  /// Helper when using the `.icon` constructors.
  Widget _buildIconOrLoading(BuildContext context) {
    if (isLoading) {
      return Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: _buildLoadingSpinner(context),
      );
    }
    return Icon(icon);
  }

  /// Standardizes the text styling explicitly if the theme doesn't catch it
  /// (though AppTheme should cover it).
  Widget _buildLabel(BuildContext context) {
    return Text(text); // Theme textStyle applies automatically
  }

  /// Extracts the standard loading spinner to ensure it's sized correctly.
  Widget _buildLoadingSpinner(BuildContext context) {
    final color = type == AppButtonType.primary
        ? Colors.white
        : Theme.of(context).primaryColor;

    return SizedBox(
      width: 24,
      height: 24,
      child: CircularProgressIndicator(
        strokeWidth: 2.5,
        valueColor: AlwaysStoppedAnimation<Color>(color),
      ),
    );
  }
}
