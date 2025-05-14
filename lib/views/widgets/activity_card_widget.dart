import 'package:flutter/material.dart';

class ActivityCardWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? location;
  final String? time;
  final String? date;
  final IconData activityIcon;
  final Color? iconColor;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onTap;
  final String onEditText;
  final double? height;
  final double? width;

  const ActivityCardWidget({
    super.key,
    required this.title,
    required this.subtitle,
    this.location,
    this.time,
    this.date,
    this.activityIcon = Icons.travel_explore,
    this.iconColor,
    this.onEdit,
    this.onDelete,
    this.onTap,
    this.onEditText = 'Editar',
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final defaultIconColor = colors.primary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 5,
        color: colors.surfaceContainer,
        margin: const EdgeInsets.only(top: 8, left: 5, right: 5, bottom: 3),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: height ?? 100, // Slightly taller default height
            minWidth: width ?? double.infinity,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      activityIcon,
                      color: iconColor ?? defaultIconColor,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              color: colors.primary,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            subtitle,
                            style: TextStyle(
                              color: colors.secondary,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            spacing: 4,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (date != null) ...[
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_today,
                                      size: 16,
                                      color: colors.tertiary,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      date!,
                                      style: TextStyle(
                                        color: colors.onSurfaceVariant,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                              if (time != null) ...[
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.access_time,
                                      size: 16,
                                      color: colors.tertiary,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      time!,
                                      style: TextStyle(
                                        color: colors.onSurfaceVariant,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Actions section
              if (onEdit != null || onDelete != null)
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: OverflowBar(
                    alignment: MainAxisAlignment.end,
                    children: [
                      if (onEdit != null)
                        TextButton.icon(
                          onPressed: onEdit,
                          icon: Icon(
                            Icons.edit_outlined,
                            size: 18,
                            color: colors.primary,
                          ),
                          label: Text(
                            onEditText,
                            style: TextStyle(color: colors.primary),
                          ),
                        ),
                      if (onDelete != null)
                        TextButton.icon(
                          onPressed: onDelete,
                          icon: Icon(
                            Icons.delete_outline,
                            size: 18,
                            color: colors.error,
                          ),
                          label: Text(
                            'Eliminar',
                            style: TextStyle(color: colors.error),
                          ),
                        ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
