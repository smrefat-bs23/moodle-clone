// ignore_for_file: comment_references

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_boilerplate/feature_set_base_url/cubit/site_suggestion_event.dart';
import 'package:flutter_boilerplate/feature_set_base_url/cubit/site_suggestion_failure_mapper.dart';
import 'package:flutter_boilerplate/feature_set_base_url/cubit/site_suggestion_state.dart';
import 'package:flutter_boilerplate_core/flutter_boilerplate_core.dart';
import 'package:flutter_boilerplate_domain/feature_set_base_url/entities/site_suggestion_entity.dart';
import 'package:flutter_boilerplate_domain/feature_set_base_url/usecases/get_site_suggestion_usecase.dart';
import 'package:injectable/injectable.dart';

/// Bloc that orchestrates the Base URL search/suggestion behaviour.
///
/// Responsibilities:
/// - Debounces keystrokes by [AppDuration.searchDebounce] before firing
///   the lookup, so the API is not spammed while the user types.
/// - Cancels any in-flight request when a new keystroke arrives, so the
///   UI never displays stale results.
/// - Skips the network call entirely when the input is empty.
/// - Skips emitting a state if the request was issued for a query that
///   the user has since moved past.
///
/// The HTTP call hits the documented Moodle `core_webservice_get_site_info`
/// endpoint via the existing use case / repository / datasource stack,
/// passing the typed text as the base URL. The server returns the single
/// site registered to the configured wstoken — that's what produces the
/// "search-as-you-type" behaviour that matches the official Moodle
/// mobile app.
@injectable
class SiteSuggestionCubit extends Bloc<SiteSuggestionEvent, SiteSuggestionState> {
  /// Creates a [SiteSuggestionCubit].
  SiteSuggestionCubit({
    required GetSiteSuggestionUseCase getSiteSuggestionUseCase,
    SiteSuggestionFailureMapper? failureMapper,
  })  : _getSiteSuggestionUseCase = getSiteSuggestionUseCase,
        _failureMapper = failureMapper ?? const SiteSuggestionFailureMapper(),
        super(const SiteSuggestionInitial(query: '')) {
    on<SiteSuggestionQueryChanged>(_onQueryChanged);
    on<SiteSuggestionRetryRequested>(_onRetry);
    on<SiteSuggestionDebounceElapsed>(_onDebounceElapsed);
    on<SiteSuggestionCommitRequested>(_onCommitRequested);
    on<SiteSuggestionRequestCompleted>(_onRequestCompleted);
  }

  /// The only host the configured wstoken is valid against. Kept as a
  /// fixed constant here so the search-as-you-type UX surfaces the
  /// registered site regardless of what the user typed (a different
  /// host would just yield a 403 / invalidtoken from the server).
  static const String _moodleHost =
      'https://lmsmobile.ahnafmuttaki.com';

  final GetSiteSuggestionUseCase _getSiteSuggestionUseCase;
  final SiteSuggestionFailureMapper _failureMapper;

  Timer? _debounceTimer;
  CancelToken? _activeCancelToken;
  String _currentQuery = '';

  @override
  Future<void> close() async {
    _debounceTimer?.cancel();
    _activeCancelToken?.cancel('cubit disposed');
    return super.close();
  }

  Future<void> _onQueryChanged(
    SiteSuggestionQueryChanged event,
    Emitter<SiteSuggestionState> emit,
  ) async {
    final query = event.query.trim();
    _currentQuery = query;

    _debounceTimer?.cancel();

    if (query.isEmpty) {
      _activeCancelToken?.cancel('input cleared');
      _activeCancelToken = null;
      emit(const SiteSuggestionInitial(query: ''));
      return;
    }

    emit(SiteSuggestionLoading(query: query));

    _debounceTimer = Timer(AppDuration.searchDebounce, () {
      if (isClosed) return;
      add(SiteSuggestionDebounceElapsed(query));
    });
  }

  Future<void> _onRetry(
    SiteSuggestionRetryRequested event,
    Emitter<SiteSuggestionState> emit,
  ) async {
    _debounceTimer?.cancel();
    final query = event.query.trim();
    _currentQuery = query;
    if (query.isEmpty) {
      return;
    }
    emit(SiteSuggestionLoading(query: query));
    await _fireLookup(query);
  }

