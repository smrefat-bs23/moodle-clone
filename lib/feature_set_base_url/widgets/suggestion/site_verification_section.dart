// ignore_for_file: comment_references, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boilerplate/feature_set_base_url/cubit/site_suggestion_cubit.dart';
import 'package:flutter_boilerplate/feature_set_base_url/cubit/site_suggestion_event.dart';
import 'package:flutter_boilerplate/feature_set_base_url/cubit/site_suggestion_state.dart';
import 'package:flutter_boilerplate/feature_set_base_url/widgets/site_info.dart';
import 'package:flutter_boilerplate/feature_set_base_url/widgets/suggestion/connect_to_your_site_tile.dart';
import 'package:flutter_boilerplate/feature_set_base_url/widgets/suggestion/site_verification_card.dart';
import 'package:flutter_boilerplate/feature_set_base_url/widgets/suggestion/suggestion_list_placeholder.dart';
import 'package:flutter_boilerplate_core/flutter_boilerplate_core.dart';

/// Orchestrator widget that ties the existing [SiteInfo] input field to
/// the [SiteSuggestionCubit] and renders a [SiteVerificationCard]
/// directly underneath once the user commits a URL.
///
/// Replaces the earlier "search-as-you-type" affordance: the
/// `core_webservice_get_site_info` endpoint does not accept a query
/// parameter, so firing on every keystroke was wasted work. The cubit
/// still listens to keystrokes for the loading-state spinner, but the
/// actual lookup fires on:
/// - explicit user commit (`onSubmitted` / "Done" key)
/// - the user leaving the field (`onEditingComplete`)
/// - 1.5 s of typing idle (the cubit's debounce window)
///
/// When the cubit is in any non-Initial state, the "Please select your
/// account:" label is shown above the verification card, exactly as the
/// official Moodle mobile app does.
class SiteVerificationSection extends StatelessWidget {
  const SiteVerificationSection({
    required this.textController,
    required this.focusNode,
    super.key,
  });

  final TextEditingController textController;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SiteSuggestionCubit, SiteSuggestionState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SiteInfo(
              controller: textController,
              focusNode: focusNode,
              onChanged: (value) => context
                  .read<SiteSuggestionCubit>()
                  .add(SiteSuggestionQueryChanged(value)),
              onSubmitted: (value) => context
                  .read<SiteSuggestionCubit>()
                  .add(SiteSuggestionCommitRequested(value)),
              onEditingComplete: () => context
                  .read<SiteSuggestionCubit>()
                  .add(SiteSuggestionCommitRequested(textController.text)),
            ),
            const SizedBox(height: AppSpacing.md),
            if (state is! SiteSuggestionInitial)
              const _PleaseSelectYourAccount(),
            AnimatedSize(
              duration: AppDuration.suggestionFade,
              alignment: Alignment.topCenter,
              child: _buildBody(context, state),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, SiteSuggestionState state) {
    return switch (state) {
      SiteSuggestionInitial() => const SizedBox.shrink(),
      SiteSuggestionLoading(:final query) => _SuggestionContainer(
          key: ValueKey('loading-$query'),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ConnectToYourSiteTile(typedValue: query),
              const SizedBox(height: AppSpacing.md),
              const SuggestionListPlaceholder(isLoading: true),
            ],
          ),
        ),
      SiteSuggestionSuccess(:final query, :final suggestions) =>
        _SuggestionContainer(
          key: ValueKey('success-$query'),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ConnectToYourSiteTile(typedValue: query),
              if (suggestions.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.md),
                SiteVerificationCard(suggestion: suggestions.first),
              ],
            ],
          ),
        ),
      SiteSuggestionEmpty(:final query) => _SuggestionContainer(
          key: ValueKey('empty-$query'),
          child: ConnectToYourSiteTile(typedValue: query),
        ),
      SiteSuggestionError(:final query, :final message) => _SuggestionContainer(
          key: ValueKey('error-$query'),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ConnectToYourSiteTile(typedValue: query),
              const SizedBox(height: AppSpacing.md),
              SuggestionListPlaceholder(
                errorMessage: message,
                onRetry: () => context
                    .read<SiteSuggestionCubit>()
                    .add(SiteSuggestionRetryRequested(query)),
              ),
            ],
          ),
        ),
    };
  }
}

class _SuggestionContainer extends StatelessWidget {
  const _SuggestionContainer({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.xs),
      child: child,
    );
  }
}

/// "Please select your account:" label.
class _PleaseSelectYourAccount extends StatelessWidget {
  const _PleaseSelectYourAccount();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(bottom: AppSpacing.sm),
      child: Text(
        AppStrings.pleaseSelectYourAccount,
        style: TextStyle(
          fontSize: AppSize.fontSm,
          fontWeight: FontWeight.w400,
          color: Color(0xFF212121),
          letterSpacing: AppSize.letterSpacingNone,
          height: AppSize.lineHeight,
        ),
      ),
    );
  }
}