import 'package:flutter/material.dart';

Future<String?> showLanguageDialog(BuildContext context, Color royalBlueColor,
    Color goldColor, String currentLanguage) async {
  String selectedLang = currentLanguage;

  return showDialog<String>(
    context: context,
    builder: (BuildContext dialogContext) {
      return StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Row(
              children: [
                Icon(Icons.translate, color: goldColor),
                const SizedBox(width: 8),
                const Text('اختر اللغة',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildLangOption(
                  context: context,
                  title: 'العربية',
                  subtitle: 'Arabic',
                  flag: '🇮🇶',
                  isSelected: selectedLang == 'العربية',
                  royalBlue: royalBlueColor,
                  onTap: () {
                    selectedLang = 'العربية';
                    Navigator.pop(dialogContext, selectedLang);
                  },
                ),
                const SizedBox(height: 10),
                _buildLangOption(
                  context: context,
                  title: 'English',
                  subtitle: 'الإنكليزية',
                  flag: '🇬🇧',
                  isSelected: selectedLang == 'English',
                  royalBlue: royalBlueColor,
                  onTap: () {
                    selectedLang = 'English';
                    Navigator.pop(dialogContext, selectedLang);
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('إلغاء',
                      style: TextStyle(color: Colors.grey))),
            ],
          );
        },
      );
    },
  );
}

Widget _buildLangOption({
  required BuildContext context,
  required String title,
  required String subtitle,
  required String flag,
  required bool isSelected,
  required Color royalBlue,
  required VoidCallback onTap,
}) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(12),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isSelected
            ? royalBlue.withOpacity(0.08)
            : Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: isSelected ? royalBlue : Colors.grey.shade300,
            width: isSelected ? 2 : 1),
      ),
      child: Row(
        children: [
          Text(flag, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? royalBlue : Colors.black87)),
                Text(subtitle,
                    style: const TextStyle(fontSize: 11, color: Colors.grey)),
              ],
            ),
          ),
          Icon(isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
              color: isSelected ? royalBlue : Colors.grey, size: 22),
        ],
      ),
    ),
  );
}