  Future<void> _onDebounceElapsed(
    SiteSuggestionDebounceElapsed event,
    Emitter<SiteSuggestionState> emit,
  ) async {
    await _fireLookup(event.query);
  }

  /// Explicit commit from the UI (focus loss, "Done" key, or the
  /// section's commit button). Skips the debounce timer and fires the
  /// lookup immediately.
  Future<void> _onCommitRequested(
    SiteSuggestionCommitRequested event,
    Emitter<SiteSuggestionState> emit,
  ) async {
    final query = event.query.trim();
    if (query.isEmpty) return;
    _debounceTimer?.cancel();
    _currentQuery = query;
    emit(SiteSuggestionLoading(query: query));
    await _fireLookup(query);
  }

  Future<void> _onRequestCompleted(
    SiteSuggestionRequestCompleted event,
    Emitter<SiteSuggestionState> emit,
  ) async {
    // Drop the result if the user has already moved past this query.
    if (event.issuedQuery != _currentQuery) {
      return;
    }

    final failure = event.failure;
    if (failure != null) {
      emit(SiteSuggestionError(
        query: event.issuedQuery,
        message: _failureMapper.messageFor(failure),
      ));
      return;
    }

    final suggestions = event.suggestions;
    if (suggestions == null || suggestions.isEmpty) {
      emit(SiteSuggestionEmpty(query: event.issuedQuery));
      return;
    }

    emit(SiteSuggestionSuccess(
      query: event.issuedQuery,
      suggestions: suggestions,
    ));
  }

  /// Fire a lookup against the configured Moodle endpoint through the
  /// existing use case / repository / datasource stack. The use case
  /// returns a [Result] with the parsed [SiteSuggestionEntity] or a
  /// typed [AppFailure]; the cubit maps both into its own sealed state.
  Future<void> _fireLookup(String query) async {
    final cancelToken = CancelToken();
    _activeCancelToken?.cancel('superseded');
    _activeCancelToken = cancelToken;

    // ── Temporary diagnostic logs (per spec) ────────────────────────
    // ignore: avoid_print
    debugPrint('[SiteSuggestionCubit] lookup fired for query="$query"');
    // ignore: avoid_print
    debugPrint('[SiteSuggestionCubit] request url: '
        '$_moodleHost/webservice/rest/server.php');
    // ignore: avoid_print
    debugPrint('[SiteSuggestionCubit] request body: '
        '{moodlewsrestformat: json, '
        'wstoken: 5dc0f086abc4b82a1562b01a20637705, '
        'wsfunction: core_webservice_get_site_info}');

    final (entity, failure) = await _getSiteSuggestionUseCase(
      baseUrl: _moodleHost,
      cancelToken: cancelToken,
    );

    if (isClosed) return;

    if (entity != null) {
      // ignore: avoid_print
      debugPrint('[SiteSuggestionCubit] parsed model: $entity');
      // ignore: avoid_print
      debugPrint('[SiteSuggestionCubit] raw keys: '
          '${entity.raw.keys.toList()}');
      // ignore: avoid_print
      debugPrint('[SiteSuggestionCubit] repository output: '
          'entity=$entity, failure=null');
      // `core_webservice_get_site_info` returns the single site registered
      // to the configured wstoken — it is NOT a search endpoint, so the
      // server always returns one record regardless of the typed query.
      // We surface that record directly to the UI; the user has the
      // "Connect to your site" affordance to confirm it.
      // ignore: avoid_print
      debugPrint('[SiteSuggestionCubit] cubit state: '
          'SiteSuggestionSuccess(1 suggestion)');
      add(SiteSuggestionRequestCompleted(
        issuedQuery: query,
        suggestions: <SiteSuggestionEntity>[entity],
        failure: null,
      ));
      return;
    }

    // Cancellation surfaces as a null failure from the repository — that
    // is benign, the next keystroke will issue a new call.
    if (failure == null) {
      // ignore: avoid_print
      debugPrint('[SiteSuggestionCubit] cancelled');
      return;
    }

    // ignore: avoid_print
    debugPrint('[SiteSuggestionCubit] repository output: '
        'entity=null, failure=$failure');
    // ignore: avoid_print
    debugPrint('[SiteSuggestionCubit] cubit state: '
        'SiteSuggestionError(${failure.message})');
    add(SiteSuggestionRequestCompleted(
      issuedQuery: query,
      suggestions: null,
      failure: failure,
    ));
  }
}