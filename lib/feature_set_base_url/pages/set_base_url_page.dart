// ignore_for_file: comment_references

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boilerplate/feature_set_base_url/cubit/site_suggestion_cubit.dart';
import 'package:flutter_boilerplate/feature_set_base_url/cubit/site_suggestion_state.dart';
import 'package:flutter_boilerplate/feature_set_base_url/widgets/base_url_header.dart';
import 'package:flutter_boilerplate/feature_set_base_url/widgets/help_link.dart';
import 'package:flutter_boilerplate/feature_set_base_url/widgets/moodle_logo.dart';
import 'package:flutter_boilerplate/feature_set_base_url/widgets/or_divider.dart';
import 'package:flutter_boilerplate/feature_set_base_url/widgets/qr_scan_button.dart';
import 'package:flutter_boilerplate/feature_set_base_url/widgets/suggestion/site_verification_section.dart';
import 'package:flutter_boilerplate/src/injection/di.dart' as di;
import 'package:flutter_boilerplate_core/flutter_boilerplate_core.dart';

/// Top-level page that hosts the Set Base URL flow.
///
/// The page has two visual states (initial logo splash vs. active
/// search view) keyed off the [SiteSuggestionCubit] state. We wrap the
/// Scaffold in a [BlocBuilder] and switch the children list. **Critically
/// we keep `SearchSuggestionSection` at the same tree position across
/// both states** so Flutter can reconcile its element and preserve the
/// `TextEditingController` / `FocusNode` that own the URL input. If
/// its position moved when the state flips from initial → active, the
/// TextField would lose focus on the first keystroke.
class SetBaseUrlPage extends StatelessWidget {
  const SetBaseUrlPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.getIt<SiteSuggestionCubit>(),
      child: const _SetBaseUrlPageBody(),
    );
  }
}

class _SetBaseUrlPageBody extends StatefulWidget {
  const _SetBaseUrlPageBody();

  @override
  State<_SetBaseUrlPageBody> createState() => _SetBaseUrlPageBodyState();
}

class _SetBaseUrlPageBodyState extends State<_SetBaseUrlPageBody> {
  final TextEditingController _urlController = TextEditingController();
  final FocusNode _urlFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Light background, dark status-bar icons — matches the official
    // Moodle mobile app's chrome.
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
  }

  @override
  void dispose() {
    _urlController.dispose();
    _urlFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SiteSuggestionCubit, SiteSuggestionState>(
      builder: (context, state) {
        final isActive = state is! SiteSuggestionInitial;
        return Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: true,
          body: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: _PageLayout(
                      isActive: isActive,
                      urlController: _urlController,
                      urlFocusNode: _urlFocusNode,
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

/// Stable widget tree used by [_SetBaseUrlPageBody].
///
/// The trick: keep the [SearchSuggestionSection] (which contains the
/// TextField) at the same position in the [Column] children list across
/// both states. Surrounding widgets are added above or below, but the
/// [SearchSuggestionSection] is always the THIRD child so Flutter's
/// element reconciliation preserves its State — including the
/// `TextEditingController` and `FocusNode` — across the initial →
/// active flip. That keeps the keyboard open and the cursor in place
/// while the user types.
class _PageLayout extends StatelessWidget {
  const _PageLayout({
    required this.isActive,
    required this.urlController,
    required this.urlFocusNode,
  });

  final bool isActive;
  final TextEditingController urlController;
  final FocusNode urlFocusNode;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // [0] Above-input space.
        const SizedBox(height: AppSpacing.xxs),
        // [1] Header.
        BaseUrlHeader(showBackButton: isActive),
        // [2] Above-input decoration (logo vs gap).
        _AboveInputDecoration(isActive: isActive),
        // [3] The URL input — invariant position. Flutter preserves
        //     this element across state swaps, so focus stays.
        SiteVerificationSection(
          textController: urlController,
          focusNode: urlFocusNode,
        ),
        // [4] Below-input decoration.
        _BelowInputDecoration(isActive: isActive),
        // [5] Bottom group (OR + QR / empty).
        _BottomGroup(isActive: isActive),
        // [6] Help link.
        const HelpLink(),
        // [7] Trailing padding.
        const SizedBox(height: AppSpacing.md),
      ],
    );
  }
}

/// Above-input decoration: logo on the initial splash, simple gap on
/// the active layout.
class _AboveInputDecoration extends StatelessWidget {
  const _AboveInputDecoration({required this.isActive});

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    if (isActive) {
      return const SizedBox(height: AppSpacing.md);
    }
    return Column(
      children: [
        const SizedBox(height: AppSpacing.xlMd),
        const MoodleLogo(),
        const SizedBox(height: AppSpacing.xxlSm),
      ],
    );
  }
}

/// Below-input decoration on the initial splash — sized spacer to push
/// the OR / QR group down to match the official Moodle splash. On the
/// active layout, returns an empty widget because all the content is
/// rendered inside [SearchSuggestionSection].
class _BelowInputDecoration extends StatelessWidget {
  const _BelowInputDecoration({required this.isActive});

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    if (isActive) {
      return const SizedBox.shrink();
    }
    return const SizedBox(height: AppSpacing.xlMd);
  }
}

/// Bottom group: OR + QR code button on the initial splash, simple gap
/// on the active layout.
class _BottomGroup extends StatelessWidget {
  const _BottomGroup({required this.isActive});

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    if (isActive) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: const [
        OrDivider(),
        SizedBox(height: AppSpacing.xlMd),
        QrScanButton(),
        SizedBox(height: AppSpacing.xlSm),
      ],
    );
  }
}