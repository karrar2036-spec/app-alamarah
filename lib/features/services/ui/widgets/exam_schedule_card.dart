import 'package:flutter/material.dart';

class ExamScheduleScreen extends StatelessWidget {
  final String department;
  final String level;
  final String studyType;
  final String section;

  const ExamScheduleScreen({
    super.key,
    required this.department,
    required this.level,
    required this.studyType,
    required this.section,
  });

  @override
  Widget build(BuildContext context) {
    final examData = [
      {
        'day': 'السبت / Saturday',
        'date': '2026/05/16',
        'title': 'امتحان رياضيات / Math Exam',
        'type': 'نظري / Theory',
        'time': '09:00 ص - 11:00 ص',
        'hall': 'القاعة 1 / Hall 1'
      },
      {
        'day': 'الأحد / Sunday',
        'date': '2026/05/17',
        'title': 'امتحان حقوق الإنسان / Human Rights Exam',
        'type': 'نظري / Theory',
        'time': '09:00 ص - 11:00 ص',
        'hall': 'القاعة الكبرى / Great Hall'
      },
      {
        'day': 'الإثنين / Monday',
        'date': '2026/05/18',
        'title': 'امتحان حاسوب (العملي) / Computer (Practical)',
        'type': 'عملي / Practical',
        'time': '09:00 ص - 12:00 م',
        'hall': 'مختبر الحاسوب / Lab'
      },
      {
        'day': 'الثلاثاء / Tuesday',
        'date': '2026/05/19',
        'title': 'امتحان اللغة الإنكليزية / English Exam',
        'type': 'نظري / Theory',
        'time': '09:00 ص - 11:00 ص',
        'hall': 'القاعة 3 / Hall 3'
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('الجدول الامتحاني / Exam Schedule',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        backgroundColor: const Color(0xFFE11D48),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFE11D48).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE11D48), width: 1.5),
              ),
              child: Row(
                children: [
                  const Icon(Icons.assignment,
                      color: Color(0xFFE11D48), size: 30),
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
                            color: Color(0xFFE11D48),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '$level | $studyType | $section',
                          style: const TextStyle(
                              fontSize: 13, color: Colors.black87),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ...examData.map((exam) {
              bool isLab = exam['type']!.contains('عملي');
              return Container(
                margin: const EdgeInsets.only(bottom: 14),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.grey.shade300),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    )
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            exam['day']!,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: Color(0xFF002366),
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(Icons.calendar_today,
                                  size: 14, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text(
                                exam['date']!,
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE11D48).withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.edit_note,
                                color: Color(0xFFE11D48)),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  exam['title']!,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(Icons.access_time,
                                        size: 13, color: Colors.grey),
                                    const SizedBox(width: 3),
                                    Expanded(
                                      child: Text(
                                        '${exam['time']!} - ${exam['hall']!}',
                                        style: const TextStyle(
                                            fontSize: 11, color: Colors.grey),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: isLab
                                  ? Colors.orange.shade100
                                  : Colors.red.shade100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              exam['type']!,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: isLab
                                    ? Colors.orange.shade900
                                    : Colors.red.shade900,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}