import 'package:flutter/material.dart';

class AppColors {
  AppColors._(); // منع إنشاء نسخة من الكلاس

  // الألوان الرئيسية الهوية (الكحلي والذهبي)
  static const Color primary = Color(0xFF0D1B2A); // الأزرق الكحلي الداكن
  static const Color secondary = Color(0xFFC5A059); // اللون الذهبي

  // ألوان إضافية مساعدة
  static const Color accent = Color(0xFF1B263B); // كحلي بدرجة أفتح
  static const Color background = Color(0xFFF4F6F8); // خلفية فاتحة عامة
  static const Color darkBackground = Color(0xFF121212); // خلفية داكنة

  // ألوان النصوص
  static const Color textPrimary = Color(0xFF1E293B);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textLight = Colors.white;
}
