import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final String? errorText;
  final IconData? icon; // Optional icon
  final VoidCallback? onIconPressed; // Action for the icon
  final double? width; // Optional width
  final bool disabled; // Disabled option

  const MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.obscureText = false,
    this.errorText,
    this.icon,
    this.onIconPressed,
    this.width,
    this.disabled = false, // Default to false
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final double height = errorText != null ? 80.0 : 55.0;

    return SizedBox(
      height: height,
      width: width, // Use the provided width if available
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: colors.primary.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: TextField(
                controller: controller,
                onEditingComplete: onIconPressed,
                obscureText: obscureText,
                enabled: !disabled,
                decoration: InputDecoration(
                  labelText: hintText,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide(
                      color: colors.primary,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(17.0),
                    borderSide: BorderSide(
                      color: colors.primary,
                    ),
                  ),
                  filled: true,
                  fillColor: disabled
                      ? Colors.grey[300]
                      : colors.onPrimary, // Change background if disabled
                  hintText: hintText,
                  hintStyle: TextStyle(color: colors.secondary, fontSize: 15),
                  errorText: errorText, // Display error text
                  suffixIcon: icon != null
                      ? IconButton(
                          icon: Icon(icon, color: colors.primary),
                          onPressed: disabled ? null : onIconPressed,
                        )
                      : null, // Add optional icon button
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
