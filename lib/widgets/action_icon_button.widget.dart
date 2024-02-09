import 'package:flutter/material.dart';

class ActionIconButtonWidget extends StatelessWidget {
  final Widget icon;
  final VoidCallback? onPressed;

  const ActionIconButtonWidget({
    super.key,
    required this.icon,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.secondary,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: icon,
      ),
    );
  }
}
