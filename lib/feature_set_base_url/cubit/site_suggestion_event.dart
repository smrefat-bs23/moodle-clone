// ignore_for_file: comment_references

import 'package:flutter_boilerplate_core/flutter_boilerplate_core.dart';
import 'package:flutter_boilerplate_domain/feature_set_base_url/entities/site_suggestion_entity.dart';

/// Sealed event hierarchy for the Base URL search/suggestion bloc.
sealed class SiteSuggestionEvent extends BaseEvent {
  /// Creates a [SiteSuggestionEvent].
  const SiteSuggestionEvent();
}

/// Fired by the TextField on every keystroke.
///
/// The cubit applies a debounce window before issuing the network
/// request, and cancels any in-flight request from a previous
/// keystroke before firing the new one.
class SiteSuggestionQueryChanged extends SiteSuggestionEvent {
  /// Creates a [SiteSuggestionQueryChanged].
  const SiteSuggestionQueryChanged(this.query);

  /// The new value of the input field.
  final String query;

  @override
  List<Object?> get props => [query];
}

/// Fired by the "Retry" affordance in the error widget.
class SiteSuggestionRetryRequested extends SiteSuggestionEvent {
  /// Creates a [SiteSuggestionRetryRequested].
  const SiteSuggestionRetryRequested(this.query);

  /// The query to retry against.
  final String query;

  @override
  List<Object?> get props => [query];
}

/// Internal event fired by the debounce [Timer] inside [SiteSuggestionCubit].
///
/// Kept in the same file as [SiteSuggestionEvent] because Dart 3 sealed
/// classes can only be extended from within their declaring library.
class SiteSuggestionDebounceElapsed extends SiteSuggestionEvent {
  /// Creates a [SiteSuggestionDebounceElapsed].
  const SiteSuggestionDebounceElapsed(this.query);

  /// The query that should now be looked up.
  final String query;

  @override
  List<Object?> get props => [query];
}

/// Internal event fired when an in-flight request resolves.
///
/// Kept in the same file as [SiteSuggestionEvent] because Dart 3 sealed
/// classes can only be extended from within their declaring library.
class SiteSuggestionRequestCompleted extends SiteSuggestionEvent {
  /// Creates a [SiteSuggestionRequestCompleted].
  const SiteSuggestionRequestCompleted({
    required this.issuedQuery,
    this.suggestions,
    this.failure,
  });

  /// The query the request was issued for.
  final String issuedQuery;

  /// The resolved suggestions, or `null` on failure / parse error.
  ///
  /// Empty list means "the server returned no matches" — handled by the
  /// cubit as the dedicated empty state.
  final List<SiteSuggestionEntity>? suggestions;

  /// The failure if the request failed.
  final AppFailure? failure;

  @override
  List<Object?> get props => [issuedQuery, suggestions, failure?.code];
}

/// Fired when the user explicitly commits the typed URL (focus loss,
/// "Done" / "Enter" key, or the section's commit button).
///
/// `core_webservice_get_site_info` does not accept a query parameter,
/// so every keystroke returns the same payload. This event lets the
/// caller coalesce typing into a single deliberate request.
class SiteSuggestionCommitRequested extends SiteSuggestionEvent {
  /// Creates a [SiteSuggestionCommitRequested].
  const SiteSuggestionCommitRequested(this.query);

  /// The committed URL to verify.
  final String query;

  @override
  List<Object?> get props => [query];
}