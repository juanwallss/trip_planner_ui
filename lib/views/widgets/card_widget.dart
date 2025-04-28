import 'package:flutter/material.dart';

class CardWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final double? height;
  final double? width;

  const CardWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onEdit,
    required this.onDelete,
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
      margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
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
                style: TextStyle(color: colors.secondary, fontWeight: FontWeight.w300),
              ),
            ),
            OverflowBar(
              alignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: onEdit,
                  child: Text('Editar', style: TextStyle(color: colors.primary)),
                ),
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
