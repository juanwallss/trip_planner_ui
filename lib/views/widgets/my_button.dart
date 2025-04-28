import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final Function()? onTap;
  final String? text; // Made nullable
  final IconData? icon; // Optional icon
  final double? width; // Optional width

  const MyButton({
    super.key,
    required this.onTap,
    this.text, // Nullable text
    this.icon,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(22),
        margin: const EdgeInsets.symmetric(horizontal: 25),
        width: width, // Use the provided width if available
        decoration: BoxDecoration(
          color: colors.primary,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, color: Colors.white),
              if (text != null) const SizedBox(width: 8), // Spacing if text exists
            ],
            if (text != null)
              Text(
                text!,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
          ],
        ),
      ),
    );
  }
}