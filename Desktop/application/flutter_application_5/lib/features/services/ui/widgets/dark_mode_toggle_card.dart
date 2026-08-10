import 'package:flutter/material.dart';

class DarkModeToggleCard extends StatelessWidget {
  final bool isDark;
  final ValueChanged<bool> onToggle;

  const DarkModeToggleCard({
    super.key,
    required this.isDark,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: ListTile(
        leading: Icon(
          isDark ? Icons.dark_mode : Icons.light_mode,
          color: isDark ? const Color(0xFFC5A059) : Colors.orange,
        ),
        title: const Text(
          'الوضع الداكن',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          isDark ? 'مفعل' : 'غير مفعل',
        ),
        trailing: Switch(
          value: isDark,
          onChanged: onToggle,
        ),
      ),
    );
  }
}
