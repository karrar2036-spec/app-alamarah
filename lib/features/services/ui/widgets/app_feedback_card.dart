import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void showAppFeedbackDialog(
    BuildContext context, Color royalBlueColor, Color goldColor) {
  final TextEditingController feedbackController = TextEditingController();
  bool isSubmitting = false;

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext dialogContext) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Row(
              children: [
                Icon(Icons.rate_review_outlined, color: goldColor),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'ملاحظات حول التطبيق',
                    style:
                        TextStyle(fontSize: 14.5, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            content: SizedBox(
              width: double.maxFinite,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'نسعد بسماع آرائك ومقترحاتك لتطوير وتحسين واجهة التطبيق:',
                      style: TextStyle(
                        fontSize: 12.5,
                        color: Colors.grey,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: feedbackController,
                      enabled: !isSubmitting,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: 'اكتب ملاحظتك أو مقترحك هنا',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              BorderSide(color: royalBlueColor, width: 2),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actionsPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: isSubmitting
                        ? null
                        : () => Navigator.pop(dialogContext),
                    child: const Text(
                      'إلغاء',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: royalBlueColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: isSubmitting
                        ? null
                        : () async {
                            final text = feedbackController.text.trim();
                            if (text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'يرجى كتابة الملاحظة أو المقترح أولاً'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }

                            setState(() {
                              isSubmitting = true;
                            });

                            try {
                              //app-api-ip تم تصحيح الآي بي إلى السيرفر السحابي الجديد
                              final response = await http
                                  .post(
                                    Uri.parse(
                                        'https://app-alamarah.com/api/feedback'),
                                    headers: {
                                      'Content-Type': 'application/json'
                                    },
                                    body: json.encode({'note': text}),
                                  )
                                  .timeout(const Duration(seconds: 10));

                              if (!dialogContext.mounted) return;
                              Navigator.pop(dialogContext);

                              if (response.statusCode == 200 ||
                                  response.statusCode == 201) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'شكراً لك! تم استلام ملاحظتك بنجاح.'),
                                    backgroundColor: Colors.green,
                                    duration: Duration(seconds: 4),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'تعذر إرسال الملاحظة (رمز الخطأ: ${response.statusCode})'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            } catch (e) {
                              if (!dialogContext.mounted) return;
                              Navigator.pop(dialogContext);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'تعذر الاتصال بالسيرفر! تأكد من اتصال الإنترنت.'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                    child: isSubmitting
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'إرسال',
                            style: TextStyle(color: Colors.white),
                          ),
                  ),
                ],
              ),
            ],
          );
        },
      );
    },
  );
}
