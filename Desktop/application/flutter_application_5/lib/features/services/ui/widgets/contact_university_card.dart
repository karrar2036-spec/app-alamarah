import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void showUniversityContactDialog(
    BuildContext context, Color royalBlueColor, Color goldColor) {
  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.phone_in_talk_outlined, color: goldColor),
            const SizedBox(width: 8),
            const Expanded(
              child: Text(
                'تواصل مع الجامعة ',
                style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'قنوات الاتصال الرسمية برئاسة جامعة العمارة الاهلية',
                  style:
                      TextStyle(fontSize: 12, color: Colors.grey, height: 1.4),
                ),
                const SizedBox(height: 16),
                _buildContactOption(
                  icon: Icons.email,
                  color: Colors.red,
                  title: 'البريد الإلكتروني / Email',
                  subtitle: 'info@alamarahuc.edu.iq',
                  onTap: () =>
                      launchUrl(Uri.parse('mailto:info@alamarahuc.edu.iq')),
                ),
                const SizedBox(height: 10),
                _buildContactOption(
                  icon: Icons.phone,
                  color: Colors.green,
                  title: 'رقم الهاتف الأول / Phone 1',
                  subtitle: '07735551113',
                  onTap: () => launchUrl(Uri.parse('tel:07735551113')),
                ),
                const SizedBox(height: 10),
                _buildContactOption(
                  icon: Icons.phone,
                  color: Colors.green,
                  title: 'رقم الهاتف الثاني / Phone 2',
                  subtitle: '07737943285',
                  onTap: () => launchUrl(Uri.parse('tel:07737943285')),
                ),
              ],
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

Widget _buildContactOption({
  required IconData icon,
  required Color color,
  required String title,
  required String subtitle,
  required VoidCallback onTap,
}) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(12),
    child: Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(0.2),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
        ],
      ),
    ),
  );
}
