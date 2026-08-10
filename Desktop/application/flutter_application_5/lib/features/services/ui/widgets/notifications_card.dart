import 'package:flutter/material.dart';

void showNotificationsDialog(
    BuildContext context, Color royalBlueColor, Color goldColor) {
  final notifications = [
    'تم إطلاق الوثائق لعام 2024-2025',
    'على الطالب مراجعة الجامعة من أجل استلام التأييد',
    'تم إطلاق هويات الطلبة',
    'تنويه: يوم الأحد عطلة رسمية',
  ];

  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.notifications_active_outlined, color: goldColor),
            const SizedBox(width: 8),
            const Expanded(
              child: Text(
                'التنبيهات الإدارية',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: notifications.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    radius: 14,
                    backgroundColor: royalBlueColor.withOpacity(0.1),
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        color: royalBlueColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  title: Text(
                    notifications[index],
                    style: const TextStyle(fontSize: 13, height: 1.4),
                  ),
                );
              },
            ),
          ),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: royalBlueColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text(
              'إغلاق',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      );
    },
  );
}
