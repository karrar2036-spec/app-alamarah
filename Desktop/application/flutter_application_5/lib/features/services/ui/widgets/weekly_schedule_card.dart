import 'package:flutter/material.dart';

class WeeklyScheduleScreen extends StatelessWidget {
  final String department;
  final String level;
  final String studyType;
  final String section;

  const WeeklyScheduleScreen({
    super.key,
    required this.department,
    required this.level,
    required this.studyType,
    required this.section,
  });

  @override
  Widget build(BuildContext context) {
    final scheduleData = [
      {
        'day': 'السبت / Saturday',
        'subjects': [
          {
            'time': '08:30 - 10:30',
            'title': 'رياضيات / Math',
            'type': 'نظري / Theory',
            'hall': 'قاعة 101 / Hall 101',
          },
          {
            'time': '10:30 - 12:30',
            'title': 'حاسوب / Computer',
            'type': 'عملي / Practical',
            'hall': 'مختبر الحاسوب 2 / Lab 2',
          },
        ],
      },
      {
        'day': 'الأحد / Sunday',
        'subjects': [
          {
            'time': '08:30 - 10:30',
            'title': 'إنكليزي / English',
            'type': 'نظري / Theory',
            'hall': 'قاعة 103 / Hall 103',
          },
          {
            'time': '10:30 - 12:30',
            'title': 'حقوق الإنسان / Human Rights',
            'type': 'نظري / Theory',
            'hall': 'القاعة الكبرى / Great Hall',
          },
        ],
      },
      {
        'day': 'الإثنين / Monday',
        'subjects': [
          {
            'time': '08:30 - 11:30',
            'title': 'حاسوب / Computer',
            'type': 'عملي / Practical',
            'hall': 'مختبر الشبكات / Networks Lab',
          },
          {
            'time': '11:30 - 01:30',
            'title': 'رياضيات / Math',
            'type': 'نظري / Theory',
            'hall': 'قاعة 101 / Hall 101',
          },
        ],
      },
      {
        'day': 'الثلاثاء / Tuesday',
        'subjects': [
          {
            'time': '08:30 - 10:30',
            'title': 'حقوق الإنسان / Human Rights',
            'type': 'نظري / Theory',
            'hall': 'قاعة 105 / Hall 105',
          },
          {
            'time': '10:30 - 12:30',
            'title': 'إنكليزي / English',
            'type': 'نظري / Theory',
            'hall': 'قاعة 102 / Hall 102',
          },
        ],
      },
      {
        'day': 'الأربعاء / Wednesday',
        'subjects': [
          {
            'time': '08:30 - 10:30',
            'title': 'رياضيات / Math',
            'type': 'نظري / Theory',
            'hall': 'قاعة 101 / Hall 101',
          },
          {
            'time': '10:30 - 01:30',
            'title': 'حاسوب / Computer',
            'type': 'عملي / Practical',
            'hall': 'مختبر البرمجة / Programming Lab',
          },
        ],
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'الجدول الأسبوعي / Weekly Schedule',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        backgroundColor: const Color(0xFF002366),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFD4AF37).withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFFD4AF37),
                  width: 1.5,
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.school,
                    color: Color(0xFF002366),
                    size: 30,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          department,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF002366),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '$level | $studyType | $section',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ...scheduleData.map(
              (dayData) {
                final subjects =
                    dayData['subjects'] as List<Map<String, String>>;

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: Colors.grey.shade300,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: const BoxDecoration(
                          color: Color(0xFF002366),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          ),
                        ),
                        child: Text(
                          dayData['day'] as String,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Column(
                        children: subjects.map(
                          (subject) {
                            final bool isLab =
                                subject['type']!.contains('عملي');

                            return Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.grey.shade200,
                                    width: 1,
                                  ),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.access_time,
                                        size: 15,
                                        color: Colors.grey.shade600,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        subject['time']!,
                                        style: const TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          subject['title']!,
                                          textAlign: TextAlign.right,
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          subject['hall']!,
                                          textAlign: TextAlign.right,
                                          style: const TextStyle(
                                            fontSize: 11,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isLab
                                          ? Colors.orange.shade100
                                          : Colors.blue.shade100,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      subject['type']!,
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: isLab
                                            ? Colors.orange.shade900
                                            : Colors.blue.shade900,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ).toList(),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
