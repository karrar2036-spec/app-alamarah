class ApiEndpoints {
  // IP السيرفر السحابي المباشر
  static const String baseUrl = 'http://77.42.120.91/api';

  // رابط جلب القبولات والدرجات
  static const String degrees = '$baseUrl/degrees';

  // رابط الأقسام
  static const String departments = '$baseUrl/departments';

  // رابط محادثة الذكاء الاصطناعي
  static const String aiChat = '$baseUrl/chat-ai';
}
