// ignore_for_file: comment_references, sort_constructors_first

import 'package:flutter_boilerplate_core/flutter_boilerplate_core.dart';
import 'package:flutter_boilerplate_domain/feature_set_base_url/entities/site_suggestion_entity.dart';

/// Sealed state hierarchy for the Base URL search/suggestion feature.
///
/// Every state carries the [query] that produced it so the UI can
/// confirm the suggestion is still relevant to what the user typed.
sealed class SiteSuggestionState extends BaseState {
  /// Creates a [SiteSuggestionState].
  const SiteSuggestionState({required this.query});

  /// The query text that produced this state.
  final String query;

  @override
  List<Object?> get props => [query];
}

/// The initial state — fired before the user has typed anything.
class SiteSuggestionInitial extends SiteSuggestionState {
  /// Creates a [SiteSuggestionInitial].
  const SiteSuggestionInitial({required super.query});

  @override
  List<Object?> get props => [query];
}

/// Loading state — a request is in flight.
class SiteSuggestionLoading extends SiteSuggestionState {
  /// Creates a [SiteSuggestionLoading].
  const SiteSuggestionLoading({required super.query});

  @override
  List<Object?> get props => [query];
}

/// Success state — the API returned at least one suggestion.
///
/// Endpoints may return an empty list; that is modelled as
/// [SiteSuggestionEmpty] (not [SiteSuggestionSuccess]) so the UI can
/// show a dedicated empty-state widget.
class SiteSuggestionSuccess extends SiteSuggestionState {
  /// Creates a [SiteSuggestionSuccess].
  const SiteSuggestionSuccess({
    required super.query,
    required this.suggestions,
  });

  /// The resolved suggestions.
  final List<SiteSuggestionEntity> suggestions;

  @override
  List<Object?> get props => [query, suggestions];
}

/// Empty state — the API returned no suggestions.
class SiteSuggestionEmpty extends SiteSuggestionState {
  /// Creates a [SiteSuggestionEmpty].
  const SiteSuggestionEmpty({required super.query});

  @override
  List<Object?> get props => [query];
}

/// Error state — the suggestion lookup failed.
class SiteSuggestionError extends SiteSuggestionState {
  /// Creates a [SiteSuggestionError].
  const SiteSuggestionError({
    required super.query,
    required this.message,
  });

  /// User-friendly error message derived from the [AppFailure].
  final String message;

  @override
  List<Object?> get props => [query, message];
}
