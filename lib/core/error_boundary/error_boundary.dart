import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/error_boundary/error_screen.dart';

/// Widget that catches and displays errors gracefully
class ErrorBoundary extends StatefulWidget {
  /// Creates an error boundary
  const ErrorBoundary({required this.child, this.onError, super.key});

  /// Child widget to wrap
  final Widget child;

  /// Callback when error occurs
  final void Function(Object error, StackTrace stack)? onError;

  @override
  State<ErrorBoundary> createState() => _ErrorBoundaryState();
}

class _ErrorBoundaryState extends State<ErrorBoundary> {
  Object? _error;
  StackTrace? _stackTrace;

  void _setError(Object error, StackTrace? stackTrace) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _error = error;
          _stackTrace = stackTrace;
        });
      }
    });
    widget.onError?.call(error, stackTrace ?? StackTrace.current);
  }

  void _reset() {
    setState(() {
      _error = null;
      _stackTrace = null;
    });
  }

  @override
  void initState() {
    super.initState();
    FlutterError.onError = (FlutterErrorDetails details) {
      _setError(details.exception, details.stack);
    };
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return ErrorScreen(
        error: _error.toString(),
        stackTrace: _stackTrace?.toString(),
        onRetry: _reset,
      );
    }

    return widget.child;
  }

  @override
  void dispose() {
    FlutterError.onError = FlutterError.dumpErrorToConsole;
    super.dispose();
  }
}
