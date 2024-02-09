import 'package:flutter/material.dart';

class StandardDivider extends StatelessWidget {
  final double? indent;
  final double? endIndent;
  final double? thickness;

  const StandardDivider({
    super.key,
    this.indent,
    this.endIndent,
    this.thickness,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Divider(
      indent: indent,
      endIndent: endIndent,
      thickness: thickness,
      color: theme.colorScheme.secondary,
      height: 1,
    );
  }
}
