import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void showStudentComplaintDialog(
    BuildContext context, Color royalBlueColor, Color goldColor) {
  final TextEditingController complaintController = TextEditingController();
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
                Icon(Icons.report_problem_outlined, color: goldColor),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'الشكاوى الطلابية',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'يرجى كتابة تفاصيل الشكوى أو الملاحظة أدناه (10 أحرف على الأقل):',
                    style: TextStyle(
                        fontSize: 12, color: Colors.grey, height: 1.4),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: complaintController,
                    enabled: !isSubmitting,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: 'اكتب الشكوى هنا...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: royalBlueColor, width: 2),
                      ),
                    ),
                  ),
                ],
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
                            final text = complaintController.text.trim();

                            // التحقق مما إذا كان الحقل فارغاً
                            if (text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('يرجى كتابة الشكوى أولاً'),
                                  backgroundColor: Colors.red,
                                  duration: Duration(seconds: 2),
                                ),
                              );
                              return;
                            }

                            // التحقق مما إذا كان النص أقل من 10 أحرف
                            if (text.length < 10) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'عذراً، يجيب أن تحتوي الشكوى على 10 أحرف على الأقل لتوضيح المشكلة بدقة'),
                                  backgroundColor: Colors.orangeAccent,
                                  duration: Duration(seconds: 3),
                                ),
                              );
                              return;
                            }

                            setState(() {
                              isSubmitting = true;
                            });

                            try {
                              final response = await http
                                  .post(
                                    Uri.parse(
                                        'http://77.42.120.91/api/complaints'),
                                    headers: {
                                      'Content-Type': 'application/json',
                                      'Accept': 'application/json',
                                    },
                                    body: json.encode({
                                      'complaint': text,
                                      'content': text,
                                      'message': text,
                                    }),
                                  )
                                  .timeout(const Duration(seconds: 10));

                              if (!dialogContext.mounted) return;
                              Navigator.pop(dialogContext);

                              if (response.statusCode == 200 ||
                                  response.statusCode == 201) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'تم استلام الشكوى وسيتم التدقيق وأخذ الإجراء اللازم'),
                                    backgroundColor: Colors.green,
                                    duration: Duration(seconds: 4),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'تعذر إرسال الشكوى (رمز الخطأ: ${response.statusCode})'),
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
