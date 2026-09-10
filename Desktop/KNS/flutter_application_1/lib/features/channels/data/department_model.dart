// نموذج تحويل بيانات القسم المرجعة من الـ API إلى كائن يفهمه التطبيق
class Department {
  // اسم القسم
  final String name;

  // نوع الدراسة (صباحي / مسائي)
  final String studyType;

  // الحد الأدنى للقبول
  final num minGrade;

  Department({
    required this.name,
    required this.studyType,
    required this.minGrade,
  });

  // دالة تحويل بيانات JSON إلى كائن Department
  factory Department.fromJson(Map<String, dynamic> json) {
    return Department(
      name: json['اسم_القسم'] ?? '',
      studyType: json['نوع_الدراسة'] ?? '',
      minGrade: json['الحد_الأدنى'] ?? 0,
    );
  }
}
