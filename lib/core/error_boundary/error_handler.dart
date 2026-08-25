import 'package:flutter/material.dart';
import 'package:flutter_boilerplate_core/utils/failure/app_failure.dart';

/// Handles displaying errors to users
class ErrorHandler {
  /// Private constructor
  ErrorHandler._();

  /// Show error dialog
  static Future<void> showErrorDialog(
    BuildContext context,
    AppFailure failure,
  ) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(failure.message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  /// Show error snackbar
  static void showErrorSnackbar(BuildContext context, AppFailure failure) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(failure.message),
        backgroundColor: Colors.red.shade700,
        action: SnackBarAction(
          label: 'Dismiss',
          textColor: Colors.white,
          onPressed: () {},
        ),
      ),
    );
  }

  /// Get user-friendly error message from failure
  static String getErrorMessage(AppFailure failure) {
    return failure.message;
  }
}
