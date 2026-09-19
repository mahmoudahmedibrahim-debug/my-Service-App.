import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool outlined;
  final IconData? icon;
  final Color? color;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.outlined = false,
    this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final child = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[Icon(icon, size: 20), const SizedBox(width: 8)],
        Text(label),
      ],
    );

    if (outlined) {
      return OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(54),
          side: BorderSide(color: color ?? Theme.of(context).colorScheme.primary, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        child: child,
      );
    }

    return ElevatedButton(
      onPressed: onPressed,
      style: color != null ? ElevatedButton.styleFrom(backgroundColor: color) : null,
      child: child,
    );
  }
}
