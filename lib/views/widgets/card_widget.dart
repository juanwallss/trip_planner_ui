import 'package:flutter/material.dart';

class CardWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback? onEdit; // Made nullable
  final VoidCallback? onDelete; // Made nullable
  final String onEditText; // Customizable text for the "Edit" button
  final double? height;
  final double? width;

  const CardWidget({
    super.key,
    required this.title,
    required this.subtitle,
    this.onEdit, // Nullable, optional
    this.onDelete, // Nullable, optional
    this.onEditText = 'Editar', // Default value for the "Edit" button text
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 5,
      color: colors.surfaceContainer,
      margin: const EdgeInsets.only(top: 5, left: 5, right: 5),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: height ?? 150, // Default height
          minWidth: width ?? double.infinity, // Default width
        ),
        child: Column(
          children: [
            ListTile(
              title: Text(
                title,
                style: TextStyle(color: colors.primary, fontSize: 20),
              ),
              subtitle: Text(
                subtitle,
                style: TextStyle(
                  color: colors.secondary,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
            if (onEdit != null || onDelete != null) // Show actions only if at least one is provided
              OverflowBar(
                alignment: MainAxisAlignment.end,
                children: [
                  if (onEdit != null) // Show "Edit" button only if onEdit is provided
                    TextButton(
                      onPressed: onEdit,
                      child: Text(onEditText, style: TextStyle(color: colors.primary)),
                    ),
                  if (onDelete != null) // Show "Delete" button only if onDelete is provided
                    TextButton(
                      onPressed: onDelete,
                      child: const Text('Eliminar'),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
