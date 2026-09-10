import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AdmissionGradesScreen extends StatefulWidget {
  final String selectedBranch;
  final double studentGrade;
  final int channelId;
  final int branch1Id;
  final int branch2Id;

  const AdmissionGradesScreen({
    super.key,
    required this.selectedBranch,
    required this.studentGrade,
    this.channelId = 1,
    this.branch1Id = 1,
    this.branch2Id = 1,
  });

  @override
  State<AdmissionGradesScreen> createState() => _AdmissionGradesScreenState();
}

class _AdmissionGradesScreenState extends State<AdmissionGradesScreen> {
  late Future<List<dynamic>> _departmentsFuture;

  //deg-api-ip رابط السيرفر الأساسي
  static const String baseUrl = 'https://app-alamarah.com/api';

  @override
  void initState() {
    super.initState();
    _departmentsFuture = fetchAcceptedDepartments();
  }

  Future<List<dynamic>> fetchAcceptedDepartments() async {
    // تم تصحيح الرابط بإضافة /degrees بشكل صحيح
    final uri = Uri.parse(
      '$baseUrl/degrees?deg=${widget.studentGrade}&chan=${widget.channelId}&brch1=${widget.branch1Id}&brch2=${widget.branch2Id}',
    );

    try {
      final response = await http.get(uri).timeout(
            const Duration(seconds: 10),
          );

      if (response.statusCode == 200) {
        // فك ترميز النصوص العربية بصيغة utf8
        final data = json.decode(utf8.decode(response.bodyBytes));
        if (data is List) {
          return data;
        } else if (data is Map && data.containsKey('data')) {
          return data['data'] ?? [];
        }
        return [];
      } else {
        throw 'فشل جلب البيانات من السيرفر (رمز الاستجابة: ${response.statusCode})';
      }
    } on SocketException {
      throw 'تعذر الاتصال بالسيرفر! تأكد من تشغيل السيرفر واتصال الهاتف بالإنترنت.';
    } on TimeoutException {
      throw 'انتهت مهلة الانتظار! السيرفر لا يستجيب، تحقق من اتصال الشبكة.';
    } catch (e) {
      throw 'حدث خطأ أثناء الاتصال: $e';
    }
  }

  void _retry() {
    setState(() {
      _departmentsFuture = fetchAcceptedDepartments();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('الأقسام المقبولة (${widget.selectedBranch})'),
        backgroundColor: const Color(0xFF16A34A),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _departmentsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Color(0xFF16A34A)),
                  SizedBox(height: 16),
                  Text('جاري جلب الأقسام المتاحة...'),
                ],
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.cloud_off,
                      size: 60,
                      color: Colors.redAccent,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: _retry,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF16A34A),
                      ),
                      icon: const Icon(Icons.refresh, color: Colors.white),
                      label: const Text(
                        'إعادة المحاولة',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          final departments = snapshot.data ?? [];

          if (departments.isEmpty) {
            return const Center(
              child: Text(
                'لا توجد أقسام متاحة لهذا المعدل والفرع',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            );
          }

          return ListView.builder(
            itemCount: departments.length,
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) {
              final item = departments[index];

              final String deptName =
                  item['اسم_القسم'] ?? item['department_name'] ?? 'قسم علمي';
              final String studyType = item['نوع_الدراسة'] ?? '';
              final String minGrade =
                  (item['الحد_الأدنى'] ?? item['min_grade'] ?? '0').toString();

              final bool isMorning = studyType == 'صباحي';

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.school,
                        color: Color(0xFF16A34A),
                        size: 30,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              deptName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Text(
                                  'الحد الأدنى: $minGrade%',
                                  style: const TextStyle(
                                    color: Color(0xFF16A34A),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                if (studyType.isNotEmpty) ...[
                                  const SizedBox(width: 12),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isMorning
                                          ? Colors.blue.shade50
                                          : Colors.orange.shade50,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      studyType,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: isMorning
                                            ? Colors.blue.shade800
                                            : Colors.orange.shade800,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
