import 'package:flutter/material.dart';

void showNotesDialog(
    BuildContext context, Color royalBlueColor, Color goldColor) {
  final notes = [
    'يجب على الطالب جلب الهوية للدخول ',
    'عدم دخول القاعة بعد المحاضر ',
    'عدم التجاوز على الكادر',
  ];

  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.note_alt_outlined, color: goldColor),
            const SizedBox(width: 8),
            const Expanded(
              child: Text(
                'ملاحظات وتعليمات',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: notes.map((note) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.check_circle_outline,
                        color: Color(0xFFE11D48),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          note,
                          style: const TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
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
              'فهمت ذلك ',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      );
    },
  );
}
