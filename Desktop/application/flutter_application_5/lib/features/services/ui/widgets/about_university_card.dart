import 'package:flutter/material.dart';

void showAboutUniversityDialog(
    BuildContext context, Color royalBlueColor, Color goldColor) {
  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.school_outlined, color: goldColor),
            const SizedBox(width: 8),
            const Expanded(
              child: Text(
                'حول الجامعة',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.6,
            ),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: royalBlueColor.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: royalBlueColor.withOpacity(0.2)),
                ),
                child: const Text(
                  'تأسست كلية العمارة الجامعة سنة 2017 ربطاً بقرار مجلس الوزراء المرقم (358) لسنة 2017 ليكون مقرها في محافظة ميسان/ مدينة العمارة، وتهدف الكلية إلى رفد المجتمع بالكوادر العلمية المتخصصة في مختلف المجالات',
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.6,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.justify,
                ),
              ),
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
