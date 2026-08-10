import 'package:flutter/material.dart';

class SubjectsListScreen extends StatelessWidget {
  final String department;
  final String level;

  const SubjectsListScreen({
    super.key,
    required this.department,
    required this.level,
  });

  @override
  Widget build(BuildContext context) {
    final subjectsData = [
      {
        'title': 'رياضيات / Math',
        'code': 'MATH101',
        'type': 'نظري / Theory',
        'hours': '3 ساعات أسبوعياً / 3 hours weekly'
      },
      {
        'title': 'حاسوب / Computer',
        'code': 'CS102',
        'type': 'عملي ونظري / Practical & Theory',
        'hours': '4 ساعات أسبوعياً / 4 hours weekly'
      },
      {
        'title': 'اللغة الإنكليزية / English Language',
        'code': 'ENG101',
        'type': 'نظري / Theory',
        'hours': '2 ساعة أسبوعياً / 2 hours weekly'
      },
      {
        'title': 'حقوق الإنسان / Human Rights',
        'code': 'HR101',
        'type': 'نظري / Theory',
        'hours': '2 ساعة أسبوعياً / 2 hours weekly'
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('المواد الدراسية / Subjects List',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        backgroundColor: const Color(0xFF002366),
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
                color: const Color(0xFFD4AF37).withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFD4AF37), width: 1.5),
              ),
              child: Row(
                children: [
                  const Icon(Icons.menu_book,
                      color: Color(0xFF002366), size: 30),
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
                          level,
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
            ...subjectsData.map((subject) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFF002366),
                    child: Icon(Icons.book, color: Colors.white, size: 20),
                  ),
                  title: Text(
                    subject['title']!,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  subtitle: Text('${subject['code']!} • ${subject['hours']!}',
                      style: const TextStyle(fontSize: 11)),
                  trailing: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD4AF37).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      subject['type']!,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF002366),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}