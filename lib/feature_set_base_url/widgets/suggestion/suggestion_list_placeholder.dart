// ignore_for_file: comment_references

import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/feature_set_base_url/widgets/suggestion/suggestion_empty_widget.dart';
import 'package:flutter_boilerplate/feature_set_base_url/widgets/suggestion/suggestion_error_widget.dart';
import 'package:flutter_boilerplate/feature_set_base_url/widgets/suggestion/suggestion_loading_widget.dart';

/// Picks the right placeholder widget (loading / empty / error) when
/// the suggestion list itself does not have items to render.
///
/// Concrete suggestions are rendered by [SuggestionList]; this widget
/// only handles the "no tiles" cases so the [SearchSuggestionSection]
/// stays trivial.
class SuggestionListPlaceholder extends StatelessWidget {
  /// Creates a [SuggestionListPlaceholder].
  const SuggestionListPlaceholder({
    this.isLoading = false,
    this.errorMessage,
    this.onRetry,
    super.key,
  });

  /// Whether the lookup is currently in flight.
  final bool isLoading;

  /// Optional error message.
  final String? errorMessage;

  /// Optional retry callback.
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const SuggestionLoadingWidget();
    }
    if (errorMessage != null) {
      return SuggestionErrorWidget(
        message: errorMessage!,
        onRetry: onRetry,
      );
    }
    return const SuggestionEmptyWidget();
  }
}