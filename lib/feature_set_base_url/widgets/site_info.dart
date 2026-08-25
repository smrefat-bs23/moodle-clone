// ignore_for_file: comment_references

import 'package:flutter/material.dart';
import 'package:flutter_boilerplate_core/utils/constants/app_constants.dart';

/// Minimum number of characters required before the "Your site" label
/// turns green (matches the official Moodle mobile app behaviour).
const int _kSiteValidMinLength = 3;

/// Label color states for the "Your site" caption above the URL field.
///
/// Centralised locally to keep all changes scoped to `lib/`. If a
/// future refactor exposes an `AppColors` in `core/`, these should be
/// migrated there.
const Color _kSiteLabelColorNeutral = Color(0xFF212121);
const Color _kSiteLabelColorError = Color(0xFFFF0000);
const Color _kSiteLabelColorValid = Color(0xFF0F7B0F);

/// The "Your site" labelled input that anchors the Set Base URL page.
///
/// Backwards-compatible: when no [controller]/[focusNode]/[onChanged] are
/// supplied, the widget manages its own internal controller/focus node
/// exactly as it did before — this preserves the existing Set Base URL
/// behaviour for callers that do not need search-as-you-type.
///
/// When [controller] is supplied, this widget does NOT dispose it on
/// its own (the caller owns the lifecycle).
class SiteInfo extends StatefulWidget {
  /// Creates a [SiteInfo].
  const SiteInfo({
    super.key,
    this.controller,
    this.focusNode,
    this.onChanged,
    this.onSubmitted,
    this.onEditingComplete,
  });

  /// Optional external controller. When null, an internal one is used.
  final TextEditingController? controller;

  /// Optional external focus node. When null, an internal one is used.
  final FocusNode? focusNode;

  /// Optional callback fired on every keystroke.
  final ValueChanged<String>? onChanged;

  /// Optional callback fired when the user submits the field
  /// ("Done" / "Enter" key on the soft keyboard).
  final ValueChanged<String>? onSubmitted;

  /// Optional callback fired when the field loses focus.
  final VoidCallback? onEditingComplete;

  @override
  State<SiteInfo> createState() => _SiteInfoState();
}

class _SiteInfoState extends State<SiteInfo> {
  late final TextEditingController _internalController =
      TextEditingController();
  late final FocusNode _internalFocusNode = FocusNode();

  bool _isFocused = false;

  /// Set to `true` the first time the user taps into the field and
  /// then taps back out without typing anything. Drives the
  /// "unfocused empty → red" behaviour of the official Moodle app.
  bool _hasLostFocusWithEmptyInput = false;

  TextEditingController get _effectiveController =>
      widget.controller ?? _internalController;

  FocusNode get _effectiveFocusNode =>
      widget.focusNode ?? _internalFocusNode;

  @override
  void initState() {
    super.initState();
    _effectiveFocusNode.addListener(_onFocusChange);
    _effectiveController.addListener(_onTextChange);
  }

  void _onFocusChange() {
    if (!mounted) return;
    final wasFocused = _isFocused;
    final hasFocus = _effectiveFocusNode.hasFocus;
    setState(() {
      _isFocused = hasFocus;
      // Latching flag: only flip on the *transition* from focused → not
      // focused, and only when the input is still empty at that moment.
      if (wasFocused && !hasFocus && _effectiveController.text.isEmpty) {
        _hasLostFocusWithEmptyInput = true;
      }
    });
  }

  void _onTextChange() {
    if (!mounted) return;
    // As soon as the user types anything, the field is no longer
    // considered "empty" — clear the latched flag so subsequent
    // unfocus with content doesn't trigger the red colour.
    if (_effectiveController.text.isNotEmpty) {
      _hasLostFocusWithEmptyInput = false;
    }
    setState(() {});
  }

  /// The label is green as soon as the user has typed enough chars to
  /// match the official Moodle app's "valid" threshold.
  bool get _isValid =>
      _effectiveController.text.trim().length >= _kSiteValidMinLength;

  /// The label colour depends on the validity of the typed URL and
  /// whether the user has tapped into and out of the field at least
  /// once without typing anything.
  ///
  /// Precedence:
  /// 1. Valid (≥ 3 chars) → green.
  /// 2. Previously focused-and-left-with-empty-input → red.
  /// 3. Otherwise → neutral (black).
  Color get _labelColor {
    if (_isValid) {
      return _kSiteLabelColorValid;
    }
    if (_hasLostFocusWithEmptyInput) {
      return _kSiteLabelColorError;
    }
    return _kSiteLabelColorNeutral;
  }

  /// The label is bold whenever the field is focused, mirroring the
  /// official Moodle app behaviour.
  FontWeight get _labelFontWeight =>
      _isFocused ? FontWeight.w700 : FontWeight.w400;

  @override
  void dispose() {
    _effectiveFocusNode.removeListener(_onFocusChange);
    _effectiveController.removeListener(_onTextChange);
    // Only dispose the focus node and controller if WE created them.
    if (widget.focusNode == null) {
      _internalFocusNode.dispose();
    }
    if (widget.controller == null) {
      _internalController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.yourSite,
          style: TextStyle(
            fontSize: AppSize.fontXs,
            fontWeight: _labelFontWeight,
            color: _labelColor,
            letterSpacing: AppSize.letterSpacingNone,
            height: AppSize.lineHeight,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),

        TextField(
          enableSuggestions: false,
          autocorrect: false,
          selectionControls: null,
          controller: _effectiveController,
          focusNode: _effectiveFocusNode,
          cursorColor: _labelColor,
          onChanged: widget.onChanged,
          onSubmitted: widget.onSubmitted,
          onEditingComplete: widget.onEditingComplete,
          style: const TextStyle(
            fontSize: AppSize.fontSm,
            fontWeight: FontWeight.w400,
            color: Color(0xFF000000),
            letterSpacing: AppSize.letterSpacingNone,
            height: AppSize.lineHeight,
          ),
          decoration: InputDecoration(
            isDense: true,
            hintText: AppStrings.siteHint,
            hintStyle: const TextStyle(
              fontSize: AppSize.fontSm,
              fontWeight: FontWeight.w400,
              color: Color(0xFF757575),
              letterSpacing: AppSize.letterSpacingNone,
              height: AppSize.lineHeight,
            ),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            focusedErrorBorder: InputBorder.none,
            filled: false,
            fillColor: Colors.transparent,
            contentPadding: EdgeInsets.zero,
            suffixIcon: _effectiveController.text.isEmpty
                ? null
                : GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      _effectiveController.clear();
                      if (widget.onChanged != null) {
                        widget.onChanged!('');
                      }
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: AppSpacing.xs),
                      child: Icon(
                        Icons.close,
                        size: AppSize.iconMd,
                        color: Color(0xFF757575),
                      ),
                    ),
                  ),
          ),
        ),

        const SizedBox(height: AppSpacing.xs),

        Divider(
          height: AppSize.lineHeight,
          thickness: AppSize.dividerThickness,
          color: _labelColor,
        ),
      ],
    );
  }
}