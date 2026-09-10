import 'dart:convert'; // تم تصحيح حرف t الزائد هنا
import 'package:http/http.dart' as http;
import 'package:flutter_application_5/core/constants/api_endpoints.dart';
import 'package:flutter_application_5/features/channels/data/department_model.dart';

class AdmissionCalculator {
  // دالة جلب الأقسام المقبولة من السيرفر
  static Future<List<Department>> fetchAcceptedDepartments({
    required double grade,
    required int channelId,
    required int branch1Id,
    required int branch2Id,
    int? branch3Id,
  }) async {
    try {
      final Map<String, String> queryParams = {
        'deg': grade.toString(),
        'chan': channelId.toString(),
        'brch1': branch1Id.toString(),
        'brch2': branch2Id.toString(),
      };

      if (branch3Id != null) {
        queryParams['brch3'] = branch3Id.toString();
      }

      final uri =
          Uri.parse(ApiEndpoints.degrees).replace(queryParameters: queryParams);
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        final List<dynamic> data = body['data'];

        return data.map((item) => Department.fromJson(item)).toList();
      } else {
        throw Exception('فشل في جلب البيانات من السيرفر');
      }
    } catch (e) {
      throw Exception('حدث خطأ في الاتصال: $e');
    }
  }
}
