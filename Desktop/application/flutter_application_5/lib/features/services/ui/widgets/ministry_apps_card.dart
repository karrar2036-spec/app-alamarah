import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void showMinisterialAppsDialog(
    BuildContext context, Color royalBlueColor, Color goldColor) {
  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.apps, color: goldColor),
            const SizedBox(width: 8),
            const Expanded(
              child: Text(
                'التطبيقات الوزارية ',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'روابط منصات وتطبيقات وزارة التعليم العالي والبحث العلمي',
                style: TextStyle(fontSize: 12, color: Colors.grey, height: 1.4),
              ),
              const SizedBox(height: 16),
              _buildAppOption(
                imagePath: 'photo/hepiq.png',
                fallbackIcon: Icons.school,
                color: const Color(0xFF002366),
                title: 'تطبيق هبك / Hepiq App',
                subtitle: 'cent.mohesr.gov.iq',
                onTap: () => launchUrl(
                    Uri.parse('https://cent.mohesr.gov.iq/student/login'),
                    mode: LaunchMode.externalApplication),
              ),
              const SizedBox(height: 12),
              _buildAppOption(
                imagePath: 'photo/qdm.png',
                fallbackIcon: Icons.work_outline,
                color: const Color(0xFFE91E63),
                title: 'منصة قَدِم / QDM Platform',
                subtitle: 'pu-cap.mohesr.gov.iq',
                onTap: () => launchUrl(
                    Uri.parse('https://pu-cap.mohesr.gov.iq/'),
                    mode: LaunchMode.externalApplication),
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: royalBlueColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('إغلاق', style: TextStyle(color: Colors.white)),
          ),
        ],
      );
    },
  );
}

Widget _buildAppOption({
  required String imagePath,
  required IconData fallbackIcon,
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
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                imagePath,
                width: 24,
                height: 24,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(fallbackIcon, color: color, size: 20);
                },
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 12.5, fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
        ],
      ),
    ),
  );
}
