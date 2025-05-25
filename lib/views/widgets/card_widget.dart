import 'package:flutter/material.dart';

class CardWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback? onEdit; // Made nullable
  final VoidCallback? onDelete; // Made nullable
  final VoidCallback? onTap; // Added for tapping the entire card
  final String onEditText; // Customizable text for the "Edit" button
  final double? height;
  final double? width;

  const CardWidget({
    super.key,
    required this.title,
    required this.subtitle,
    this.onEdit, // Nullable, optional
    this.onDelete, // Nullable, optional
    this.onTap, // Nullable, optional
    this.onEditText = 'Editar', // Default value for the "Edit" button text
    this.height,
    this.width,
  });
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: colors.primary.withOpacity(0.2), width: 1),
          ),
          elevation: 8,
          shadowColor: colors.primary.withOpacity(0.4),
          margin: const EdgeInsets.only(top: 5, left: 5, right: 5),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  colors.surfaceContainer,
                  colors.surfaceContainer
                      .withBlue(colors.surfaceContainer.blue + 15),
                ],
              ),
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: height ?? 150, // Default height
                minWidth: width ?? double.infinity, // Default width
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: colors.primary.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.map_outlined,
                            color: colors.primary,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: TextStyle(
                                  color: colors.primary,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                subtitle,
                                style: TextStyle(
                                  color: colors.secondary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  height: 1.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (onEdit != null ||
                      onDelete !=
                          null)
                  const Divider(height: 1, thickness: 1),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (onEdit !=
                              null)
                            TextButton.icon(
                              onPressed: onEdit,
                              icon: Icon(Icons.visibility,
                                  size: 18, color: colors.primary),
                              label: Text(
                                onEditText,
                                style: TextStyle(
                                  color: colors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          if (onDelete !=
                              null) // Show "Delete" button only if onDelete is provided
                            TextButton.icon(
                              onPressed: onDelete,
                              icon: const Icon(Icons.delete_outline,
                                  size: 18, color: Colors.red),
                              label: const Text(
                                'Eliminar',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          )),
    );
  }
}
