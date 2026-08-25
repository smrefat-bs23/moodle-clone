// ignore_for_file: comment_references, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter_boilerplate_core/flutter_boilerplate_core.dart';

/// Bottom sheet that lists every web-service function the Moodle site
/// exposed. Tapping the "Web Services" chip in the verification card
/// shows this sheet so the user can browse the 500+ function list
/// without inflating the inline card.
///
/// Populate via [FunctionListSheet.show] which takes a list of dynamic
/// maps (`{name, version}`) from the `functions[]` payload.
class FunctionListSheet extends StatelessWidget {
  const FunctionListSheet({required this.functions, super.key});

  final List<dynamic> functions;

  /// Shows the bottom sheet using the closest [Navigator].
  static Future<void> show(
    BuildContext context,
    List<dynamic> functions,
  ) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => FunctionListSheet(functions: functions),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // Normalise the dynamic payload into a stable shape.
    final items = <_FunctionEntry>[];
    for (final f in functions) {
      if (f is Map) {
        final name = f['name']?.toString() ?? '';
        final version = f['version']?.toString() ?? '';
        if (name.isNotEmpty) items.add(_FunctionEntry(name, version));
      }
    }
    items.sort((a, b) => a.name.compareTo(b.name));

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              child: Text(
                '${AppStrings.verificationWebServicesRegion} · ${items.length}',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
            const Divider(height: AppSize.lineHeight),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: items.length,
                itemBuilder: (context, i) {
                  final entry = items[i];
                  return ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(
                      Icons.api_outlined,
                      size: AppSize.verificationIconMd,
                      color: colorScheme.primary,
                    ),
                    title: Text(
                      entry.name,
                      style: textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    trailing: Text(
                      entry.version,
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FunctionEntry {
  const _FunctionEntry(this.name, this.version);
  final String name;
  final String version;
}
