import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void showTechnicalSupportDialog(
    BuildContext context, Color royalBlueColor, Color goldColor) {
  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Icon(Icons.headset_mic_outlined, color: goldColor),
            const SizedBox(width: 8),
            const Expanded(
              child: Text(
                'الدعم الفني',
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
                  'إذا واجهتك أي مشكلة تقنية داخل التطبيق يمكنك التواصل مع فريق الدعم الفني عبر القنوات التالية',
                  style:
                      TextStyle(fontSize: 12, color: Colors.grey, height: 1.4),
                ),
                const SizedBox(height: 16),
                _buildSupportOption(
                  icon: Icons.send,
                  color: const Color(0xFF229ED9),
                  title: 'تليغرام الدعم الفني / Telegram Support',
                  subtitle: '@knsk98',
                  onTap: () async {
                    final Uri url = Uri.parse('https://t.me/knsk98');
                    launchUrl(url, mode: LaunchMode.externalApplication);
                  },
                ),
                const SizedBox(height: 10),
                _buildSupportOption(
                  icon: Icons.phone_android,
                  color: const Color(0xFF25D366),
                  title: 'واتساب الدعم الفني / WhatsApp Support',
                  subtitle: '07767421779',
                  onTap: () async {
                    final Uri url = Uri.parse('https://wa.me/9647767421779');
                    launchUrl(url, mode: LaunchMode.externalApplication);
                  },
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

Widget _buildSupportOption({
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
